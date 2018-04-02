--ALTER VIEW [vw_digital_monitor]
--AS
SELECT
	D.ȸ����ȣ, D.���ι��, D.����, D.������, Year(D.������) AS JoinYear, Month(D.������) AS JoinMonth, 1 AS DonorCount, NULL AS BudgetCount, DATEPART(week, D.������) AS weeknum, 
	CASE 
	WHEN D.���԰��='���ͳ�/Ȩ������' THEN 'Web'
	ELSE D.���԰��
	END AS ���԰��, I.���԰�λ�, D.���ʵ�ϱ���, 
	CASE
	WHEN PL.ȸ����ȣ is not null THEN PL.�ݾ�
	WHEN PL.ȸ����ȣ is null AND D.���ʵ�ϱ��� = '����' THEN D.���αݾ� 
	WHEN PL.ȸ����ȣ is null AND D.���ʵ�ϱ��� = '�Ͻ�' THEN D.�ѳ��αݾ� 
	END
	AS IncomeAmount, NULL AS BudgetAmount
FROM
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������� D
LEFT JOIN
	[work].[dbo].[db0_clnt_i] I	
ON
	D.ȸ����ȣ = I.ȸ����ȣ
LEFT JOIN
	(
	SELECT
		*
	FROM
		ȸ����ȣ, �ݾ�
		(
		SELECT
			ȸ����ȣ, ��û��, RANK() OVER (PARTITION BY ȸ����ȣ ORDER BY ��û�� ASC) AS ��û����, �ݾ�
		FROM
			MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������ݾ����� 
		) A
	WHERE
		A.��û���� =1
	) PL
ON
	D.ȸ����ȣ = PL.ȸ����ȣ
WHERE
	D.���԰�� in ('���ͳ�/Ȩ������', 'Lead Conversion')
UNION ALL
SELECT
	NULL, NULL, NULL, B.JoinDate, Year(B.JoinDate) AS JoinYear, Month(B.JoinDate) AS JoinMonth, NULL, B.DonorCount, DATEPART(week, B.JoinDate) AS weeknum, B.���԰��, NULL, B.���ʵ�ϱ���, NULL, B.Amount AS BudgetAmount
FROM
	[report].[dbo].[web_lc_budget] B
