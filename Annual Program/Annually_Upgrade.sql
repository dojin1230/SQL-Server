use work
go

--CREATE VIEW [dbo].[vw_call_annual_upgrade]
--AS
SELECT
	--P.회원번호, 
	--'' AS 내용,
	--CONVERT(DATE,GETDATE(),126) AS 일자,
	--'TM_후원증액_연간-미처리' AS [기록분류/상세분류],
	--'SK-진행' AS 구분1,
	--'UP.CALL_WV' AS 제목
	P.회원번호, I.휴대전화번호, P.최종납부일, D.납부금액, PA.평균금액
FROM
	(SELECT
		A.회원번호, 납부건수, 총금액, 최종납부일
	FROM
		(
		SELECT
			회원번호, count(납부일) 납부건수, sum(납부금액) 총금액, MAX(납부일) 최종납부일
		FROM
			MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_결제정보 
		WHERE
			납부일 >= CONVERT(DATE, '2017-01-01', 126)
			AND 납부일 < CONVERT(DATE, '2018-01-01', 126)
			AND 정기수시 ='정기'
			AND 환불상태 =''
			--AND 납부금액 >= 10000
		GROUP BY 회원번호
		) A	
	WHERE
		A.납부건수 >= 5 AND A.총금액 >= 50000) P	-- 2017년 총 5회 이상, 총 5만원 이상 
LEFT JOIN
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보 D
ON 
	P.회원번호 = D.회원번호
LEFT JOIN
	(SELECT
		회원번호, 기록구분2
	FROM
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 
	WHERE
		기록구분2 like '1%' OR 기록구분2 like '2%') CR
ON
	P.회원번호 = CR.회원번호
LEFT JOIN
	(SELECT 
		회원번호, count(1) 거절수
	FROM
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 
	WHERE
		기록분류 like 'TM_후원증액%'
		AND 기록분류상세 =N'통성-증액거절'		
	GROUP BY 회원번호
	HAVING count(1) >=2) RR
ON
	P.회원번호 = RR.회원번호
LEFT JOIN
	(SELECT 
		회원번호, count(1) 거절수
	FROM
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 
	WHERE
		기록분류 in ('TM_특별일시후원')
		AND 기록분류상세 =N'통성-후원거절'		
	GROUP BY 회원번호
	HAVING count(1) >=2) SR
ON
	P.회원번호 = RR.회원번호
LEFT JOIN
	(SELECT
		회원번호, AVG(납부금액) 평균금액
	FROM
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_결제정보 
	WHERE
		납부일 >= CONVERT(DATE, DATEADD(month, -6, GETDATE()), 126) 
		AND 정기수시='정기'
	GROUP BY
		회원번호) PA
ON
	P.회원번호 = PA.회원번호
LEFT JOIN
	(SELECT 
		회원번호
	FROM
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 
	WHERE
		기록분류=N'TM_특별일시후원'
		AND 기록분류상세 in (N'통성-후원동의',N'통성-후원거절')
		AND 참고일 >= CONVERT(DATE, '2017-01-01', 126)
		AND 참고일 < CONVERT(DATE, '2018-01-01', 126)) SS
ON
	P.회원번호 = SS.회원번호
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
		회원번호, 기록분류, 참고일
	FROM
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 
	WHERE
		기록분류=N'Cancellation'
		AND 참고일 >= CONVERT(DATE, DATEADD(year, -1, GETDATE()), 126) ) C
ON
	P.회원번호 = C.회원번호
LEFT JOIN
	(SELECT
		회원번호
	FROM
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 
	WHERE
		기록분류 like '결제관련 요청/문의'
		AND 기록분류상세 = '후원금액downgrade'
		AND 참고일 > CONVERT(DATE, DATEADD(day, -30, GETDATE()), 126)) DW30
ON
	P.회원번호 = DW30.회원번호
LEFT JOIN
	(SELECT
		회원번호
	FROM
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 
	WHERE
		기록분류 like 'TM_후원증액%'
		AND 기록분류상세 = '통성-증액거절'
		AND 참고일 > CONVERT(DATE, DATEADD(month, -6, GETDATE()), 126)) UR6
ON
	P.회원번호 = UR6.회원번호
LEFT JOIN
	(SELECT
		회원번호
	FROM
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 
	WHERE
		기록분류 like 'TM%'
		AND 기록분류상세 not in (N'제외',N'무응')
		AND 참고일 > CONVERT(DATE, DATEADD(day, -45, GETDATE()), 126)) D45
ON
	P.회원번호 = D45.회원번호
LEFT JOIN
	(SELECT
		회원번호
	FROM
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 
	WHERE
		기록분류 like 'TM_후원증액_연간'
		AND 기록일시 = CONVERT(DATETIME, '2018-02-05 00:00')) UP
ON
	P.회원번호 = UP.회원번호
LEFT JOIN
	dbo.no_response NR
ON
	P.회원번호 = NR.회원번호
LEFT JOIN
	dbo.db0_clnt_i I
ON
	P.회원번호 = I.회원번호
WHERE														-- 2017년 총 금액 5만원 이상, 총 5회 이상 납부한 사람			
	D.가입일 < CONVERT(varchar(10), '2017-06-01', 126)		-- Monthly Upgrade 콜이랑 안 겹치도록, 2017년 6월 이전에 가입한 사람
	AND UP.회원번호 is null									-- 2월 5일에 증액콜 할당한 사람 제외
	AND D.휴대전화번호='유'									-- 휴대전화번호가 있는 사람만
	AND D.회원상태='Normal'									-- 회원상태가 Normal인 사람만
	AND D.등록구분 !='외국인'									-- 외국인 제외
	AND CR.회원번호 is null									-- 반응이 1~2번인 사람 제외
	--AND DW30.회원번호 is null								-- 최근 30일 내에 downgrade 요청한 사람 제외
	AND UR6.회원번호 is null									-- 최근 6개월 내에 증액 콜 거절한 사람 제외
	AND RR.회원번호 is null									-- 과거 증액 TM에서 2회 이상 거부한 사람 제외
	AND D.납부금액 <= PA.평균금액								-- 2017년부터 지금까지 평균금액보다 현 납부금액이 높은 사람 제외
	--AND SR.회원번호 is null								-- 과거 스페셜어필 TM에서 2회 이상 거부한 사람 제외	
	--AND SD.회원번호 is null								-- 2017년 스페셜 어필 성공/거부자 사람 제외
	AND UN.회원번호 is null									-- 결번 제외
	AND D45.회원번호 is null									-- 최근 45일 이내 콜이 간 사람 제외
	AND C.회원번호 is null									-- 최근 1년 이내 캔슬 요청이 있던 사람 제외
	AND NR.회원번호 is null									-- 최근 TM결과값이 무응/통성X 연속 3번인 사람 제외