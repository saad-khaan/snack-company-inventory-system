/*
CSC 370 
Complex SQL Queries for the Snack Company Inventory System

This script covers:
  - GROUP BY aggregation and HAVING
  - JOINs across multiple tables
  - WHERE vs HAVING
  - EXISTS / NOT EXISTS subqueries
  - A subquery that depends on an aggregation
  - Computed columns
  - Foreign key constraints blocking invalid DML

NOTE: A few queries use threshold values (marked with "TUNE") that may
need adjusting once the full generated dataset is loaded.
*/

USE SnackCompany;


/* =========================================================
   QUERY 1: Total quantity sold per product
   Business question: which snacks are selling, and how much?
   Techniques: JOIN + GROUP BY + SUM
   ========================================================= */

SELECT
    p.ProductID,
    p.ProductName,
    SUM(c.Quantity) AS TotalSold
FROM Contains c
JOIN Products p ON c.ProductID = p.ProductID
GROUP BY p.ProductID, p.ProductName
ORDER BY TotalSold DESC;


/* =========================================================
   QUERY 2: Suppliers that supply more than X products
   Business question: which suppliers are we most dependent on?
   Techniques: JOIN + GROUP BY + HAVING + COUNT
   ========================================================= */

SELECT
    s.SupplierID,
    s.SupplierName,
    COUNT(p.ProductID) AS NumProducts
FROM Suppliers s
JOIN Products p ON p.SupplierId = s.SupplierID
GROUP BY s.SupplierID, s.SupplierName
HAVING COUNT(p.ProductID) > 5      -- TUNE: raise this once we have 200 products / 25 suppliers
ORDER BY NumProducts DESC;


/* =========================================================
   QUERY 3: WHERE vs HAVING
   Business question: among recent orders only, which products
   sold well?
   WHERE filters individual rows BEFORE grouping.
   HAVING filters whole groups AFTER grouping.
   ========================================================= */

-- 3a: WHERE and HAVING doing different jobs in one query
SELECT
    p.ProductName,
    SUM(c.Quantity) AS TotalSold
FROM Contains c
JOIN Products p ON c.ProductID = p.ProductID
JOIN Transactions t ON c.TransactionID = t.TransactionID
WHERE t.TransactionDate >= '2026-07-15'   -- TUNE: pick a date inside our data range
GROUP BY p.ProductID, p.ProductName
HAVING SUM(c.Quantity) >= 2               -- TUNE
ORDER BY TotalSold DESC;

-- 3b: Same result from WHERE and HAVING.
-- When the filter is on the grouping column itself, both work and
-- return identical results. Only the timing differs.
SELECT IsSeasonal, COUNT(*) AS NumProducts
FROM Products
WHERE IsSeasonal = TRUE
GROUP BY IsSeasonal;

SELECT IsSeasonal, COUNT(*) AS NumProducts
FROM Products
GROUP BY IsSeasonal
HAVING IsSeasonal = TRUE;


/* =========================================================
   QUERY 4: Products at or below their minimum stock level
   Business question: what do we need to reorder, and how much?
   Techniques: WHERE on a comparison between two columns,
               computed column for the reorder amount
   ========================================================= */

SELECT
    p.ProductID,
    p.ProductName,
    s.SupplierName,
    p.InventoryAmount,
    p.MinAmount,
    (p.MinAmount - p.InventoryAmount) AS UnitsToReorder
FROM Products p
JOIN Suppliers s ON p.SupplierId = s.SupplierID
WHERE p.InventoryAmount <= p.MinAmount
ORDER BY UnitsToReorder DESC;


/* =========================================================
   QUERY 5: Highest profit margin products
   Business question: which snacks make us the most money per unit?
   Techniques: computed columns (SellPrice - SupplyPrice)
   Note: prices are stored in cents, so we divide for the percentage.
   ========================================================= */

SELECT
    p.ProductName,
    p.SupplyPrice,
    p.SellPrice,
    (p.SellPrice - p.SupplyPrice) AS ProfitPerUnit,
    ROUND(100.0 * (p.SellPrice - p.SupplyPrice) / p.SellPrice, 1) AS MarginPercent
FROM Products p
WHERE p.SellPrice > 0
ORDER BY ProfitPerUnit DESC
LIMIT 10;


/* =========================================================
   QUERY 6: Products that have never been sold
   Business question: is anyone buying this?
   Techniques: NOT EXISTS subquery

   We use NOT EXISTS rather than NOT IN on purpose. If the subquery
   ever returned a NULL ProductID, NOT IN would evaluate to UNKNOWN
   for every row and return an empty result (three-valued logic).
   NOT EXISTS is not affected by NULLs.
   ========================================================= */

SELECT
    p.ProductID,
    p.ProductName,
    p.InventoryAmount
FROM Products p
WHERE NOT EXISTS (
    SELECT 1
    FROM Contains c
    WHERE c.ProductID = p.ProductID
)
ORDER BY p.ProductName;


/* =========================================================
   QUERY 7: Products selling above the average
   Business question: which products beat our typical performance?
   Techniques: subquery that depends on an aggregation
               (inner query computes per-product totals, then averages them)
   ========================================================= */

SELECT
    p.ProductName,
    SUM(c.Quantity) AS TotalSold
FROM Contains c
JOIN Products p ON c.ProductID = p.ProductID
GROUP BY p.ProductID, p.ProductName
HAVING SUM(c.Quantity) > (
    SELECT AVG(ProductTotal)
    FROM (
        SELECT SUM(Quantity) AS ProductTotal
        FROM Contains
        GROUP BY ProductID
    ) AS PerProductTotals
)
ORDER BY TotalSold DESC;


/* =========================================================
   QUERY 8: Foreign key constraint demonstrations

   Every statement below is EXPECTED TO FAIL. Run them one at a
   time and capture the error messages - this is the evidence that
   our referential integrity constraints are working.

   TUNE: the IDs below assume supplier 1 and user1@example.com exist
   and are still referenced. Adjust to real values from the dataset.
   ========================================================= */

-- 8a: INSERT a product whose supplier does not exist.
-- Fails: SupplierId has no matching row in Suppliers.
INSERT INTO Products (ProductID, ProductName, SupplierId, InStock, SellPrice, MinAmount, SupplyPrice, InventoryAmount, IsSeasonal)
VALUES (9999, 'Ghost Chips', 99999, TRUE, 399, 10, 200, 50, FALSE);

-- 8b: DELETE a supplier that still supplies products.
-- Fails: Products rows still reference this supplier.
DELETE FROM Suppliers WHERE SupplierID = 1;

-- 8c: INSERT a Contains row for a transaction that does not exist.
-- Fails: TransactionID has no matching row in Transactions.
INSERT INTO Contains (TransactionID, ProductID, Quantity)
VALUES (999999, 101, 1);

-- 8d: DELETE a user who still has transactions.
-- Fails: Transactions rows still reference this UserEmail.
DELETE FROM Users WHERE UserEmail = 'user1@example.com';