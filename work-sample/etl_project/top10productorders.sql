WITH yearly_product_orders AS
(
    SELECT
        YEAR(fs.OrderDate) AS SalesYear,
        dp.ProductKey,
        dp.ProductName,
        SUM(fs.Quantity) AS TotalQuantity
    FROM gold.fact_sales fs
    JOIN gold.dim_product dp
        ON fs.ProductSK = dp.ProductSK
        AND dp.IsCurrent = 1
    GROUP BY
        YEAR(fs.OrderDate),
        dp.ProductKey,
        dp.ProductName
),
ranked AS
(
    SELECT *,
        ROW_NUMBER() OVER
        (
            PARTITION BY SalesYear
            ORDER BY TotalQuantity DESC
        ) AS rn
    FROM yearly_product_orders
)
SELECT
    SalesYear,
    ProductKey,
    ProductName,
    TotalQuantity,
    rn
FROM ranked
WHERE rn <= 10
ORDER BY SalesYear, TotalQuantity DESC;