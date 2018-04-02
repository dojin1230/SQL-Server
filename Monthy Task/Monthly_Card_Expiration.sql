-- 결번이거나 통화반응이 1인 사람 제외
-- 무응 연속 4번인 사람 제외
-- 외국인 제외
-- 전화번호 있는 사람만
-- Normal만

USE WORK
GO

SELECT
	D.회원번호, 
	CASE
	WHEN ING.회원번호 is null THEN '' 
	ELSE '진행 중인 콜에서 진행 바람' 
	END AS 내용,
	CONVERT(DATE, GETDATE(), 126) AS 일자,
	CASE
	WHEN UN.회원번호 is null AND D.등록구분 != '외국인' AND D.휴대전화번호='유' AND ING.회원번호 is null THEN 'TM_신용카드종료예정-미처리' 
	WHEN ING.회원번호 is not null THEN 'TM_신용카드종료예정-제외' 
	ELSE 'Freezing-CC/CMS problems'
	END AS [기록분류/상세분류],
	CASE
	WHEN UN.회원번호 is null AND D.등록구분 != '외국인' AND D.휴대전화번호='유' AND ING.회원번호 is null THEN 'SK-진행' 
	WHEN ING.회원번호 is not null THEN 'SK-완료' 
	ELSE 'IH-완료'
	END AS 구분1,
	CASE
	WHEN UN.회원번호 is null AND D.등록구분 != '외국인' AND D.휴대전화번호='유' THEN 'UC.CALL_WV' 
	ELSE 'F'
	END AS 제목,
	UN.회원번호 AS 결번여부, D.등록구분, D.휴대전화번호
FROM
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보 D
LEFT JOIN
	(SELECT
		*
	FROM
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록
	WHERE
		기록분류상세 = '결번'
		OR 기록구분2 like '1%') UN
ON 
	D.회원번호 = UN.회원번호
LEFT JOIN
	(SELECT
		회원번호
	FROM
		dbo.no_response) NR
ON
	D.회원번호 = NR.회원번호
LEFT JOIN
	(SELECT
		회원번호, 기록일시
	FROM
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 
	WHERE
		기록분류 like 'TM%'
		AND 처리진행사항 in ('SK-진행', 'IH-지연')
		AND 기록일시 >= CONVERT(DATETIME, DATEADD(day, -7, GETDATE()), 126)
	) ING
ON 
	D.회원번호 = ING.회원번호	
WHERE
	--NR.회원번호 is null				-- 무응 연속 4번인 사람 제외
	D.회원상태 = 'Normal'		-- Normal만
	AND D.회원번호 IN
	('82014996',
'82015665',
'82017100',
'82019105',
'82022602',
'82024870',
'82036427',
'82038272',
'82041380',
'82044908',
'82045699',
'82047573',
'82048622',
'82050055',
'82050589',
'82053065',
'82054584',
'82054685') 
ORDER BY 4




