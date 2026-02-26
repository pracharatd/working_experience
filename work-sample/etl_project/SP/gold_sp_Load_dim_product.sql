CREATE PROCEDURE gold.sp_Load_dim_product
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE 
        @CurrentDateTime DATETIME2 = SYSDATETIME(),
        @OpenEndDate DATETIME2 = '9999-12-31';

    BEGIN TRY
        BEGIN TRAN;

        /* =========================================
           1. Expire changed rows (ALL columns)
        ==========================================*/
        UPDATE tgt
        SET
            tgt.EffectiveEndDate = @CurrentDateTime,
            tgt.IsCurrent = 0
        FROM gold.dim_product tgt
        INNER JOIN silver.product src
            ON tgt.ProductKey = src.ProductKey
            AND tgt.IsCurrent = 1
        WHERE
            ISNULL(tgt.ProductCode,'PLACEHOLDER') <> ISNULL(src.ProductCode,'PLACEHOLDER')
        OR  ISNULL(tgt.ProductName,'PLACEHOLDER') <> ISNULL(src.ProductName,'PLACEHOLDER')
        OR  ISNULL(tgt.Manufacturer,'PLACEHOLDER') <> ISNULL(src.Manufacturer,'PLACEHOLDER')
        OR  ISNULL(tgt.Brand,'PLACEHOLDER') <> ISNULL(src.Brand,'PLACEHOLDER')
        OR  ISNULL(tgt.Color,'PLACEHOLDER') <> ISNULL(src.Color,'PLACEHOLDER')
        OR  ISNULL(tgt.WeightUnit,'PLACEHOLDER') <> ISNULL(src.WeightUnit,'PLACEHOLDER')

        -- numeric comparisons (force consistent decimal)
        OR  ISNULL(CAST(tgt.Weight AS DECIMAL(18,4)),0) <> ISNULL(CAST(src.Weight AS DECIMAL(18,4)),0)
        OR  ISNULL(CAST(tgt.Cost AS DECIMAL(18,4)),0) <> ISNULL(CAST(src.Cost AS DECIMAL(18,4)),0)
        OR  ISNULL(CAST(tgt.Price AS DECIMAL(18,4)),0) <> ISNULL(CAST(src.Price AS DECIMAL(18,4)),0)

        OR  ISNULL(tgt.CategoryKey,-1) <> ISNULL(src.CategoryKey,-1)
        OR  ISNULL(tgt.CategoryName,'PLACEHOLDER') <> ISNULL(src.CategoryName,'PLACEHOLDER')
        OR  ISNULL(tgt.SubCategoryKey,-1) <> ISNULL(src.SubCategoryKey,-1)
        OR  ISNULL(tgt.SubCategoryName,'PLACEHOLDER') <> ISNULL(src.SubCategoryName,'PLACEHOLDER');


        /* =========================================
           2. Insert new + changed rows
        ==========================================*/
        INSERT INTO gold.dim_product
        (
            ProductKey,
            ProductCode,
            ProductName,
            Manufacturer,
            Brand,
            Color,
            WeightUnit,
            Weight,
            Cost,
            Price,
            CategoryKey,
            CategoryName,
            SubCategoryKey,
            SubCategoryName,
            EffectiveStartDate,
            EffectiveEndDate,
            IsCurrent
        )
        SELECT
            src.ProductKey,
            src.ProductCode,
            src.ProductName,
            src.Manufacturer,
            src.Brand,
            src.Color,
            src.WeightUnit,
            CAST(src.Weight AS DECIMAL(18,4)),
            CAST(src.Cost AS DECIMAL(18,4)),
            CAST(src.Price AS DECIMAL(18,4)),
            src.CategoryKey,
            src.CategoryName,
            src.SubCategoryKey,
            src.SubCategoryName,
            @CurrentDateTime,
            @OpenEndDate,
            1
        FROM silver.product src
        LEFT JOIN gold.dim_product tgt
            ON tgt.ProductKey = src.ProductKey
            AND tgt.IsCurrent = 1
        WHERE
            tgt.ProductKey IS NULL
        OR (
            ISNULL(tgt.ProductCode,'PLACEHOLDER') <> ISNULL(src.ProductCode,'PLACEHOLDER')
        OR  ISNULL(tgt.ProductName,'PLACEHOLDER') <> ISNULL(src.ProductName,'PLACEHOLDER')
        OR  ISNULL(tgt.Manufacturer,'PLACEHOLDER') <> ISNULL(src.Manufacturer,'PLACEHOLDER')
        OR  ISNULL(tgt.Brand,'PLACEHOLDER') <> ISNULL(src.Brand,'PLACEHOLDER')
        OR  ISNULL(tgt.Color,'PLACEHOLDER') <> ISNULL(src.Color,'PLACEHOLDER')
        OR  ISNULL(tgt.WeightUnit,'PLACEHOLDER') <> ISNULL(src.WeightUnit,'PLACEHOLDER')

        OR  ISNULL(CAST(tgt.Weight AS DECIMAL(18,4)),0) <> ISNULL(CAST(src.Weight AS DECIMAL(18,4)),0)
        OR  ISNULL(CAST(tgt.Cost AS DECIMAL(18,4)),0) <> ISNULL(CAST(src.Cost AS DECIMAL(18,4)),0)
        OR  ISNULL(CAST(tgt.Price AS DECIMAL(18,4)),0) <> ISNULL(CAST(src.Price AS DECIMAL(18,4)),0)

        OR  ISNULL(tgt.CategoryKey,-1) <> ISNULL(src.CategoryKey,-1)
        OR  ISNULL(tgt.CategoryName,'PLACEHOLDER') <> ISNULL(src.CategoryName,'PLACEHOLDER')
        OR  ISNULL(tgt.SubCategoryKey,-1) <> ISNULL(src.SubCategoryKey,-1)
        OR  ISNULL(tgt.SubCategoryName,'PLACEHOLDER') <> ISNULL(src.SubCategoryName,'PLACEHOLDER')
        );

        COMMIT TRAN;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRAN;

        THROW;
    END CATCH
END;
GO
