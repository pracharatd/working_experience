SELECT TOP 10
    dp.ProductKey,
    dp.ProductName,
    SUM(fs.Quantity) AS TotalQuantity,
    SUM(fs.NetPriceUSD) AS TotalSalesAmount,
    SUM(fs.UnitCostUSD) AS TotalCost,
    SUM(fs.NetPriceUSD - fs.UnitCostUSD) AS TotalProfit
FROM gold.fact_sales fs
JOIN gold.dim_product dp
    ON fs.ProductSK = dp.ProductSK
    AND dp.IsCurrent = 1
GROUP BY
    dp.ProductKey,
    dp.ProductName
ORDER BY
    TotalSalesAmount DESC;