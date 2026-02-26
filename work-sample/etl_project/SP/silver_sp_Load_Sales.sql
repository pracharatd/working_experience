SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE silver.sp_Load_Sales
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY

        -- Snapshot refresh
        TRUNCATE TABLE silver.sales;

        INSERT INTO silver.sales
        (
            OrderKey,
            LineNumber,
            OrderDate,
            DeliveryDate,
            CustomerKey,
            StoreKey,
            ProductKey,
            Quantity,
            UnitPriceUSD,
            NetPriceUSD,
            UnitCostUSD
        )
        SELECT
            TRY_CAST(s.OrderKey AS INT),
            TRY_CAST(s.LineNumber AS INT),
            TRY_CAST(s.OrderDate AS DATE),
            TRY_CAST(s.DeliveryDate AS DATE),
            TRY_CAST(s.CustomerKey AS INT),
            TRY_CAST(s.StoreKey AS INT),
            TRY_CAST(s.ProductKey AS INT),
            TRY_CAST(s.Quantity AS INT),

            -- Convert to USD and round to nearest .01
            CAST(
                ROUND(
                    TRY_CAST(s.UnitPrice AS DECIMAL(18,6)) *
                    TRY_CAST(c.Exchange AS DECIMAL(18,6)), 
                2)
            AS DECIMAL(18,4)) AS UnitPriceUSD,

            CAST(
                ROUND(
                    TRY_CAST(s.NetPrice AS DECIMAL(18,6)) *
                    TRY_CAST(c.Exchange AS DECIMAL(18,6)), 
                2)
            AS DECIMAL(18,4)) AS NetPriceUSD,

            CAST(
                ROUND(
                    TRY_CAST(s.UnitCost AS DECIMAL(18,6)) *
                    TRY_CAST(c.Exchange AS DECIMAL(18,6)), 
                2)
            AS DECIMAL(18,4)) AS UnitCostUSD

        FROM bronze.sales s
        INNER JOIN bronze.currencyexchange c
            ON TRY_CAST(s.OrderDate AS DATE) = TRY_CAST(c.[Date] AS DATE)
           AND LTRIM(RTRIM(s.CurrencyCode)) = LTRIM(RTRIM(c.FromCurrency))
           AND c.ToCurrency = 'USD'
        WHERE TRY_CAST(s.OrderKey AS INT) IS NOT NULL;

    END TRY
    BEGIN CATCH
        THROW;
    END CATCH

END;
GO
