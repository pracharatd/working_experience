SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE silver.sp_Load_Store
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY

        -- Snapshot refresh pattern
        TRUNCATE TABLE silver.store;

        INSERT INTO silver.store
        (
            StoreKey,
            StoreCode,
            GeoAreaKey,
            CountryCode,
            CountryName,
            State,
            OpenDate,
            CloseDate,
            Description,
            SquareMeters,
            Status
        )
        SELECT
            TRY_CAST(S.StoreKey AS INT),
            LTRIM(RTRIM(S.StoreCode)),
            TRY_CAST(S.GeoAreaKey AS INT),
            LTRIM(RTRIM(S.CountryCode)),
            LTRIM(RTRIM(S.CountryName)),
            LTRIM(RTRIM(S.State)),
            TRY_CAST(S.OpenDate AS DATE),
            TRY_CAST(S.CloseDate AS DATE),
            LTRIM(RTRIM(S.Description)),
            TRY_CAST(S.SquareMeters AS DECIMAL(18,4)),
            LTRIM(RTRIM(S.Status))
        FROM bronze.store S
        WHERE TRY_CAST(S.StoreKey AS INT) IS NOT NULL;

    END TRY
    BEGIN CATCH
        THROW;
    END CATCH

END;
GO
