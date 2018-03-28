-------- 후원재개 6개월 연간 콜 
USE work
GO

SELECT
	--D.회원번호,
	--'후원재시작-미처리' AS [기록분류/상세분류],
	--CONVERT(date,GETDATE()) AS 일자, 
	--CONVERT(date,GETDATE()) AS 참고일, 
	--'SK-진행' AS 구분1,
	--'RA.CALL_WV' AS 제목,	
	--CASE
	--WHEN D.납부방법 = 'CMS' AND BR.결과메세지 is not null THEN BR.결과메세지
	--WHEN D.납부방법 = '신용카드' AND CR.실패사유 is not null THEN CR.실패사유
	--ELSE ''
	--END AS 내용,
	--F.최근Freezing일,
	--BCR.최근출금일
	D.회원번호, D.회원상태, D.가입일, D.최종납부년월
FROM
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보 D
LEFT JOIN
	(SELECT
		회원번호
	FROM
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 
	WHERE
		기록구분2 like '1%') CR
ON
	D.회원번호 = CR.회원번호
LEFT JOIN
	(SELECT 
		회원번호
	FROM
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 
	WHERE
		기록분류 like N'TM_후원재시작%'
		AND 기록분류상세 in (N'통성-재시작동의',N'통성-재시작거절')
		AND 참고일 >= CONVERT(varchar(10), '2017-01-01', 126)
		) RS
ON
	D.회원번호 = RS.회원번호
LEFT JOIN
	(SELECT 
		회원번호
	FROM
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 
	WHERE
		기록분류상세=N'결번') UN
ON
	D.회원번호 = UN.회원번호
LEFT JOIN
	(SELECT
		회원번호
	FROM
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 
	WHERE
		기록분류='Cancellation'
		AND 제목='14') C14
ON
	D.회원번호 = C14.회원번호
LEFT JOIN
	(SELECT
		회원번호
	FROM
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 
	WHERE
		기록분류 like 'TM%'
		AND ((기록분류상세 =N'제외') OR (기록분류상세 =N'무응' AND 기록구분2 is null))
		AND 참고일 > CONVERT(varchar(10), DATEADD(day, -45, GETDATE()), 126)) M3
ON
	D.회원번호 = M3.회원번호
LEFT JOIN
	(SELECT
		회원번호
	FROM
		MRMRT.그린피스동아시아서울사무소0868.DBO.UV_GP_후원자정보
	WHERE
		등록구분=N'외국인') F
ON
	D.회원번호 = F.회원번호
LEFT JOIN
	(SELECT
		회원번호
	FROM
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 
	WHERE
		기록분류 like 'TM_후원재시작%'
		AND 처리진행사항='SK-진행') RP
ON
	D.회원번호 = RP.회원번호
LEFT JOIN
	(SELECT
		회원번호
	FROM
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 
	WHERE
		기록분류 = 'Cancellation'
		AND 참고일 > CONVERT(DATE, DATEADD(month, -2, GETDATE()), 126)) C
ON
	D.회원번호 = C.회원번호
LEFT JOIN
	dbo.no_response NR
ON
	D.회원번호 = NR.회원번호
WHERE
	--D.최종납부년월 >= '2016-12'																		-- Annual Reactivation 콜이랑 안 겹치게, 최종납부년월이 2016년 10월 이상인 사람만
	--AND 
	D.최종납부년월 > SUBSTRING(CONVERT(varchar(10), DATEADD(month, -13, GETDATE()), 126), 1, 7)		-- Monthly Reactivation 콜이랑 안 겹치게, 미납납부 1년이 넘은 사람은 제외 	
	AND D.최종납부년월 <= SUBSTRING(CONVERT(varchar(10), DATEADD(month, -7, GETDATE()), 126), 1, 7)	-- 미납납부한 지 6개월 이상인 사람만
	AND D.최초등록구분 = N'정기'																		-- 최초등록구분이 정기인 사람만
	AND D.휴대전화번호='유'																			-- 휴대전화번호가 있는 사람만
	AND D.회원상태 in ('Freezing', 'canceled')														-- 회원상태가 canceled거나 freezing인 사람만
	AND CR.회원번호 is null																			-- 통화반응이 1번인 사람 제외
	AND RS.회원번호 is null																			-- 2017년부터 후원재시작 콜 동의 혹은 거부한 사람 제외
	AND UN.회원번호 is null																			-- 결번인 사람 제외
	AND C14.회원번호 is null																			-- 취소 사유가 이민인 사람 제외
	AND M3.회원번호 is null																			-- 최근 45일간 TM콜이 할당되어 통화 성공한 사람 제외
	AND F.회원번호 is null																			-- 외국인 제외
	AND RP.회원번호 is null																			-- 후원재시작 콜 진행 중인 사람 제외
	AND NR.회원번호 is null																			-- 무응 연속 3번인 사람 제외
	AND C.회원번호 is null																			-- 2달 이내에 Cancellation 요청한 사람
ORDER BY 2 DESC, 4 DESC
GO

