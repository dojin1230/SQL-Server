SELECT
	distinct ȸ���ڵ� AS ȸ����ȣ,
	'' AS ����,
	'Freezing - CC/CMS problems' AS [��Ϻз�/�󼼺з�],
	'IH-�Ϸ�' AS ����1,
	'F' AS ����,
	CONVERT(DATE, GETDATE(), 126) AS ������,
	CONVERT(DATE, GETDATE(), 126) AS ����
FROM
	(
	SELECT 
		ȸ���ڵ�, ����޼���
	FROM 
		MRMRT.�׸��ǽ����ƽþƼ���繫��0868.DBO.UV_GP_CMS�������
		WHERE
		����� >= DATEADD(day, -3, GETDATE())
		and ó����� = '��ݽ���' AND ����޼��� NOT LIKE '%�ܾ�%'
	UNION ALL
	SELECT 
		ȸ���ڵ�, ���л���
	FROM 
		MRMRT.�׸��ǽ����ƽþƼ���繫��0868.DBO.UV_GP_�ſ�ī��������
				WHERE
		����� >= DATEADD(day, -3, GETDATE())
		and ��� ='����' AND ���л���  NOT LIKE '%�ܾ�%' AND ���л��� NOT LIKE '%�ܰ�%' AND ���л��� NOT LIKE '%�ѵ�%' 
	) BCR
LEFT JOIN
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������� D
ON
	BCR.ȸ���ڵ� = D.ȸ����ȣ
LEFT JOIN
	(SELECT 
		ȸ����ȣ
	FROM
		MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_������� 
	WHERE
		��Ϻз���=N'���') UN
ON
	BCR.ȸ���ڵ� = UN.ȸ����ȣ
LEFT JOIN
	(SELECT
		ȸ����ȣ
	FROM
		MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_������� 
	WHERE
		��Ϻз� like 'TM%'
		AND ��Ϻз��� not in (N'����',N'����')
		AND ������ > CONVERT(varchar(10), DATEADD(day, -45, GETDATE()), 126)) D45
ON
	BCR.ȸ���ڵ� = D45.ȸ����ȣ
LEFT JOIN
	(SELECT
		ȸ����ȣ
	FROM
		MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_������� 
	WHERE
		��ϱ���2 like '1%') DN
ON
	BCR.ȸ���ڵ� = DN.ȸ����ȣ
LEFT JOIN
	(SELECT
		ȸ����ȣ, ����Ͻ�
	FROM
		MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_������� 
	WHERE
		��Ϻз� like 'TM_��������%'
		AND ����Ͻ� >= CONVERT(DATETIME, DATEADD(day, -1, GETDATE()), 126)
	) ING
ON 
	BCR.ȸ���ڵ� = ING.ȸ����ȣ	
LEFT JOIN
	(SELECT ȸ����ȣ, �����Ͻ�
	FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�ſ�ī���������
	WHERE �����Ͻ� >= '2018-03-09 17:04'   -- MRM���� �ֱٰ������� ���ν�û�Ͻ� ����
	) CA
ON BCR.ȸ���ڵ� = CA.ȸ����ȣ
WHERE
	D.ȸ������ = 'Normal'				-- ȸ�����°� Normal�� �����
	and CA.ȸ����ȣ is null				-- ī������ �Ѿ ���Ŀ� ī����� �� ȸ�� ����
	AND ING.ȸ����ȣ IS NULL
	AND (D.�޴���ȭ��ȣ = '��'				-- �޴���ȭ��ȣ 
	or D.��ϱ��� = '�ܱ���'			-- �ܱ��� 
	or UN.ȸ����ȣ is not null				-- ���
	or D45.ȸ����ȣ is not null				-- �ֱ� 45�� �̳��� ��ȭ�� ���� ��� 
	or DN.ȸ����ȣ is not null				-- ��ȭ������ 1���� ���
	)
ORDER BY 5
