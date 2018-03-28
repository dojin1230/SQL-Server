SELECT 
	sum(납부금액)
FROM
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_결제정보 
WHERE
	회원번호 IN ('82000154','82032414')
	and 납부일 >= CONVERT(DATE, '2017-01-01') 
		AND 납부일 < CONVERT(DATE, '2018-01-01') 
		AND 환불상태=''


select
	sum(납부금액)
FROM
	(
	SELECT 
		회원번호, 납부금액
	FROM
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_결제정보 
	WHERE
		납부일 >= CONVERT(DATE, '2017-01-01') 
		AND 납부일 < CONVERT(DATE, '2018-01-01') 
		AND 환불상태=''
	) PR
LEFT JOIN
	(
	select 
		회원번호, MIN(납부일) 첫결제일
	from 
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_결제정보 
	group by 회원번호
	) DE
ON
	PR.회원번호 = DE.회원번호
WHERE
	DE.첫결제일 >= CONVERT(DATE, '2017-01-01') 




select 
	sum(납부금액)
FROM
	(
	SELECT 
		회원번호, 납부금액
	FROM
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_결제정보 
	WHERE
		납부일 >= CONVERT(DATE, '2017-01-01') 
		AND 납부일 < CONVERT(DATE, '2018-01-01') 
		AND 환불상태=''
	) PR
LEFT JOIN	
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
			기록분류=N'TM_후원재시작'
			AND 기록분류상세=N'통성-재시작동의'
			AND 참고일 >= CONVERT(DATE, '2017-01-01') 
			AND 참고일 < CONVERT(DATE, '2018-01-01') 
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
ON
	PR.회원번호 = A.회원번호
WHERE	
	A.첫결제일 >= CONVERT(DATE, '2017-01-01') 
	AND A.첫결제일 < CONVERT(DATE, '2018-01-01') 

-------------

select
	회원번호, 첫결제일
from
	(
	select 
		회원번호, MIN(납부일) 첫결제일
	from 
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_결제정보 
	group by 회원번호
	) DE
WHERE
	DE.첫결제일 >= CONVERT(DATE, '2017-01-01') 
	and DE.첫결제일 < CONVERT(DATE, '2018-01-01') 



select 
*
from
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
			기록분류=N'TM_후원재시작'
			AND 기록분류상세=N'통성-재시작동의'
			AND 참고일 >= CONVERT(DATE, '2017-01-01') 
			AND 참고일 < CONVERT(DATE, '2018-01-01') 
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
WHERE	
	A.첫결제일 >= CONVERT(DATE, '2017-01-01') 
	AND A.첫결제일 < CONVERT(DATE, '2018-01-01') 
