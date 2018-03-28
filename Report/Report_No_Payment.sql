SELECT
	가입경로 [Channel], Year(가입일) [Year], Month(가입일) [Month], COUNT(회원번호) [Count]
FROM
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보 D
WHERE
	회원상태 in ('Freezing', 'canceled')
	AND 총납부건수 = 0
GROUP BY 가입경로, Year(가입일), Month(가입일)