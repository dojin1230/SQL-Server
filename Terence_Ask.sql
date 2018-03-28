USE mrm
GO


SELECT 
	COUNT(1)
FROM 
	MRMRT.그린피스동아시아서울사무소0868.DBO.UV_GP_후원자정보 S
WHERE
	S.최종납부년월 < '2016-10' 	AND 
	S.총납부건수 >= 1  AND	
	S.휴대전화번호='유' 
GO


SELECT 
	S.회원번호, S.최종납부년월, S.총납부건수, H.기록구분2
FROM 
	MRMRT.그린피스동아시아서울사무소0868.DBO.UV_GP_후원자정보 S
LEFT JOIN
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 H
ON
	S.회원번호 = H.회원번호 
WHERE
	S.최종납부년월 < '2016-10' 	AND 
	S.총납부건수 >= 1 AND 
	S.휴대전화번호='유' AND
	(H.기록분류 like 'TM%' AND H.기록구분2 like '1%') AND
	H.회원번호 is null
GROUP BY 
	S.회원번호
GO

SELECT 
	*
FROM 
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 H
WHERE
	H.기록분류 like 'TM%' AND H.기록구분2 like '1%'