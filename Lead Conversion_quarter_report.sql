USE work
GO

SELECT
	D.���ʵ�ϱ���, count(D.ȸ����ȣ)
FROM
	(
	SELECT 
		ȸ����ȣ, MIN(������) ���ʳ�����
	FROM 
		MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_��������
	WHERE
		ȯ�һ��� != '��üȯ��'
	GROUP BY
		ȸ����ȣ
	) PR
LEFT JOIN
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������� D
ON
	PR.ȸ����ȣ = D.ȸ����ȣ
WHERE
	PR.���ʳ����� >= convert(date, '2017-01-01', 126)
	and PR.���ʳ����� < convert(date, '2018-01-01', 126)
	and (DATEDIFF(YY, D.�������, GETDATE()) > 25 or (D.���԰�� = '�Ÿ�����' and D.�Ҽ� = 'Inhouse' and dbo.FN_SPLIT(D.DDF��,';',2) < 930125) )
group by
	D.���ʵ�ϱ���
