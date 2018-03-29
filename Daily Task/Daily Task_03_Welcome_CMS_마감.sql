
-- 3주된 감사콜 마감 --

-- 1. 후원동의 --
SELECT '1. 후원동의:', H.회원번호
FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 H
LEFT JOIN
	(SELECT 회원번호
	 FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보
	 WHERE
	 (납부방법 = '신용카드' AND CARD상태 = '승인완료')
	 OR (납부방법 = 'CMS' AND CMS상태 IN ('신규완료', '신규진행'))
	 OR (납부방법 = 'CMS' AND CMS상태 = '신규대기' AND CMS증빙자료등록필요 = 'N')
	 ) D	 
ON H.회원번호 = D.회원번호
WHERE H.기록분류상세 = '통성-후원동의'
	AND H.기록분류 = 'TM_감사'
	AND CONVERT(DATE,기록일시) = CONVERT(DATE, GETDATE()-21)
	AND D.회원번호 IS NULL

UNION ALL
-- 2. 후원거절(해지) --

SELECT '2. 후원거절(해지):', H.회원번호
FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 H
LEFT JOIN
	(SELECT 회원번호
	 FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록
	 WHERE 참고일 >= CONVERT(DATE, GETDATE()-21)
		AND 기록분류 = 'Cancellation'
	) H2
ON H.회원번호 = H2.회원번호
WHERE H.기록분류상세 = '통성-후원거절(해지)'
	AND H.기록분류 = 'TM_감사'
	AND CONVERT(DATE,H.기록일시) = CONVERT(DATE, GETDATE()-21)
	AND H2.회원번호 IS NULL

UNION ALL

-- 3. 결번 --
SELECT '3. 결번:', H.회원번호
FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 H
LEFT JOIN
	(SELECT 회원번호
	 FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보
	 WHERE
	 (납부방법 = '신용카드' AND CARD상태 = '승인완료')
	 OR 
	 (납부방법 = 'CMS' AND CMS상태 = '신규완료')
	 OR 
	 회원상태 = 'Freezing'
	  ) D	 
ON H.회원번호 = D.회원번호
WHERE H.기록분류상세 = '결번'
	AND H.기록분류 = 'TM_감사'
	AND CONVERT(DATE,기록일시) = CONVERT(DATE, GETDATE()-21)
	AND D.회원번호 IS NULL

UNION ALL
-- 4. SK-진행건 마감 (프리징 필요건 확인) -- 

SELECT '4. 프리징:', H.회원번호
FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 H
LEFT JOIN
	(SELECT 회원번호
	 FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보
	 WHERE
	 (납부방법 = '신용카드' AND CARD상태 = '승인완료')
	 OR 
	 (납부방법 = 'CMS' AND CMS상태 = '신규완료')
	 OR 
	 회원상태 = 'Freezing'
	  ) D	 
ON H.회원번호 = D.회원번호
WHERE H.처리진행사항 = 'SK-진행'
	AND H.기록분류 = 'TM_감사'
	AND CONVERT(DATE,기록일시) = CONVERT(DATE, GETDATE()-21)
	AND D.회원번호 IS NULL



