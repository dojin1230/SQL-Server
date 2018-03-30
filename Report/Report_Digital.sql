ALTER VIEW [vw_digital_monitor]
AS
SELECT
	D.ȸ����ȣ, D.���ι��, D.����, D.������, Year(D.������) AS JoinYear, Month(D.������) AS JoinMonth, 1 AS DonorCount, NULL AS BudgetCount, DATEPART(week, D.������) AS weeknum, 
	CASE 
	WHEN D.���԰��='���ͳ�/Ȩ������' THEN 'Web'
	ELSE D.���԰��
	END AS ���԰��, I.���԰�λ�, D.���ʵ�ϱ���, 
	CASE
	WHEN D.���ʵ�ϱ��� ='����' THEN D.���αݾ� 
	WHEN D.���ʵ�ϱ��� = '�Ͻ�' THEN D.�ѳ��αݾ� 
	END
	AS IncomeAmount, NULL AS BudgetAmount
FROM
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������� D
LEFT JOIN
	[work].[dbo].[db0_clnt_i] I	
ON
	D.ȸ����ȣ = I.ȸ����ȣ
WHERE
	D.���԰�� in ('���ͳ�/Ȩ������', 'Lead Conversion')
UNION ALL
SELECT
	NULL, NULL, NULL, B.JoinDate, Year(B.JoinDate) AS JoinYear, Month(B.JoinDate) AS JoinMonth, NULL, B.DonorCount, DATEPART(week, B.JoinDate) AS weeknum, B.���԰��, NULL, B.���ʵ�ϱ���, NULL, B.Amount AS BudgetAmount
FROM
	[report].[dbo].[web_lc_budget] B



select * from  [vw_digital_monitor] where ������='2018-03-29'

