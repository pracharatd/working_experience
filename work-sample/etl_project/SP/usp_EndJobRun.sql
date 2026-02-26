IF OBJECT_ID('JobConfig.usp_EndJobRun') IS NOT NULL
    DROP PROCEDURE JobConfig.usp_EndJobRun;
GO

CREATE PROCEDURE JobConfig.usp_EndJobRun
    @JobRunId      INT,
    @RowsProcessed BIGINT,
    @Status        VARCHAR(20),
    @ErrorMessage  VARCHAR(4000)
AS
BEGIN

    DECLARE @EndTime DATETIME2 = SYSDATETIME();

    UPDATE JobConfig.JobRunHistory
    SET
        JobEndTime      = @EndTime,
        RowsProcessed   = @RowsProcessed,
        Status          = @Status,
        ErrorMessage    = @ErrorMessage,
        DurationSeconds = DATEDIFF(SECOND, JobStartTime, @EndTime),
        UpdatedAt       = @EndTime
    WHERE JobRunId = @JobRunId;

END;
GO
