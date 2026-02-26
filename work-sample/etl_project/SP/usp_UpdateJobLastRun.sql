IF OBJECT_ID('JobConfig.usp_UpdateJobLastRun') IS NOT NULL
    DROP PROCEDURE JobConfig.usp_UpdateJobLastRun;
GO

CREATE PROCEDURE JobConfig.usp_UpdateJobLastRun
    @SourceDetailId INT,
    @Zone           VARCHAR(100),
    @EntityName     VARCHAR(150),
    @RowsProcessed  BIGINT,
    @Status         VARCHAR(20)
AS
BEGIN

    DELETE FROM JobConfig.JobLastRun
    WHERE SourceDetailId = @SourceDetailId;

    INSERT INTO JobConfig.JobLastRun
    (
        SourceDetailId,
        Zone,
        EntityName,
        LastExtractStartTime,
        LastExtractEndTime,
        LastJobEndTime,
        LastStatus,
        LastRowsProcessed,
        UpdatedAt
    )
    VALUES
    (
        @SourceDetailId,
        @Zone,
        @EntityName,
        NULL,
        NULL,
        SYSDATETIME(),
        @Status,
        @RowsProcessed,
        SYSDATETIME()
    );

END;
GO
