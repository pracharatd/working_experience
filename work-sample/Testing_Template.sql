SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [QA_Playground].[spValidate_Example] AS
BEGIN

/****************************************************************************
**
** Object:				[QA_Test].[spValidate_Example] 
**
** Source:				GW
**
** Notes: 
**
*****************************************************************************
SUMMARY OF CHANGES
 

StoryID        Date			Author				Comments
---------    ----------		--------------		-----------------------------
XXXXX       2024-XXX-XX		Pracharat D.		Initial Development
*****************************************************************************/

--DROP TEMP TABLE
IF OBJECT_ID('QA_Test.TABLE_A') IS NOT NULL DROP TABLE QA_Test.TABLE_A
IF OBJECT_ID('QA_Test.TABLE_B') IS NOT NULL DROP TABLE QA_Test.TABLE_B
IF OBJECT_ID('QA_Test.TABLE_C') IS NOT NULL DROP TABLE QA_Test.TABLE_C

--Select LastJobExtractEndTime to use as filter for the staging tables
DECLARE @LastJobExtractEndTime DATETIME2 = '2011-01-01'
,@SPName VARCHAR(MAX) = 'sp_upsert_Example' 
,@Zone VARCHAR(MAX) = 'Example'

SELECT @LastJobExtractEndTime = Extract_EndTime
FROM [JobConfig].[JobLastRun]
WHERE [stored_ProcedureName] = @SPName AND [Zone] = @zone


--DEDUPLICATION
-------------------------stg_guidewire.CS_SHO_EARNED_PREM_TRAN----------------------------------------------
SELECT *
INTO QA_Test.TABLE_A
FROM (
SELECT *, ROW_NUMBER() OVER (PARTITION BY  KEY_A, ID_A ORDER BY [insert_time] DESC) AS rnb
FROM QA_Table.TABLE_A
WHERE [insert_time] <= @LastJobExtractEndTime
) x
WHERE rnb = 1

-------------------------stg_guidewire.CS_SPA_EARNED_PREM_TRAN----------------------------------------------

SELECT *
INTO QA_Test.TABLE_B
FROM (
SELECT *, ROW_NUMBER() OVER (PARTITION BY  KEY_B, ID_B ORDER BY [insert_time] DESC) AS rnb
FROM QA_Table.TABLE_B
WHERE [insert_time] <= @LastJobExtractEndTime
) x
WHERE rnb = 1

-------------------------stg_guidewire.CS_SPA_EARNED_PREM_TRAN----------------------------------------------

SELECT *
INTO QA_Test.TABLE_C
FROM (
SELECT *, ROW_NUMBER() OVER (PARTITION BY  KEY_C, ID_C ORDER BY [insert_time] DESC) AS rnb
FROM QA_Table.TABLE_C
WHERE [insert_time] <= @LastJobExtractEndTime
) x
WHERE rnb = 1

------------------------------------------------------------------------------------------------------------

--QA_Build_Script_Based_On_STM
IF OBJECT_ID('QA_Test.Example_A') IS NOT NULL DROP TABLE QA_Test.Example_A

--First Section
SELECT DISTINCT
KEY_A AS TARGET_KEY
ID_A AS TARGET_ID

INTO QA_Test.Example_A

From QA_Test.TABLE_A  TAB_A

LEFT OUTER JOIN QA_Test.RELATED_TABLE rel
ON TAB_A.KEY_A = rel.RELATED_KEY_A

--Second Section
IF OBJECT_ID('QA_Test.Example_B') IS NOT NULL DROP TABLE QA_Test.Example_B

SELECT DISTINCT
KEY_B AS TARGET_KEY
ID_B AS TARGET_ID

INTO QA_Test.Example_B

From QA_Test.TABLE_B  TAB_B

LEFT OUTER JOIN QA_Test.RELATED_TABLE rel
ON TAB_B.KEY_B = rel.RELATED_KEY_B

--Third Section
IF OBJECT_ID('QA_Test.Example_C') IS NOT NULL DROP TABLE QA_Test.Example_C

SELECT DISTINCT
KEY_C AS TARGET_KEY
ID_C AS TARGET_ID

INTO QA_Test.Example_C

From QA_Test.TABLE_C  TAB_C

LEFT OUTER JOIN QA_Test.RELATED_TABLE rel
ON TAB_C.KEY_C = rel.RELATED_KEY_C

--UNION ALL
IF OBJECT_ID('QA_Test.Example') IS NOT NULL DROP TABLE QA_Test.Example

SELECT DISTINCT *
INTO QA_Test.Example
FROM (
	SELECT DISTINCT * FROM QA_Test.Example_A

	UNION ALL

	SELECT DISTINCT * FROM QA_Test.Example_B

	UNION ALL

	SELECT DISTINCT * FROM QA_Test.Example_C
) AS x

--DEV_Records
IF OBJECT_ID('QA_Test.Target_Table') IS NOT NULL DROP TABLE QA_Test.Target_Table

SELECT * 
INTO QA_Test.Target_Table
FROM Target_Schema.Target_Table

--DECLARE FOR REPORT
DECLARE @EXECUTED_BY NVARCHAR(100)
SET @EXECUTED_BY = SUSER_SNAME();

--Data_Count_Validation_QA_Record_Counts
WITH [COUNT_QA] AS (SELECT COUNT (*) C FROM QA_Test.Example)

--Data_Count_Validation_QA_Record_Counts
,[COUNT_DEV] AS (SELECT COUNT (*) C FROM QA_Test.Target_Table)

--BK_Validation_Matched_Record_Counts
,[BK_MATCHED] AS (
    SELECT COUNT (*) C 
    FROM QA_Test.Example AS QA
    INNER JOIN QA_Test.Target_Table AS DEV
    ON QA.TARGET_KEY = DEV.TARGET_KEY
    )

--BK_Validation_Not_Matched_Record_Counts
,[BK_NOT_MATCHED] AS (
    SELECT COUNT (*) C 
    FROM QA_Test.Example AS QA
    FULL OUTER JOIN QA_Test.Target_Table AS DEV
	ON QA.TARGET_KEY = DEV.TARGET_KEY 
	WHERE QA.TARGET_KEY IS NULL OR DEV.TARGET_KEY IS NULL
    )

--Data_Validation_Matched_Record_Counts
, [MATCHED] AS (
    SELECT COUNT (*) C 
    FROM QA_Test.Example AS QA
    INNER JOIN QA_Test.Target_Table AS DEV
	ON QA.TARGET_KEY = DEV.TARGET_KEY
    WHERE 
COALESCE(CAST(QA.TARGET_ID AS VARCHAR(255)), '-99') = COALESCE(CAST(DEV.TARGET_ID AS VARCHAR(255)), '-99')
)

--Data_Validation_Not_Matched_Record_Counts
,NOT_MATCHED AS (
    SELECT COUNT (*) C 
    FROM QA_Test.Example AS QA
    INNER JOIN QA_Test.Target_Table AS DEV
 	ON QA.TARGET_KEY = DEV.TARGET_KEY
    WHERE 
COALESCE(CAST(QA.TARGET_ID AS VARCHAR(255)), '-99') <> COALESCE(CAST(DEV.TARGET_ID AS VARCHAR(255)), '-99')
)

--Report
INSERT INTO QA_Playground.[QA_Validation]
SELECT 
	  GETDATE() AS EXECUTED_DATETIME,
      'TARGET_SCHEMA.TARGET_TABLE' AS TEST_NAME
      ,'GW' AS SOURCE_SYSTEM
     --Data_Count_Validation
      ,[COUNT_QA].C AS QA_COUNT
      ,[COUNT_DEV].C AS DEV_COUNT
      ,CASE
            WHEN [COUNT_QA].C = [COUNT_DEV].C 
            THEN 'PASS'
            ELSE 'FAIL'
    END AS STEP_1_COUNT_VALIDATION
     --BK_Validation
     ,[BK_MATCHED].C AS BK_MATCHED_COUNT
     ,[BK_NOT_MATCHED].C AS BK_NOT_MATCHED_COUNT
 
     ,CASE
            WHEN [BK_MATCHED].C = [COUNT_QA].C 
            AND [BK_NOT_MATCHED].C = 0
            THEN 'PASS'
            ELSE 'FAIL'
    END AS STEP_2_BK_VALIDATION
     --Data_Validation
      ,[MATCHED].C AS MATCHED_RECORDS 
      ,[NOT_MATCHED].C AS NOT_MATCHED_RECORDS
     ,CASE 
             WHEN [MATCHED].C = [COUNT_DEV].C AND [NOT_MATCHED].C = 0 
             THEN 'PASS' 
             ELSE 'FAIL' 
     END AS STEP_3_DATA_VALIDATION,
	 @EXECUTED_BY AS EXECUTED_BY,
	 NULL AS REMARK
 
FROM [COUNT_QA],[COUNT_DEV],[BK_MATCHED],[BK_NOT_MATCHED],[MATCHED],[NOT_MATCHED]

--Check Report
SELECT * FROM QA_Playground.[QA_Validation] WHERE TEST_NAME = 'TARGET_SCHEMA.TARGET_TABLE' ORDER BY EXECUTED_DATETIME DESC

/***************************************************************
Duplicates check
***************************************************************/
SELECT TARGET_KEY, COUNT(*) AS [Duplicate Count]
FROM QA_Test.Target_Table
WHERE Source_System_Code = 'GW'
GROUP BY TARGET_KEY
HAVING COUNT(*) > 1

SELECT TARGET_KEY, COUNT(*) AS [Duplicate Count]
FROM QA_Test.Example
WHERE Source_System_Code = 'GW'
GROUP BY TARGET_KEY
HAVING COUNT(*) > 1

/***************************************************************
BK NULL check
***************************************************************/
SELECT TARGET_KEY
FROM QA_Test.Target_Table
WHERE Source_System_Code = 'GW' AND (TARGET_KEY IS NULL)

SELECT TARGET_KEY
FROM QA_Test.Example
WHERE Source_System_Code = 'GW' AND (TARGET_KEY IS NULL)

----------------------------------------ROUGH WORK----------------------------------------
/*


SELECT
MAX(TARGET_KEY) AS TARGET_KEY,
MAX(TARGET_ID) AS TARGET_ID
FROM (
SELECT
CASE WHEN COALESCE(CAST(QA.TARGET_KEY AS VARCHAR(255)), '-99') <> COALESCE(CAST(DEV.TARGET_KEY AS VARCHAR(255)), '-99') THEN 1 ELSE 0 END AS TARGET_KEY
CASE WHEN COALESCE(CAST(QA.TARGET_ID AS VARCHAR(255)), '-99') <> COALESCE(CAST(DEV.SOURCE_SYSTEM_Code AS VARCHAR(255)), '-99') THEN 1 ELSE 0 END AS TARGET_ID
    FROM QA_Test.Example AS QA
    INNER JOIN QA_Test.Target_Table AS DEV
	ON QA.TARGET_KEY = DEV.TARGET_KEY 
) AS x

*/
END



GO