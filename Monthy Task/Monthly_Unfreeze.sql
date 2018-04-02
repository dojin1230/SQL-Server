--dbo.UV_GP_후원자정보 	 		회원현황								D	Donor 
--dbo.UV_GP_후원약정금액정보 	 	납부항목								PL	Payment List
--dbo.UV_GP_일시후원결제결과 	 	신용카드(나이스페이) > 수시납부현황	T	Temporary Result
--dbo.UV_GP_신용카드승인정보 	 	신용카드 > 회원승인현황				CA 	Card Approval
--dbo.UV_GP_신용카드결제결과 	 	신용카드 > 정기납부현황				CR 	Card Result 	
--dbo.UV_GP_변경이력 	 		변경이력								CH 	Change History
--dbo.UV_GP_관리기록 	 		관리기록								H 	History	
--dbo.UV_GP_결제정보 	 		회비납부 - 성공한 후원금				PR	Payment Result	
--dbo.UV_GP_CMS승인정보 	 		SmartCMS > 회원신청					BA 	Bank Approval
--dbo.UV_GP_CMS결제결과 	 		SmartCMS > 출금신청					BR 	Bank Result

-- Unfreezing
--CREATE VIEW [dbo].[vw_call_unfreeze]
--AS
SELECT
	F.회원번호,
	CASE 
	WHEN H.기록분류상세 = 'insufficient funds' THEN 'TM_후원재개_잔액부족-미처리' 
	WHEN H.기록분류상세 = 'CC/CMS problems' THEN 'TM_후원재개_정보오류-미처리' 
	END AS [기록분류/상세분류],
	CONVERT(date,GETDATE()) AS 일자, 
	'SK-진행' AS 구분1,
	'UF.CALL_WV' AS 제목,	
	CASE
	WHEN D.납부방법 = 'CMS' AND BR.결과메세지 is not null THEN BR.결과메세지
	WHEN D.납부방법 = '신용카드' AND CR.실패사유 is not null THEN CR.실패사유
	ELSE ''
	END AS 내용,
	F.최근Freezing일,
	BCR.최근출금일
FROM
	(
	SELECT
		회원번호, 기록분류, MAX(참고일) 최근Freezing일 
	FROM
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록
	WHERE
		기록분류 = 'Freezing' --AND 기록분류상세='CC/CMS problems'
	GROUP BY
		회원번호, 기록분류
	) F
LEFT JOIN
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 H
ON
	F.회원번호 = H.회원번호 
	AND F.최근Freezing일 = H.참고일
	AND F.기록분류 = H.기록분류
LEFT JOIN
	(
	SELECT
		회원코드, MAX(출금일) AS 최근출금일
	FROM
		(
		SELECT 
			회원코드, 출금일
		FROM 
			MRMRT.그린피스동아시아서울사무소0868.DBO.UV_GP_CMS결제결과
		UNION ALL
		SELECT 
			회원코드, 출금일
		FROM 
			MRMRT.그린피스동아시아서울사무소0868.DBO.UV_GP_신용카드결제결과
		) A
	GROUP BY
		회원코드
	) BCR
ON
	F.회원번호 = BCR.회원코드
LEFT JOIN
	MRMRT.그린피스동아시아서울사무소0868.DBO.UV_GP_CMS결제결과	BR
ON
	BCR.회원코드 = BR.회원코드 
	AND BCR.최근출금일 = BR.출금일
LEFT JOIN
	MRMRT.그린피스동아시아서울사무소0868.DBO.UV_GP_신용카드결제결과	CR
ON
	BCR.회원코드 = CR.회원코드 
	AND BCR.최근출금일 = CR.출금일
LEFT JOIN
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보 D
ON
	F.회원번호 = D.회원번호
LEFT JOIN
	(SELECT
		회원번호, 기록분류, 참고일
	FROM
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 
	WHERE
		기록분류 like 'TM%'
		AND 기록분류상세 not in (N'제외',N'무응')
		AND 참고일 > CONVERT(varchar(10), DATEADD(day, -60, GETDATE()), 126)) D45
ON
	F.회원번호 = D45.회원번호
LEFT JOIN
	(SELECT
		회원번호, 기록분류, 참고일
	FROM
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 
	WHERE
		기록분류 like 'TM_후원재개%') UF
		--AND 기록분류상세 not in (N'제외',N'무응')) UF
ON
	F.회원번호 = UF.회원번호
LEFT JOIN
	(SELECT 
		회원번호, 기록분류상세
	FROM
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 
	WHERE
		기록분류상세=N'결번') UN
ON
	F.회원번호 = UN.회원번호
LEFT JOIN
	(SELECT
		회원번호, 기록구분2
	FROM
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 
	WHERE
		기록구분2 like '1%' ) CRE
ON
	F.회원번호 = CRE.회원번호
LEFT JOIN
	(SELECT
		회원번호, 기록구분2
	FROM
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 
	WHERE
		기록분류 = 'Cancellation'
		AND 기록분류상세 = '지연') C
ON
	F.회원번호 = C.회원번호
WHERE
	D.회원상태 = 'Freezing'																			-- 회원상태가 Freezing인 사람만
	AND D.등록구분 != '외국인'																		-- 외국인이 아닌 사람만
	AND D.휴대전화번호 = '유'																			-- 휴대폰번호 있는 사람만
	AND D.최초등록구분 = '정기'																		-- 최초등록구분이 정기인 사람만
	AND D45.회원번호 is null																			-- 최근 60일 이내에 콜을 받은 적 있는 사람 제외
	AND UF.회원번호 is null																			-- 예전에 후원재개콜을 받은 적 있는 사람 제외
	AND UN.회원번호 is null																			-- 결번 제외
	AND CRE.회원번호 is null																			-- 통화반응이 1번인 사람 제외
	AND C.회원번호 is null																			-- 취소 지연 중인 사람 제외
	AND D.최종납부년월 >= SUBSTRING(CONVERT(varchar(10), DATEADD(year, -1, GETDATE()), 126), 1, 7)	-- Lapsed Donor가 아닌 사람만
	--OR D.최종납부년월 is null)																		-- 한 번도 결제 안한 사람들을 포함
ORDER BY
	2 DESC

	
