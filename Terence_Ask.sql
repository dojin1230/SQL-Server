USE mrm
GO


SELECT 
	COUNT(1)
FROM 
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.DBO.UV_GP_�Ŀ������� S
WHERE
	S.�������γ�� < '2016-10' 	AND 
	S.�ѳ��ΰǼ� >= 1  AND	
	S.�޴���ȭ��ȣ='��' 
GO


SELECT 
	S.ȸ����ȣ, S.�������γ��, S.�ѳ��ΰǼ�, H.��ϱ���2
FROM 
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.DBO.UV_GP_�Ŀ������� S
LEFT JOIN
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_������� H
ON
	S.ȸ����ȣ = H.ȸ����ȣ 
WHERE
	S.�������γ�� < '2016-10' 	AND 
	S.�ѳ��ΰǼ� >= 1 AND 
	S.�޴���ȭ��ȣ='��' AND
	(H.��Ϻз� like 'TM%' AND H.��ϱ���2 like '1%') AND
	H.ȸ����ȣ is null
GROUP BY 
	S.ȸ����ȣ
GO

SELECT 
	*
FROM 
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_������� H
WHERE
	H.��Ϻз� like 'TM%' AND H.��ϱ���2 like '1%'