use work
go
SELECT
	D.ȸ����ȣ
FROM
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������� D
LEFT JOIN
	(SELECT
		ȸ����ȣ, ��ϱ���2
	FROM
		MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_������� 
	WHERE
		��ϱ���2 like '1%') CR
ON
	D.ȸ����ȣ = CR.ȸ����ȣ
LEFT JOIN
	(SELECT 
		ȸ����ȣ
	FROM
		MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_������� 
	WHERE
		��Ϻз���=N'���') UN
ON
	D.ȸ����ȣ = UN.ȸ����ȣ
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
	D.ȸ����ȣ = D45.ȸ����ȣ
LEFT JOIN
	dbo.no_response NR
ON
	D.ȸ����ȣ = NR.ȸ����ȣ

LEFT JOIN
	(SELECT
		ȸ����ȣ
	FROM
		MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_������� 
	WHERE
		ó��������� = 'SK-����'
	) ING
ON 
	D.ȸ����ȣ = ING.ȸ����ȣ
WHERE
	D.������ >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE())-4, 0)
	AND D.������ < DATEADD(mm, DATEDIFF(mm, 0, GETDATE())-3, 0)		-- ������ 3�������� 
	AND D.���ʵ�ϱ��� = '����'										-- ���ʵ�ϱ����� ������ �����
	AND D.�޴���ȭ��ȣ = '��'										-- �޴���ȭ��ȣ �ִ� �����
	AND D.��ϱ��� != '�ܱ���'										-- �ܱ����� �ƴ� �����
	AND D.ȸ������ = 'Normal'										-- ȸ�����°� Normal�� �����
	AND CR.ȸ����ȣ is null											-- ������ 1���� ��� ����
	AND UN.ȸ����ȣ is null											-- ����� ��� ����
	AND D45.ȸ����ȣ is null										-- �ֱ� 45�� �̳� ���� �� ��� ����
	AND NR.ȸ����ȣ is null											-- ���� ���� 4���� ��� ����
	AND ING.ȸ����ȣ IS NULL