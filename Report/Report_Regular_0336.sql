SELECT 
	* 
FROM 
	[HK].[Korea Report Data].[dbo].[Table_Report_RegularPayment_KR]
GO
-------------------------------- ȫ��
INSERT INTO
	[HK].[Korea Report Data].[dbo].[Table_Report_RegularPayment_KR]
SELECT
	'Korea' AS Region,
	NULL AS OpportunityID,
	NULL AS RGID, 
	PMAX.ȸ���ڵ� AS ConstituentID, 
	Year(PMAX.������ִ밪) AS [DebitYear], 
	--Month(PMAX.������ִ밪) AS [DebitMonth],
	'Feb' AS [DebitMonth],
	PMAX.������ִ밪 AS [DebitDate], 
		CASE 
	WHEN ó����� like N'���%' THEN CMS.��û�ݾ�
	ELSE CRD.��û�ݾ�
	END AS Amount, 
	CASE
	WHEN ó����� like N'%����%' THEN 0
	ELSE 1
	END AS Success,
	NULL AS RGJoinDate,
	CASE
	WHEN S.���԰��=N'�Ÿ�����' THEN 'DDC-'+ S.�Ҽ�
	WHEN S.���԰��=N'Lead Conversion' THEN S.���԰��
	WHEN S.���԰��=N'���ͳ�/Ȩ������' THEN 'Web'
	ELSE 'Others'
	END AS [Programme],
	CASE
	WHEN S.���԰��=N'�Ÿ�����' AND S.�Ҽ�!='Inhouse' THEN 'Agency'
	ELSE 'Inhouse'
	END AS [Resource],
	'Korea' AS [Team]
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
			����� >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE())-1, 0)
			AND ����� < DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0)
		UNION ALL
		SELECT
			 ȸ���ڵ�,
			 CONVERT(datetime, �����) AS �����
		FROM
			MRMRT.�׸��ǽ����ƽþƼ���繫��0868.DBO.UV_GP_�ſ�ī��������
		WHERE
			����� >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE())-1, 0)
			AND ����� < DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0)
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
	 
-------------------------------- �ѱ�
--��� �ޱ�

SELECT 
	*
INTO 
	[report].[dbo].[regular_201801]
FROM
	[report].[dbo].[regular]

--������Ʈ�ϱ�

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


--INSERT INTO [dbo].[regular]
--select 
--[A vs B], Country, [Debit year], 
--CASE 
--WHEN [Debit month]='Jan' THEN 1
--WHEN [Debit month]='Feb' THEN 2
--WHEN [Debit month]='Mar' THEN 3
--WHEN [Debit month]='Apr' THEN 4
--WHEN [Debit month]='May' THEN 5
--WHEN [Debit month]='Jun' THEN 6
--WHEN [Debit month]='Jul' THEN 7
--WHEN [Debit month]='Aug' THEN 8
--WHEN [Debit month]='Sep' THEN 9
--WHEN [Debit month]='Oct' THEN 10
--WHEN [Debit month]='Nov' THEN 11
--WHEN [Debit month]='Dec' THEN 12
--END AS [Debit month],
--[Debit date], Constituent_id, Response,[Payment method], iFrequency, Amount, [Last updated], [Join channel]
-- from [dbo].[old_regular]
--where [Debit year] !='2017'

































-------------------------------- �ѱ�

CREATE VIEW [dbo].[regular]
AS 
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
		--	����� >= CONVERT(varchar(10), DATEADD(mm, DATEDIFF(mm, 0, GETDATE())-1, 0), 126)
		--	AND ����� < CONVERT(varchar(10), DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0), 126)
		UNION ALL
		SELECT
			 ȸ���ڵ�,
			 CONVERT(datetime, �����) AS �����
		FROM
			MRMRT.�׸��ǽ����ƽþƼ���繫��0868.DBO.UV_GP_�ſ�ī��������
		--WHERE
		--	����� >= CONVERT(varchar(10), DATEADD(mm, DATEDIFF(mm, 0, GETDATE())-1, 0), 126)
		--	AND ����� < CONVERT(varchar(10), DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0), 126)
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