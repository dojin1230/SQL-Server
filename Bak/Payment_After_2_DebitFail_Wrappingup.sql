SELECT 
	H.회원번호, H.기록분류상세, S.납부방법, H.참고일, C.승인일, C.승인경로, CM.신청일, CM.처리결과
FROM 
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 H
LEFT JOIN
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보 S
ON
	H.회원번호 = S.회원번호
LEFT JOIN
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_신용카드승인정보 C
ON
	H.회원번호 = C.회원번호
LEFT JOIN
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_CMS승인정보 CM
ON
	H.회원번호 = CM.회원번호
WHERE
	H.기록분류='TM_결제실패_정기_정보오류'
	--AND H.기록분류상세='통성-후원거절'
	AND H.기록일시 >= CONVERT(varchar(10), '2017-10-11', 126) AND H.기록일시 < CONVERT(varchar(10), '2017-10-25', 126) 
ORDER BY 
	승인일 DESC

