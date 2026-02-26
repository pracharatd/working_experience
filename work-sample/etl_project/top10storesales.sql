SELECT
    ds.StoreKey,
    ds.StoreCode,
    YEAR(fs.OrderDate)  AS SalesYear,
    MONTH(fs.OrderDate) AS SalesMonth,
    SUM(fs.NetPriceUSD) AS MonthlySales,
    SUM(fs.Quantity)    AS TotalQuantity
FROM gold.fact_sales fs
JOIN gold.dim_store ds
    ON fs.StoreSK = ds.StoreSK
    AND ds.IsCurrent = 1
GROUP BY
    ds.StoreKey,
    ds.StoreCode,
    YEAR(fs.OrderDate),
    MONTH(fs.OrderDate)
ORDER BY
    ds.StoreKey,
    SalesYear,
    SalesMonth;