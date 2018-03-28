use work
go
SELECT
	D.회원번호
FROM
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보 D
LEFT JOIN
	(SELECT
		회원번호, 기록구분2
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
		기록분류상세=N'결번') UN
ON
	D.회원번호 = UN.회원번호
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
	D.회원번호 = D45.회원번호
LEFT JOIN
	dbo.no_response NR
ON
	D.회원번호 = NR.회원번호

LEFT JOIN
	(SELECT
		회원번호
	FROM
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 
	WHERE
		처리진행사항 = 'SK-진행'
	) ING
ON 
	D.회원번호 = ING.회원번호
WHERE
	D.가입일 >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE())-4, 0)
	AND D.가입일 < DATEADD(mm, DATEDIFF(mm, 0, GETDATE())-3, 0)		-- 가입일 3개월차만 
	AND D.최초등록구분 = '정기'										-- 최초등록구분이 정기인 사람만
	AND D.휴대전화번호 = '유'										-- 휴대전화번호 있는 사람만
	AND D.등록구분 != '외국인'										-- 외국인이 아닌 사람만
	AND D.회원상태 = 'Normal'										-- 회원상태가 Normal인 사람만
	AND CR.회원번호 is null											-- 반응이 1번인 사람 제외
	AND UN.회원번호 is null											-- 결번인 사람 제외
	AND D45.회원번호 is null										-- 최근 45일 이내 콜이 간 사람 제외
	AND NR.회원번호 is null											-- 무응 연속 4번인 사람 제외
	AND ING.회원번호 IS NULL