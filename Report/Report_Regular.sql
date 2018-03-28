-- 0. 기존 테이블 백업 받기

SELECT 
	*
INTO 
	[report].[dbo].[regular_201802]
FROM
	[report].[dbo].[regular]

-- 1. 저번달 데이터 업데이트하기

INSERT INTO [dbo].[regular]
SELECT
	'Actual' AS [A vs B], 
	'South Korea' AS Country,
	Year(PMAX.출금일최대값) AS [Debit year], 
	Month(PMAX.출금일최대값) AS [Debit month], 
	PMAX.출금일최대값 AS [Debit date], 
	PMAX.회원코드 AS Constituent_id, 
	CASE
	WHEN 처리결과 like N'%실패%' THEN 0
	ELSE 1
	END AS Response,
	CASE 
	WHEN 처리결과 like N'출금%' THEN 'CMS'
	ELSE 'CRD'
	END AS [Payment method],
	1 AS iFrequency,
	CASE 
	WHEN 처리결과 like N'출금%' THEN CMS.신청금액
	ELSE CRD.신청금액
	END AS Amount, 
	Getdate() AS [Last updated],
	CASE
	WHEN S.가입경로=N'거리모집' THEN 'DDC-'+ S.소속
	WHEN S.가입경로=N'Lead Conversion' THEN S.가입경로
	WHEN S.가입경로=N'인터넷/홈페이지' THEN 'Web'
	ELSE 'Others'
	END AS [Join channel]
FROM
(
	SELECT
		회원코드,
		MAX(출금일) AS 출금일최대값
	FROM
	(
		SELECT
			 회원코드,
			 CONVERT(datetime, 출금일) AS 출금일
		FROM
			MRMRT.그린피스동아시아서울사무소0868.DBO.UV_GP_CMS결제결과
		WHERE
			CONVERT(date, 출금일, 126) >= CONVERT(varchar(10), DATEADD(mm, DATEDIFF(mm, 0, GETDATE())-1, 0), 126)
			AND CONVERT(date, 출금일, 126) < CONVERT(varchar(10), DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0), 126)
		UNION ALL
		SELECT
			 회원코드,
			 CONVERT(datetime, 출금일) AS 출금일
		FROM
			MRMRT.그린피스동아시아서울사무소0868.DBO.UV_GP_신용카드결제결과
		WHERE
			CONVERT(date, 출금일, 126) >= CONVERT(varchar(10), DATEADD(mm, DATEDIFF(mm, 0, GETDATE())-1, 0), 126)
			AND CONVERT(date, 출금일, 126) < CONVERT(varchar(10), DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0), 126)
	) PRES
	GROUP BY
	회원코드
) PMAX
LEFT JOIN
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_CMS결제결과 CMS
ON 
	PMAX.회원코드 = CMS.회원코드 AND PMAX.출금일최대값 = CMS.출금일
LEFT JOIN
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_신용카드결제결과 CRD
ON 
	PMAX.회원코드 = CRD.회원코드 AND PMAX.출금일최대값 = CRD.출금일
LEFT JOIN
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보 S
ON 
	PMAX.회원코드 = S.회원번호
GO

--2. 홍콩 데이터 확인

SELECT 
	* 
FROM 
	[HK].[Korea Report Data].[dbo].[Table_Report_RegularPayment_KR]
GO

--3. 홍콩에 데이터 넣기

INSERT INTO
	[HK].[Korea Report Data].[dbo].[Table_Report_RegularPayment_KR]
SELECT
	'Korea' AS Region,
	NULL AS OpportunityID,
	NULL AS RGID, 
	ConstituentID, 
	[DebitYear], 
	CASE 
	WHEN [DebitMonth]=1 THEN 'Jan'
	WHEN [DebitMonth]=2 THEN 'Feb'
	WHEN [DebitMonth]=3 THEN 'Mar'
	WHEN [DebitMonth]=4 THEN 'Apr'
	WHEN [DebitMonth]=5 THEN 'May'
	WHEN [DebitMonth]=6 THEN 'Jun'
	WHEN [DebitMonth]=7 THEN 'Jul'
	WHEN [DebitMonth]=8 THEN 'Aug'
	WHEN [DebitMonth]=9 THEN 'Sep'
	WHEN [DebitMonth]=10 THEN 'Oct'
	WHEN [DebitMonth]=11 THEN 'Nov'
	WHEN [DebitMonth]=12 THEN 'Dec'
	END AS [DebitMonth],
	[DebitDate], 
	[Amount], 
	[Success],
	NULL AS RGJoinDate,
	[Programme],
	CASE 
	WHEN [dbo].FN_SPLIT([Programme],'-',2) in ('Inhouse', 'Web', 'Others', 'Telephone') THEN 'Inhouse'
	ELSE 'Agency' 
	END AS [Resource],
	'Korea' AS [Team]
 FROM 
	[report].[dbo].[regular]
 WHERE
	[DebitDate] < CONVERT(DATETIME, '2017-01-01')