SELECT 
	H.ȸ����ȣ, H.��Ϻз���, S.���ι��, H.������, C.������, C.���ΰ��, CM.��û��, CM.ó�����
FROM 
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_������� H
LEFT JOIN
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������� S
ON
	H.ȸ����ȣ = S.ȸ����ȣ
LEFT JOIN
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�ſ�ī��������� C
ON
	H.ȸ����ȣ = C.ȸ����ȣ
LEFT JOIN
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_CMS�������� CM
ON
	H.ȸ����ȣ = CM.ȸ����ȣ
WHERE
	H.��Ϻз�='TM_��������_����_��������'
	--AND H.��Ϻз���='�뼺-�Ŀ�����'
	AND H.����Ͻ� >= CONVERT(varchar(10), '2017-10-11', 126) AND H.����Ͻ� < CONVERT(varchar(10), '2017-10-25', 126) 
ORDER BY 
	������ DESC

