use report
go

-- 0. ���� �۾��� ���� upgrade/downgrade �Ŀ��ڵ��� �������� : 10�� �����ϸ� ������ �� �� �ִ� �۾�, ���� 16�ϱ��� ��ٸ� �ʿ� ����
-- 0-1. �̹��� ���αݾ��� �� ���� ���αݾ׺��� ū �Ŀ��ڸ� �̾� upgrade ���̺��� update�Ѵ�.
INSERT INTO 
	[report].[dbo].[upgrade_monthly]
SELECT
	--UP.ȸ����ȣ, 'Upgrade_Actual donation' AS �׷��, UP.����
	UP.ȸ����ȣ, UP.�ֱٳ��αݾ�, UP.�������αݾ�, UP.����,-- MONTH(DATEADD(mm, DATEDIFF(mm, 0, GETDATE())-1, 0)) AS ��
	Year(MP.�ֱٳ�����) AS UpgradeYear,
	Month(MP.�ֱٳ�����) AS UpgradeMonth
FROM
	(
	SELECT
		ȸ����ȣ, �ֱٳ��αݾ�, �������αݾ�, �ֱٳ��αݾ� - �������αݾ� AS ����
	FROM
	(
		SELECT
			ȸ����ȣ,
			SUM(CASE WHEN �ֱٳ����ϼ���=1 THEN ���αݾ� END) AS �ֱٳ��αݾ�, 
			SUM(CASE WHEN �ֱٳ����ϼ���=2 THEN ���αݾ� END) AS �������αݾ�
		FROM
			(
			SELECT
				A.ȸ����ȣ, RANK() OVER (PARTITION BY PR.ȸ����ȣ ORDER BY PR.������ DESC) AS �ֱٳ����ϼ���, PR.���αݾ�
			FROM
				(
				SELECT
					ȸ����ȣ
				FROM
					MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�������� 
				WHERE
					�������='����'
					AND ������ >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0)							-- �̹��� 1��
					AND ������ <  CONVERT(DATE, CONCAT(CONVERT(VARCHAR(8), GETDATE(), 126), '16'))	-- �̹��� 16��
				) A
			LEFT JOIN
				MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�������� PR			
			ON
				A.ȸ����ȣ = PR.ȸ����ȣ
			WHERE
				PR.������� = '����'
				AND PR.ȯ�һ��� = ''
				AND PR.������ < CONVERT(DATE, CONCAT(CONVERT(VARCHAR(8), GETDATE(), 126), '16'))		-- �̹��� 16��
			) B
		GROUP BY
			ȸ����ȣ
		) C
	WHERE
		�������αݾ� is not null
	) UP
LEFT JOIN
	(
	SELECT
		ȸ����ȣ, MAX(������) AS �ֱٳ�����
	FROM
		MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�������� 
	WHERE
		�������='����'
		AND ȯ�һ��� = ''
		AND ������ < CONVERT(DATE, CONCAT(CONVERT(VARCHAR(8), GETDATE(), 126), '16'))				-- �̹��� 16��
	GROUP BY
		ȸ����ȣ
	) MP
ON
	UP.ȸ����ȣ = MP.ȸ����ȣ 
WHERE	
	UP.���� > 0

-- 0-2. �̹��� ���αݾ��� �� ���� ���αݾ׺��� ���� �Ŀ��ڸ� �̾� downgrade ���̺��� update�Ѵ�.
INSERT INTO 
	[report].[dbo].[downgrade_monthly]
SELECT
	DW.ȸ����ȣ, DW.�ֱٳ��αݾ�, DW.�������αݾ�, DW.����,
	Year(MP.�ֱٳ�����) AS DowngradeYear,
	Month(MP.�ֱٳ�����) AS DowngradeYear
FROM
	(
	SELECT
		ȸ����ȣ, �ֱٳ��αݾ�, �������αݾ�, �ֱٳ��αݾ� - �������αݾ� AS ����
	FROM
	(
		SELECT
			ȸ����ȣ,
			SUM(CASE WHEN �ֱٳ����ϼ���=1 THEN ���αݾ� END) AS �ֱٳ��αݾ�, 
			SUM(CASE WHEN �ֱٳ����ϼ���=2 THEN ���αݾ� END) AS �������αݾ�
		FROM
			(
			SELECT
				PR.ȸ����ȣ, RANK() OVER (PARTITION BY PR.ȸ����ȣ ORDER BY PR.������ DESC) AS �ֱٳ����ϼ���, PR.���αݾ�
			FROM
				(
				SELECT
					ȸ����ȣ
				FROM
					MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�������� 
				WHERE
					�������='����'
					AND ������ >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0)							-- �̹��� 1��
					AND ������ <  CONVERT(DATE, CONCAT(CONVERT(VARCHAR(8), GETDATE(), 126), '16'))	-- �̹��� 16��
				) A
			LEFT JOIN
				MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�������� PR			
			ON
				A.ȸ����ȣ = PR.ȸ����ȣ
			WHERE
				PR.������� = '����'
				AND PR.ȯ�һ��� = ''
				AND PR.������ < CONVERT(DATE, CONCAT(CONVERT(VARCHAR(8), GETDATE(), 126), '16'))		-- �̹��� 16��
			) B
		GROUP BY
			ȸ����ȣ
		) C
	WHERE
		�������αݾ� is not null
	) DW
LEFT JOIN
	(
	SELECT
		ȸ����ȣ, MAX(������) AS �ֱٳ�����
	FROM
		MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�������� 
	WHERE
		�������='����'
		AND ȯ�һ��� = ''
		AND ������ < CONVERT(DATE, CONCAT(CONVERT(VARCHAR(8), GETDATE(), 126), '16'))				-- �̹��� 16��
	GROUP BY
		ȸ����ȣ
	) MP
ON
	DW.ȸ����ȣ = MP.ȸ����ȣ 
WHERE	
	DW.���� < 0

-- 0-3. Acquired donor ���̺� ������Ʈ -- 15�� ���� �ؾ��� 
-- 0-3-1. New Acquired donor for this month
INSERT INTO [report].[dbo].[supporter_ALC]
SELECT
	'Actual' AS [Comparison], 
	'Korea' AS [Region],	
	Year(DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0)) AS [Year],				-- the year of this month
	Month(DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0)) AS [Month],			-- this month
	CONVERT(DATE, DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0)) AS [Date],	-- the first day of this month
	D.ȸ����ȣ AS [ConstituentID],
	CASE
	WHEN D.���ʵ�ϱ���=N'����' THEN 'Regular'
	WHEN D.���ʵ�ϱ���=N'�Ͻ�' THEN 'One-off'
	END AS [Income type],
	CASE 
	WHEN D.���԰��=N'�Ÿ�����' THEN 'Direct Dialogue'
	WHEN D.���԰��=N'���ͳ�/Ȩ������' THEN 'Web'
	WHEN D.���԰��=N'Lead Conversion' THEN D.���԰��
	ELSE 'Other'
	END AS [Source],
	CASE 
	WHEN D.�Ҽ� != 'Inhouse' THEN 'Agency'
	ELSE 'Inhouse'
	END AS [Sub-source],
	1 AS [NewDonor_Actual]
FROM
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������� D
WHERE	-- donors whose first payment is this month
	D.���ʳ��γ�� = SUBSTRING(CONVERT(varchar(10), DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0), 126), 1, 7)
	AND D.������ < CONVERT(DATE, CONCAT(CONVERT(VARCHAR(8), GETDATE(), 126), '16'))	-- 16�ϲ�����

-- 0-3-1. Reactivation for this month
INSERT INTO [report].[dbo].[supporter_ALC]
SELECT
	'Actual' AS [Comparison], 
	'Korea' AS [Region],	
	Year(DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0)) AS [Year],				-- the year of this month
	Month(DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0)) AS [Month],			-- this month
	CONVERT(DATE, DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0)) AS [Date],	-- the first day of this month
	A.ȸ����ȣ AS [ConstituentID],
	'Regular' AS [Income Type],
	'Reactivation' AS [Source],
	'Agency' AS [Sub-source],
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
			AND ������ >= CONVERT(DATE, '2018-01-01', 126)
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
	ù������ >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0)
	AND ù������ < CONVERT(DATE, CONCAT(CONVERT(VARCHAR(8), GETDATE(), 126), '16'))	-- �̹��� 16��

-- 1. ���� income_monthly table�� �̸� ����
exec sp_rename 'income_monthly', 'income_monthly_201802'

-- 2. �̹��� 15�ϱ��� income�� income_monthly table�� ����
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
	WHEN PR.�������='����' AND PR.[���ι��] in ('CMS', '������ü', 'GP���������Ա�') THEN '301' -------- ���ݳ��ε� ���ǿ� �߰�
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
	PR.������ >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) AND PR.������ < CONVERT(DATE, CONCAT(CONVERT(VARCHAR(8), GETDATE(), 126), '16'))
GO

-- 3. ���� income_by_cocoa table�� �̸� ����
exec sp_rename 'income_by_cocoa', 'income_by_cocoa_201802'


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
		��Ϻз� like N'TM_�Ŀ�����%'
		AND ��Ϻз��� like '%����'
		AND ������ >= CONVERT(DATE, '2018-01-01', 126)
		AND ������ < CONVERT(DATE, CONCAT(CONVERT(VARCHAR(8), GETDATE(), 126), '16'))	-- �̹��� 15�ϱ���
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

-- �ڹ����� ����
-- 142-01-41	Continuing Support	Upgrade	Inhouse
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
		��Ϻз� like N'TM_�Ŀ�����%'
		AND ��Ϻз��� like '%����'
		AND ������ >= CONVERT(DATE, '2018-01-01', 126)
		AND ������ < CONVERT(DATE, CONCAT(CONVERT(VARCHAR(8), GETDATE(), 126), '16'))	-- �̹��� 15�ϱ���
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
		AND ������ <  CONVERT(DATE, CONCAT(CONVERT(VARCHAR(8), GETDATE(), 126), '16'))	-- �̹��� 15�ϱ���
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
	D.ȸ����ȣ is null 
	OR D.DowngradeMonth < U.UpgradeMonth
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
--		AND ������ <  CONVERT(DATE, CONCAT(CONVERT(VARCHAR(8), GETDATE(), 126), '16'))	-- �̹��� 15�ϱ���
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
--		AND ������ <  CONVERT(DATE, CONCAT(CONVERT(VARCHAR(8), GETDATE(), 126), '16'))	-- �̹��� 15�ϱ���
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
		AND ������ <  CONVERT(DATE, CONCAT(CONVERT(VARCHAR(8), GETDATE(), 126), '16'))	-- �̹��� 15�ϱ���
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
		--AND CONVERT(DATETIME2, [Date]) < CONVERT(DATE, CONCAT(CONVERT(VARCHAR(8), GETDATE(), 126), '16'))	-- �̹��� 15�ϱ���
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
SELECT SUM(Amount) AS income FROM [report].dbo.income_by_cocoa
UNION ALL 
SELECT SUM(Amount) AS income FROM [report].dbo.income_monthly
GO

---- ȯ�Ұ� �Է��� ����


-- ȫ�� ������ Ȯ��
SELECT
	*
FROM
	[HK].[Korea Report Data].[dbo].[Table_Report_IncomeReport_KR_2018]

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
WHERE
	Comparison = 'Actual'
GO

---- ���� ���̺� ����صα�
SELECT 
	*
INTO 
	[dbo].[income_account_201802]
FROM
	[dbo].[income_account_2018]

---- Finance report/Monthly report�� ���̴� COCOA�� �ݾ� --- Ʋ���� ������ ���� Budget ���� Actual��!
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

--INSERT INTO
--	[report].[dbo].[income_account_2018]
--SELECT 
--	'Budget' AS Comparison,
--	ConstituentID,
--	PaidDate,
--	2018 AS [Settlement Year],
--	3 AS [Settlement Month],
--	Type,
--	[PaymentMethod],
--	[Actual],
--	Budget,
--	GL_SuffixFormula AS COCOA,
--	SUBSTRING(GL_SuffixFormula,1,3) AS [Budget code],
--	REPLACE(SUBSTRING(GL_SuffixFormula,5,5),'-','') AS [Budget subcode],
--	NULL AS [Account code]
--from 
--	[dbo].[income_budget_2018] where Month='Mar'

