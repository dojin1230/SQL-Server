--dbo.UV_GP_�Ŀ������� 	 		ȸ����Ȳ								D	Donor 
--dbo.UV_GP_�Ŀ������ݾ����� 	 	�����׸�								PL	Payment List
--dbo.UV_GP_�Ͻ��Ŀ�������� 	 	�ſ�ī��(���̽�����) > ���ó�����Ȳ	T	Temporary Result
--dbo.UV_GP_�ſ�ī��������� 	 	�ſ�ī�� > ȸ��������Ȳ				CA 	Card Approval
--dbo.UV_GP_�ſ�ī�������� 	 	�ſ�ī�� > ���ⳳ����Ȳ				CR 	Card Result 	
--dbo.UV_GP_�����̷� 	 		�����̷�								CH 	Change History
--dbo.UV_GP_������� 	 		�������								H 	History	
--dbo.UV_GP_�������� 	 		ȸ�񳳺� - ������ �Ŀ���				PR	Payment Result	
--dbo.UV_GP_CMS�������� 	 		SmartCMS > ȸ����û					BA 	Bank Approval
--dbo.UV_GP_CMS������� 	 		SmartCMS > ��ݽ�û					BR 	Bank Result

-- Unfreezing
--CREATE VIEW [dbo].[vw_call_unfreeze]
--AS
SELECT
	F.ȸ����ȣ,
	CASE 
	WHEN H.��Ϻз��� = 'insufficient funds' THEN 'TM_�Ŀ��簳_�ܾ׺���-��ó��' 
	WHEN H.��Ϻз��� = 'CC/CMS problems' THEN 'TM_�Ŀ��簳_��������-��ó��' 
	END AS [��Ϻз�/�󼼺з�],
	CONVERT(date,GETDATE()) AS ����, 
	'SK-����' AS ����1,
	'UF.CALL_WV' AS ����,	
	CASE
	WHEN D.���ι�� = 'CMS' AND BR.����޼��� is not null THEN BR.����޼���
	WHEN D.���ι�� = '�ſ�ī��' AND CR.���л��� is not null THEN CR.���л���
	ELSE ''
	END AS ����,
	F.�ֱ�Freezing��,
	BCR.�ֱ������
FROM
	(
	SELECT
		ȸ����ȣ, ��Ϻз�, MAX(������) �ֱ�Freezing�� 
	FROM
		MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�������
	WHERE
		��Ϻз� = 'Freezing' --AND ��Ϻз���='CC/CMS problems'
	GROUP BY
		ȸ����ȣ, ��Ϻз�
	) F
LEFT JOIN
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_������� H
ON
	F.ȸ����ȣ = H.ȸ����ȣ 
	AND F.�ֱ�Freezing�� = H.������
	AND F.��Ϻз� = H.��Ϻз�
LEFT JOIN
	(
	SELECT
		ȸ���ڵ�, MAX(�����) AS �ֱ������
	FROM
		(
		SELECT 
			ȸ���ڵ�, �����
		FROM 
			MRMRT.�׸��ǽ����ƽþƼ���繫��0868.DBO.UV_GP_CMS�������
		UNION ALL
		SELECT 
			ȸ���ڵ�, �����
		FROM 
			MRMRT.�׸��ǽ����ƽþƼ���繫��0868.DBO.UV_GP_�ſ�ī��������
		) A
	GROUP BY
		ȸ���ڵ�
	) BCR
ON
	F.ȸ����ȣ = BCR.ȸ���ڵ�
LEFT JOIN
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.DBO.UV_GP_CMS�������	BR
ON
	BCR.ȸ���ڵ� = BR.ȸ���ڵ� 
	AND BCR.�ֱ������ = BR.�����
LEFT JOIN
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.DBO.UV_GP_�ſ�ī��������	CR
ON
	BCR.ȸ���ڵ� = CR.ȸ���ڵ� 
	AND BCR.�ֱ������ = CR.�����
LEFT JOIN
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������� D
ON
	F.ȸ����ȣ = D.ȸ����ȣ
LEFT JOIN
	(SELECT
		ȸ����ȣ, ��Ϻз�, ������
	FROM
		MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_������� 
	WHERE
		��Ϻз� like 'TM%'
		AND ��Ϻз��� not in (N'����',N'����')
		AND ������ > CONVERT(varchar(10), DATEADD(day, -60, GETDATE()), 126)) D45
ON
	F.ȸ����ȣ = D45.ȸ����ȣ
LEFT JOIN
	(SELECT
		ȸ����ȣ, ��Ϻз�, ������
	FROM
		MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_������� 
	WHERE
		��Ϻз� like 'TM_�Ŀ��簳%') UF
		--AND ��Ϻз��� not in (N'����',N'����')) UF
ON
	F.ȸ����ȣ = UF.ȸ����ȣ
LEFT JOIN
	(SELECT 
		ȸ����ȣ, ��Ϻз���
	FROM
		MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_������� 
	WHERE
		��Ϻз���=N'���') UN
ON
	F.ȸ����ȣ = UN.ȸ����ȣ
LEFT JOIN
	(SELECT
		ȸ����ȣ, ��ϱ���2
	FROM
		MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_������� 
	WHERE
		��ϱ���2 like '1%' ) CRE
ON
	F.ȸ����ȣ = CRE.ȸ����ȣ
LEFT JOIN
	(SELECT
		ȸ����ȣ, ��ϱ���2
	FROM
		MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_������� 
	WHERE
		��Ϻз� = 'Cancellation'
		AND ��Ϻз��� = '����') C
ON
	F.ȸ����ȣ = C.ȸ����ȣ
WHERE
	D.ȸ������ = 'Freezing'																			-- ȸ�����°� Freezing�� �����
	AND D.��ϱ��� != '�ܱ���'																		-- �ܱ����� �ƴ� �����
	AND D.�޴���ȭ��ȣ = '��'																			-- �޴�����ȣ �ִ� �����
	AND D.���ʵ�ϱ��� = '����'																		-- ���ʵ�ϱ����� ������ �����
	AND D45.ȸ����ȣ is null																			-- �ֱ� 60�� �̳��� ���� ���� �� �ִ� ��� ����
	AND UF.ȸ����ȣ is null																			-- ������ �Ŀ��簳���� ���� �� �ִ� ��� ����
	AND UN.ȸ����ȣ is null																			-- ��� ����
	AND CRE.ȸ����ȣ is null																			-- ��ȭ������ 1���� ��� ����
	AND C.ȸ����ȣ is null																			-- ��� ���� ���� ��� ����
	AND D.�������γ�� >= SUBSTRING(CONVERT(varchar(10), DATEADD(year, -1, GETDATE()), 126), 1, 7)	-- Lapsed Donor�� �ƴ� �����
	--OR D.�������γ�� is null)																		-- �� ���� ���� ���� ������� ����
ORDER BY
	2 DESC

	
