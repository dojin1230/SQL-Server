SELECT
	���԰�� [Channel], Year(������) [Year], Month(������) [Month], COUNT(ȸ����ȣ) [Count]
FROM
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������� D
WHERE
	ȸ������ in ('Freezing', 'canceled')
	AND �ѳ��ΰǼ� = 0
GROUP BY ���԰��, Year(������), Month(������)