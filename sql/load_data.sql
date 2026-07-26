/* 
CSC 370
Loading sample data into the SnackCompany database for testing and demonstration purposes.
*/

USE SnackCompany;

-- Inserting two sample suppliers into the Suppliers table
INSERT INTO Suppliers (
    SupplierID,
    SupplierName,
    SupplierAddress,
    SupplierEmail,
    SupplierPhone,
    SupplierLocation
)
VALUES
    (
        1,
        'Amazing Snacks',
        '1200 Government Street',
        'saad@amazingsnacks.ca',
        '250-555-1234',
        'Victoria, BC'
    ),
    (
        2,
        'Salty Chips Co.',
        '3800 Finnerty Road',
        'sales@saltychips.ca',
        '250-123-5678',
        'Victoria, BC'
    );

-- Inserting three sample users into the Users table
INSERT INTO Users (
    UserEmail,
    UserPoints,
    UserName
)
VALUES
    (
        'user1@example.com',
        120,
        'Tom Holland' -- :)
    ),
    (
        'user2@example.com',
        75,
        'Zendaya' -- :)
    ),
    (
        'user3@example.com',
        40,
        'Robert Downey Jr.' -- :)
    );

-- Inserting two sample employees into the Employees table
INSERT INTO Employees (
    EmployeeID,
    EmployeeName
)
VALUES
    (
        1,
        'Saad Khan'
    ),
    (
        2,
        'Daniel Smith'-- :)
    );

-- Inserting five products into the Products table with various attributes
INSERT INTO Products (
    ProductID,
    ProductName,
    SupplierId,
    InStock,
    SellPrice,
    MinAmount,
    SupplyPrice,
    InventoryAmount,
    IsSeasonal
)
VALUES
    (
        101,
        'Ketchup Chips',
        1,
        TRUE,
        399,
        20,
        210,
        75,
        FALSE
    ),
    (
        102,
        'Maple Cookies',
        1,
        TRUE,
        549,
        15,
        300,
        38,
        FALSE
    ),
    (
        103,
        'Sea Salt Popcorn',
        2,
        TRUE,
        449,
        15,
        240,
        42,
        FALSE
    ),
    (
        104,
        'Chocolate Bar',
        2,
        TRUE,
        499,
        10,
        275,
        27,
        FALSE
    ),
    (
        105,
        'Gummu Bears',
        2,
        FALSE,
        599,
        12,
        325,
        0,
        TRUE
    );

-- Inserting sample transactions into the Transactions table
INSERT INTO Transactions (
    TransactionID,
    TransactionDate,
    UserEmail,
    UserBillingInfo,
    UserAddress,
    ProcessedBy
)
VALUES
    (
        1001,
        '2026-07-14',
        'user1@example.com',
        'Visa ending in 1111',
        '721 Government Street, Victoria, BC',
        1
    ),
    (
        1002,
        '2026-07-15',
        'user2@example.com',
        'Mastercard ending in 2222',
        '912 Government Street, Victoria, BC',
        2
    );

-- Inserting sample data into the Contains table to link transactions with products and their quantities
INSERT INTO Contains (
    TransactionID,
    ProductID,
    Quantity
)
VALUES
    (
        1001,
        101,
        2
    ),
    (
        1002,
        103,
        1
    );