-------- 후원재시작 자발해지 월간 콜 
USE work
GO

SELECT
	H.회원번호, D.회원상태, D.최종납부년월
FROM
	(
	SELECT
		회원번호
	FROM
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 
	WHERE
		기록분류 = 'Cancellation' 
		AND 기록분류상세 = 'Canceled'
		AND 제목 = 'B90'
		AND 참고일 >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0)		
		--AND 참고일 >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE())-1, 0)		
		--AND 참고일 < DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0)		
	) H
LEFT JOIN
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보 D
ON
	H.회원번호 = D.회원번호
LEFT JOIN
	(SELECT
		회원번호
	FROM
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 
	WHERE
		기록구분2 like '1%') CR
ON
	H.회원번호 = CR.회원번호
LEFT JOIN
	(SELECT 
		회원번호
	FROM
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 
	WHERE
		기록분류 like N'TM_후원재시작%'
		AND 기록분류상세 in (N'통성-재시작동의',N'통성-재시작거절')
		AND 참고일 >= CONVERT(varchar(10), '2017-01-01', 126)
		) RS
ON
	H.회원번호 = RS.회원번호
LEFT JOIN
	(SELECT 
		회원번호
	FROM
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 
	WHERE
		기록분류상세=N'결번') UN
ON
	H.회원번호 = UN.회원번호
LEFT JOIN
	(SELECT
		회원번호
	FROM
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 
	WHERE
		기록분류='Cancellation'
		AND 제목='14') C14
ON
	H.회원번호 = C14.회원번호
LEFT JOIN
	(SELECT
		회원번호
	FROM
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 
	WHERE
		기록분류 like 'TM%'
		AND ((기록분류상세 =N'제외') OR (기록분류상세 =N'무응' AND 기록구분2 is null))
		AND 참고일 > CONVERT(varchar(10), DATEADD(day, -45, GETDATE()), 126)) M3
ON
	H.회원번호 = M3.회원번호
LEFT JOIN
	(SELECT
		회원번호
	FROM
		MRMRT.그린피스동아시아서울사무소0868.DBO.UV_GP_후원자정보
	WHERE
		등록구분=N'외국인') F
ON
	H.회원번호 = F.회원번호
LEFT JOIN
	(SELECT
		회원번호
	FROM
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 
	WHERE
		기록분류 like 'TM_후원재시작%'
		AND 처리진행사항='SK-진행') RP
ON
	H.회원번호 = RP.회원번호
LEFT JOIN
	dbo.no_response NR
ON
	H.회원번호 = NR.회원번호
WHERE											-- 저번달에 은행에서 계좌 해지한 사람만
	D.최초등록구분 = N'정기'						-- 최초등록구분이 정기인 사람만
	AND D.휴대전화번호='유'						-- 휴대전화번호가 있는 사람만
	AND D.회원상태 in ('canceled','Freezing')	-- 회원상태가 canceled거나 freezing인 사람만
	AND CR.회원번호 is null						-- 통화반응이 1번인 사람 제외
	AND RS.회원번호 is null						-- 2017년부터 후원재시작 콜 동의 혹은 거부한 사람 제외
	AND UN.회원번호 is null						-- 결번인 사람 제외
	AND C14.회원번호 is null						-- 취소 사유가 이민인 사람 제외
	AND M3.회원번호 is null						-- 최근 45일간 TM콜이 할당되어 통화 성공한 사람 제외
	AND F.회원번호 is null						-- 외국인 제외
	AND RP.회원번호 is null						-- 후원재시작 콜 진행 중인 사람 제외
	AND NR.회원번호 is null						-- 무응 연속 4번인 사람 제외