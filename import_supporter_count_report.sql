INSERT INTO
	[HK].[Korea Report Data].[dbo].[Table_Supporter_Count]
	([Comparison], [Region], [Year], [Month], [Date], [ConstituentID], [Source], [Resource], [Type], [NewDonor_Actual])
SELECT	
	'Actual' AS [Comparison], 
	'Korea' AS [Region],
	CAST(2017 AS INT) AS [Year], 
	[Acquried month] AS [Month], 
	[Acquired date] AS [Date],
	[Constituent_id] AS [ConstituentID],
	[Source] AS [Source],
	[Sub-source] AS [Resource],
	[Donor type] AS [Type],
	[Count] AS [NewDonor_Actual]
FROM
	[dbo].[supporter_count_gpkr]
GO