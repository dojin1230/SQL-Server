USE WORK
go
SELECT
	i.회원번호,
	i.성명,
	i.우편물수신처,
	CASE
	WHEN i.우편물수신처='자택' THEN 집주소
	WHEN i.우편물수신처='직장' THEN 직장주소
	END AS 주소,
	CASE
	WHEN i.우편물수신처='자택' THEN 집주소상세
	WHEN i.우편물수신처='직장' THEN 직장주소상세
	END AS 주소상세,
	CASE
	WHEN i.우편물수신처='자택' THEN 집우편번호
	WHEN i.우편물수신처='직장' THEN 직장우편번호
	END AS 우편번호
FROM
	[dbo].[db0_clnt_i] i
LEFT JOIN
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보 D
ON
	i.회원번호 = D.회원번호
LEFT JOIN
	(SELECT 
		회원번호
	FROM 
		MRMRT.그린피스동아시아서울사무소0868.DBO.UV_GP_관리기록 H
	WHERE 
		기록분류상세='반송-X') H
ON 
	i.회원번호 = H.회원번호
WHERE
	H.회원번호 is null
	AND D.회원상태 = 'Normal'
	AND ((i.우편물수신처 = '자택' AND i.집주소 is not null) OR (i.우편물수신처 = '직장' AND i.직장주소 is not null) )
	AND (D.가입일 >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) OR (D.총납부건수 >= 2))