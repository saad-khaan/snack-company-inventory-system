USE SnackCompany;

-- TIER 1 VIEWS
-- Regular employees

-- Tier 1 employees can see product information
-- but NOT supplier cost information.

CREATE VIEW Tier1Products AS
SELECT
    ProductID,
    ProductName,
    InStock,
    SellPrice,
    MinAmount,
    InventoryAmount,
    IsSeasonal
FROM Products;

-- Tier 1 employees can see basic transaction
-- information but not customer information.

CREATE VIEW Tier1Transactions AS
SELECT
    TransactionID,
    TransactionDate,
    ProcessedBy
FROM Transactions;

-- TIER 2 VIEWS
-- Supervisors

-- Tier 2 employees can also see supplier
-- information and company supply price.

CREATE VIEW Tier2Products AS
SELECT
    ProductID,
    ProductName,
    SupplierID,
    InStock,
    SellPrice,
    MinAmount,
    SupplyPrice,
    InventoryAmount,
    IsSeasonal
FROM Products;

-- Tier 2 employees can identify the customer
-- who placed the order, but still cannot see
-- billing information or addresses.

CREATE VIEW Tier2Transactions AS
SELECT
    TransactionID,
    TransactionDate,
    UserEmail,
    ProcessedBy
FROM Transactions;

-- One MySQL account per actual employee (username = first_last).
-- Privileges granted match each employee's EmployeeTier.

-- Tier 1

-- EmployeeID 1, Marcus Vance, Tier 1
CREATE USER IF NOT EXISTS 'marcus_vance'@'localhost'
IDENTIFIED BY 'MarcusVance123!';

GRANT SELECT ON SnackCompany.Tier1Products TO 'marcus_vance'@'localhost';
GRANT SELECT ON SnackCompany.Tier1Transactions TO 'marcus_vance'@'localhost';

-- EmployeeID 2, Elena Rostova, Tier 1
CREATE USER IF NOT EXISTS 'elena_rostova'@'localhost'
IDENTIFIED BY 'ElenaRostova123!';

GRANT SELECT ON SnackCompany.Tier1Products TO 'elena_rostova'@'localhost';
GRANT SELECT ON SnackCompany.Tier1Transactions TO 'elena_rostova'@'localhost';

-- EmployeeID 3, David Chen, Tier 1
CREATE USER IF NOT EXISTS 'david_chen'@'localhost'
IDENTIFIED BY 'DavidChen123!';

GRANT SELECT ON SnackCompany.Tier1Products TO 'david_chen'@'localhost';
GRANT SELECT ON SnackCompany.Tier1Transactions TO 'david_chen'@'localhost';

-- EmployeeID 4, Sarah Jenkins, Tier 1
CREATE USER IF NOT EXISTS 'sarah_jenkins'@'localhost'
IDENTIFIED BY 'SarahJenkins123!';

GRANT SELECT ON SnackCompany.Tier1Products TO 'sarah_jenkins'@'localhost';
GRANT SELECT ON SnackCompany.Tier1Transactions TO 'sarah_jenkins'@'localhost';

-- EmployeeID 5, Carlos Mendoza, Tier 1
CREATE USER IF NOT EXISTS 'carlos_mendoza'@'localhost'
IDENTIFIED BY 'CarlosMendoza123!';

GRANT SELECT ON SnackCompany.Tier1Products TO 'carlos_mendoza'@'localhost';
GRANT SELECT ON SnackCompany.Tier1Transactions TO 'carlos_mendoza'@'localhost';

-- Tier 2 (supervisors)

-- EmployeeID 6, Priya Patel, Tier 2
CREATE USER IF NOT EXISTS 'priya_patel'@'localhost'
IDENTIFIED BY 'PriyaPatel123!';

GRANT SELECT ON SnackCompany.Tier2Products TO 'priya_patel'@'localhost';
GRANT SELECT ON SnackCompany.Tier2Transactions TO 'priya_patel'@'localhost';

-- EmployeeID 7, James Sterling, Tier 2
CREATE USER IF NOT EXISTS 'james_sterling'@'localhost'
IDENTIFIED BY 'JamesSterling123!';

GRANT SELECT ON SnackCompany.Tier2Products TO 'james_sterling'@'localhost';
GRANT SELECT ON SnackCompany.Tier2Transactions TO 'james_sterling'@'localhost';

-- EmployeeID 8, Amara Okafor, Tier 2
CREATE USER IF NOT EXISTS 'amara_okafor'@'localhost'
IDENTIFIED BY 'AmaraOkafor123!';

GRANT SELECT ON SnackCompany.Tier2Products TO 'amara_okafor'@'localhost';
GRANT SELECT ON SnackCompany.Tier2Transactions TO 'amara_okafor'@'localhost';

-- Tier 3 (managers)
-- Tier 3 gets full DML (SELECT, INSERT, UPDATE, DELETE) across every
-- relation in the ERD (Products, Transactions, Contains, Suppliers,
-- Employees, and Users) -- managers can both see and modify everything,
-- but still no DDL/admin privileges (CREATE, DROP, ALTER, GRANT OPTION),
-- so there's nothing hidden from managers, so no view is needed.

-- EmployeeID 9, Robert Hayes, Tier 3
CREATE USER IF NOT EXISTS 'robert_hayes'@'localhost'
IDENTIFIED BY 'RobertHayes123!';

GRANT SELECT, INSERT, UPDATE, DELETE ON SnackCompany.Products TO 'robert_hayes'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON SnackCompany.Transactions TO 'robert_hayes'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON SnackCompany.Contains TO 'robert_hayes'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON SnackCompany.Suppliers TO 'robert_hayes'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON SnackCompany.Employees TO 'robert_hayes'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON SnackCompany.Users TO 'robert_hayes'@'localhost';

-- EmployeeID 10, Lisa Takahashi, Tier 3
CREATE USER IF NOT EXISTS 'lisa_takahashi'@'localhost'
IDENTIFIED BY 'LisaTakahashi123!';

GRANT SELECT, INSERT, UPDATE, DELETE ON SnackCompany.Products TO 'lisa_takahashi'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON SnackCompany.Transactions TO 'lisa_takahashi'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON SnackCompany.Contains TO 'lisa_takahashi'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON SnackCompany.Suppliers TO 'lisa_takahashi'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON SnackCompany.Employees TO 'lisa_takahashi'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON SnackCompany.Users TO 'lisa_takahashi'@'localhost';

FLUSH PRIVILEGES;

-- REVOKE EXAMPLE: EMPLOYEE DEMOTION
-- Scenario: Priya Patel (EmployeeID 6) was a Tier 2 supervisor and has just been demoted to Tier 1.

REVOKE SELECT ON SnackCompany.Tier2Products FROM 'priya_patel'@'localhost';
REVOKE SELECT ON SnackCompany.Tier2Transactions FROM 'priya_patel'@'localhost';

GRANT SELECT ON SnackCompany.Tier1Products TO 'priya_patel'@'localhost';
GRANT SELECT ON SnackCompany.Tier1Transactions TO 'priya_patel'@'localhost';

FLUSH PRIVILEGES;

-- CASCADE vs RESTRICT
-- This temporarily re-grantsTier2Products to Priya
-- it does not undo her demotion above.

-- James Sterling (Tier 2) can give Tier 2 product access onward
GRANT SELECT ON SnackCompany.Tier2Products
TO 'james_sterling'@'localhost'
WITH GRANT OPTION;

-- James re-grants that same privilege to Priya
GRANT SELECT ON SnackCompany.Tier2Products TO 'priya_patel'@'localhost';

-- RESTRICT: fails, because Priya's access here depends on James's grant

-- Left commented out so the script can still run end-to-end.
-- REVOKE SELECT ON SnackCompany.Tier2Products
-- FROM 'james_sterling'@'localhost' RESTRICT;

-- CASCADE: succeeds, and also revokes Priya's re-granted privilege since it depended solely on James's grant.
-- Priya's own Tier1 grants from the demotion above are untouched, since those came from a separate, independent grant.

-- REVOKE SELECT ON SnackCompany.Tier2Products
-- FROM 'james_sterling'@'localhost' CASCADE;

-- NOTE: MySQL does not actually have RESTRICT and CASCADE syntax so we cannot follow what we have done in lecture.
-- Here are two revokes just to revert the database back to previous state before example.
REVOKE SELECT ON SnackCompany.Tier2Products FROM 'james_sterling'@'localhost';
REVOKE SELECT ON SnackCompany.Tier2Products FROM 'priya_patel'@'localhost';

FLUSH PRIVILEGES;
