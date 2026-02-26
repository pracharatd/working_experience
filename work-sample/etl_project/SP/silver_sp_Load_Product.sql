SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE silver.sp_Load_Product
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY

        -- Snapshot refresh pattern
        TRUNCATE TABLE silver.product;

        INSERT INTO silver.product
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
            SubCategoryName
        )
        SELECT
            TRY_CAST(S.ProductKey AS INT),
            LTRIM(RTRIM(S.ProductCode)),
            LTRIM(RTRIM(S.ProductName)),
            LTRIM(RTRIM(S.Manufacturer)),
            LTRIM(RTRIM(S.Brand)),
            LTRIM(RTRIM(S.Color)),
            LTRIM(RTRIM(S.WeightUnit)),
            TRY_CAST(S.Weight AS DECIMAL(18,4)),
            TRY_CAST(S.Cost AS DECIMAL(18,4)),
            TRY_CAST(S.Price AS DECIMAL(18,4)),
            TRY_CAST(S.CategoryKey AS INT),
            LTRIM(RTRIM(S.CategoryName)),
            TRY_CAST(S.SubCategoryKey AS INT),
            LTRIM(RTRIM(S.SubCategoryName))
        FROM bronze.product S
        WHERE TRY_CAST(S.ProductKey AS INT) IS NOT NULL;

    END TRY
    BEGIN CATCH
        THROW;
    END CATCH

END;
GO
