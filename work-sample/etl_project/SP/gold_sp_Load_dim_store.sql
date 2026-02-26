CREATE PROCEDURE gold.sp_Load_dim_store
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
        FROM gold.dim_store tgt
        INNER JOIN silver.store src
            ON tgt.StoreKey = src.StoreKey
            AND tgt.IsCurrent = 1
        WHERE
            ISNULL(tgt.StoreCode,-1) <> ISNULL(src.StoreCode,-1)
        OR  ISNULL(tgt.GeoAreaKey,-1) <> ISNULL(src.GeoAreaKey,-1)
        OR  ISNULL(tgt.CountryCode,'PLACEHOLDER') <> ISNULL(src.CountryCode,'PLACEHOLDER')
        OR  ISNULL(tgt.CountryName,'PLACEHOLDER') <> ISNULL(src.CountryName,'PLACEHOLDER')
        OR  ISNULL(tgt.State,'PLACEHOLDER') <> ISNULL(src.State,'PLACEHOLDER')
        OR  ISNULL(tgt.OpenDate,'1900-01-01') <> ISNULL(src.OpenDate,'1900-01-01')
        OR  ISNULL(tgt.CloseDate,'1900-01-01') <> ISNULL(src.CloseDate,'1900-01-01')
        OR  ISNULL(tgt.Description,'PLACEHOLDER') <> ISNULL(src.Description,'PLACEHOLDER')

        -- numeric safe compare
        OR  ISNULL(CAST(tgt.SquareMeters AS DECIMAL(18,4)),-1) <> ISNULL(CAST(src.SquareMeters AS DECIMAL(18,4)),-1)

        OR  ISNULL(tgt.Status,'PLACEHOLDER') <> ISNULL(src.Status,'PLACEHOLDER');


        /* =========================================
           2. Insert new + changed rows
        ==========================================*/
        INSERT DECIMAL(18,4)O gold.dim_store
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
            Status,
            EffectiveStartDate,
            EffectiveEndDate,
            IsCurrent
        )
        SELECT
            src.StoreKey,
            src.StoreCode,
            src.GeoAreaKey,
            src.CountryCode,
            src.CountryName,
            src.State,
            src.OpenDate,
            src.CloseDate,
            src.Description,
            CAST(src.SquareMeters AS DECIMAL(18,4)),
            src.Status,
            @CurrentDateTime,
            @OpenEndDate,
            1
        FROM silver.store src
        LEFT JOIN gold.dim_store tgt
            ON tgt.StoreKey = src.StoreKey
            AND tgt.IsCurrent = 1
        WHERE
            tgt.StoreKey IS NULL
        OR (
            ISNULL(tgt.StoreCode,-1) <> ISNULL(src.StoreCode,-1)
        OR  ISNULL(tgt.GeoAreaKey,-1) <> ISNULL(src.GeoAreaKey,-1)
        OR  ISNULL(tgt.CountryCode,'PLACEHOLDER') <> ISNULL(src.CountryCode,'PLACEHOLDER')
        OR  ISNULL(tgt.CountryName,'PLACEHOLDER') <> ISNULL(src.CountryName,'PLACEHOLDER')
        OR  ISNULL(tgt.State,'PLACEHOLDER') <> ISNULL(src.State,'PLACEHOLDER')
        OR  ISNULL(tgt.OpenDate,'1900-01-01') <> ISNULL(src.OpenDate,'1900-01-01')
        OR  ISNULL(tgt.CloseDate,'1900-01-01') <> ISNULL(src.CloseDate,'1900-01-01')
        OR  ISNULL(tgt.Description,'PLACEHOLDER') <> ISNULL(src.Description,'PLACEHOLDER')
        OR  ISNULL(CAST(tgt.SquareMeters AS DECIMAL(18,4)),-1) <> ISNULL(CAST(src.SquareMeters AS DECIMAL(18,4)),-1)
        OR  ISNULL(tgt.Status,'PLACEHOLDER') <> ISNULL(src.Status,'PLACEHOLDER')
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
