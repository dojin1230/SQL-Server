-- ����̰ų� ��ȭ������ 1�� ��� ����
-- ���� ���� 4���� ��� ����
-- �ܱ��� ����
-- ��ȭ��ȣ �ִ� �����
-- Normal��

USE WORK
GO

SELECT
	D.ȸ����ȣ, 
	CASE
	WHEN ING.ȸ����ȣ is null THEN '' 
	ELSE '���� ���� �ݿ��� ���� �ٶ�' 
	END AS ����,
	CONVERT(DATE, GETDATE(), 126) AS ����,
	CASE
	WHEN UN.ȸ����ȣ is null AND D.��ϱ��� != '�ܱ���' AND D.�޴���ȭ��ȣ='��' AND ING.ȸ����ȣ is null THEN 'TM_�ſ�ī�����Ό��-��ó��' 
	WHEN ING.ȸ����ȣ is not null THEN 'TM_�ſ�ī�����Ό��-����' 
	ELSE 'Freezing-CC/CMS problems'
	END AS [��Ϻз�/�󼼺з�],
	CASE
	WHEN UN.ȸ����ȣ is null AND D.��ϱ��� != '�ܱ���' AND D.�޴���ȭ��ȣ='��' AND ING.ȸ����ȣ is null THEN 'SK-����' 
	WHEN ING.ȸ����ȣ is not null THEN 'SK-�Ϸ�' 
	ELSE 'IH-�Ϸ�'
	END AS ����1,
	CASE
	WHEN UN.ȸ����ȣ is null AND D.��ϱ��� != '�ܱ���' AND D.�޴���ȭ��ȣ='��' THEN 'UC.CALL_WV' 
	ELSE 'F'
	END AS ����,
	UN.ȸ����ȣ AS �������, D.��ϱ���, D.�޴���ȭ��ȣ
FROM
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������� D
LEFT JOIN
	(SELECT
		*
	FROM
		MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�������
	WHERE
		��Ϻз��� = '���'
		OR ��ϱ���2 like '1%') UN
ON 
	D.ȸ����ȣ = UN.ȸ����ȣ
LEFT JOIN
	(SELECT
		ȸ����ȣ
	FROM
		dbo.no_response) NR
ON
	D.ȸ����ȣ = NR.ȸ����ȣ
LEFT JOIN
	(SELECT
		ȸ����ȣ, ����Ͻ�
	FROM
		MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_������� 
	WHERE
		��Ϻз� like 'TM%'
		AND ó��������� in ('SK-����', 'IH-����')
		AND ����Ͻ� >= CONVERT(DATETIME, DATEADD(day, -7, GETDATE()), 126)
	) ING
ON 
	D.ȸ����ȣ = ING.ȸ����ȣ	
WHERE
	--NR.ȸ����ȣ is null				-- ���� ���� 4���� ��� ����
	D.ȸ������ = 'Normal'		-- Normal��
	AND D.ȸ����ȣ IN
	('82008619',
'82015222',
'82015243',
'82016593',
'82018214',
'82020446',
'82020807',
'82022574',
'82023951',
'82025006',
'82029655',
'82033588',
'82033936',
'82033988',
'82035765',
'82036338',
'82037930',
'82038268',
'82038605',
'82039839',
'82042018',
'82042738',
'82043786',
'82043996',
'82044803',
'82047360',
'82047569',
'82048150',
'82049619',
'82049898') 
ORDER BY 4




