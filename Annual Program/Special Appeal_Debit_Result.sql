USE work
go
-- 결제 결과	
select 
	SA.회원번호,
	S.회원상태,
	--I.성명,
	--I.우편물수신처,
	--I.집주소, 
	--I.집주소상세,
	--I.집우편번호,
	P.납부금액,
	P.납부일	
from
	(
	SELECT
		회원번호
	FROM
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록
	WHERE
		((기록분류 = 'TM_특별일시후원' AND 기록분류상세='통성-후원동의')
		OR
		기록분류 = '특별일시후원 요청/문의')
		AND 기록일시 >= CONVERT(varchar(10), '2017-09-10', 126)
		) SA
	LEFT JOIN
	(SELECT
		*
	FROM
		MRMRT.그린피스동아시아서울사무소0868.DBO.UV_GP_결제정보
	WHERE
		정기수시='수시'
		AND (납부일='2017-11-10' OR 납부일='2017-11-27' OR 납부일='2017-12-11' OR 납부일='2017-12-27' OR 납부일='2018-01-10')) P
	ON
		SA.회원번호 = P.회원번호
	LEFT JOIN
		MRMRT.그린피스동아시아서울사무소0868.DBO.UV_GP_후원자정보 S
	ON
		SA.회원번호 = S.회원번호
ORDER BY 4
GO



SELECT 
	SA.회원번호,
	--S.회원상태,
	I.성명,
	I.우편물수신처,
	I.집주소, 
	I.집주소상세,
	I.집우편번호,
	P.납부금액,
	P.납부일	
from
	(
	SELECT
		회원번호
	FROM
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록
	WHERE
		((기록분류 = 'TM_특별일시후원' AND 기록분류상세='통성-후원동의')
		OR
		기록분류 = '특별일시후원 요청/문의')
		AND 기록일시 >= CONVERT(varchar(10), '2017-09-10', 126)
		) SA
	LEFT JOIN
	(SELECT
		*
	FROM
		MRMRT.그린피스동아시아서울사무소0868.DBO.UV_GP_결제정보
	WHERE
		정기수시='수시'
		AND (납부일='2017-11-10' OR 납부일='2017-11-27' OR 납부일='2017-12-11' OR 납부일='2017-12-27' OR 납부일='2018-01-10')) P
	ON
		SA.회원번호 = P.회원번호
	LEFT JOIN
		MRMRT.그린피스동아시아서울사무소0868.DBO.UV_GP_후원자정보 S
	ON
		SA.회원번호 = S.회원번호
	LEFT JOIN
		dbo.db0_clnt_i I
	ON
		SA.회원번호 = I.회원번호
ORDER BY 납부일
GO

