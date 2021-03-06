use report
go

-- 1. 전월 mid income이 든 income_monthly table 삭제
DROP TABLE [report].dbo.income_monthly	

-- 2. 전월 순수 income을 income_monthly table에 넣음
SELECT
	PR.[회원번호] AS ConstituentID,
	CONVERT(DATE,PR.납부일,126) AS [PaidDate],
	CASE
	WHEN PR.정기수시='정기' THEN 'Regular'
	WHEN PR.정기수시='수시' THEN 'Oneoff'
	END AS [Type],
	CASE
	WHEN PR.[납부방법] = '신용카드' THEN 'CRD'
	WHEN PR.[납부방법] = '계좌이체' THEN 'Bank transfer'
	WHEN PR.[납부방법] = 'GP계좌직접입금' THEN 'Bank transfer'
	WHEN PR.[납부방법] = 'CMS' THEN 'Bank transfer'
	ELSE PR.[납부방법]
	END AS [Paymentmethod],
	CASE
	WHEN PR.정기수시='정기' AND PR.[납부방법] in ('CMS', '계좌이체', 'GP계좌직접입금') THEN '301'
	WHEN PR.정기수시='정기' AND PR.[납부방법] = '신용카드' THEN '303'
	WHEN PR.정기수시='수시' AND PR.[납부방법] in ('CMS', '계좌이체', 'GP계좌직접입금') THEN '311'
	WHEN PR.정기수시='수시' AND PR.[납부방법] = '신용카드' THEN '312'
	END AS [Account code],
	CONVERT(INT, PR.납부금액) AS [Amount],
	환불상태 AS RefundTF, 
	CONVERT(INT, PR.환불총액) AS [Refund amount]	
INTO [report].dbo.income_monthly
FROM
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_결제정보 PR
WHERE
	PR.납부일 >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE())-1, 0) AND PR.납부일 < DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) 	
GO

-- 3. Mid Income 시에 업데이트했던 테이블 삭제 
DROP TABLE
	[report].dbo.income_by_cocoa

-- 4. dbo.upgrade_monthly와 dbo.downgrade_monthly가 업데이트 되어 있는지 확인
SELECT
	*	
FROM
	[report].[dbo].[upgrade_monthly]
WHERE
	UpgradeMonth = Month(DATEADD(mm, DATEDIFF(mm, 0, GETDATE())-1, 0))
GO
SELECT
	*
FROM
	[report].[dbo].[downgrade_monthly]
WHERE
	DowngradeMonth = Month(DATEADD(mm, DATEDIFF(mm, 0, GETDATE())-1, 0))
GO

-- 4. 콜을 받고 증액한 사람의 차액 
-- 142-02-41	Continuing Support	Upgrade	Outsourcing
SELECT
	'Actual' AS [Comparison], 
	I.[ConstituentID], I.[PaidDate], I.[Type], I.[Paymentmethod],	
	U.차액 AS Amount,
	'142-02-41' AS COCOA,
	I.[Account code]
INTO 
	[report].dbo.income_by_cocoa
FROM
	[report].dbo.upgrade_monthly U
INNER JOIN
	(
	SELECT
		회원번호, 기록분류, 기록분류상세, 참고일, 제목
	FROM
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 
	WHERE
		기록분류 like 'TM_후원증액%'
		AND 기록분류상세 like '%성공'
		AND 참고일 >= CONVERT(DATE, '2018-01-01', 126) 
		AND 참고일 < DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) 	
	) H
ON
	U.회원번호 = H.회원번호
INNER JOIN
	(
	SELECT
		*
	FROM
		[report].dbo.income_monthly 
	WHERE
		[Type]='Regular'
	) I
ON
	U.회원번호 = I.[ConstituentID]
LEFT JOIN
	[report].dbo.downgrade_monthly D
ON
	U.회원번호 = D.회원번호
WHERE
	D.회원번호 is null 
	OR D.DowngradeMonth < U.UpgradeMonth
GO

-- 142-01-41	Continuing Support	Upgrade	Inhouse
-- 자발증액 차액
INSERT INTO [report].dbo.income_by_cocoa
SELECT
	'Actual' AS [Comparison], 
	I.[ConstituentID], I.[PaidDate], I.[Type], I.[Paymentmethod],	
	--CASE
	--WHEN
	--I.[RefundTF] ='' THEN U.차액
	--ELSE -U.차액
	--END AS Amount,
	U.차액 AS Amount,
	'142-01-41' AS COCOA,
	I.[Account code]
FROM
	[report].dbo.upgrade_monthly U
INNER JOIN
	(
	SELECT
		*
	FROM
		[report].dbo.income_monthly 
	WHERE
		[Type]='Regular'
	) I
ON
	U.회원번호 = I.[ConstituentID] 
LEFT JOIN
	(
	SELECT
		회원번호, 기록분류, 기록분류상세, 참고일, 제목
	FROM
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 
	WHERE
		기록분류 like 'TM_후원증액%'
		AND 기록분류상세 like '%성공'
		AND 참고일 >= CONVERT(DATE, '2018-01-01', 126)
		AND 참고일 < DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) 	
	) H
ON
	H.회원번호 = U.회원번호
LEFT JOIN
	[report].dbo.downgrade_monthly D
ON
	U.회원번호 = D.회원번호
WHERE
	(D.회원번호 is null OR D.DowngradeMonth < U.UpgradeMonth)
	AND H.회원번호 is null 
GO


-- 증액한 사람의 원래 금액
-- 140-01-41	Continuing Support	Unprompted	
-- 141-02-41	Continuing Support	Prompted	Outsourcing
-- 146-02-41	Continuing Support	Supporter Care	Outsourcing
-- 121-01-41	Acquisition	Direct dialogue	Inhouse-Seoul
-- 126-01-41	Acquisition	Reactivation	
-- 127-01-41	Acquisition	Web	
-- 128-02-41	Acquisition	Telephone	Outsourcing
-- 130-01-41	Acquisition	Other	
INSERT INTO [report].dbo.income_by_cocoa
SELECT 
	'Actual' AS [Comparison], 
	I.[ConstituentID], I.[PaidDate], I.[Type], I.[Paymentmethod],	
	U.직전납부금액 AS Amount,
	CASE 
	WHEN H.회원번호 is not null AND H.기록분류 in ( 'TM_결제실패_정기_정보오류', 'TM_후원재개_정보오류', 'TM_후원재개_잔액부족') THEN '141-02-41'
	WHEN H.회원번호 is not null AND H.기록분류 = 'TM_신용카드_종료예정' THEN '146-02-41' 
	WHEN ALC.ConstituentID is not null AND ALC.Source = 'Direct Dialogue'	THEN '121-01-41'
	WHEN ALC.ConstituentID is not null AND ALC.Source = 'Web'				THEN '127-01-41'
	WHEN ALC.ConstituentID is not null AND ALC.Source = 'Lead Conversion'	THEN '128-02-41'
	WHEN ALC.ConstituentID is not null AND ALC.Source = 'Reactivation'		THEN '126-01-41'
	WHEN ALC.ConstituentID is not null AND ALC.Source = 'Other'				THEN '130-01-41'
	ELSE '140-01-41' 
	END AS COCOA,
	I.[Account code]
FROM
	[report].dbo.upgrade_monthly U
INNER JOIN
	(
	SELECT
		*
	FROM
		[report].dbo.income_monthly 
	WHERE
		[Type]='Regular'
	) I
ON
	U.회원번호 = I.[ConstituentID]
LEFT JOIN
	(
	SELECT
		회원번호, 기록분류, 기록분류상세, 참고일
	FROM
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 
	WHERE
		기록분류 in ('TM_신용카드_종료예정', 'TM_결제실패_정기_정보오류', 'TM_후원재개_정보오류', 'TM_후원재개_잔액부족')
		AND 기록분류상세 like '%동의'
		AND 참고일 >= CONVERT(DATE, '2018-01-01', 126)
		AND 참고일 <  DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) 	
	) H
ON
	U.회원번호 = H.회원번호 AND I.[PaidDate] >= H.참고일 
LEFT JOIN
	(
	SELECT
		*
	FROM
		[report].[dbo].[supporter_ALC] 
	WHERE 
		[Date] >= CONVERT(DATE, '2018-01-01')
		AND Source in ('Direct Dialogue', 'Lead Conversion', 'Web', 'Other', 'Reactivation')
	) ALC
ON
	U.회원번호 = ALC.ConstituentID
LEFT JOIN
	[report].dbo.downgrade_monthly D
ON
	U.회원번호 = D.회원번호
WHERE
	D.회원번호 is null OR D.DowngradeMonth < U.UpgradeMonth
GO

---- 144-01-41	Continuing Support	Special Appeal	Inhouse
--INSERT INTO [report].dbo.income_by_cocoa
--SELECT 
--	'Actual' AS [Comparison], 
--	I.[ConstituentID], I.[PaidDate], I.[Type], I.[Paymentmethod],	
--	I.Amount AS Amount,
--	'144-01-41' AS COCOA,
--	I.[Account code]
--FROM
--	(
--	SELECT
--		*
--	FROM
--		[report].dbo.income_monthly 
--	WHERE
--		[Type]='Oneoff'
--	) I
--LEFT JOIN
--	(
--	SELECT
--		*
--	FROM
--		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록
--	WHERE
--		기록분류 = '특별일시후원 요청/문의'
--		AND 참고일 >= CONVERT(DATE, '2018-01-01',126)
--		AND 참고일 <  DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) 	
--	) H
--ON
--	I.[ConstituentID] = H.회원번호 AND I.Amount = CONVERT(INT, [dbo].[FN_SPLIT](H.제목,':',2))
--WHERE
--	I.[PaidDate] >= H.참고일 
--GO	

---- 144-02-41	Continuing Support	Special Appeal	Outsourcing
--INSERT INTO [report].dbo.income_by_cocoa
--SELECT
--	'Actual' AS [Comparison], 
--	I.[ConstituentID], I.[PaidDate], I.[Type], I.[Paymentmethod],	
--	I.Amount AS Amount,
--	'144-02-41' AS COCOA,
--	I.[Account code]
--FROM
--	(
--	SELECT
--		*
--	FROM
--		[report].dbo.income_monthly 
--	WHERE
--		[Type]='Oneoff'
--	) I
--LEFT JOIN
--	(
--	SELECT
--		*
--	FROM
--		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록
--	WHERE
--		기록분류 = 'TM_특별일시후원' 
--		AND 기록분류상세='통성-후원동의'
--		AND 참고일 >= CONVERT(DATE, '2018-01-01',126)
--		AND 참고일 <  DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) 	
--	) H
--ON
--	I.[ConstituentID] = H.회원번호 AND I.Amount = CONVERT(INT, REPLACE([dbo].[FN_SPLIT](H.제목,':',2),',',''))
--WHERE
--	I.[PaidDate] >= H.참고일 
--GO


-- 141-02-41	Continuing Support	Prompted		Outsourcing
-- 146-02-41	Continuing Support	Supporter Care	Outsourcing
-- 재개/결제실패/신용카드 콜을 받고 결제한 사람
INSERT INTO [report].dbo.income_by_cocoa
SELECT 
	'Actual' AS [Comparison], 
	I.[ConstituentID], I.[PaidDate], I.[Type], I.[Paymentmethod],	
	I.Amount AS Amount,
	CASE
	WHEN H.기록분류 in ( 'TM_결제실패_정기_정보오류', 'TM_후원재개_정보오류', 'TM_후원재개_잔액부족') THEN '141-02-41'
	WHEN H.기록분류 = 'TM_신용카드_종료예정' THEN '146-02-41'
	END AS COCOA,
	I.[Account code]
FROM
	[report].dbo.income_monthly I
LEFT JOIN
	(
	SELECT
		회원번호, 기록분류, 기록분류상세, 참고일
	FROM
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 
	WHERE
		기록분류 in ('TM_신용카드_종료예정', 'TM_결제실패_정기_정보오류', 'TM_후원재개_정보오류', 'TM_후원재개_잔액부족')
		AND 기록분류상세 like '%동의'
		AND 참고일 >= CONVERT(DATE, '2018-01-01', 126)
		AND 참고일 <  DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) 	
	) H
ON
	I.[ConstituentID] = H.회원번호
LEFT JOIN
	[report].dbo.income_by_cocoa M
ON
	I.[ConstituentID] = M.[ConstituentID]
WHERE 
	I.[PaidDate] >= H.참고일 
	AND M.[ConstituentID] is null
GO

-- Acquired donor
--121-01-41		Acquisition	Direct dialogue	Inhouse-Seoul
--126-01-41		Acquisition	Reactivation
--127-01-41		Acquisition	Web	
--128-01-41		Acquisition	Telephone	Inhouse
--128-02-41		Acquisition	Telephone	Outsourcing
--130-01-41		Acquisition	Other	
INSERT INTO [report].dbo.income_by_cocoa
SELECT 
	'Actual' AS [Comparison], 
	I.[ConstituentID], I.[PaidDate], I.[Type], I.[Paymentmethod],	
	I.Amount AS Amount,
	CASE
	WHEN ALC.Source = 'Direct Dialogue'	THEN '121-01-41'
	WHEN ALC.Source = 'Web'				THEN '127-01-41'
	WHEN ALC.Source = 'Lead Conversion'	THEN '128-02-41'
	WHEN ALC.Source = 'Reactivation'	THEN '126-01-41'
	ELSE '130-01-41'
	END AS COCOA,
	I.[Account code]
FROM
	(
	SELECT
		*
	FROM
		[report].[dbo].[supporter_ALC] 
	WHERE 
		[Date] >= CONVERT(DATE, '2018-01-01')
		AND Source in ('Direct Dialogue', 'Lead Conversion', 'Web', 'Other', 'Reactivation')
	) ALC
INNER JOIN
	[report].dbo.income_monthly I
ON 
	ALC.ConstituentID = I.[ConstituentID]
LEFT JOIN
	[report].dbo.income_by_cocoa M 
ON
	ALC.ConstituentID = M.[ConstituentID] 
WHERE
	M.[ConstituentID] is null
GO

-- 140-01-41	Continuing Support	Unprompted
INSERT INTO [report].dbo.income_by_cocoa
SELECT 
	'Actual' AS [Comparison], 
	I.[ConstituentID], I.[PaidDate], I.[Type], I.[Paymentmethod],	
	I.Amount AS Amount,
	'140-01-41' AS COCOA,
	I.[Account code]
FROM
	[report].dbo.income_monthly I
LEFT JOIN
	[report].dbo.income_by_cocoa M 
ON
	I.[ConstituentID] = M.[ConstituentID] AND I.[Type] = M.[Type]
WHERE
	M.[ConstituentID] is null
GO

-- COCOA별로 쪼개진 금액과 원래 금액 비교
SELECT 'Before' AS Compare, SUM(Amount) AS income FROM [report].dbo.income_monthly 
UNION ALL 
SELECT 'After' AS Compare, SUM(Amount) AS income FROM [report].dbo.income_by_cocoa 
GO

-- 환불건의 원래 COCOA 코드를 찾는다.
SELECT 
	* 
FROM 
	[report].[dbo].[income_account_2018]
WHERE 
	ConstituentID in ('82053902', '82052777',  '82000438')  ------------- 환불대상 회원번호를 넣는다.

-- 301 : CMS 정기
-- 303 : 카드 정기
-- 311 : CMS 일시
-- 312 : 카드 일시

-- 환불건 입력하기
--1월 환불건
--INSERT INTO [report].dbo.income_by_cocoa VALUES ('Actual', '82000154', '2018-01-05', 'Oneoff', 'Bank transfer', -9123100, '127-01-41', '311') 
--GO
--INSERT INTO [report].dbo.income_by_cocoa VALUES ('Actual', '82031791', '2018-01-05', 'Regular', 'Bank transfer', -45000, '140-01-41', '301') 
--GO
--INSERT INTO [report].dbo.income_by_cocoa VALUES ('Actual', '82004515', '2018-01-19', 'Regular', 'Bank transfer', -20000, '140-01-41', '301') 
--GO
--2월 환불건
--INSERT INTO [report].dbo.income_by_cocoa VALUES ('Actual', '82032183', '2018-02-13', 'Regular', 'Bank transfer', -15000, '140-01-41', '301') 
--GO
--INSERT INTO [report].dbo.income_by_cocoa VALUES ('Actual', '82009335', '2018-02-12', 'Regular', 'CRD', -30000,	'140-01-41', '303') 
--GO
--3월 환불건
INSERT INTO [report].dbo.income_by_cocoa VALUES ('Actual', '82053902', '2018-03-16', 'Regular', 'Bank transfer', -10000, '128-02-41', '301') 
GO
INSERT INTO [report].dbo.income_by_cocoa VALUES ('Actual', '82052777', '2018-03-16', 'Regular', 'Bank transfer', -15000, '140-01-41', '301') 
GO
INSERT INTO [report].dbo.income_by_cocoa VALUES ('Actual', '82000438', '2018-03-16', 'Regular', 'Bank transfer', -20000, '140-01-41', '301') 
GO

---- Mid Income 데이터 삭제
DELETE FROM
	[dbo].[income_account_2018]
WHERE
	Comparison = 'Actual'
	AND [Settlement Month] = Month(DATEADD(mm, DATEDIFF(mm, 0, GETDATE())-1, 0))


---- Finance report/Monthly report에 보이는 COCOA별 금액
INSERT INTO
	[report].[dbo].[income_account_2018]
SELECT 
	[Comparison],
	[ConstituentID], 
	[PaidDate], 
	Year([PaidDate]) AS [Settlement Year],
	Month([PaidDate]) AS [Settlement Month],	
	[Type], 
	[Paymentmethod], 
	[Amount] AS [Actual], 
	NULL AS [Budget],
	[COCOA],
	SUBSTRING([COCOA], 1, 3) AS [Budget code], 
	REPLACE(SUBSTRING([COCOA], 5, 5),'-','') AS [Budget subcode], 
    [Account code]
FROM
	[report].[dbo].income_by_cocoa
WHERE
	Comparison = 'Actual'
GO

-- 홍콩 데이터 확인
SELECT
	*
FROM
	[HK].[Korea Report Data].[dbo].[Table_Report_IncomeReport_KR_2018]
WHERE
	Month = 'Mar'

-- Mid Income 삭제
DELETE FROM
	[HK].[Korea Report Data].[dbo].[Table_Report_IncomeReport_KR_2018]
WHERE
	Month = 'Mar'

-- 홍콩에 데이터 전달하기
INSERT INTO
	[HK].[Korea Report Data].[dbo].[Table_Report_IncomeReport_KR_2018]
	([Comparison], [ConstituentID], [Region], [Paymentmethod], [PaidDate], [Year], [Month], [GL_Middle], [GL_SuffixFormula], [Actual], [Type])
SELECT
	[Comparison], 
	[ConstituentID],
	'Korea' AS [Region],
	[Paymentmethod], 
	[PaidDate], 
	Year(PaidDate) AS [Year], 
	CASE 
	WHEN Month(PaidDate)=1 THEN 'Jan'
	WHEN Month(PaidDate)=2 THEN 'Feb'
	WHEN Month(PaidDate)=3 THEN 'Mar'
	WHEN Month(PaidDate)=4 THEN 'Apr'
	WHEN Month(PaidDate)=5 THEN 'May'
	WHEN Month(PaidDate)=6 THEN 'Jun'
	WHEN Month(PaidDate)=7 THEN 'Jul'
	WHEN Month(PaidDate)=8 THEN 'Aug'
	WHEN Month(PaidDate)=9 THEN 'Sep'
	WHEN Month(PaidDate)=10 THEN 'Oct'
	WHEN Month(PaidDate)=11 THEN 'Nov'
	WHEN Month(PaidDate)=12 THEN 'Dec'
	END AS [Month], 
	[Account code] AS [GL_Middle], 
	COCOA AS [GL_SuffixFormula],
	[Amount] AS [Actual],
	[Type]
FROM
	[report].dbo.income_by_cocoa
GO



--INSERT INTO
--	[report].[dbo].[income_account_2018]
--SELECT 
--	'Budget' AS Comparison,
--	ConstituentID,
--	PaidDate,
--	2018 AS [Settlement Year],
--	Month(PaidDate) AS [Settlement Month],
--	Type,
--	[PaymentMethod],
--	[Actual],
--	Budget,
--	GL_SuffixFormula AS COCOA,
--	SUBSTRING(GL_SuffixFormula,1,3) AS [Budget code],
--	REPLACE(SUBSTRING(GL_SuffixFormula,5,5),'-','') AS [Budget subcode],
--	NULL AS [Account code]
--from 
--	[dbo].[income_budget_2018]
