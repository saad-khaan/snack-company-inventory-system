USE SnackCompany;

-- TransactionDate is filtered with a range comparison (WHERE TransactionDate >= ...) in three separate queries
-- (queries.sql Query 3a, 9a, 9b), and has no existing index,so each of those currently forces a full table scan of
-- Transactions.

CREATE INDEX idx_transactions_date
ON Transactions (TransactionDate);

-- ProductName backs the ORDER BY in Query 6 (products never sold). Only matters once Products is large enough that
-- sorting becomes expensive

CREATE INDEX idx_products_name
ON Products (ProductName);

-- Composite index for Query 12 (highest inventory product per supplier).
-- The correlated subquery SELECT MAX(InventoryAmount) FROM Products WHERE SupplierID = ...
-- already benefits from the FK auto-index on SupplierID, but a composite index lets MySQL answer the MAX() straight
-- from the index without touching the underlying rows.
-- SupplierID first (the equality filter), then InventoryAmount (the value being maxed).

CREATE INDEX idx_products_supplier_inventory
ON Products (SupplierID, InventoryAmount);
