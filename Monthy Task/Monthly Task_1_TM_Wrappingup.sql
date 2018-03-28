--- TM_후원재개_정보오류 
SELECT
	H.회원번호, H.처리진행사항, H.참고일, D.납부방법,
	CASE 
	WHEN D.납부방법 ='신용카드' THEN C.CARD상태 
	WHEN D.납부방법 ='CMS' THEN CM.처리결과 
	END AS 납부상태, 
	CASE 
	WHEN D.납부방법 ='신용카드' THEN C.승인일 
	WHEN D.납부방법 ='CMS' THEN CM.신청일
	END AS 승인신청일
FROM
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 H
LEFT JOIN
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_신용카드승인정보 C
ON
	H.회원번호 = C.회원번호
LEFT JOIN
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_CMS승인정보 CM
ON
	H.회원번호 = CM.회원번호
LEFT JOIN
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보 D 
ON
	H.회원번호 = D.회원번호 
WHERE
	H.기록분류='TM_후원재개_정보오류'
	AND H.기록분류상세='통성-재개동의'
	AND H.기록일시 >= CONVERT(varchar(10), DATEADD(day, -36, GETDATE()), 126)

-- TM_신용카드종료예정 
SELECT
	H.회원번호, H.처리진행사항, H.참고일, C.CARD상태, C.승인일
FROM
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 H
LEFT JOIN
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_신용카드승인정보 C
ON
	H.회원번호 = C.회원번호
WHERE
	H.기록분류='TM_신용카드종료예정'
	AND H.기록분류상세='통성-변경동의'
	AND H.기록일시 >= CONVERT(varchar(10), DATEADD(day, -36, GETDATE()), 126)



	