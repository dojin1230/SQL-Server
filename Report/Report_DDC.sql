use report
GO

ALTER VIEW vw_DDC
AS
SELECT
	ȸ����ȣ, ������, JoinYear, JoinMonth, 
	CASE 
	WHEN ���ι�� is null THEN 'Unknown'
	WHEN ���ι�� = '�ſ�ī��' THEN 'Card'
	ELSE ���ι��
	END AS PaymentMethod, 
	����, 
	CASE 
	WHEN Age < 26 THEN 'Under 25'
	WHEN Age >=26 AND Age < 31 THEN '26-30'
	WHEN Age >=31 AND Age < 35 THEN '31-35'
	WHEN Age >=35 AND Age < 41 THEN '36-40'
	WHEN Age >=41 THEN 'Over 41'
	ELSE 'Unknown'
	END AS Agegroup,
	Source
FROM
(
	SELECT
		ȸ����ȣ, ������, 
		Year(������) AS JoinYear,
		Month(������) AS JoinMonth,
		���ι��, 
		����, 
		CASE
		WHEN LEN([dbo].[FN_SPLIT](DDF��,';',2))=6 AND �Ҽ� = 'Inhouse' THEN DATEDIFF(year,[dbo].[FN_SPLIT](DDF��,';',2), GETDATE())
		ELSE ���� 
		END AS Age,
		CASE
		WHEN �Ҽ� != 'Inhouse' THEN 'Outsourcing'
		ELSE �Ҽ�
		END AS Source
		--[dbo].[FN_SPLIT](DDF��,';',2) AS �������-- DDM��ȣ, DDM��, DDF��ȣ, DDF��, DD��ҹ�ȣ, DD���
	FROM
		MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������� 
	WHERE
		���԰��='�Ÿ�����'
) D
