IF OBJECT_ID('JobConfig.usp_EndBatch') IS NOT NULL
    DROP PROCEDURE JobConfig.usp_EndBatch;
GO

CREATE PROCEDURE JobConfig.usp_EndBatch
    @BatchId INT,
    @Status  VARCHAR(20)
AS
BEGIN

    DECLARE @EndTime DATETIME2 = SYSDATETIME();

    UPDATE JobConfig.BatchTime
    SET
        BatchEndTime    = @EndTime,
        Status          = @Status,
        DurationSeconds = DATEDIFF(SECOND, BatchStartTime, @EndTime),
        UpdatedAt       = @EndTime
    WHERE BatchId = @BatchId;

END;
GO
