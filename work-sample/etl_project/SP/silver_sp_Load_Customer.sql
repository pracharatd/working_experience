SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC silver.sp_Load_Customer
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY

        -- Snapshot refresh pattern
        TRUNCATE TABLE silver.customer;

        INSERT INTO silver.customer
        (
            CustomerKey,
            GeoAreaKey,
            StartDT,
            EndDT,
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
            Longitude
        )
        SELECT
            TRY_CAST(S.CustomerKey AS INT),
            TRY_CAST(S.GeoAreaKey AS INT),
            TRY_CAST(S.StartDT AS DATE),
            TRY_CAST(S.EndDT AS DATE),
            LTRIM(RTRIM(S.Continent)),
            LTRIM(RTRIM(S.Gender)),
            LTRIM(RTRIM(S.Title)),
            LTRIM(RTRIM(S.GivenName)),
            LTRIM(RTRIM(S.MiddleInitial)),
            LTRIM(RTRIM(S.Surname)),
            LTRIM(RTRIM(S.StreetAddress)),
            LTRIM(RTRIM(S.City)),
            LTRIM(RTRIM(S.State)),
            LTRIM(RTRIM(S.StateFull)),
            LTRIM(RTRIM(S.ZipCode)),
            LTRIM(RTRIM(S.Country)),
            LTRIM(RTRIM(S.CountryFull)),
            TRY_CAST(S.Birthday AS DATE),
            TRY_CAST(S.Age AS INT),
            LTRIM(RTRIM(S.Occupation)),
            LTRIM(RTRIM(S.Company)),
            LTRIM(RTRIM(S.Vehicle)),
            TRY_CAST(S.Latitude AS DECIMAL(18,10)),
            TRY_CAST(S.Longitude AS DECIMAL(18,10))
        FROM bronze.customer S
        WHERE TRY_CAST(S.CustomerKey AS INT) IS NOT NULL;

    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;
GO
