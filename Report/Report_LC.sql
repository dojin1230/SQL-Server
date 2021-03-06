-- Lead Conversion 
use report
go

CREATE VIEW vw_lc_report
AS
SELECT
	Code AS SupporterID,
	Year(최종통화일) AS [ProgramYear], 
	Month(최종통화일) AS [ProgramMonth], 
	'WV' AS Telemarketer,
	SUM(CASE WHEN 통화결과 ='결번' THEN 1 ELSE 0 END)	AS Unknown,
	SUM(CASE 
		WHEN 통화결과 in ('성공','거부','제외','추후재전','통성X','추후전화거부') THEN 1
		WHEN 통화결과 ='결번' THEN null 
		ELSE 0 END)	AS Reached,
	SUM(CASE 
		WHEN 통화결과 = '성공' THEN 1
		WHEN 통화결과 in ('결번','제외','미처리','무응', null) THEN null
		ELSE 0 END)	AS Accepted,
	통화결과
FROM
	[report].[dbo].[LC_WV_2017]
GROUP BY
	Code, 최종통화일, 통화결과
UNION ALL
SELECT
	code AS SupporterID,
	Year([최종통화일(=기입일)]) AS [ProgramYear], 
	Month([최종통화일(=기입일)]) AS [ProgramMonth], 
	'MPC' AS Telemarketer,
	SUM(CASE WHEN 통화결과 ='결번' THEN 1 ELSE 0 END)	AS Unknown,
	SUM(CASE 
		WHEN 통화결과 in ('성공','거부','제외','추후재전','통성-설명X','추후전화거부') THEN 1
		WHEN 통화결과 ='결번' THEN null 
		ELSE 0 END)	AS Reached,
	SUM(CASE 
		WHEN 통화결과 = '성공' THEN 1
		WHEN 통화결과 in ('결번','제외','미처리','무응', null) THEN null
		ELSE 0 END)	AS Accepted,
	통화결과
FROM
	[report].[dbo].[LC_MPC_2017]
GROUP BY
	Code, [최종통화일(=기입일)], 통화결과


SELECT
	*
FROM
	[report].[dbo].[vw_lc_report] LC
LEFT JOIN
	MRMRT.그린피스동아시아서울사무소0868.DBO.UV_GP_후원자정보 D	
ON
	LC.SupporterID = D.DDM번호
WHERE
	D.가입경로='Lead Conversion'
	


ALTER VIEW [dbo].[vw_tm_report]
AS 
SELECT
	회원번호 AS [DonorID], 
	Year(참고일) AS [ProgramYear], 
	Month(참고일) AS [ProgramMonth], 
	CASE
	WHEN 기록분류 = 'TM_감사'				THEN 'Welcome'
	WHEN 기록분류 = 'TM_감사3개월'			THEN 'Welcome 3M'
	WHEN 기록분류 = 'TM_감사6개월'			THEN 'Welcome 6M'
	WHEN 기록분류 like 'TM_결제실패_%'		THEN 'Debit Fail'
	WHEN 기록분류 = 'TM_후원증액_1년차'		THEN 'New Donor Upgrade'
	WHEN 기록분류 = 'TM_후원증액_연간'		THEN 'Annual Upgrade'
	WHEN 기록분류 like 'TM_후원재개_%'		THEN 'Unfreeze'
	WHEN 기록분류 = 'TM_후원재시작'			THEN 'Monthly Reactivation'
	WHEN 기록분류 = 'TM_후원재시작_연간'	THEN 'Annual Reactivation'
	WHEN 기록분류 = 'TM_신용카드종료예정'	THEN 'Card Expiry'
	WHEN 기록분류 = 'TM_특별일시후원'		THEN 'Special Appeal'
	WHEN 기록분류 = 'TM_CMS증빙'			THEN 'CMS Proof'
	END AS Category,
	CASE
	WHEN 처리진행사항 like 'IH%' THEN 'Inhouse'
	WHEN 처리진행사항 like 'SK%' AND 제목 like '%WV%'		THEN 'WV'
	WHEN 처리진행사항 like 'SK%' AND 제목 like '%MPC%'	THEN 'MPC'
	WHEN 처리진행사항 like 'SK%' AND 제목 like '%세일%'	THEN '세일'
	END AS Telemarketer,
	--SUM(CASE WHEN 기록분류상세 ='제외' THEN 1 ELSE 0 END)										AS OptedOut,
	SUM(CASE WHEN 기록분류상세 ='결번' THEN 1 ELSE 0 END)										AS Unknown,
	SUM(CASE 
		WHEN 기록분류상세 like '통성-%' THEN 1 
		WHEN 기록분류상세 ='결번' THEN null 
		ELSE 0 END)	AS Reached,
	SUM(CASE 
		WHEN 처리진행사항 like '%완료' AND (기록분류상세 like '%동의' OR 기록분류상세 like '%성공') THEN 1 
		WHEN 처리진행사항 like '%완료' AND 기록분류상세 in ('무응','결번','미처리') THEN null
	    WHEN 처리진행사항 like '%진행' OR 처리진행사항 like '%지연' THEN null 
		ELSE 0 END)	AS Accepted,
	처리진행사항,
	기록분류상세
FROM
	MRMRT.그린피스동아시아서울사무소0868.DBO.UV_GP_관리기록
WHERE
	기록분류 like 'TM%' 
	--AND 처리진행사항 like '%완료'
	AND 기록분류상세 != '제외'
	AND CONVERT(DATE,참고일,126) >= CONVERT(DATE, '2017-01-01', 126)
	AND CONVERT(DATE,참고일,126) < CONVERT(DATE, '2018-01-01', 126)
GROUP BY
	회원번호, 기록분류, 기록분류상세, 처리진행사항, 참고일, 제목
GO