USE report
go

-- 0. ���� mid Income �� update�ߴ� ������ �����ϰ� �������� update�� ���̺� ���
DELETE FROM
	[report].[dbo].[supporter_ALC]
WHERE
	Year = 2018
	AND Month = Month(DATEADD(mm, DATEDIFF(mm, 0, GETDATE())-1, 0))
GO
SELECT
	*
INTO
	[report].[dbo].[supporter_ALC_201802]
FROM
	[report].[dbo].[supporter_ALC]
GO


-- 1. Acquired donor 
-- 1-1. New Acquired donor for last month
INSERT INTO [report].[dbo].[supporter_ALC]
SELECT
	'Actual' AS [Comparison], 
	'Korea' AS [Region],	
	Year(DATEADD(mm, DATEDIFF(mm, 0, GETDATE())-1, 0)) AS [Year],				-- the year of last month
	Month(DATEADD(mm, DATEDIFF(mm, 0, GETDATE())-1, 0)) AS [Month],				-- last month
	CONVERT(DATE, DATEADD(mm, DATEDIFF(mm, 0, GETDATE())-1, 0)) AS [Date],		-- the first day of last month
	D.ȸ����ȣ AS [ConstituentID],
	CASE
	WHEN D.���ʵ�ϱ���=N'����' THEN 'Regular'
	WHEN D.���ʵ�ϱ���=N'�Ͻ�' THEN 'One-off'
	END AS [Type],
	CASE 
	WHEN D.���԰��=N'�Ÿ�����' THEN 'Direct Dialogue'
	WHEN D.���԰��=N'���ͳ�/Ȩ������' THEN 'Web'
	WHEN D.���԰��=N'Lead Conversion' THEN D.���԰��
	ELSE 'Other'
	END AS [Source],
	CASE 
	WHEN D.�Ҽ� != 'Inhouse' THEN 'Agency'
	ELSE 'Inhouse'
	END AS [Resource],
	1 AS [NewDonor_Actual]
FROM
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������� D
WHERE	-- donors whose first payment is last month
	D.���ʳ��γ�� = SUBSTRING(CONVERT(varchar(10), DATEADD(mm, DATEDIFF(mm, 0, GETDATE())-1, 0), 126), 1, 7)


-- 1-2. Reactivation for last month
INSERT INTO [report].[dbo].[supporter_ALC]
SELECT
	'Actual' AS [Comparison], 
	'Korea' AS [Region],	
	Year(DATEADD(mm, DATEDIFF(mm, 0, GETDATE())-1, 0)) AS [Year],				-- the year of last month
	Month(DATEADD(mm, DATEDIFF(mm, 0, GETDATE())-1, 0)) AS [Month],				-- last month
	CONVERT(DATE, DATEADD(mm, DATEDIFF(mm, 0, GETDATE())-1, 0)) AS [Date],	-- the first day of last month
	A.ȸ����ȣ AS [ConstituentID],
	'Regular' AS [Type],
	'Reactivation' AS [Source],
	'Agency' AS [Resource],
	1 AS [NewDonor_Actual]
FROM
	(
	SELECT
		H.ȸ����ȣ, MIN(PR.������) ù������
	FROM
		(
		SELECT
			ȸ����ȣ, ������ AS ������
		FROM
			MRMRT.�׸��ǽ����ƽþƼ���繫��0868.DBO.UV_GP_�������
		WHERE
			��Ϻз� like N'TM_�Ŀ������%'
			AND ��Ϻз���=N'�뼺-����۵���'
			AND ������ >= '2018-01-01'
		) H
	LEFT JOIN
		MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�������� PR
	ON	
		H.ȸ����ȣ = PR.ȸ����ȣ
	WHERE
		PR.������ >= H.������
	GROUP BY
		H.ȸ����ȣ
	) A
WHERE	-- donors whose first payment is last month since they agreed to donate again 
	ù������ >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE())-1, 0)
	AND ù������ < DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0)

-- 2. Lapsed donor for last month
INSERT INTO [report].[dbo].[supporter_ALC]
SELECT
	'Actual' AS [Comparison], 
	'Korea' AS [Region],	
	Year(DATEADD(mm, DATEDIFF(mm, 0, GETDATE())-1, 0)) AS [Year],				-- the year of last month
	Month(DATEADD(mm, DATEDIFF(mm, 0, GETDATE())-1, 0)) AS [Month],				-- last month
	CONVERT(DATE, DATEADD(mm, DATEDIFF(mm, 0, GETDATE())-1, 0)) AS [Date],	-- the first day of last month
	D.ȸ����ȣ AS [ConstituentID],
	CASE
	WHEN D.���ʵ�ϱ���=N'����' THEN 'Regular'
	WHEN D.���ʵ�ϱ���=N'�Ͻ�' THEN 'One-off'
	END AS [Type],
	'Lapsed' AS [Source],
	'Lapsed' AS [Resource],
	-1 AS [NewDonor_Actual]
FROM
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������� D
WHERE	 -- donors whose last payment was before 13 months 
	D.�������γ�� = SUBSTRING(CONVERT(varchar(10), DATEADD(month, -13, GETDATE()), 126), 1, 7) 
GO

-- 3. Current donor for last month
INSERT INTO [report].[dbo].[supporter_ALC]
SELECT
	'Actual' AS [Comparison], 
	'Korea' AS [Region],	
	Year(DATEADD(mm, DATEDIFF(mm, 0, GETDATE())-1, 0)) AS [Year],				-- the year of last month
	Month(DATEADD(mm, DATEDIFF(mm, 0, GETDATE())-1, 0)) AS [Month],				-- last month
	CONVERT(DATE, DATEADD(mm, DATEDIFF(mm, 0, GETDATE())-1, 0)) AS [Date],	-- the first day of last month
	D.ȸ����ȣ AS [ConstituentID],
	CASE
	WHEN D.���ʵ�ϱ���=N'����' THEN 'Regular'
	WHEN D.���ʵ�ϱ���=N'�Ͻ�' THEN 'One-off'
	END AS [Type],
	'Current' AS [Source],
	'Current' AS [Resource],
	1 AS [NewDonor_Actual]
FROM
	(
	SELECT
		ȸ����ȣ
	FROM
		MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_��������
	WHERE
		ȯ�һ��� != N'����ȯ��'  -- donors whose last payment is within a year but not ones whose first payment is this month
		AND ������ >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE())-12, 0)
		AND ������ < DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0)
	GROUP BY
		ȸ����ȣ
	) PR
LEFT JOIN
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������� D
ON
	PR.ȸ����ȣ = D.ȸ����ȣ

-- ȫ�� ������ Ȯ���ϱ�
SELECT 
	*
FROM
	[HK].[Korea Report Data].[dbo].[Table_SupporterCount_KR] 
WHERE
	 Year=2018
	 AND Month = 'Mar'

-- ȫ�� ������ �ֱ�
INSERT INTO
	[HK].[Korea Report Data].[dbo].[Table_SupporterCount_KR]
SELECT
	[Comparison], 
	[Region],
	[Year], 
	CASE 
	WHEN [Month]=1 THEN 'Jan'
	WHEN [Month]=2 THEN 'Feb'
	WHEN [Month]=3 THEN 'Mar'
	WHEN [Month]=4 THEN 'Apr'
	WHEN [Month]=5 THEN 'May'
	WHEN [Month]=6 THEN 'Jun'
	WHEN [Month]=7 THEN 'Jul'
	WHEN [Month]=8 THEN 'Aug'
	WHEN [Month]=9 THEN 'Sep'
	WHEN [Month]=10 THEN 'Oct'
	WHEN [Month]=11 THEN 'Nov'
	WHEN [Month]=12 THEN 'Dec'
	END AS [Month], 
	[Date],
	[ConstituentID],
	NULL AS [CampaignId],
	NULL AS [Name],
	[Source],
	[Resource],
	NULL AS [Team],
	[Type],
	[NewDonor_Actual],
	NULL AS [NewDonorAmt_Actual],
	NULL AS [Age]
FROM
	[report].dbo.[supporter_ALC]
WHERE
	Year=2018 AND Month = Month(DATEADD(mm, DATEDIFF(mm, 0, GETDATE())-1, 0))

---- Join donor 
--ALTER VIEW [vw_join_count_monthly] AS
--SELECT
--	D.ȸ����ȣ AS [Constituent_id],
--	Year(D.������) AS [Join year],
--	Month(D.������) AS [Join month],
--	CASE 
--	WHEN D.���԰��='�Ÿ�����' THEN 'Direct Dialogue'
--	WHEN D.���԰��='���ͳ�/Ȩ������' THEN 'Web'
--	WHEN D.���԰��='Lead Conversion' THEN D.���԰��
--	ELSE 'Others'
--	END AS [Source],
--	CASE 
--	WHEN D.�Ҽ� != 'Inhouse' THEN 'Agency'
--	ELSE 'Inhouse'
--	END AS [Resource],
--	CASE
--	WHEN D.���ʵ�ϱ���='����' THEN 'Regular'
--	WHEN D.���ʵ�ϱ���='�Ͻ�' THEN 'One-off'
--	END AS [Type],
--	D.������
--FROM
--	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������� D
--WHERE
--	������ >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE())-1, 0)
--	AND ������ < DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0)
--UNION ALL
--SELECT
--	D.ȸ����ȣ AS [Constituent_id],
--	Year(H.������) AS [Join year],
--	Month(H.������) AS [Join month],
--	'Reactivation' AS [Source],
--	'Agency' AS [Resource],
--	CASE
--	WHEN D.���ʵ�ϱ���='����' THEN 'Regular'
--	WHEN D.���ʵ�ϱ���='�Ͻ�' THEN 'One-off'
--	END AS [Type],
--	H.������ AS ������
--FROM
--	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.DBO.UV_GP_������� H
--LEFT JOIN
--	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������� D
--ON
--	H.ȸ����ȣ = D.ȸ����ȣ
--WHERE
--	H.��Ϻз�='TM_�Ŀ������'
--	AND H.��Ϻз���='�뼺-����۵���'
--	AND H.������ >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE())-1, 0)
--	AND H.������ < DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0)


---- Cancel donor 
--ALTER VIEW [vw_cancel_count_monthly] AS
--SELECT
--	D.ȸ����ȣ AS [Constituent_id],
--	Year(H.������) AS [Canceled year],
--	Month(H.������) AS [Canceled month],
--	GETDATE() AS [Last updated]
--FROM
--	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.DBO.UV_GP_������� H
--LEFT JOIN
--	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������� D
--ON
--	H.ȸ����ȣ = D.ȸ����ȣ
--WHERE
--	H.��Ϻз� = 'Cancellation'
--	AND H.��Ϻз��� like '%canceled%'
--	AND H.������ >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE())-1, 0)
--	AND H.������ < DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0)
