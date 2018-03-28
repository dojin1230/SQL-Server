SELECT 
	* 
FROM 
	[HK].[Korea Report Data].[dbo].[Table_Report_RegularPayment_KR]
GO
-------------------------------- 홍콩
INSERT INTO
	[HK].[Korea Report Data].[dbo].[Table_Report_RegularPayment_KR]
SELECT
	'Korea' AS Region,
	NULL AS OpportunityID,
	NULL AS RGID, 
	PMAX.회원코드 AS ConstituentID, 
	Year(PMAX.출금일최대값) AS [DebitYear], 
	--Month(PMAX.출금일최대값) AS [DebitMonth],
	'Feb' AS [DebitMonth],
	PMAX.출금일최대값 AS [DebitDate], 
		CASE 
	WHEN 처리결과 like N'출금%' THEN CMS.신청금액
	ELSE CRD.신청금액
	END AS Amount, 
	CASE
	WHEN 처리결과 like N'%실패%' THEN 0
	ELSE 1
	END AS Success,
	NULL AS RGJoinDate,
	CASE
	WHEN S.가입경로=N'거리모집' THEN 'DDC-'+ S.소속
	WHEN S.가입경로=N'Lead Conversion' THEN S.가입경로
	WHEN S.가입경로=N'인터넷/홈페이지' THEN 'Web'
	ELSE 'Others'
	END AS [Programme],
	CASE
	WHEN S.가입경로=N'거리모집' AND S.소속!='Inhouse' THEN 'Agency'
	ELSE 'Inhouse'
	END AS [Resource],
	'Korea' AS [Team]
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
			출금일 >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE())-1, 0)
			AND 출금일 < DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0)
		UNION ALL
		SELECT
			 회원코드,
			 CONVERT(datetime, 출금일) AS 출금일
		FROM
			MRMRT.그린피스동아시아서울사무소0868.DBO.UV_GP_신용카드결제결과
		WHERE
			출금일 >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE())-1, 0)
			AND 출금일 < DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0)
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
	 
-------------------------------- 한국
--백업 받기

SELECT 
	*
INTO 
	[report].[dbo].[regular_201801]
FROM
	[report].[dbo].[regular]

--업데이트하기

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


--INSERT INTO [dbo].[regular]
--select 
--[A vs B], Country, [Debit year], 
--CASE 
--WHEN [Debit month]='Jan' THEN 1
--WHEN [Debit month]='Feb' THEN 2
--WHEN [Debit month]='Mar' THEN 3
--WHEN [Debit month]='Apr' THEN 4
--WHEN [Debit month]='May' THEN 5
--WHEN [Debit month]='Jun' THEN 6
--WHEN [Debit month]='Jul' THEN 7
--WHEN [Debit month]='Aug' THEN 8
--WHEN [Debit month]='Sep' THEN 9
--WHEN [Debit month]='Oct' THEN 10
--WHEN [Debit month]='Nov' THEN 11
--WHEN [Debit month]='Dec' THEN 12
--END AS [Debit month],
--[Debit date], Constituent_id, Response,[Payment method], iFrequency, Amount, [Last updated], [Join channel]
-- from [dbo].[old_regular]
--where [Debit year] !='2017'

































-------------------------------- 한국

CREATE VIEW [dbo].[regular]
AS 
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
		--	출금일 >= CONVERT(varchar(10), DATEADD(mm, DATEDIFF(mm, 0, GETDATE())-1, 0), 126)
		--	AND 출금일 < CONVERT(varchar(10), DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0), 126)
		UNION ALL
		SELECT
			 회원코드,
			 CONVERT(datetime, 출금일) AS 출금일
		FROM
			MRMRT.그린피스동아시아서울사무소0868.DBO.UV_GP_신용카드결제결과
		--WHERE
		--	출금일 >= CONVERT(varchar(10), DATEADD(mm, DATEDIFF(mm, 0, GETDATE())-1, 0), 126)
		--	AND 출금일 < CONVERT(varchar(10), DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0), 126)
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