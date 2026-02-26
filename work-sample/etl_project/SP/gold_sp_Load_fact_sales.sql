CREATE PROCEDURE gold.sp_Load_fact_sales
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @CurrentDateTime DATETIME2 = SYSDATETIME();

    BEGIN TRY

        IF OBJECT_ID('tempdb..#src') IS NOT NULL
            DROP TABLE #src;

        CREATE TABLE #src
        (
            OrderKey INT,
            LineNumber INT,
            CustomerSK INT,
            StoreSK INT,
            ProductSK INT,
            OrderDate DATE,
            DeliveryDate DATE,
            Quantity INT,
            UnitPriceUSD DECIMAL(18,4),
            NetPriceUSD DECIMAL(18,4),
            UnitCostUSD DECIMAL(18,4)
        );

        INSERT INTO #src
        SELECT
            s.OrderKey,
            s.LineNumber,
            dc.CustomerSK,
            ds.StoreSK,
            dp.ProductSK,
            s.OrderDate,
            s.DeliveryDate,
            s.Quantity,
            s.UnitPriceUSD,
            s.NetPriceUSD,
            s.UnitCostUSD
        FROM silver.sales s
        INNER JOIN gold.dim_customer dc
            ON s.CustomerKey = dc.CustomerKey AND dc.IsCurrent = 1
        INNER JOIN gold.dim_store ds
            ON s.StoreKey = ds.StoreKey AND ds.IsCurrent = 1
        INNER JOIN gold.dim_product dp
            ON s.ProductKey = dp.ProductKey AND dp.IsCurrent = 1;

        UPDATE tgt
        SET
            tgt.CustomerSK   = src.CustomerSK,
            tgt.StoreSK      = src.StoreSK,
            tgt.ProductSK    = src.ProductSK,
            tgt.OrderDate    = src.OrderDate,
            tgt.DeliveryDate = src.DeliveryDate,
            tgt.Quantity     = src.Quantity,
            tgt.UnitPriceUSD = src.UnitPriceUSD,
            tgt.NetPriceUSD  = src.NetPriceUSD,
            tgt.UnitCostUSD  = src.UnitCostUSD,
            tgt.UpdatedAt    = @CurrentDateTime
        FROM gold.fact_sales tgt
        INNER JOIN #src src
            ON tgt.OrderKey = src.OrderKey
           AND tgt.LineNumber = src.LineNumber
        WHERE
            ISNULL(tgt.CustomerSK,-1) <> ISNULL(src.CustomerSK,-1)
        OR  ISNULL(tgt.StoreSK,-1) <> ISNULL(src.StoreSK,-1)
        OR  ISNULL(tgt.ProductSK,-1) <> ISNULL(src.ProductSK,-1)
        OR  ISNULL(tgt.Quantity,-1) <> ISNULL(src.Quantity,-1)
        OR  ISNULL(tgt.UnitPriceUSD,-1) <> ISNULL(src.UnitPriceUSD,-1)
        OR  ISNULL(tgt.NetPriceUSD,-1) <> ISNULL(src.NetPriceUSD,-1)
        OR  ISNULL(tgt.UnitCostUSD,-1) <> ISNULL(src.UnitCostUSD,-1)
        OR  ISNULL(tgt.OrderDate,'1900-01-01') <> ISNULL(src.OrderDate,'1900-01-01')
        OR  ISNULL(tgt.DeliveryDate,'1900-01-01') <> ISNULL(src.DeliveryDate,'1900-01-01');

        INSERT INTO gold.fact_sales
        (
            OrderKey, LineNumber,
            CustomerSK, StoreSK, ProductSK,
            OrderDate, DeliveryDate,
            Quantity, UnitPriceUSD, NetPriceUSD, UnitCostUSD,
            CreatedAt, UpdatedAt
        )
        SELECT
            src.OrderKey,
            src.LineNumber,
            src.CustomerSK,
            src.StoreSK,
            src.ProductSK,
            src.OrderDate,
            src.DeliveryDate,
            src.Quantity,
            src.UnitPriceUSD,
            src.NetPriceUSD,
            src.UnitCostUSD,
            @CurrentDateTime,
            @CurrentDateTime
        FROM #src src
        LEFT JOIN gold.fact_sales tgt
            ON tgt.OrderKey = src.OrderKey
           AND tgt.LineNumber = src.LineNumber
        WHERE tgt.OrderKey IS NULL;

    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;
GO
