use [report]
GO

-- 0. �����޿� Mid-Income �� update�ص״� upgrade/downgrade �����͸� �����Ѵ�.
DELETE FROM
	[report].[dbo].[upgrade_monthly]
WHERE
	UpgradeMonth = MONTH(DATEADD(mm, DATEDIFF(mm, 0, GETDATE())-1, 0))
GO

DELETE FROM
	[report].[dbo].[downgrade_monthly]
WHERE
	DowngradeMonth = MONTH(DATEADD(mm, DATEDIFF(mm, 0, GETDATE())-1, 0))
GO

-- 1. ������ ���αݾ��� �� ���� ���αݾ׺��� ū �Ŀ��ڸ� �̾� upgrade ���̺��� update�Ѵ�.
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
				PR.ȸ����ȣ, RANK() OVER (PARTITION BY PR.ȸ����ȣ ORDER BY PR.������ DESC) AS �ֱٳ����ϼ���, PR.���αݾ�
			FROM
				(
				SELECT
					ȸ����ȣ
				FROM
					MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�������� 
				WHERE
					�������='����'
					AND ������ >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE())-1, 0)	-- ������ 1��
					AND ������ < DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0)		-- �̹��� 1��
				) A
			LEFT JOIN
				MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�������� PR			
			ON
				A.ȸ����ȣ = PR.ȸ����ȣ
			WHERE
				PR.������� = '����'
				AND PR.ȯ�һ��� = ''
				AND PR.������ < DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0)		-- �̹��� 1��
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
		AND ������ < DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0)
	GROUP BY
		ȸ����ȣ
	) MP
ON
	UP.ȸ����ȣ = MP.ȸ����ȣ 
WHERE	
	UP.���� > 0

-- 2. ������ ���αݾ��� �� ���� ���αݾ׺��� ���� �Ŀ��ڸ� �̾� downgrade ���̺��� update�Ѵ�.
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
					AND ������ >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE())-1, 0)	-- ������ 1��
					AND ������ < DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0)		-- �̹��� 1��
				) A
			LEFT JOIN
				MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�������� PR			
			ON
				A.ȸ����ȣ = PR.ȸ����ȣ
			WHERE
				PR.������� = '����'
				AND PR.ȯ�һ��� = ''
				AND PR.������ < DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0)		-- �̹��� 1��
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
		AND ������ < DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0)
	GROUP BY
		ȸ����ȣ
	) MP
ON
	DW.ȸ����ȣ = MP.ȸ����ȣ 
WHERE	
	DW.���� < 0

-- 3. ������ Upgrade �Ŀ��ڵ��� �׷쿡 �Ҵ��Ѵ�.
SELECT
	UP.ȸ����ȣ, 'Upgrade_Actual donation' AS �׷��
FROM
	[report].[dbo].[upgrade_monthly] UP
LEFT JOIN
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������� D
ON
	UP.ȸ����ȣ = D.ȸ����ȣ
WHERE
	Up.UpgradeMonth = MONTH(DATEADD(mm, DATEDIFF(mm, 0, GETDATE())-1, 0))	-- ���׷��̵��� ���� �������� �����
	AND D.ȸ������ = 'Normal'												-- ȸ������ Normal�� �����


-- 4. ����� ������ ����� �� ������ ù ���θ� �� �Ŀ��ڵ��� �׷쿡 �Ҵ��Ѵ�. 
SELECT
	A.ȸ����ȣ, 'Reactivation_Actual donation' AS �׷��
FROM
	(
	SELECT
		H.ȸ����ȣ, MIN(PR.������) ù������
	FROM
		(
		SELECT
			ȸ����ȣ, ������ AS �簡����
		FROM
			MRMRT.�׸��ǽ����ƽþƼ���繫��0868.DBO.UV_GP_�������
		WHERE
			��Ϻз� like N'TM_�Ŀ������%'
			AND ��Ϻз���=N'�뼺-����۵���'
		) H
	LEFT JOIN
		MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�������� PR
	ON	
		H.ȸ����ȣ = PR.ȸ����ȣ
	WHERE
		PR.������ >= H.�簡����
	GROUP BY
		H.ȸ����ȣ
	) A
LEFT JOIN 
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������� D
ON
	A.ȸ����ȣ = D.ȸ����ȣ
WHERE	-- donors whose first payment is last month since they agreed to donate again 
	A.ù������ >= CONVERT(DATE, DATEADD(mm, DATEDIFF(mm, 0, GETDATE())-1, 0), 126)
	AND A.ù������ < CONVERT(DATE, DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0), 126)
	AND D.ȸ������ = 'Normal'

-- 5. ����Ʈ ����¡ Ÿ�����Ѵ�.
SELECT
	DD.ȸ����ȣ, 
	'Freezing-insufficient funds' AS [��Ϻз�/�󼼺з�],
	CONVERT(DATE,GETDATE(),126) AS ����,
	'IH-�Ϸ�' AS ����1,
	'F' AS ����,
	CONVERT(DATE,GETDATE(),126) AS ������,
	COUNT(DD.ȸ����ȣ) AS �̳�Ƚ��
FROM
	(SELECT 
		D.ȸ����ȣ, D.ȸ������
	FROM
		MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������� D
	INNER JOIN
		(SELECT �����, ȸ���ڵ�, ��û�ݾ�,
			CASE
				WHEN ó����� = '��ݿϷ�' THEN '����'
				ELSE '����'
			END AS ���,
			����޼���,
			CASE
				WHEN ����޼��� LIKE '%�ܾ�%' THEN 'SOFT'
				--WHEN ����޼��� LIKE '%�ܰ�%' THEN 'SOFT'
				--WHEN ����޼��� LIKE '%�ѵ�%' THEN 'SOFT'
				WHEN ó����� = '��ݿϷ�' THEN NULL
				ELSE 'HARD'
			END AS TYPE,
			'CMS' AS pymt_mtd
		FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_CMS�������
		UNION ALL
		SELECT �����, ȸ���ڵ�, ��û�ݾ�, ���, ���л���,
			CASE
				WHEN ���л��� LIKE '%�ܾ�%' THEN 'SOFT'
				WHEN ���л��� LIKE '%�ܰ�%' THEN 'SOFT'
				WHEN ���л��� LIKE '%�ѵ�%' THEN 'SOFT'
				WHEN ��� = '����' THEN NULL
				ELSE 'HARD'
			END AS TYPE,
			'CRD' AS pymt_mtd
		FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�ſ�ī��������) BR_CR
	ON D.ȸ����ȣ = BR_CR.ȸ���ڵ� 		-- �Ŀ��������� CMS �� ī�� ������� ���� (����������� �̳����� �Ǿ������� ����Ʈ ���ε� ����)
	LEFT JOIN
		(
		SELECT 
			�Ϸù�ȣ, ID, ȸ����ȣ, ����Ͻ�, ��Ϻз�, ��Ϻз���, ������, ó���������, ����, �����Է���, ��ϱ���2
		FROM 
			MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�������
		WHERE
			��Ϻз� = 'TM_�Ŀ��簳_�ܾ׺���'
			AND ��Ϻз��� = '�뼺-�簳����'
			AND CONVERT(date,������) >= CONVERT(date, DATEADD(MONTH, -3, GETDATE()), 126)
		) H
	ON 
		D.ȸ����ȣ = H.ȸ����ȣ    	-- �Ŀ��������� ������� ����
	WHERE (CONVERT(VARCHAR(7),D.�������γ��) < CONVERT(VARCHAR(7), DATEADD(MONTH, -4, GETDATE()), 126)
		OR D.�������γ�� IS NULL)  -- ���������� ������ ���� 4���� �����̰ų� ���α���� ���� ��츸 ���� (��: 1���� �۾��� �������γ���� ���⵵ 8�� ����)
		AND BR_CR.��� = '����'			-- ī�� �� CMS ������� ��� ������ ���
		AND BR_CR.TYPE = 'SOFT'			-- ���л����� �ܾ�/�ܰ�/�ѵ� ������ ���
		AND CONVERT(VARCHAR(7),BR_CR.�����) >= CONVERT(VARCHAR(7), DATEADD(MONTH, -4, GETDATE()), 126)  -- ������� �� ������� 4���� �̳��� ��츸 ����
		AND H.ȸ����ȣ IS NULL			-- 3���� �̳��� �ܾ׺��� ���� �ް� ������ ��� ����
	) DD
GROUP BY 
	DD.ȸ����ȣ, DD.ȸ������
HAVING
	COUNT(DD.ȸ����ȣ) >= 8
	AND DD.ȸ������ = 'normal'

-- ���ⳳ�ΰ� ����� ȸ���� Cancel�� �����Ѵ�.
SELECT
	*
FROM
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������� D
LEFT JOIN
	(
	SELECT
		*
	FROM
		MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������ݾ�����
	WHERE
		������ >= SUBSTRING(CONVERT(VARCHAR(10), GETDATE(), 126), 1, 7) 
		OR ���� in ('���','����')
	) PL
ON
	D.ȸ����ȣ = PL.ȸ����ȣ
WHERE
	D.ȸ������ = 'Normal'
	AND D.���ʵ�ϱ��� = '����'
	AND PL.ȸ����ȣ is null