SELECT
	회원번호, 최초납부년월, 최종납부년월, 가입경로
FROM
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보
WHERE
	최초납부년월 is not null
	AND 최종납부년월 < '2016-11'
	AND 최초등록구분='정기'
	AND 총납부건수 >=2
GO

SELECT
	회원번호, 최초납부년월, 
	CASE
	WHEN 최종납부년월 is null THEN '2017-10'
	ELSE 최종납부년월
	END [최종납부년월], 가입경로
FROM
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보
WHERE
	최초납부년월 is not null
	AND 최초등록구분='정기'
	AND 총납부건수 >=2
GO
