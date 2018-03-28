USE work
GO

SELECT
	D.최초등록구분, count(D.회원번호)
FROM
	(
	SELECT 
		회원번호, MIN(납부일) 최초납부일
	FROM 
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_결제정보
	WHERE
		환불상태 != '전체환불'
	GROUP BY
		회원번호
	) PR
LEFT JOIN
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보 D
ON
	PR.회원번호 = D.회원번호
WHERE
	PR.최초납부일 >= convert(date, '2017-01-01', 126)
	and PR.최초납부일 < convert(date, '2018-01-01', 126)
	and (DATEDIFF(YY, D.생년월일, GETDATE()) > 25 or (D.가입경로 = '거리모집' and D.소속 = 'Inhouse' and dbo.FN_SPLIT(D.DDF명,';',2) < 930125) )
group by
	D.최초등록구분
