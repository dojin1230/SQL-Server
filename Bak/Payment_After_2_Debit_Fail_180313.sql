SELECT
	CONVERT(DATE, GETDATE(), 126) AS ����,
	ȸ���ڵ� AS ȸ����ȣ,
	CASE
	WHEN ING.ȸ����ȣ is null THEN BCR.����޼��� 
	ELSE '���� ���� �ݿ��� ���� �ٶ�' 
	END AS ����,
	CASE
	WHEN ING.ȸ����ȣ is null THEN 'TM_��������_����_�������� - ��ó��'
	ELSE 'TM_��������_����_�������� - ����' 
	END AS [��Ϻз�/�󼼺з�],
	CASE
	WHEN ING.ȸ����ȣ is null THEN 'SK-����'
	ELSE 'SK-�Ϸ�'
	END AS ����1,
	'DF.CALL_WV' AS ����
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
		��Ϻз� like 'TM%'
		AND ó��������� in ('SK-����', 'IH-����')
		AND ����Ͻ� >= CONVERT(DATETIME, DATEADD(day, -14, GETDATE()), 126)
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
	AND D.�޴���ȭ��ȣ = '��'				-- �޴���ȭ��ȣ �ִ� �����
	AND D.��ϱ��� != '�ܱ���'			-- �ܱ��� ����
	AND UN.ȸ����ȣ is null				-- ��� ����
	AND D45.ȸ����ȣ is null				-- �ֱ� 45�� �̳��� ��ȭ�� ���� ��� ����
	AND DN.ȸ����ȣ is null				-- ��ȭ������ 1���� ��� ����
	AND CA.ȸ����ȣ is null				-- ī������ �Ѿ ���Ŀ� ī����� �� ȸ�� ����
ORDER BY 5
