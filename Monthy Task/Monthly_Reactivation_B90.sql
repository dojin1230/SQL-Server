-------- �Ŀ������ �ڹ����� ���� �� 
USE work
GO

SELECT
	H.ȸ����ȣ, D.ȸ������, D.�������γ��
FROM
	(
	SELECT
		ȸ����ȣ
	FROM
		MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_������� 
	WHERE
		��Ϻз� = 'Cancellation' 
		AND ��Ϻз��� = 'Canceled'
		AND ���� = 'B90'
		AND ������ >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0)		
		--AND ������ >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE())-1, 0)		
		--AND ������ < DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0)		
	) H
LEFT JOIN
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������� D
ON
	H.ȸ����ȣ = D.ȸ����ȣ
LEFT JOIN
	(SELECT
		ȸ����ȣ
	FROM
		MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_������� 
	WHERE
		��ϱ���2 like '1%') CR
ON
	H.ȸ����ȣ = CR.ȸ����ȣ
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
	H.ȸ����ȣ = RS.ȸ����ȣ
LEFT JOIN
	(SELECT 
		ȸ����ȣ
	FROM
		MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_������� 
	WHERE
		��Ϻз���=N'���') UN
ON
	H.ȸ����ȣ = UN.ȸ����ȣ
LEFT JOIN
	(SELECT
		ȸ����ȣ
	FROM
		MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_������� 
	WHERE
		��Ϻз�='Cancellation'
		AND ����='14') C14
ON
	H.ȸ����ȣ = C14.ȸ����ȣ
LEFT JOIN
	(SELECT
		ȸ����ȣ
	FROM
		MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_������� 
	WHERE
		��Ϻз� like 'TM%'
		AND ((��Ϻз��� =N'����') OR (��Ϻз��� =N'����' AND ��ϱ���2 is null))
		AND ������ > CONVERT(varchar(10), DATEADD(day, -45, GETDATE()), 126)) M3
ON
	H.ȸ����ȣ = M3.ȸ����ȣ
LEFT JOIN
	(SELECT
		ȸ����ȣ
	FROM
		MRMRT.�׸��ǽ����ƽþƼ���繫��0868.DBO.UV_GP_�Ŀ�������
	WHERE
		��ϱ���=N'�ܱ���') F
ON
	H.ȸ����ȣ = F.ȸ����ȣ
LEFT JOIN
	(SELECT
		ȸ����ȣ
	FROM
		MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_������� 
	WHERE
		��Ϻз� like 'TM_�Ŀ������%'
		AND ó���������='SK-����') RP
ON
	H.ȸ����ȣ = RP.ȸ����ȣ
LEFT JOIN
	dbo.no_response NR
ON
	H.ȸ����ȣ = NR.ȸ����ȣ
WHERE											-- �����޿� ���࿡�� ���� ������ �����
	D.���ʵ�ϱ��� = N'����'						-- ���ʵ�ϱ����� ������ �����
	AND D.�޴���ȭ��ȣ='��'						-- �޴���ȭ��ȣ�� �ִ� �����
	AND D.ȸ������ in ('canceled','Freezing')	-- ȸ�����°� canceled�ų� freezing�� �����
	AND CR.ȸ����ȣ is null						-- ��ȭ������ 1���� ��� ����
	AND RS.ȸ����ȣ is null						-- 2017����� �Ŀ������ �� ���� Ȥ�� �ź��� ��� ����
	AND UN.ȸ����ȣ is null						-- ����� ��� ����
	AND C14.ȸ����ȣ is null						-- ��� ������ �̹��� ��� ����
	AND M3.ȸ����ȣ is null						-- �ֱ� 45�ϰ� TM���� �Ҵ�Ǿ� ��ȭ ������ ��� ����
	AND F.ȸ����ȣ is null						-- �ܱ��� ����
	AND RP.ȸ����ȣ is null						-- �Ŀ������ �� ���� ���� ��� ����
	AND NR.ȸ����ȣ is null						-- ���� ���� 4���� ��� ����