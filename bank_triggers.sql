-- Creating SQL triggers for a credit union involves writing automated scripts that respond to specific database events. These triggers can help maintain data integrity, enforce business rules, and automate processes. Here are 5 - 10 real-life scenarios with corresponding SQL trigger queries that a senior Database Administrator (DBA) might use:

-- 1. Detecting Large Transactions
-- Scenario: Trigger to alert when a transaction exceeds a certain amount.
-- SQL Trigger:

-- sql

CREATE TRIGGER AlertLargeTransaction
AFTER INSERT ON Transactions
FOR EACH ROW
WHEN NEW.amount > 10000
BEGIN
    INSERT INTO Alerts(transaction_id, message)
    VALUES (NEW.id, 'Transaction exceeds $10,000 threshold.');
END;
-- 2. Preventing Negative Account Balances
-- Scenario: Trigger to prevent withdrawals that would result in a negative balance.
-- SQL Trigger:

-- sql

CREATE TRIGGER PreventNegativeBalance
BEFORE UPDATE ON Accounts
FOR EACH ROW
WHEN NEW.balance < 0
BEGIN
    RAISE EXCEPTION 'Insufficient funds.';
END;
-- 3. Automatic Interest Calculation
-- Scenario: Monthly trigger to calculate and add interest to savings accounts.
-- SQL Trigger:

-- sql

CREATE TRIGGER CalculateInterest
AFTER INSERT ON MonthlyCronJobs
WHEN NEW.job_name = 'InterestCalculation'
BEGIN
    UPDATE Accounts
    SET balance = balance + (balance * interest_rate / 12)
    WHERE account_type = 'Savings';
END;
-- 4. Monitoring Account Inactivity
-- Scenario: Trigger to flag accounts that have been inactive for over a year.
-- SQL Trigger:

-- sql

CREATE TRIGGER FlagInactiveAccounts
AFTER UPDATE ON Transactions
FOR EACH ROW
BEGIN
    UPDATE Accounts
    SET status = 'Inactive'
    WHERE id = NEW.account_id AND last_activity < CURRENT_DATE - INTERVAL '1 year';
END;
-- 5. Validating New Accounts
-- Scenario: Trigger to ensure new accounts meet certain criteria.
-- SQL Trigger:

-- sql

CREATE TRIGGER ValidateNewAccount
BEFORE INSERT ON Accounts
FOR EACH ROW
BEGIN
    IF NEW.balance < 100 OR NEW.account_type NOT IN ('Checking', 'Savings')
    THEN RAISE EXCEPTION 'Invalid account details.';
    END IF;
END;
-- 6. Archiving Old Transactions
-- Scenario: Trigger to move old transactions to an archive table.
-- SQL Trigger:

-- sql

CREATE TRIGGER ArchiveOldTransactions
AFTER INSERT ON MonthlyCronJobs
WHEN NEW.job_name = 'TransactionArchiving'
BEGIN
    INSERT INTO TransactionArchive
    SELECT * FROM Transactions
    WHERE transaction_date < CURRENT_DATE - INTERVAL '5 years';
    
    DELETE FROM Transactions
    WHERE transaction_date < CURRENT_DATE - INTERVAL '5 years';
END;
-- 7. Detecting Suspicious Login Activity
-- Scenario: Trigger to log and alert on multiple failed login attempts.
-- SQL Trigger:

-- sql

CREATE TRIGGER LogFailedLogins
AFTER UPDATE ON UserLogins
FOR EACH ROW
WHEN NEW.failed_attempts > 3
BEGIN
    INSERT INTO SecurityAlerts(user_id, message)
    VALUES (NEW.user_id, 'Multiple failed login attempts detected.');
END;
-- 8. Enforcing Loan Payment Deadlines
-- Scenario: Trigger to apply penalties to overdue loan payments.
-- SQL Trigger:

-- sql

CREATE TRIGGER ApplyLoanPenalties
AFTER UPDATE ON LoanPayments
FOR EACH ROW
WHEN NEW.due_date < CURRENT_DATE AND NEW.paid = FALSE
BEGIN
    UPDATE Loans
    SET balance = balance + (balance * penalty_rate)
    WHERE id = NEW.loan_id;
END;
-- 9. Auto-Updating Account Status
-- Scenario: Trigger to change account status based on balance thresholds.
-- SQL Trigger:

-- sql

CREATE TRIGGER UpdateAccountStatus
AFTER UPDATE ON Accounts
FOR EACH ROW
BEGIN
    IF NEW.balance > 50000
    THEN UPDATE Accounts SET status = 'Premium' WHERE id = NEW.id;
    ELSEIF NEW.balance < 500
    THEN UPDATE Accounts SET status = 'Basic' WHERE id = NEW.id;
    END IF;
END;
-- 10. Data Integrity Check for Account Mergers
-- Scenario: Trigger to ensure data integrity when merging accounts.
-- SQL Trigger:

-- sql

CREATE TRIGGER CheckAccountMerge
BEFORE UPDATE ON AccountMergers
FOR EACH ROW
BEGIN
    IF (SELECT COUNT(*) FROM Accounts WHERE id IN (NEW.primary_account_id, NEW.secondary_account_id)) < 2
    THEN RAISE EXCEPTION 'One or more accounts do not exist.';
    END IF;
END;
-- Each of these triggers is tailored to specific operational or security needs of a credit union, demonstrating how SQL can be effectively used to automate and secure financial data management
