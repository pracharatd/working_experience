CREATE PROCEDURE gold.sp_Load_dim_customer
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE 
        @CurrentDateTime DATETIME2 = SYSDATETIME(),
        @OpenEndDate DATETIME2 = '9999-12-31';

    BEGIN TRY
        BEGIN TRAN;

        /* ========================================
           1. Expire changed rows (ALL columns)
        ======================================== */
        UPDATE tgt
        SET
            tgt.EffectiveEndDate = @CurrentDateTime,
            tgt.IsCurrent = 0
        FROM gold.dim_customer tgt
        INNER JOIN silver.customer src
            ON tgt.CustomerKey = src.CustomerKey
            AND tgt.IsCurrent = 1
        WHERE
            ISNULL(tgt.GeoAreaKey,-1) <> ISNULL(src.GeoAreaKey,-1)
        OR  ISNULL(tgt.Continent,'PLACEHOLDER') <> ISNULL(src.Continent,'PLACEHOLDER')
        OR  ISNULL(tgt.Gender,'PLACEHOLDER') <> ISNULL(src.Gender,'PLACEHOLDER')
        OR  ISNULL(tgt.Title,'PLACEHOLDER') <> ISNULL(src.Title,'PLACEHOLDER')
        OR  ISNULL(tgt.GivenName,'PLACEHOLDER') <> ISNULL(src.GivenName,'PLACEHOLDER')
        OR  ISNULL(tgt.MiddleInitial,'PLACEHOLDER') <> ISNULL(src.MiddleInitial,'PLACEHOLDER')
        OR  ISNULL(tgt.Surname,'PLACEHOLDER') <> ISNULL(src.Surname,'PLACEHOLDER')
        OR  ISNULL(tgt.StreetAddress,'PLACEHOLDER') <> ISNULL(src.StreetAddress,'PLACEHOLDER')
        OR  ISNULL(tgt.City,'PLACEHOLDER') <> ISNULL(src.City,'PLACEHOLDER')
        OR  ISNULL(tgt.State,'PLACEHOLDER') <> ISNULL(src.State,'PLACEHOLDER')
        OR  ISNULL(tgt.StateFull,'PLACEHOLDER') <> ISNULL(src.StateFull,'PLACEHOLDER')
        OR  ISNULL(tgt.ZipCode,'PLACEHOLDER') <> ISNULL(src.ZipCode,'PLACEHOLDER')
        OR  ISNULL(tgt.Country,'PLACEHOLDER') <> ISNULL(src.Country,'PLACEHOLDER')
        OR  ISNULL(tgt.CountryFull,'PLACEHOLDER') <> ISNULL(src.CountryFull,'PLACEHOLDER')
        OR  ISNULL(tgt.Birthday,'1900-01-01') <> ISNULL(src.Birthday,'1900-01-01')
        OR  ISNULL(tgt.Age,-1) <> ISNULL(src.Age,-1)
        OR  ISNULL(tgt.Occupation,'PLACEHOLDER') <> ISNULL(src.Occupation,'PLACEHOLDER')
        OR  ISNULL(tgt.Company,'PLACEHOLDER') <> ISNULL(src.Company,'PLACEHOLDER')
        OR  ISNULL(tgt.Vehicle,'PLACEHOLDER') <> ISNULL(src.Vehicle,'PLACEHOLDER')
        OR  ISNULL(tgt.Latitude,-1) <> ISNULL(src.Latitude,-1)
        OR  ISNULL(tgt.Longitude,-1) <> ISNULL(src.Longitude,-1);

        /* ========================================
           2. Insert new + changed rows
        ======================================== */
        INSERT INTO gold.dim_customer
        (
            CustomerKey,
            GeoAreaKey,
            Continent,
            Gender,
            Title,
            GivenName,
            MiddleInitial,
            Surname,
            StreetAddress,
            City,
            State,
            StateFull,
            ZipCode,
            Country,
            CountryFull,
            Birthday,
            Age,
            Occupation,
            Company,
            Vehicle,
            Latitude,
            Longitude,
            EffectiveStartDate,
            EffectiveEndDate,
            IsCurrent
        )
        SELECT
            src.CustomerKey,
            src.GeoAreaKey,
            src.Continent,
            src.Gender,
            src.Title,
            src.GivenName,
            src.MiddleInitial,
            src.Surname,
            src.StreetAddress,
            src.City,
            src.State,
            src.StateFull,
            src.ZipCode,
            src.Country,
            src.CountryFull,
            src.Birthday,
            src.Age,
            src.Occupation,
            src.Company,
            src.Vehicle,
            src.Latitude,
            src.Longitude,
            @CurrentDateTime,
            @OpenEndDate,
            1
        FROM silver.customer src
        LEFT JOIN gold.dim_customer tgt
            ON tgt.CustomerKey = src.CustomerKey
            AND tgt.IsCurrent = 1
        WHERE
            tgt.CustomerKey IS NULL
        OR (
            ISNULL(tgt.GeoAreaKey,-1) <> ISNULL(src.GeoAreaKey,-1)
        OR  ISNULL(tgt.Continent,'PLACEHOLDER') <> ISNULL(src.Continent,'PLACEHOLDER')
        OR  ISNULL(tgt.Gender,'PLACEHOLDER') <> ISNULL(src.Gender,'PLACEHOLDER')
        OR  ISNULL(tgt.Title,'PLACEHOLDER') <> ISNULL(src.Title,'PLACEHOLDER')
        OR  ISNULL(tgt.GivenName,'PLACEHOLDER') <> ISNULL(src.GivenName,'PLACEHOLDER')
        OR  ISNULL(tgt.MiddleInitial,'PLACEHOLDER') <> ISNULL(src.MiddleInitial,'PLACEHOLDER')
        OR  ISNULL(tgt.Surname,'PLACEHOLDER') <> ISNULL(src.Surname,'PLACEHOLDER')
        OR  ISNULL(tgt.StreetAddress,'PLACEHOLDER') <> ISNULL(src.StreetAddress,'PLACEHOLDER')
        OR  ISNULL(tgt.City,'PLACEHOLDER') <> ISNULL(src.City,'PLACEHOLDER')
        OR  ISNULL(tgt.State,'PLACEHOLDER') <> ISNULL(src.State,'PLACEHOLDER')
        OR  ISNULL(tgt.StateFull,'PLACEHOLDER') <> ISNULL(src.StateFull,'PLACEHOLDER')
        OR  ISNULL(tgt.ZipCode,'PLACEHOLDER') <> ISNULL(src.ZipCode,'PLACEHOLDER')
        OR  ISNULL(tgt.Country,'PLACEHOLDER') <> ISNULL(src.Country,'PLACEHOLDER')
        OR  ISNULL(tgt.CountryFull,'PLACEHOLDER') <> ISNULL(src.CountryFull,'PLACEHOLDER')
        OR  ISNULL(tgt.Birthday,'1900-01-01') <> ISNULL(src.Birthday,'1900-01-01')
        OR  ISNULL(tgt.Age,-1) <> ISNULL(src.Age,-1)
        OR  ISNULL(tgt.Occupation,'PLACEHOLDER') <> ISNULL(src.Occupation,'PLACEHOLDER')
        OR  ISNULL(tgt.Company,'PLACEHOLDER') <> ISNULL(src.Company,'PLACEHOLDER')
        OR  ISNULL(tgt.Vehicle,'PLACEHOLDER') <> ISNULL(src.Vehicle,'PLACEHOLDER')
        OR  ISNULL(tgt.Latitude,-1) <> ISNULL(src.Latitude,-1)
        OR  ISNULL(tgt.Longitude,-1) <> ISNULL(src.Longitude,-1)
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
