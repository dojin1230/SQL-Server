-- Account/Person Level
SELECT
	PR.회원번호			AS [Account ID], 
	CASE
	WHEN D.생년월일 is not null THEN Year(D.생년월일)		
	ELSE ''
	END AS [Year of Birth], 
	CASE 
	WHEN D.성별='여' THEN 'F'
	WHEN D.성별='남' THEN 'M'
	ELSE 'U'
	END AS [Gender], 
	'' AS [Legacy Status],
	CASE 
	WHEN D.가입경로='거리모집'			THEN 'F2F'
	WHEN D.가입경로='인터넷/홈페이지'		THEN 'DT'
	WHEN D.가입경로='Lead Conversion'	THEN 'TM'
	ELSE 'Others'
	END AS [Original Recruitment Channel],
	''	AS [Original Recruitment Response Mechanism],
	D.가입일				AS [Original Recruitment Date],
	CASE 
	WHEN D.소속 is null OR D.소속 = 'Inhouse' THEN 'IN'
	ELSE 'AG'
	END AS [Original Recruitment In-House/Agency],
	CASE
	WHEN D.최초등록구분='정기' THEN 'RP'
	WHEN D.최초등록구분='일시' THEN 'S'
	END	AS [Original Recruitment Type],
	PRMIN.최초납부일		AS [First Payment Date],
	CASE WHEN RG.회원번호 is not null THEN 'Y' ELSE 'N' END	AS 	[Have Given Regular Gift],
	CASE WHEN SG.회원번호 is not null THEN 'Y' ELSE 'N' END	AS 	[Have Given Single Gift]
FROM
	(
	SELECT
		회원번호
	FROM
		MRMRT.그린피스동아시아서울사무소0868.DBO.UV_GP_결제정보
	WHERE
		납부일 >= CONVERT(DATE, '2017-01-01') AND 납부일 < CONVERT(DATE, '2018-01-01')
	GROUP BY
		회원번호
	) PR
LEFT JOIN
(
	SELECT
		회원번호, MIN(납부일) AS 최초납부일
	FROM
		MRMRT.그린피스동아시아서울사무소0868.DBO.UV_GP_결제정보
	GROUP BY
		회원번호
	) PRMIN
ON
	PR.회원번호 = PRMIN.회원번호
LEFT JOIN
	MRMRT.그린피스동아시아서울사무소0868.DBO.UV_GP_후원자정보 D
ON
	PR.회원번호 = D.회원번호
LEFT JOIN
	(
	SELECT
		회원번호
	FROM
		MRMRT.그린피스동아시아서울사무소0868.DBO.UV_GP_결제정보
	WHERE
		납부일 >= CONVERT(DATE, '2017-01-01') AND 납부일 < CONVERT(DATE, '2018-01-01')
		AND 정기수시='정기'
	GROUP BY
		회원번호
	) RG
ON
	PR.회원번호 = RG.회원번호
LEFT JOIN
	(
	SELECT
		회원번호
	FROM
		MRMRT.그린피스동아시아서울사무소0868.DBO.UV_GP_결제정보
	WHERE
		납부일 >= CONVERT(DATE, '2017-01-01') AND 납부일 < CONVERT(DATE, '2018-01-01')
		AND 정기수시='수시'
	GROUP BY
		회원번호
	) SG
ON
	PR.회원번호 = SG.회원번호
ORDER BY
	1

-- Gift Level
SELECT
	PR.일련번호 AS [Gift ID],
	PR.회원번호 AS [Account ID],
	PR.납부일 AS [Gift Date],
	PR.납부금액 AS [Gift Amount],
	CASE 
	WHEN D.가입경로='거리모집'			THEN 'F2F'
	WHEN D.가입경로='인터넷/홈페이지'		THEN 'DT'
	WHEN D.가입경로='Lead Conversion'	THEN 'TM'
	ELSE 'Others'
	END AS [Source Channel],
	'' AS [Gift Response Mechanism],
	CASE 
	WHEN PR.정기수시 = '정기' THEN 'RP'
	WHEN PR.정기수시 = '수시' THEN 'S'
	END AS [Gift Type],
	CASE WHEN PR.정기수시 = '정기' THEN 'M' 
	ELSE '' END AS [Frequency],
	CASE 
	WHEN D.소속 is null OR D.소속 = 'Inhouse' THEN 'IN'
	ELSE 'AG'
	END AS [Inhouse / Agency],
	CASE
	WHEN PR.납부방법 = '신용카드'			THEN 'CC'
	WHEN PR.납부방법 = '계좌이체'			THEN 'BT'
	WHEN PR.납부방법 = 'CMS'				THEN 'DD'
	WHEN PR.납부방법 = 'GP계좌직접입금'	THEN 'BT'
	WHEN PR.납부방법 = '현금납부'			THEN 'CS'
	END AS [Payment Method],
	'N' AS [Emergency],
	'N' AS [Child Sponsorship],
	'N' AS [Legacy],
	'N' AS [Restricted],
	'N' AS [Symbolic Gift],
	'N' AS [Event Sponsorship],
	'' AS [Source Code],
	CASE WHEN PR.환불상태 = '' THEN 'Y'
	ELSE 'N' 
	END AS [Gift Status]
FROM
	(
	SELECT
		*
	FROM
		MRMRT.그린피스동아시아서울사무소0868.DBO.UV_GP_결제정보
	WHERE
		납부일 >= CONVERT(DATE, '2017-01-01') AND 납부일 < CONVERT(DATE, '2018-01-01') 
	) PR
LEFT JOIN
	MRMRT.그린피스동아시아서울사무소0868.DBO.UV_GP_후원자정보 D
ON
	PR.회원번호 = D.회원번호

--Regular Giving Pledge
SELECT
	PR.일련번호	AS [Regular Giving Pledge ID],
	PR.회원번호	AS [Account ID],
	PR.납부일	AS [Regular Giving Pledge Date],
	PR.납부금액	AS [Regular Giving Pledge Gift Amount],
	CASE 
	WHEN D.가입경로='거리모집'			THEN 'F2F'
	WHEN D.가입경로='인터넷/홈페이지'		THEN 'DT'
	WHEN D.가입경로='Lead Conversion'	THEN 'TM'
	ELSE 'Others'
	END AS [Regular Giving Pledge Source Channel],
	'' AS [Regular Giving Pledge Response Mechanism],
	'M' AS [Regular Giving Pledge Frequency],
	CASE
	WHEN PR.납부방법 = '신용카드'			THEN 'CC'
	WHEN PR.납부방법 = '계좌이체'			THEN 'BT'
	WHEN PR.납부방법 = 'CMS'				THEN 'DD'
	WHEN PR.납부방법 = 'GP계좌직접입금'	THEN 'BT'
	WHEN PR.납부방법 = '현금납부'			THEN 'CS'
	END AS [Regular Giving Pledge Payment Method],
	CASE 
	WHEN D.소속 is null OR D.소속 = 'Inhouse' THEN 'IN'
	ELSE 'AG'
	END AS [Regular Giving Pledge In-House/Agency],
	'N' AS [Regular Giving Pledge Child Sponsorship],
	'' AS [Regular Giving Pledge Source Code]
FROM
	(
	SELECT
		*
	FROM
		MRMRT.그린피스동아시아서울사무소0868.DBO.UV_GP_결제정보
	WHERE
		납부일 >= CONVERT(DATE, '2017-01-01') AND 납부일 < CONVERT(DATE, '2018-01-01') 
		AND 정기수시='정기'
	) PR
LEFT JOIN
	MRMRT.그린피스동아시아서울사무소0868.DBO.UV_GP_후원자정보 D
ON
	PR.회원번호 = D.회원번호



