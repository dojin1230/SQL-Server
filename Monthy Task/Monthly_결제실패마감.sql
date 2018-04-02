use work
GO

SELECT
	H.회원번호,
	CASE 
	WHEN H.기록분류상세 = '통성-변경거절(해지)' THEN 'Cancellation-canceled' 
	ELSE 'Freezing - CC/CMS problems' 
	END AS [기록분류/상세분류],
	CONVERT(date,GETDATE()) AS 일자, 
	'IH-완료' AS 구분1,
	CASE 
	WHEN H.기록분류상세 = '통성-변경거절(해지)' THEN 'T' 
	ELSE 'F' 
	END AS 제목,	
	CONVERT(DATE,GETDATE(),126) AS 참고일
FROM
	(
	SELECT
		*
	FROM
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 
	WHERE
		기록분류 = 'TM_결제실패_정기_정보오류'
		AND CONVERT(DATE, 기록일시) >= CONVERT(DATE,GETDATE()-25) 
	) H
LEFT JOIN
	(
	SELECT 
		*
    FROM 
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록
    WHERE 
		기록분류 = 'cancellation'
        AND CONVERT(DATE,기록일시) >= CONVERT(DATE,GETDATE()-25)
	) C
ON
	H.회원번호 = C.회원번호
LEFT JOIN
	(
	SELECT 
		회원번호
	FROM 
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_신용카드승인정보
    WHERE 
		승인일시 >= '2018-03-26 17:05'									---- 신용카드 > 정기납부현황 > 납부신청일시값 변경할 것
	UNION ALL
	SELECT 
		회원번호
	FROM 
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_CMS승인정보
    WHERE 
		신청일 >= '2018-03-26'											----- 날짜만 납부신청일시값으로 변경할 것								
		AND 처리결과 != '승인실패'
	) CR
ON	
	H.회원번호 = CR.회원번호
LEFT JOIN
	(
	SELECT 
		*
	FROM
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_결제정보
	WHERE
		귀속년월 = SUBSTRING(CONVERT(varchar(10), DATEADD(mm, DATEDIFF(mm, 0, GETDATE())-1, 0), 126), 1, 7)
	) PL
ON
	H.회원번호 = PL.회원번호 
WHERE
	C.회원번호 is null									-- 캔슬 기록 심겨져 있는 사람 제외
	AND CR.회원번호 is null								-- 마지막 결제 이후에 CMS나 CARD 승인된 사람 제외
	AND PL.회원번호 is null								-- 3월에 결제된 사람 제외
	AND H.기록분류상세 not in ('제외', '통성-변경동의')	-- 제외나 변경동의 제외
ORDER BY
	2