-------- �Ŀ������ ���� �� 
USE work
GO

SELECT
	D.ȸ����ȣ, D.ȸ������, D.������, D.�������γ��
FROM
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������� D
LEFT JOIN
	(SELECT
		ȸ����ȣ
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
		��Ϻз� like N'TM_�Ŀ������%'
		AND ��Ϻз��� in (N'�뼺-����۵���',N'�뼺-����۰���')
		AND ������ >= CONVERT(varchar(10), '2017-01-01', 126)
		) RS
ON
	D.ȸ����ȣ = RS.ȸ����ȣ
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
		��Ϻз�='Cancellation'
		AND ����='14') C14
ON
	D.ȸ����ȣ = C14.ȸ����ȣ
LEFT JOIN
	(SELECT
		ȸ����ȣ
	FROM
		MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_������� 
	WHERE
		��Ϻз� like 'TM%'
		AND ��Ϻз��� not in (N'����',N'����')
		AND ������ > CONVERT(DATE, DATEADD(day, -45, GETDATE()), 126)) M3
ON
	D.ȸ����ȣ = M3.ȸ����ȣ
LEFT JOIN
	(SELECT
		ȸ����ȣ
	FROM
		MRMRT.�׸��ǽ����ƽþƼ���繫��0868.DBO.UV_GP_�Ŀ�������
	WHERE
		��ϱ���=N'�ܱ���') F
ON
	D.ȸ����ȣ = F.ȸ����ȣ
LEFT JOIN
	(SELECT
		ȸ����ȣ
	FROM
		MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_������� 
	WHERE
		��Ϻз� like 'TM_�Ŀ������%'
		AND ó���������='SK-����') RP
ON
	D.ȸ����ȣ = RP.ȸ����ȣ
LEFT JOIN
	(SELECT
		ȸ����ȣ
	FROM
		MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_������� 
	WHERE
		��Ϻз� = 'Cancellation'
		AND ������ > CONVERT(DATE, DATEADD(month, -2, GETDATE()), 126)) C
ON
	D.ȸ����ȣ = C.ȸ����ȣ
LEFT JOIN
	dbo.no_response NR
ON
	D.ȸ����ȣ = NR.ȸ����ȣ
WHERE
	D.�������γ�� < '2016-12'					-- Monthly Reactivation ���̶� �� ��ġ����, �������γ���� 2016�� 9�� ������ �����
	AND D.���ʵ�ϱ��� = N'����'					-- ���ʵ�ϱ����� ������ �����
	AND D.�޴���ȭ��ȣ='��'						-- �޴���ȭ��ȣ�� �ִ� �����
	AND D.ȸ������ in ('canceled','Freezing')	-- ȸ�����°� canceled�ų� freezing�� �����
	AND CR.ȸ����ȣ is null						-- ��ȭ������ 1���� ��� ����
	AND RS.ȸ����ȣ is null						-- 2017�� �̷� �Ŀ������ �� ���� Ȥ�� �ź��� ��� ����
	AND UN.ȸ����ȣ is null						-- ����� ��� ����
	AND C14.ȸ����ȣ is null						-- ��� ������ �̹��� ��� ����
	AND M3.ȸ����ȣ is null						-- �ֱ� 45�ϰ� TM���� �Ҵ�Ǿ� ��ȭ ������ ��� ����
	AND F.ȸ����ȣ is null						-- �ܱ��� ����
	AND RP.ȸ����ȣ is null						-- �Ŀ������ �� ���� ���� ��� ����
	AND NR.ȸ����ȣ is null						-- ���� ���� 4���� ��� ����
	AND C.ȸ����ȣ is null						-- 2�� �̳��� Cancellation ��û�� ���
ORDER BY 4 DESC
GO

