/* 
CSC 370 
This script will implement the current ERD into a relational database.
Creates tables and sets up the relationships between them, including primary and foreign keys and constraints.
*/

CREATE DATABASE SnackCompany; -- Create database

USE SnackCompany; -- This will select the database that we create tables in.

-- Create Suppliers table
CREATE TABLE Suppliers (
    SupplierID INT PRIMARY KEY, -- Unique number which is used to identify supplier
    -- Remaining attributes of the supplier table:
    SupplierName VARCHAR(100), 
    SupplierAddress VARCHAR(255),
    SupplierEmail VARCHAR(255),
    SupplierPhone VARCHAR(30),
    SupplierLocation VARCHAR(100),

    CHECK (SupplierEmail LIKE '%_@_%._%') -- Checking if the supplier emails follows rough email format "saadkhan@uvic.ca"
);

-- Creates the Users table with attributes and constraints
CREATE TABLE Users ( 
    UserEmail VARCHAR(255) PRIMARY KEY, -- User's email is unique identifier
    UserPoints INT, -- Number of lyalty points the user has
    UserName VARCHAR(100), -- Name of the user

    -- Checking if user points are non negatgive and if the email follows rough email format
    CHECK (UserPoints >= 0),
    CHECK (UserEmail LIKE '%_@_%._%')
);

-- Create Employees table with attributes and constraints
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    EmployeeName VARCHAR(100)

    EmployeeTier INT NOT NULL,

    CHECK (EmployeeTier BETWEEN 1 AND 3)
);

-- Create Products table with attributes and constraints
CREATE TABLE Products (
    ProductID INT PRIMARY KEY, -- Unique id used to identify each product
    ProductName VARCHAR(100), -- Product name
    SupplierID INT,

    -- TRUE means product is in stock, FALSE means product is out of stock
    InStock BOOLEAN,
    SellPrice INT,
    MinAmount INT,
    SupplyPrice INT,
    InventoryAmount INT,
    -- TRUE means product is seasonal, FALSE means product is not seasonal
    IsSeasonal BOOLEAN,

    -- Constraints to ensure that prices and inventory amounts are non-negative and minimum amount is greater than 0
    CHECK (SellPrice >= 0),
    CHECK (SupplyPrice >= 0),
    CHECK (InventoryAmount >= 0),
    CHECK (MinAmount > 0),

    -- Connect each product to an existing supplier
    FOREIGN KEY (SupplierID)
        REFERENCES Suppliers(SupplierID)
);

-- Create the Transactions table with attributes and constraints
CREATE TABLE Transactions (
    TransactionID INT PRIMARY KEY,
    TransactionDate DATE,
    UserEmail VARCHAR(255),
    UserBillingInfo VARCHAR(255),
    UserAddress VARCHAR(255),
    ProcessedBy INT,

    -- Check that the transaction date is after the date of the creation of the company
    CHECK (TransactionDate > '2026-07-13'),

    -- Connecting transaction to users
    FOREIGN KEY (UserEmail)
        REFERENCES Users(UserEmail),

    -- COnnecting htransaction to some existing employee
    FOREIGN KEY (ProcessedBy)
        REFERENCES Employees(EmployeeID)
);

-- Create the Contains table
-- This will basically record which products are included in each transaction
CREATE TABLE Contains (
    TransactionID INT,
    ProductID INT,
    Quantity INT,

    -- Combination of TransactionID and ProductID must be unique, this will prevent the same product from appearing twice in one transaction.
    PRIMARY KEY (TransactionID, ProductID),

    -- Quantity must be greater than 0 :)
    CHECK (Quantity > 0),

    -- Connecting the row to an existing transaction and product
    FOREIGN KEY (TransactionID)
        REFERENCES Transactions(TransactionID),

    FOREIGN KEY (ProductID)
        REFERENCES Products(ProductID)
);