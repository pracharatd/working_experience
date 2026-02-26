SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE silver.sp_Load_Orders
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY

        -- Snapshot refresh
        TRUNCATE TABLE silver.orders;

        INSERT INTO silver.orders
        (
            OrderKey,
            LineNumber,
            CustomerKey,
            StoreKey,
            ProductKey,
            OrderDate,
            DeliveryDate,
            CurrencyCode,
            Quantity,
            UnitPriceUSD,
            NetPriceUSD,
            UnitCostUSD
        )
        SELECT 
            TRY_CAST(o.OrderKey AS INT),
            TRY_CAST(r.LineNumber AS INT),
            TRY_CAST(o.CustomerKey AS INT),
            TRY_CAST(o.StoreKey AS INT),
            TRY_CAST(r.ProductKey AS INT),
            TRY_CAST(o.OrderDate AS DATE),
            TRY_CAST(o.DeliveryDate AS DATE),
            LTRIM(RTRIM(o.CurrencyCode)),
            TRY_CAST(r.Quantity AS INT),

            -- Convert to USD
            CAST(ROUND(TRY_CAST(r.UnitPrice AS DECIMAL(18,6)) * 
                       TRY_CAST(c.Exchange AS DECIMAL(18,6)), 2) 
                 AS DECIMAL(18,4)) AS UnitPriceUSD,

            CAST(ROUND(TRY_CAST(r.NetPrice AS DECIMAL(18,6)) * 
                       TRY_CAST(c.Exchange AS DECIMAL(18,6)), 2) 
                 AS DECIMAL(18,4)) AS NetPriceUSD,

            CAST(ROUND(TRY_CAST(r.UnitCost AS DECIMAL(18,6)) * 
                       TRY_CAST(c.Exchange AS DECIMAL(18,6)), 2) 
                 AS DECIMAL(18,4)) AS UnitCostUSD

        FROM bronze.orders o
        INNER JOIN bronze.orderrows r
            ON TRY_CAST(o.OrderKey AS INT) = TRY_CAST(r.OrderKey AS INT)
        INNER JOIN bronze.currencyexchange c
            ON TRY_CAST(c.Date AS DATE) = TRY_CAST(o.OrderDate AS DATE)
           AND LTRIM(RTRIM(c.FromCurrency)) = LTRIM(RTRIM(o.CurrencyCode))
           AND c.ToCurrency = 'USD'
        WHERE TRY_CAST(o.OrderKey AS INT) IS NOT NULL;

    END TRY
    BEGIN CATCH
        THROW;
    END CATCH

END;
GO
