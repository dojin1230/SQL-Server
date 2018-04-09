select 
	* 
from 
	[HK].[Korea Report Data].[dbo].[Table_Report_IncomeReport_KR_2018]
where 
	Year=2018 
	AND Month='Mar'

select 
	* 
from 
	[HK].[Korea Report Data].[dbo].[Table_Report_RegularPayment_KR]
where 
	DebitYear=2018 
	AND DebitMonth='Mar'

select 
	* 
from 
	[HK].[Korea Report Data].[dbo].[Table_Report_SuccessRate_KR]
where 
	Year=2018 
	AND Month=3

	
-- Supporter Count 
-- 홍콩에 데이터 넣기
INSERT INTO
	[HK].[Korea Report Data].[dbo].[Table_Supporter_Count_KR]
SELECT
	[Comparison], 
	[Region],
	[Year], 
	CASE 
	WHEN [Month]=1 THEN 'Jan'
	WHEN [Month]=2 THEN 'Feb'
	WHEN [Month]=3 THEN 'Mar'
	WHEN [Month]=4 THEN 'Apr'
	WHEN [Month]=5 THEN 'May'
	WHEN [Month]=6 THEN 'Jun'
	WHEN [Month]=7 THEN 'Jul'
	WHEN [Month]=8 THEN 'Aug'
	WHEN [Month]=9 THEN 'Sep'
	WHEN [Month]=10 THEN 'Oct'
	WHEN [Month]=11 THEN 'Nov'
	WHEN [Month]=12 THEN 'Dec'
	END AS [Month], 
	[Date],
	[ConstituentID],
	NULL AS [CampaignId],
	NULL AS [Name],
	[Source],
	[Resource],
	NULL AS [Team],
	[Type],
	[NewDonor_Actual],
	NULL AS [NewDonorAmt_Actual],
	NULL AS [Age]
FROM
	[report].dbo.[supporter_ALC]
WHERE
	Year=2018 AND Month = Month(DATEADD(mm, DATEDIFF(mm, 0, GETDATE())-2, 0))

-- 한국과 건수 비교
SELECT 
	'HK' AS Supporter_Count, COUNT(1) AS 건수
FROM 
	[HK].[Korea Report Data].[dbo].[Table_Supporter_Count_KR]
WHERE 
	Year=2018 
	AND Month='Feb'
UNION ALL
SELECT 
	'Korea' AS Supporter_Count, COUNT(1) AS 건수
FROM 
	[report].dbo.[supporter_ALC]
WHERE 
	Year=2018 
	AND Month=2


