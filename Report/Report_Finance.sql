USE report
GO
-- 0. BC/Nicepay ���̺��� update�ؾ� �Ѵ�.
-- 1. finance_details ���̺��� ����Ѵ�.
SELECT
	*
INTO
	[report].[dbo].[finance_details_201801]	
FROM
	[report].[dbo].[finance_details]	


-- 2. ���� Income�� Fee/NetIncome ���� ǥ���Ͽ� finance_details ���̺� �״´�.
INSERT INTO [report].dbo.finance_details
SELECT 
	Year([Payment date]) AS [Payment year],
	Month([Payment date]) AS [Payment month], 
	[Payment date], 
	[Regular-One-off], 
	Constituent_ID, 
	[Payment method], 
	[Payment transition result], 
	CASE 
	WHEN [Payment transition result]='Fail' THEN 0
	ELSE Amount
	END AS Income, 
	CASE
	WHEN [Payment method] = 'CMS' THEN Fee
	WHEN [Payment method] = '�ſ�ī��' AND [Payment transition result]='Fail' THEN 0
	WHEN [Payment method] in ('�ſ�ī��','������ü') AND [Payment transition result]='Success' AND N.�ֹ���ȣ is null THEN Fee
	WHEN [Payment method] = '�ſ�ī��' AND [Payment transition result]='Success' AND N.�ֹ���ȣ is not null THEN BC.[����_������]
	ELSE 0
	END AS Fee, 
	CASE
	WHEN [Payment transition result]='Fail' THEN 0-Fee 
	WHEN [Payment transition result]='Success' AND N.�ֹ���ȣ is null THEN Amount-Fee 
	WHEN [Payment transition result]='Success' AND N.�ֹ���ȣ is not null THEN Amount-BC.[����_������]
	END AS [Net income],
	CASE
	WHEN [Regular-One-off] = 'One-off' AND [Payment method] = 'GP���������Ա�' THEN 'Others'
	WHEN [Regular-One-off] = 'One-off' AND [Payment method] != 'GP���������ӱ�' THEN 'Nicepay'	
	WHEN [Regular-One-off] = 'Regular' AND [Payment method] = '�ſ�ī��' AND N.�ֹ���ȣ is null THEN 'Nicepay'
	WHEN [Regular-One-off] = 'Regular' AND [Payment method] = '�ſ�ī��' AND N.�ֹ���ȣ is not null THEN 'BC'
	WHEN [Regular-One-off] = 'Regular' AND [Payment method] = 'CMS' THEN 'KFTC'
	ELSE 'Others'
	END AS Company
	--N.�ֹ���ȣ,
	--BC.���ι�ȣ
FROM
(
	SELECT
		CONVERT(DATE,�����,126) AS [Payment date],
		'Regular' AS [Regular-One-off],
		ȸ���ڵ� AS Constituent_ID,
		CASE
		WHEN ���='����' THEN 'Success'
		WHEN ���='����' THEN 'Fail'
		END AS [Payment transition result],
		��û�ݾ� AS Amount,
		������ AS Fee,
		'�ſ�ī��' AS [Payment method],
		ī��� AS [CC Company]
	FROM 
		MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�ſ�ī��������
	WHERE 
		����Ͻ� =''
	UNION ALL
	SELECT
		CONVERT(DATE,�����,126) AS [Payment date],
		'Regular' AS [Regular-One-off],
		ȸ���ڵ� AS Constituent_ID,
		CASE
		WHEN [ó�����]='��ݿϷ�' THEN 'Success'
		ELSE 'Fail'
		END AS [Payment transition result],
		��û�ݾ� AS [requested amount],
		������ AS [Service fee],
		'CMS' as [Payment method],
		'' AS [CC Company]	
	FROM 
		MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_CMS�������
	UNION ALL
	SELECT
		CONVERT(DATE,������,126) as ������,
		'One-off' as ����,
		ȸ����ȣ,
		'Success' as ���,
		�����ݾ� AS Amount,
		������ AS Fee,
		CASE
		WHEN �������='������ü' THEN '������ü'
		WHEN �������='CARD' THEN '�ſ�ī��'
		END AS �������,
		CASE
		WHEN �������='CARD' THEN ������������
		ELSE NULL
		END AS aa
	FROM
		MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ͻ��Ŀ��������
	WHERE 
		��������Ͻ�=''
	UNION ALL
	SELECT
		CONVERT(DATE,������,126) AS [Payment date],
		CASE
		WHEN �������='����' THEN 'Regular'
		WHEN �������='����' THEN 'One-off'
		END AS [Regular-One-off],
		[ȸ����ȣ] AS Constituent_id,
		'Success' as ���,
		���αݾ� AS Amount,
		0 as ������,
		CASE
		WHEN ���ι��='�ſ�ī��' THEN 'CRD'
		ELSE [���ι��]
		END AS [Payment method],
		'' AS aa
	FROM
		MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_��������
	WHERE
		[���ι��] in ('���ݳ���','GP���������Ա�')
	) PR
LEFT JOIN
	dbo.Nicepay N
ON
	PR.Constituent_ID = N.�ֹ���ȣ
LEFT JOIN
	dbo.BC
ON
	BC.���ι�ȣ = N.���ι�ȣ	
WHERE
	PR.[Payment date] >= CONVERT(DATE, DATEADD(mm, DATEDIFF(mm, 0, GETDATE())-1, 0), 126)
	AND PR.[Payment date] < CONVERT(DATE, DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0), 126)

-- 3. ȯ�Ұ��� �Է��Ѵ�.
INSERT INTO [report].dbo.finance_details VALUES (2018,	2,	'2018-02-13', 'Regular', '82032183', 'CMS',	'Success',	-15000,	0,	-15000,	'KFTC') 
GO
INSERT INTO [report].dbo.finance_details VALUES (2018,	2,	'2018-02-12', 'Regular', '82009335', '�ſ�ī��',	'Success',	-30000,	-1089,	-28911,	'Nicepay') 
GO

-- 4. Acquired Income ���̺��� update�Ѵ�.
INSERT INTO
	[report].[dbo].[acquired_income_2018]
SELECT
	F.Fee, F.[Regular-One-off], F.Income,  F.[Net income], F.[Payment year], F.[Payment month], F.Constituent_ID, ALC.Source
FROM
	[report].[dbo].[supporter_ALC] ALC
LEFT JOIN
	[report].dbo.finance_details F
ON
	F.Constituent_ID = ALC.ConstituentID
WHERE
	ALC.Source in ('Direct Dialogue', 'Lead Conversion', 'Web', 'Other','Reactivation')
	AND ALC.[Year]=2018
	AND ALC.Month in (1,2) -----------------������ �ɷ� ��ĥ ��
	AND F.[Payment year] = 2018