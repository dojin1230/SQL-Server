USE [work]
GO

CREATE VIEW [dbo].[vw_daily_task_01]
AS
-- 납부정보 변경된 사람 Unfreezing/Reactivation

SELECT DISTINCT CH.회원번호, D.회원상태, CH.변경일시, '납부정보변경-회원상태' as 내용
FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_변경이력 CH
LEFT JOIN
MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보 D
ON CH.회원번호 = D.회원번호
WHERE 
(CH.변경항목 = '증빙자료추가' 
 OR CH.변경항목 LIKE '예금%' 
 OR CH.변경항목 IN ('은행', '계좌번호','납부방법','납부일') 
OR (CH.변경항목 = '납부여부' AND CH.수정후 = 'Y'))
--AND CH.변경일시 >= GETDATE() - 1
 AND CH.변경일시 >= GETDATE() - 4
AND D.회원상태 IN ('Freezing','Canceled')
AND (D.납부방법 = '신용카드' OR D.은행 != '' AND D.납부방법 = 'CMS')
AND D.납부여부 = 'Y'



union all
-- 회원상태변경 관리기록 확인 --

SELECT H.회원번호, CH.수정후, CH.변경일시, '노멀변경-관리기록확인' as 내용
FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_변경이력 CH
LEFT JOIN
	(SELECT * 
	FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록
	WHERE 기록분류상세 IN ('통성-재시작동의', '통성-재개동의', '자발_Unfreezing','자발_Reactivation')
		AND 참고일 >= GETDATE() - 4
	) H
ON CH.회원번호 = H.회원번호
WHERE CH.변경항목 = '회원상태'
	AND CH.변경일시 >= GETDATE() - 3
	AND CH.수정전 = 'freezing'
	AND CH.수정후 = 'normal'
	AND H.회원번호 IS NULL

union all
-- 이메일 수신여부 변경 --

SELECT 
	ch.회원번호, I.이메일, ch.변경일시, '이메일수신-수정후: '+ch.수정후
FROM 
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_변경이력 CH
LEFT JOIN 
	[work].[dbo].[db0_clnt_i] I
ON 
	CH.회원번호 = I.회원번호
WHERE 
	변경항목 = '이메일수신여부'
	--AND CONVERT(DATE,변경일시) >= CONVERT(DATE,GETDATE() - 1) -- 전날
	AND (CONVERT(DATE,변경일시) BETWEEN CONVERT(DATE, GETDATE()-3) AND CONVERT(DATE, GETDATE()-1)) -- 지난 3일
union all
-- 카드 승인 (자발 재개/재시작)

select 
	D.회원번호, D.회원상태, CA.승인일, '카드승인-회원상태변경'
from 
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보 D 
	left join MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_신용카드승인정보 as CA
on 
	D.회원번호 = CA.회원번호
where 
	-- 날짜 정보 제대로 확인할 것
	-- CA.승인일 = CONVERT(varchar(10), DATEADD(day, -1, GETDATE()), 126) 
	CA.승인일 >= CONVERT(varchar(10), DATEADD(day, -3, GETDATE()), 126)
	and CA.승인경로 !='MRM'
	and D.회원상태 != 'normal'

go
