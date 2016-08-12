USE [Credit]
GO

CREATE NONCLUSTERED INDEX [charge_charge_dt]
ON [dbo].[charge] ([charge_dt])
INCLUDE ([charge_amt], [charge_code],[member_no] );
GO

CREATE PROCEDURE dbo.pr_charge_dc_v1
    @charge_dt NVARCHAR(MAX)
AS 
SELECT  [member].[member_no],
        [charge].[charge_dt],
        [charge].[charge_amt],
        [charge].[charge_code]
FROM    [dbo].[charge]
INNER JOIN [dbo].[member]
        ON [member].[member_no] = [charge].[member_no]
WHERE   CONVERT(NVARCHAR(MAX), [charge_dt], 121) = @charge_dt;
GO

CREATE PROCEDURE dbo.pr_charge_dc_v2 @charge_dt DATETIME
AS 
SELECT  [member].[member_no],
        [charge].[charge_dt],
        [charge].[charge_amt],
        [charge].[charge_code]
FROM    [dbo].[charge]
INNER JOIN [dbo].[member]
        ON [member].[member_no] = [charge].[member_no]
WHERE   [charge_dt] = @charge_dt;
GO

-- This is good
EXEC dbo.pr_charge_dc_v1 '1999-07-14 10:43:38.273';
EXEC dbo.pr_charge_dc_v2 '1999-07-14 10:43:38.273';
GO

-- But what about something like this? (CAST on predicate, but not in JOIN)
SELECT  CAST([member].[member_no] AS VARCHAR(25)) AS [member_no],
        [charge].[charge_dt],
        [charge].[charge_amt],
        [charge].[charge_code]
FROM    [dbo].[charge]
INNER JOIN [dbo].[member]
        ON [member].[member_no] = [charge].[member_no]
WHERE   [charge_dt] = '1999-07-14 10:43:38.273';


DROP INDEX [charge_charge_dt] ON [dbo].[charge];
GO

DROP PROCEDURE [dbo].[pr_charge_dc_v1];
GO

DROP PROCEDURE [dbo].[pr_charge_dc_v2];
GO
