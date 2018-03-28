SELECT
	distinct 회원코드 AS 회원번호,
	'' AS 내용,
	'Freezing - CC/CMS problems' AS [기록분류/상세분류],
	'IH-완료' AS 구분1,
	'F' AS 제목,
	CONVERT(DATE, GETDATE(), 126) AS 참고일,
	CONVERT(DATE, GETDATE(), 126) AS 일자
FROM
	(
	SELECT 
		회원코드, 결과메세지
	FROM 
		MRMRT.그린피스동아시아서울사무소0868.DBO.UV_GP_CMS결제결과
		WHERE
		출금일 >= DATEADD(day, -3, GETDATE())
		and 처리결과 = '출금실패' AND 결과메세지 NOT LIKE '%잔액%'
	UNION ALL
	SELECT 
		회원코드, 실패사유
	FROM 
		MRMRT.그린피스동아시아서울사무소0868.DBO.UV_GP_신용카드결제결과
				WHERE
		출금일 >= DATEADD(day, -3, GETDATE())
		and 결과 ='실패' AND 실패사유  NOT LIKE '%잔액%' AND 실패사유 NOT LIKE '%잔고%' AND 실패사유 NOT LIKE '%한도%' 
	) BCR
LEFT JOIN
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보 D
ON
	BCR.회원코드 = D.회원번호
LEFT JOIN
	(SELECT 
		회원번호
	FROM
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 
	WHERE
		기록분류상세=N'결번') UN
ON
	BCR.회원코드 = UN.회원번호
LEFT JOIN
	(SELECT
		회원번호
	FROM
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 
	WHERE
		기록분류 like 'TM%'
		AND 기록분류상세 not in (N'제외',N'무응')
		AND 참고일 > CONVERT(varchar(10), DATEADD(day, -45, GETDATE()), 126)) D45
ON
	BCR.회원코드 = D45.회원번호
LEFT JOIN
	(SELECT
		회원번호
	FROM
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 
	WHERE
		기록구분2 like '1%') DN
ON
	BCR.회원코드 = DN.회원번호
LEFT JOIN
	(SELECT
		회원번호, 기록일시
	FROM
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 
	WHERE
		기록분류 like 'TM_결제실패%'
		AND 기록일시 >= CONVERT(DATETIME, DATEADD(day, -1, GETDATE()), 126)
	) ING
ON 
	BCR.회원코드 = ING.회원번호	
LEFT JOIN
	(SELECT 회원번호, 승인일시
	FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_신용카드승인정보
	WHERE 승인일시 >= '2018-03-09 17:04'   -- MRM에서 최근결제일의 납부신청일시 복사
	) CA
ON BCR.회원코드 = CA.회원번호
WHERE
	D.회원상태 = 'Normal'				-- 회원상태가 Normal인 사람만
	and CA.회원번호 is null				-- 카드정보 넘어간 이후에 카드승인 한 회원 제외
	AND ING.회원번호 IS NULL
	AND (D.휴대전화번호 = '무'				-- 휴대전화번호 
	or D.등록구분 = '외국인'			-- 외국인 
	or UN.회원번호 is not null				-- 결번
	or D45.회원번호 is not null				-- 최근 45일 이내에 전화를 받은 사람 
	or DN.회원번호 is not null				-- 통화반응이 1번인 사람
	)
ORDER BY 5
