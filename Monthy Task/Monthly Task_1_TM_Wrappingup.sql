--- TM_�Ŀ��簳_�������� 
SELECT
	H.ȸ����ȣ, H.ó���������, H.������, D.���ι��,
	CASE 
	WHEN D.���ι�� ='�ſ�ī��' THEN C.CARD���� 
	WHEN D.���ι�� ='CMS' THEN CM.ó����� 
	END AS ���λ���, 
	CASE 
	WHEN D.���ι�� ='�ſ�ī��' THEN C.������ 
	WHEN D.���ι�� ='CMS' THEN CM.��û��
	END AS ���ν�û��
FROM
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_������� H
LEFT JOIN
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�ſ�ī��������� C
ON
	H.ȸ����ȣ = C.ȸ����ȣ
LEFT JOIN
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_CMS�������� CM
ON
	H.ȸ����ȣ = CM.ȸ����ȣ
LEFT JOIN
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������� D 
ON
	H.ȸ����ȣ = D.ȸ����ȣ 
WHERE
	H.��Ϻз�='TM_�Ŀ��簳_��������'
	AND H.��Ϻз���='�뼺-�簳����'
	AND H.����Ͻ� >= CONVERT(varchar(10), DATEADD(day, -36, GETDATE()), 126)

-- TM_�ſ�ī�����Ό�� 
SELECT
	H.ȸ����ȣ, H.ó���������, H.������, C.CARD����, C.������
FROM
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_������� H
LEFT JOIN
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�ſ�ī��������� C
ON
	H.ȸ����ȣ = C.ȸ����ȣ
WHERE
	H.��Ϻз�='TM_�ſ�ī�����Ό��'
	AND H.��Ϻз���='�뼺-���浿��'
	AND H.����Ͻ� >= CONVERT(varchar(10), DATEADD(day, -36, GETDATE()), 126)



	