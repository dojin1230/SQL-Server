USE WORK
go
SELECT
	i.ȸ����ȣ,
	i.����,
	i.��������ó,
	CASE
	WHEN i.��������ó='����' THEN ���ּ�
	WHEN i.��������ó='����' THEN �����ּ�
	END AS �ּ�,
	CASE
	WHEN i.��������ó='����' THEN ���ּһ�
	WHEN i.��������ó='����' THEN �����ּһ�
	END AS �ּһ�,
	CASE
	WHEN i.��������ó='����' THEN �������ȣ
	WHEN i.��������ó='����' THEN ��������ȣ
	END AS �����ȣ
FROM
	[dbo].[db0_clnt_i] i
LEFT JOIN
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������� D
ON
	i.ȸ����ȣ = D.ȸ����ȣ
LEFT JOIN
	(SELECT 
		ȸ����ȣ
	FROM 
		MRMRT.�׸��ǽ����ƽþƼ���繫��0868.DBO.UV_GP_������� H
	WHERE 
		��Ϻз���='�ݼ�-X') H
ON 
	i.ȸ����ȣ = H.ȸ����ȣ
WHERE
	H.ȸ����ȣ is null
	AND D.ȸ������ = 'Normal'
	AND ((i.��������ó = '����' AND i.���ּ� is not null) OR (i.��������ó = '����' AND i.�����ּ� is not null) )
	AND (D.������ >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) OR (D.�ѳ��ΰǼ� >= 2))