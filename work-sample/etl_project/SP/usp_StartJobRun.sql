IF OBJECT_ID('JobConfig.usp_StartJobRun') IS NOT NULL
    DROP PROCEDURE JobConfig.usp_StartJobRun;
GO

CREATE PROCEDURE JobConfig.usp_StartJobRun
    @BatchId INT,
    @EntityId INT,
    @Zone VARCHAR(200),
    @FileName VARCHAR(300),
    @PipelineName VARCHAR(200),
    @StoredProcedureName VARCHAR(200)
AS
BEGIN

    DECLARE @CurrentTime DATETIME2 = SYSDATETIME();

    INSERT INTO JobConfig.JobRunHistory
    (
        BatchId,
        EntityId,
        Zone,
        EntityName,
        PipelineName,
        StoredProcedureName,
        JobStartTime,
        Status,
        CreatedAt
    )
    VALUES
    (
        @BatchId,
        @EntityId,
        @Zone,
        @FileName,
        @PipelineName,
        @StoredProcedureName,
        @CurrentTime,
        'RUNNING',
        @CurrentTime
    );

    SELECT TOP 1 JobRunId
    FROM JobConfig.JobRunHistory
    WHERE BatchId = @BatchId
      AND JobStartTime = @CurrentTime
    ORDER BY JobRunId DESC;

END;
GO
