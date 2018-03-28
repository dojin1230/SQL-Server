use report
GO

ALTER VIEW vw_DDC
AS
SELECT
	회원번호, 가입일, JoinYear, JoinMonth, 
	CASE 
	WHEN 납부방법 is null THEN 'Unknown'
	WHEN 납부방법 = '신용카드' THEN 'Card'
	ELSE 납부방법
	END AS PaymentMethod, 
	성별, 
	CASE 
	WHEN Age < 26 THEN 'Under 25'
	WHEN Age >=26 AND Age < 31 THEN '26-30'
	WHEN Age >=31 AND Age < 35 THEN '31-35'
	WHEN Age >=35 AND Age < 41 THEN '36-40'
	WHEN Age >=41 THEN 'Over 41'
	ELSE 'Unknown'
	END AS Agegroup,
	Source
FROM
(
	SELECT
		회원번호, 가입일, 
		Year(가입일) AS JoinYear,
		Month(가입일) AS JoinMonth,
		납부방법, 
		성별, 
		CASE
		WHEN LEN([dbo].[FN_SPLIT](DDF명,';',2))=6 AND 소속 = 'Inhouse' THEN DATEDIFF(year,[dbo].[FN_SPLIT](DDF명,';',2), GETDATE())
		ELSE 나이 
		END AS Age,
		CASE
		WHEN 소속 != 'Inhouse' THEN 'Outsourcing'
		ELSE 소속
		END AS Source
		--[dbo].[FN_SPLIT](DDF명,';',2) AS 생년월일-- DDM번호, DDM명, DDF번호, DDF명, DD장소번호, DD장소
	FROM
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보 
	WHERE
		가입경로='거리모집'
) D
