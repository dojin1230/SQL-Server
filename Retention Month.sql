SELECT
	ȸ����ȣ, ���ʳ��γ��, �������γ��, ���԰��
FROM
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ�������
WHERE
	���ʳ��γ�� is not null
	AND �������γ�� < '2016-11'
	AND ���ʵ�ϱ���='����'
	AND �ѳ��ΰǼ� >=2
GO

SELECT
	ȸ����ȣ, ���ʳ��γ��, 
	CASE
	WHEN �������γ�� is null THEN '2017-10'
	ELSE �������γ��
	END [�������γ��], ���԰��
FROM
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ�������
WHERE
	���ʳ��γ�� is not null
	AND ���ʵ�ϱ���='����'
	AND �ѳ��ΰǼ� >=2
GO
