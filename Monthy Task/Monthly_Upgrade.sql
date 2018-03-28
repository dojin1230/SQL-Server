USE work
go
SELECT
	PR.회원번호, 
	CASE
	WHEN ING.회원번호 is null THEN '' 
	ELSE '진행 중인 콜에서 진행 바람' 
	END AS 내용,
	CONVERT(DATE,GETDATE(),126) AS 일자,
	CASE
	WHEN ING.회원번호 is null THEN 'TM_후원증액-미처리'
	ELSE 'TM_후원증액-제외'
	END AS [기록분류/상세분류],
	CASE
	WHEN ING.회원번호 is null THEN 'SK-진행'
	ELSE 'SK-완료'
	END AS 구분1,
	'UP.CALL_WV' AS 제목
	--PR.회원번호, D.가입일
FROM
	(SELECT
		A.회원번호, 납부건수, 총금액
	FROM
		(
		SELECT
			회원번호, count(납부일) 납부건수, sum(납부금액) 총금액
		FROM
			MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_결제정보 
		WHERE
			정기수시='정기'
			AND 환불상태=''
			AND 납부금액 >= 10000
		GROUP BY 회원번호
		) A	
	WHERE
		A.납부건수 >= 4 AND A.총금액 >= 40000) PR	-- 여태 납부한 후원금이 1만원 이상,  총 4회 이상 납부한 사람		
LEFT JOIN
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보 D
ON 
	PR.회원번호 = D.회원번호
LEFT JOIN
	(SELECT
		회원번호, 기록구분2
	FROM
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 
	WHERE
		기록구분2 like '1%' OR 기록구분2 like '2%') CR
ON
	PR.회원번호 = CR.회원번호
LEFT JOIN
	(SELECT
		회원번호
	FROM
		(SELECT
			회원번호, AVG(납부금액) 평균금액, MIN(납부금액) 최소금액
		FROM
			MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_결제정보 
		WHERE
			납부일 >= CONVERT(varchar(10), DATEADD(month, -7, GETDATE()), 126)
			AND 정기수시='정기'
		GROUP BY
			회원번호) C
		WHERE
			C.평균금액 != C.최소금액) RG
ON
	PR.회원번호 = RG.회원번호
LEFT JOIN
	(SELECT 
		회원번호, 기록분류, 기록분류상세, 참고일
	FROM
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 
	WHERE
		기록분류=N'TM_특별일시후원'
		AND 기록분류상세 in (N'통성-후원동의',N'통성-후원거절')
		AND 참고일 >= CONVERT(varchar(10), DATEADD(month, -7, GETDATE()), 126)) SS
ON
	PR.회원번호 = SS.회원번호
LEFT JOIN
	(SELECT 
		회원번호, 기록분류상세
	FROM
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 
	WHERE
		기록분류상세=N'결번') UN
ON
	PR.회원번호 = UN.회원번호
LEFT JOIN
	(SELECT 
		회원번호, 기록분류, 참고일
	FROM
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 
	WHERE
		기록분류=N'Cancellation'
		AND 참고일 >= CONVERT(varchar(10), DATEADD(month, -7, GETDATE()), 126)) C
ON
	PR.회원번호 = C.회원번호
LEFT JOIN
	(SELECT
		회원번호, 기록분류, 참고일
	FROM
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 
	WHERE
		기록분류 like 'TM%'
		AND 기록분류상세 not in (N'제외',N'무응')
		AND 참고일 > CONVERT(varchar(10), DATEADD(day, -45, GETDATE()), 126)) D45
ON
	PR.회원번호 = D45.회원번호
LEFT JOIN
	(SELECT
		회원번호, 기록분류, 참고일
	FROM
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 
	WHERE
		기록분류 like 'TM_후원증액%'
		AND 참고일 > CONVERT(DATE, DATEADD(month, -6, GETDATE()), 126)) U60
ON
	PR.회원번호 = U60.회원번호
LEFT JOIN
	dbo.no_response NR
ON
	PR.회원번호 = NR.회원번호
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
	PR.회원번호 = ING.회원번호	
WHERE																		-- 여태 납부한 후원금이 1만원 이상, 총 4회 이상 납부한 사람	
	D.가입일 >= CONVERT(varchar(10), '2017-06-01', 126)						-- Annual Upgrade 콜이랑 안 겹치도록, 2017년 6월 이래로 가입한 사람
	AND D.가입일 < CONVERT(varchar(10), DATEADD(month, -6, GETDATE()), 126)	-- 후원 가입한 지 6개월 이상인 사람만
	AND D.휴대전화번호='유'													-- 휴대전화번호가 있는 사람만
	AND D.회원상태 = 'Normal'												-- 회원상태가 Normal인 사람만
	AND D.등록구분 !='외국인'													-- 외국인 제외	
	AND CR.회원번호 is null													-- 반응이 1~2번인 사람 제외
	AND RG.회원번호 is null													-- 최근 7개월 이내에 후원금 증액 혹은 감액한 사람 제외
	AND SS.회원번호 is null													-- 2017년 스페셜 어필 성공/거부자 사람 제외
	AND UN.회원번호 is null													-- 결번 제외
	AND D45.회원번호 is null													-- 최근 45일 이내 콜이 간 사람 제외
	AND C.회원번호 is null													-- 최근 7개월 이내에 캔슬 요청이 있던 사람 제외
	AND NR.회원번호 is null													-- 무응 연속 4번인 사람 제외
	AND U60.회원번호 is null													-- 최근 6개월 내에 증액콜을 받은 적 있는 사람 제외
ORDER BY D.가입일 DESC									