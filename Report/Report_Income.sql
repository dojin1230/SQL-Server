use report
go

-- 1. ���� mid income�� �� income_monthly table ����
DROP TABLE [report].dbo.income_monthly	

-- 2. ���� ���� income�� income_monthly table�� ����
SELECT
	PR.[ȸ����ȣ] AS ConstituentID,
	CONVERT(DATE,PR.������,126) AS [PaidDate],
	CASE
	WHEN PR.�������='����' THEN 'Regular'
	WHEN PR.�������='����' THEN 'Oneoff'
	END AS [Type],
	CASE
	WHEN PR.[���ι��] = '�ſ�ī��' THEN 'CRD'
	WHEN PR.[���ι��] = '������ü' THEN 'Bank transfer'
	WHEN PR.[���ι��] = 'GP���������Ա�' THEN 'Bank transfer'
	WHEN PR.[���ι��] = 'CMS' THEN 'Bank transfer'
	ELSE PR.[���ι��]
	END AS [Paymentmethod],
	CASE
	WHEN PR.�������='����' AND PR.[���ι��] in ('CMS', '������ü', 'GP���������Ա�') THEN '301'
	WHEN PR.�������='����' AND PR.[���ι��] = '�ſ�ī��' THEN '303'
	WHEN PR.�������='����' AND PR.[���ι��] in ('CMS', '������ü', 'GP���������Ա�') THEN '311'
	WHEN PR.�������='����' AND PR.[���ι��] = '�ſ�ī��' THEN '312'
	END AS [Account code],
	CONVERT(INT, PR.���αݾ�) AS [Amount],
	ȯ�һ��� AS RefundTF, 
	CONVERT(INT, PR.ȯ���Ѿ�) AS [Refund amount]	
INTO [report].dbo.income_monthly
FROM
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�������� PR
WHERE
	PR.������ >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE())-1, 0) AND PR.������ < DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) 	
GO

-- 3. Mid Income �ÿ� ������Ʈ�ߴ� ���̺� ���� 
DROP TABLE
	[report].dbo.income_by_cocoa

-- 4. dbo.upgrade_monthly�� dbo.downgrade_monthly�� ������Ʈ �Ǿ� �ִ��� Ȯ��
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

-- 4. ���� �ް� ������ ����� ���� 
-- 142-02-41	Continuing Support	Upgrade	Outsourcing
SELECT
	'Actual' AS [Comparison], 
	I.[ConstituentID], I.[PaidDate], I.[Type], I.[Paymentmethod],	
	U.���� AS Amount,
	'142-02-41' AS COCOA,
	I.[Account code]
INTO 
	[report].dbo.income_by_cocoa
FROM
	[report].dbo.upgrade_monthly U
INNER JOIN
	(
	SELECT
		ȸ����ȣ, ��Ϻз�, ��Ϻз���, ������, ����
	FROM
		MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_������� 
	WHERE
		��Ϻз� like 'TM_�Ŀ�����%'
		AND ��Ϻз��� like '%����'
		AND ������ >= CONVERT(DATE, '2018-01-01', 126) 
		AND ������ < DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) 	
	) H
ON
	U.ȸ����ȣ = H.ȸ����ȣ
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
	U.ȸ����ȣ = I.[ConstituentID]
LEFT JOIN
	[report].dbo.downgrade_monthly D
ON
	U.ȸ����ȣ = D.ȸ����ȣ
WHERE
	D.ȸ����ȣ is null 
	OR D.DowngradeMonth < U.UpgradeMonth
GO

-- 142-01-41	Continuing Support	Upgrade	Inhouse
-- �ڹ����� ����
INSERT INTO [report].dbo.income_by_cocoa
SELECT
	'Actual' AS [Comparison], 
	I.[ConstituentID], I.[PaidDate], I.[Type], I.[Paymentmethod],	
	--CASE
	--WHEN
	--I.[RefundTF] ='' THEN U.����
	--ELSE -U.����
	--END AS Amount,
	U.���� AS Amount,
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
	U.ȸ����ȣ = I.[ConstituentID] 
LEFT JOIN
	(
	SELECT
		ȸ����ȣ, ��Ϻз�, ��Ϻз���, ������, ����
	FROM
		MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_������� 
	WHERE
		��Ϻз� like 'TM_�Ŀ�����%'
		AND ��Ϻз��� like '%����'
		AND ������ >= CONVERT(DATE, '2018-01-01', 126)
		AND ������ < DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) 	
	) H
ON
	H.ȸ����ȣ = U.ȸ����ȣ
LEFT JOIN
	[report].dbo.downgrade_monthly D
ON
	U.ȸ����ȣ = D.ȸ����ȣ
WHERE
	(D.ȸ����ȣ is null OR D.DowngradeMonth < U.UpgradeMonth)
	AND H.ȸ����ȣ is null 
GO


-- ������ ����� ���� �ݾ�
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
	U.�������αݾ� AS Amount,
	CASE 
	WHEN H.ȸ����ȣ is not null AND H.��Ϻз� in ( 'TM_��������_����_��������', 'TM_�Ŀ��簳_��������', 'TM_�Ŀ��簳_�ܾ׺���') THEN '141-02-41'
	WHEN H.ȸ����ȣ is not null AND H.��Ϻз� = 'TM_�ſ�ī��_���Ό��' THEN '146-02-41' 
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
	U.ȸ����ȣ = I.[ConstituentID]
LEFT JOIN
	(
	SELECT
		ȸ����ȣ, ��Ϻз�, ��Ϻз���, ������
	FROM
		MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_������� 
	WHERE
		��Ϻз� in ('TM_�ſ�ī��_���Ό��', 'TM_��������_����_��������', 'TM_�Ŀ��簳_��������', 'TM_�Ŀ��簳_�ܾ׺���')
		AND ��Ϻз��� like '%����'
		AND ������ >= CONVERT(DATE, '2018-01-01', 126)
		AND ������ <  DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) 	
	) H
ON
	U.ȸ����ȣ = H.ȸ����ȣ AND I.[PaidDate] >= H.������ 
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
	U.ȸ����ȣ = ALC.ConstituentID
LEFT JOIN
	[report].dbo.downgrade_monthly D
ON
	U.ȸ����ȣ = D.ȸ����ȣ
WHERE
	D.ȸ����ȣ is null OR D.DowngradeMonth < U.UpgradeMonth
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
--		MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�������
--	WHERE
--		��Ϻз� = 'Ư���Ͻ��Ŀ� ��û/����'
--		AND ������ >= CONVERT(DATE, '2018-01-01',126)
--		AND ������ <  DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) 	
--	) H
--ON
--	I.[ConstituentID] = H.ȸ����ȣ AND I.Amount = CONVERT(INT, [dbo].[FN_SPLIT](H.����,':',2))
--WHERE
--	I.[PaidDate] >= H.������ 
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
--		MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�������
--	WHERE
--		��Ϻз� = 'TM_Ư���Ͻ��Ŀ�' 
--		AND ��Ϻз���='�뼺-�Ŀ�����'
--		AND ������ >= CONVERT(DATE, '2018-01-01',126)
--		AND ������ <  DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) 	
--	) H
--ON
--	I.[ConstituentID] = H.ȸ����ȣ AND I.Amount = CONVERT(INT, REPLACE([dbo].[FN_SPLIT](H.����,':',2),',',''))
--WHERE
--	I.[PaidDate] >= H.������ 
--GO


-- 141-02-41	Continuing Support	Prompted		Outsourcing
-- 146-02-41	Continuing Support	Supporter Care	Outsourcing
-- �簳/��������/�ſ�ī�� ���� �ް� ������ ���
INSERT INTO [report].dbo.income_by_cocoa
SELECT 
	'Actual' AS [Comparison], 
	I.[ConstituentID], I.[PaidDate], I.[Type], I.[Paymentmethod],	
	I.Amount AS Amount,
	CASE
	WHEN H.��Ϻз� in ( 'TM_��������_����_��������', 'TM_�Ŀ��簳_��������', 'TM_�Ŀ��簳_�ܾ׺���') THEN '141-02-41'
	WHEN H.��Ϻз� = 'TM_�ſ�ī��_���Ό��' THEN '146-02-41'
	END AS COCOA,
	I.[Account code]
FROM
	[report].dbo.income_monthly I
LEFT JOIN
	(
	SELECT
		ȸ����ȣ, ��Ϻз�, ��Ϻз���, ������
	FROM
		MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_������� 
	WHERE
		��Ϻз� in ('TM_�ſ�ī��_���Ό��', 'TM_��������_����_��������', 'TM_�Ŀ��簳_��������', 'TM_�Ŀ��簳_�ܾ׺���')
		AND ��Ϻз��� like '%����'
		AND ������ >= CONVERT(DATE, '2018-01-01', 126)
		AND ������ <  DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) 	
	) H
ON
	I.[ConstituentID] = H.ȸ����ȣ
LEFT JOIN
	[report].dbo.income_by_cocoa M
ON
	I.[ConstituentID] = M.[ConstituentID]
WHERE 
	I.[PaidDate] >= H.������ 
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

-- COCOA���� �ɰ��� �ݾװ� ���� �ݾ� ��
SELECT 'Before' AS Compare, SUM(Amount) AS income FROM [report].dbo.income_monthly 
UNION ALL 
SELECT 'After' AS Compare, SUM(Amount) AS income FROM [report].dbo.income_by_cocoa 
GO

-- ȯ�Ұ��� ���� COCOA �ڵ带 ã�´�.
SELECT 
	* 
FROM 
	[report].[dbo].[income_account_2018]
WHERE 
	ConstituentID in ('82053902', '82052777',  '82000438')  ------------- ȯ�Ҵ�� ȸ����ȣ�� �ִ´�.

-- 301 : CMS ����
-- 303 : ī�� ����
-- 311 : CMS �Ͻ�
-- 312 : ī�� �Ͻ�

-- ȯ�Ұ� �Է��ϱ�
--1�� ȯ�Ұ�
--INSERT INTO [report].dbo.income_by_cocoa VALUES ('Actual', '82000154', '2018-01-05', 'Oneoff', 'Bank transfer', -9123100, '127-01-41', '311') 
--GO
--INSERT INTO [report].dbo.income_by_cocoa VALUES ('Actual', '82031791', '2018-01-05', 'Regular', 'Bank transfer', -45000, '140-01-41', '301') 
--GO
--INSERT INTO [report].dbo.income_by_cocoa VALUES ('Actual', '82004515', '2018-01-19', 'Regular', 'Bank transfer', -20000, '140-01-41', '301') 
--GO
--2�� ȯ�Ұ�
--INSERT INTO [report].dbo.income_by_cocoa VALUES ('Actual', '82032183', '2018-02-13', 'Regular', 'Bank transfer', -15000, '140-01-41', '301') 
--GO
--INSERT INTO [report].dbo.income_by_cocoa VALUES ('Actual', '82009335', '2018-02-12', 'Regular', 'CRD', -30000,	'140-01-41', '303') 
--GO
--3�� ȯ�Ұ�
INSERT INTO [report].dbo.income_by_cocoa VALUES ('Actual', '82053902', '2018-03-16', 'Regular', 'Bank transfer', -10000, '128-02-41', '301') 
GO
INSERT INTO [report].dbo.income_by_cocoa VALUES ('Actual', '82052777', '2018-03-16', 'Regular', 'Bank transfer', -15000, '140-01-41', '301') 
GO
INSERT INTO [report].dbo.income_by_cocoa VALUES ('Actual', '82000438', '2018-03-16', 'Regular', 'Bank transfer', -20000, '140-01-41', '301') 
GO

---- Mid Income ������ ����
DELETE FROM
	[dbo].[income_account_2018]
WHERE
	Comparison = 'Actual'
	AND [Settlement Month] = Month(DATEADD(mm, DATEDIFF(mm, 0, GETDATE())-1, 0))


---- Finance report/Monthly report�� ���̴� COCOA�� �ݾ�
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
GO

-- ȫ�� ������ Ȯ��
SELECT
	*
FROM
	[HK].[Korea Report Data].[dbo].[Table_Report_IncomeReport_KR_2018]
WHERE
	Month = 'Mar'

-- ȫ�ῡ ������ �����ϱ�
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
