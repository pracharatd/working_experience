IF OBJECT_ID('JobConfig.usp_StartBatch') IS NOT NULL
    DROP PROCEDURE JobConfig.usp_StartBatch;
GO

CREATE PROCEDURE JobConfig.usp_StartBatch
    @BatchName VARCHAR(200)
AS
BEGIN

    DECLARE @StartTime DATETIME2 = SYSDATETIME();

    INSERT INTO JobConfig.BatchTime
    (
        BatchName,
        BatchStartTime,
        Status,
        CreatedAt
    )
    VALUES
    (
        @BatchName,
        @StartTime,
        'RUNNING',
        @StartTime
    );

END;
GO
