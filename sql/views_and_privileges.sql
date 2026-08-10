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

-- CREATE DATABASE USERS

CREATE USER IF NOT EXISTS 'tier1_employee'@'localhost'
IDENTIFIED BY 'Tier1Test123!';

CREATE USER IF NOT EXISTS 'tier2_employee'@'localhost'
IDENTIFIED BY 'Tier2Test123!';

CREATE USER IF NOT EXISTS 'tier3_employee'@'localhost'
IDENTIFIED BY 'Tier3Test123!';

-- GRANT PRIVILEGES

-- Tier 1

GRANT SELECT
ON SnackCompany.Tier1Products
TO 'tier1_employee'@'localhost';

GRANT SELECT
ON SnackCompany.Tier1Transactions
TO 'tier1_employee'@'localhost';

-- Tier 2

GRANT SELECT
ON SnackCompany.Tier2Products
TO 'tier2_employee'@'localhost';

GRANT SELECT
ON SnackCompany.Tier2Transactions
TO 'tier2_employee'@'localhost';

-- Tier 3 (manager)

GRANT SELECT
ON SnackCompany.Products
TO 'tier3_employee'@'localhost';

GRANT SELECT
ON SnackCompany.Transactions
TO 'tier3_employee'@'localhost';

FLUSH PRIVILEGES;