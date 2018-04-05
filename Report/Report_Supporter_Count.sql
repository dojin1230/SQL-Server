USE report
go

-- 0. 전월 mid Income 때 update했던 데이터 삭제하고 전월까지 update된 테이블 백업
DELETE FROM
	[report].[dbo].[supporter_ALC]
WHERE
	Year = 2018
	AND Month = Month(DATEADD(mm, DATEDIFF(mm, 0, GETDATE())-1, 0))
GO
SELECT
	*
INTO
	[report].[dbo].[supporter_ALC_201802]
FROM
	[report].[dbo].[supporter_ALC]
GO


-- 1. Acquired donor 
-- 1-1. New Acquired donor for last month
INSERT INTO [report].[dbo].[supporter_ALC]
SELECT
	'Actual' AS [Comparison], 
	'Korea' AS [Region],	
	Year(DATEADD(mm, DATEDIFF(mm, 0, GETDATE())-1, 0)) AS [Year],				-- the year of last month
	Month(DATEADD(mm, DATEDIFF(mm, 0, GETDATE())-1, 0)) AS [Month],				-- last month
	CONVERT(DATE, DATEADD(mm, DATEDIFF(mm, 0, GETDATE())-1, 0)) AS [Date],		-- the first day of last month
	D.회원번호 AS [ConstituentID],
	CASE
	WHEN D.최초등록구분=N'정기' THEN 'Regular'
	WHEN D.최초등록구분=N'일시' THEN 'One-off'
	END AS [Type],
	CASE 
	WHEN D.가입경로=N'거리모집' THEN 'Direct Dialogue'
	WHEN D.가입경로=N'인터넷/홈페이지' THEN 'Web'
	WHEN D.가입경로=N'Lead Conversion' THEN D.가입경로
	ELSE 'Other'
	END AS [Source],
	CASE 
	WHEN D.소속 != 'Inhouse' THEN 'Agency'
	ELSE 'Inhouse'
	END AS [Resource],
	1 AS [NewDonor_Actual]
FROM
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보 D
WHERE	-- donors whose first payment is last month
	D.최초납부년월 = SUBSTRING(CONVERT(varchar(10), DATEADD(mm, DATEDIFF(mm, 0, GETDATE())-1, 0), 126), 1, 7)


-- 1-2. Reactivation for last month
INSERT INTO [report].[dbo].[supporter_ALC]
SELECT
	'Actual' AS [Comparison], 
	'Korea' AS [Region],	
	Year(DATEADD(mm, DATEDIFF(mm, 0, GETDATE())-1, 0)) AS [Year],				-- the year of last month
	Month(DATEADD(mm, DATEDIFF(mm, 0, GETDATE())-1, 0)) AS [Month],				-- last month
	CONVERT(DATE, DATEADD(mm, DATEDIFF(mm, 0, GETDATE())-1, 0)) AS [Date],	-- the first day of last month
	A.회원번호 AS [ConstituentID],
	'Regular' AS [Type],
	'Reactivation' AS [Source],
	'Agency' AS [Resource],
	1 AS [NewDonor_Actual]
FROM
	(
	SELECT
		H.회원번호, MIN(PR.납부일) 첫결제일
	FROM
		(
		SELECT
			회원번호, 참고일 AS 가입일
		FROM
			MRMRT.그린피스동아시아서울사무소0868.DBO.UV_GP_관리기록
		WHERE
			기록분류 like N'TM_후원재시작%'
			AND 기록분류상세=N'통성-재시작동의'
			AND 참고일 >= '2018-01-01'
		) H
	LEFT JOIN
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_결제정보 PR
	ON	
		H.회원번호 = PR.회원번호
	WHERE
		PR.납부일 >= H.가입일
	GROUP BY
		H.회원번호
	) A
WHERE	-- donors whose first payment is last month since they agreed to donate again 
	첫결제일 >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE())-1, 0)
	AND 첫결제일 < DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0)

-- 2. Lapsed donor for last month
INSERT INTO [report].[dbo].[supporter_ALC]
SELECT
	'Actual' AS [Comparison], 
	'Korea' AS [Region],	
	Year(DATEADD(mm, DATEDIFF(mm, 0, GETDATE())-1, 0)) AS [Year],				-- the year of last month
	Month(DATEADD(mm, DATEDIFF(mm, 0, GETDATE())-1, 0)) AS [Month],				-- last month
	CONVERT(DATE, DATEADD(mm, DATEDIFF(mm, 0, GETDATE())-1, 0)) AS [Date],	-- the first day of last month
	D.회원번호 AS [ConstituentID],
	CASE
	WHEN D.최초등록구분=N'정기' THEN 'Regular'
	WHEN D.최초등록구분=N'일시' THEN 'One-off'
	END AS [Type],
	'Lapsed' AS [Source],
	'Lapsed' AS [Resource],
	-1 AS [NewDonor_Actual]
FROM
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보 D
WHERE	 -- donors whose last payment was before 13 months 
	D.최종납부년월 = SUBSTRING(CONVERT(varchar(10), DATEADD(month, -13, GETDATE()), 126), 1, 7) 
GO

-- 3. Current donor for last month
INSERT INTO [report].[dbo].[supporter_ALC]
SELECT
	'Actual' AS [Comparison], 
	'Korea' AS [Region],	
	Year(DATEADD(mm, DATEDIFF(mm, 0, GETDATE())-1, 0)) AS [Year],				-- the year of last month
	Month(DATEADD(mm, DATEDIFF(mm, 0, GETDATE())-1, 0)) AS [Month],				-- last month
	CONVERT(DATE, DATEADD(mm, DATEDIFF(mm, 0, GETDATE())-1, 0)) AS [Date],	-- the first day of last month
	D.회원번호 AS [ConstituentID],
	CASE
	WHEN D.최초등록구분=N'정기' THEN 'Regular'
	WHEN D.최초등록구분=N'일시' THEN 'One-off'
	END AS [Type],
	'Current' AS [Source],
	'Current' AS [Resource],
	1 AS [NewDonor_Actual]
FROM
	(
	SELECT
		회원번호
	FROM
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_결제정보
	WHERE
		환불상태 != N'전액환불'  -- donors whose last payment is within a year but not ones whose first payment is this month
		AND 납부일 >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE())-12, 0)
		AND 납부일 < DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0)
	GROUP BY
		회원번호
	) PR
LEFT JOIN
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보 D
ON
	PR.회원번호 = D.회원번호

-- 홍콩 데이터 확인하기
SELECT 
	*
FROM
	[HK].[Korea Report Data].[dbo].[Table_SupporterCount_KR] 
WHERE
	 Year=2018
	 AND Month = 'Mar'

-- 홍콩 데이터 넣기
INSERT INTO
	[HK].[Korea Report Data].[dbo].[Table_SupporterCount_KR]
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
	Year=2018 AND Month = Month(DATEADD(mm, DATEDIFF(mm, 0, GETDATE())-1, 0))

---- Join donor 
--ALTER VIEW [vw_join_count_monthly] AS
--SELECT
--	D.회원번호 AS [Constituent_id],
--	Year(D.가입일) AS [Join year],
--	Month(D.가입일) AS [Join month],
--	CASE 
--	WHEN D.가입경로='거리모집' THEN 'Direct Dialogue'
--	WHEN D.가입경로='인터넷/홈페이지' THEN 'Web'
--	WHEN D.가입경로='Lead Conversion' THEN D.가입경로
--	ELSE 'Others'
--	END AS [Source],
--	CASE 
--	WHEN D.소속 != 'Inhouse' THEN 'Agency'
--	ELSE 'Inhouse'
--	END AS [Resource],
--	CASE
--	WHEN D.최초등록구분='정기' THEN 'Regular'
--	WHEN D.최초등록구분='일시' THEN 'One-off'
--	END AS [Type],
--	D.가입일
--FROM
--	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보 D
--WHERE
--	가입일 >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE())-1, 0)
--	AND 가입일 < DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0)
--UNION ALL
--SELECT
--	D.회원번호 AS [Constituent_id],
--	Year(H.참고일) AS [Join year],
--	Month(H.참고일) AS [Join month],
--	'Reactivation' AS [Source],
--	'Agency' AS [Resource],
--	CASE
--	WHEN D.최초등록구분='정기' THEN 'Regular'
--	WHEN D.최초등록구분='일시' THEN 'One-off'
--	END AS [Type],
--	H.참고일 AS 가입일
--FROM
--	MRMRT.그린피스동아시아서울사무소0868.DBO.UV_GP_관리기록 H
--LEFT JOIN
--	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보 D
--ON
--	H.회원번호 = D.회원번호
--WHERE
--	H.기록분류='TM_후원재시작'
--	AND H.기록분류상세='통성-재시작동의'
--	AND H.참고일 >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE())-1, 0)
--	AND H.참고일 < DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0)


---- Cancel donor 
--ALTER VIEW [vw_cancel_count_monthly] AS
--SELECT
--	D.회원번호 AS [Constituent_id],
--	Year(H.참고일) AS [Canceled year],
--	Month(H.참고일) AS [Canceled month],
--	GETDATE() AS [Last updated]
--FROM
--	MRMRT.그린피스동아시아서울사무소0868.DBO.UV_GP_관리기록 H
--LEFT JOIN
--	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보 D
--ON
--	H.회원번호 = D.회원번호
--WHERE
--	H.기록분류 = 'Cancellation'
--	AND H.기록분류상세 like '%canceled%'
--	AND H.참고일 >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE())-1, 0)
--	AND H.참고일 < DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0)
