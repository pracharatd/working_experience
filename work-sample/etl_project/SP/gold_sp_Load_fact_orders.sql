CREATE PROCEDURE gold.sp_Load_fact_orders
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @CurrentDateTime DATETIME2 = SYSDATETIME();

    BEGIN TRY

        /* =========================================
           1. BUILD SOURCE DATASET INTO TEMP TABLE
        ==========================================*/
        IF OBJECT_ID('tempdb..#src') IS NOT NULL
            DROP TABLE #src;

        CREATE TABLE #src
        (
            OrderKey INT,
            CustomerSK INT,
            StoreSK INT,
            OrderDate DATE,
            DeliveryDate DATE,
            TotalQuantity INT,
            TotalNetAmount DECIMAL(18,4),
            TotalCostAmount DECIMAL(18,4)
        );

        INSERT INTO #src
        SELECT
            s.OrderKey,
            dc.CustomerSK,
            ds.StoreSK,
            MIN(s.OrderDate),
            MIN(s.DeliveryDate),
            SUM(s.Quantity),
            SUM(s.NetPriceUSD),
            SUM(s.UnitCostUSD)
        FROM silver.sales s
        INNER JOIN gold.dim_customer dc
            ON s.CustomerKey = dc.CustomerKey AND dc.IsCurrent = 1
        INNER JOIN gold.dim_store ds
            ON s.StoreKey = ds.StoreKey AND ds.IsCurrent = 1
        GROUP BY
            s.OrderKey,
            dc.CustomerSK,
            ds.StoreSK;

        /* =========================================
           2. UPDATE
        ==========================================*/
        UPDATE tgt
        SET
            tgt.CustomerSK      = src.CustomerSK,
            tgt.StoreSK         = src.StoreSK,
            tgt.OrderDate       = src.OrderDate,
            tgt.DeliveryDate    = src.DeliveryDate,
            tgt.TotalQuantity   = src.TotalQuantity,
            tgt.TotalNetAmount  = src.TotalNetAmount,
            tgt.TotalCostAmount = src.TotalCostAmount,
            tgt.UpdatedAt       = @CurrentDateTime
        FROM gold.fact_orders tgt
        INNER JOIN #src src
            ON tgt.OrderKey = src.OrderKey
        WHERE
            ISNULL(tgt.CustomerSK,-1) <> ISNULL(src.CustomerSK,-1)
        OR  ISNULL(tgt.StoreSK,-1) <> ISNULL(src.StoreSK,-1)
        OR  ISNULL(tgt.TotalQuantity,0) <> ISNULL(src.TotalQuantity,0)
        OR  ISNULL(tgt.TotalNetAmount,0) <> ISNULL(src.TotalNetAmount,0)
        OR  ISNULL(tgt.TotalCostAmount,0) <> ISNULL(src.TotalCostAmount,0)
        OR  ISNULL(tgt.OrderDate,'1900-01-01') <> ISNULL(src.OrderDate,'1900-01-01')
        OR  ISNULL(tgt.DeliveryDate,'1900-01-01') <> ISNULL(src.DeliveryDate,'1900-01-01');

        /* =========================================
           3. INSERT
        ==========================================*/
        INSERT INTO gold.fact_orders
        (
            OrderKey, CustomerSK, StoreSK,
            OrderDate, DeliveryDate,
            TotalQuantity, TotalNetAmount, TotalCostAmount,
            CreatedAt, UpdatedAt
        )
        SELECT
            src.OrderKey,
            src.CustomerSK,
            src.StoreSK,
            src.OrderDate,
            src.DeliveryDate,
            src.TotalQuantity,
            src.TotalNetAmount,
            src.TotalCostAmount,
            @CurrentDateTime,
            @CurrentDateTime
        FROM #src src
        LEFT JOIN gold.fact_orders tgt
            ON tgt.OrderKey = src.OrderKey
        WHERE tgt.OrderKey IS NULL;

    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;
GO
