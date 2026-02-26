CREATE PROC bronze.bulk_load_generic
    @EntityName         VARCHAR(100),
    @BronzeSchema       VARCHAR(100),
    @BronzeTable        VARCHAR(100),
    @LandingContainer   VARCHAR(100),
    @LandingFolder      VARCHAR(100)
AS
BEGIN

    DECLARE @sql NVARCHAR(MAX)

    BEGIN
        SET @SQL = 'TRUNCATE TABLE ' 
                   + QUOTENAME(@BronzeSchema) + '.' 
                   + QUOTENAME(@BronzeTable);
        EXEC(@SQL);
    END

    SET @sql = '
    COPY INTO ' + QUOTENAME(@BronzeSchema) + '.' + QUOTENAME(@BronzeTable) + '
    FROM ''https://stpduangchaaxe.dfs.core.windows.net/' + @LandingContainer + '/' + @LandingFolder + '''
    WITH
    (
        FILE_TYPE = ''PARQUET'',
        MAXERRORS = 0
    )'

    EXEC sp_executesql @sql

END
GO
