-- 0. ���� ���̺� ��� �ޱ�

SELECT 
	*
INTO 
	[report].[dbo].[regular_201802]
FROM
	[report].[dbo].[regular]

-- 1. ������ ������ ������Ʈ�ϱ�

INSERT INTO [dbo].[regular]
SELECT
	'Actual' AS [A vs B], 
	'South Korea' AS Country,
	Year(PMAX.������ִ밪) AS [Debit year], 
	Month(PMAX.������ִ밪) AS [Debit month], 
	PMAX.������ִ밪 AS [Debit date], 
	PMAX.ȸ���ڵ� AS Constituent_id, 
	CASE
	WHEN ó����� like N'%����%' THEN 0
	ELSE 1
	END AS Response,
	CASE 
	WHEN ó����� like N'���%' THEN 'CMS'
	ELSE 'CRD'
	END AS [Payment method],
	1 AS iFrequency,
	CASE 
	WHEN ó����� like N'���%' THEN CMS.��û�ݾ�
	ELSE CRD.��û�ݾ�
	END AS Amount, 
	Getdate() AS [Last updated],
	CASE
	WHEN S.���԰��=N'�Ÿ�����' THEN 'DDC-'+ S.�Ҽ�
	WHEN S.���԰��=N'Lead Conversion' THEN S.���԰��
	WHEN S.���԰��=N'���ͳ�/Ȩ������' THEN 'Web'
	ELSE 'Others'
	END AS [Join channel]
FROM
(
	SELECT
		ȸ���ڵ�,
		MAX(�����) AS ������ִ밪
	FROM
	(
		SELECT
			 ȸ���ڵ�,
			 CONVERT(datetime, �����) AS �����
		FROM
			MRMRT.�׸��ǽ����ƽþƼ���繫��0868.DBO.UV_GP_CMS�������
		WHERE
			CONVERT(date, �����, 126) >= CONVERT(varchar(10), DATEADD(mm, DATEDIFF(mm, 0, GETDATE())-1, 0), 126)
			AND CONVERT(date, �����, 126) < CONVERT(varchar(10), DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0), 126)
		UNION ALL
		SELECT
			 ȸ���ڵ�,
			 CONVERT(datetime, �����) AS �����
		FROM
			MRMRT.�׸��ǽ����ƽþƼ���繫��0868.DBO.UV_GP_�ſ�ī��������
		WHERE
			CONVERT(date, �����, 126) >= CONVERT(varchar(10), DATEADD(mm, DATEDIFF(mm, 0, GETDATE())-1, 0), 126)
			AND CONVERT(date, �����, 126) < CONVERT(varchar(10), DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0), 126)
	) PRES
	GROUP BY
	ȸ���ڵ�
) PMAX
LEFT JOIN
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_CMS������� CMS
ON 
	PMAX.ȸ���ڵ� = CMS.ȸ���ڵ� AND PMAX.������ִ밪 = CMS.�����
LEFT JOIN
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�ſ�ī�������� CRD
ON 
	PMAX.ȸ���ڵ� = CRD.ȸ���ڵ� AND PMAX.������ִ밪 = CRD.�����
LEFT JOIN
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������� S
ON 
	PMAX.ȸ���ڵ� = S.ȸ����ȣ
GO

--2. ȫ�� ������ Ȯ��

SELECT 
	* 
FROM 
	[HK].[Korea Report Data].[dbo].[Table_Report_RegularPayment_KR]
GO

--3. ȫ�ῡ ������ �ֱ�

INSERT INTO
	[HK].[Korea Report Data].[dbo].[Table_Report_RegularPayment_KR]
SELECT
	'Korea' AS Region,
	NULL AS OpportunityID,
	NULL AS RGID, 
	ConstituentID, 
	[DebitYear], 
	CASE 
	WHEN [DebitMonth]=1 THEN 'Jan'
	WHEN [DebitMonth]=2 THEN 'Feb'
	WHEN [DebitMonth]=3 THEN 'Mar'
	WHEN [DebitMonth]=4 THEN 'Apr'
	WHEN [DebitMonth]=5 THEN 'May'
	WHEN [DebitMonth]=6 THEN 'Jun'
	WHEN [DebitMonth]=7 THEN 'Jul'
	WHEN [DebitMonth]=8 THEN 'Aug'
	WHEN [DebitMonth]=9 THEN 'Sep'
	WHEN [DebitMonth]=10 THEN 'Oct'
	WHEN [DebitMonth]=11 THEN 'Nov'
	WHEN [DebitMonth]=12 THEN 'Dec'
	END AS [DebitMonth],
	[DebitDate], 
	[Amount], 
	[Success],
	NULL AS RGJoinDate,
	[Programme],
	CASE 
	WHEN [dbo].FN_SPLIT([Programme],'-',2) in ('Inhouse', 'Web', 'Others', 'Telephone') THEN 'Inhouse'
	ELSE 'Agency' 
	END AS [Resource],
	'Korea' AS [Team]
 FROM 
	[report].[dbo].[regular]
 WHERE
	[DebitDate] < CONVERT(DATETIME, '2017-01-01')