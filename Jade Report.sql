SELECT
	*
FROM
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�������
WHERE
	��Ϻз� IN ('TM_Ư���Ͻ��Ŀ�', 'Ư���Ͻ��Ŀ� ��û/����') AND
	������ >= '2017-10-01' AND
	ó��������� IN ('SK-�Ϸ�', 'IH-����') AND
	��Ϻз��� IN ( '�뼺-�Ŀ�����', '��������', '����&��ȭ����','�̸�������','��Ÿ����')
GO

SELECT
	CASE
	WHEN ó���������='IH-����' then ��Ϻз���
	WHEN ���� like 'MPC%' then 'MPC��ȭ����'
	WHEN ���� like 'WV%' then 'WV��ȭ����'
	END AS �������,
	ȸ����ȣ,
	����
FROM
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�������
WHERE
	��Ϻз� IN ('TM_Ư���Ͻ��Ŀ�', 'Ư���Ͻ��Ŀ� ��û/����') AND
	������ >= '2017-10-01' AND
	ó��������� IN ('SK-�Ϸ�', 'IH-����') AND
	��Ϻз��� IN ( '�뼺-�Ŀ�����', '��������', '����&��ȭ����','�̸�������','��Ÿ����')
GO

SELECT
	*
FROM
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�������
		
SELECT
	*
FROM
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�������
WHERE
	��Ϻз�='Ư���Ͻ��Ŀ� ��û/����' AND
	������ >= '2017-10-01' AND
	ó���������='IH-����'
GO


SELECT
	*
FROM
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ�������
WHERE
	���԰��='Lead Conversion' AND
	������ >= '2017-01-01'
GO


SELECT
	COUNT(
	CASE
	WHEN ���� is null then '������'
	ELSE ����
	END) AS ����, 
	CASE 
	WHEN ������ >=  CONVERT(varchar(10), '2017-01-01', 126) AND ������ < CONVERT(varchar(10), '2017-02-01', 126) THEN '1��' 
	WHEN ������ >=  CONVERT(varchar(10), '2017-02-01', 126) AND ������ < CONVERT(varchar(10), '2017-03-01', 126) THEN '2��' 
	WHEN ������ >=  CONVERT(varchar(10), '2017-03-01', 126) AND ������ < CONVERT(varchar(10), '2017-04-01', 126) THEN '3��' 
	WHEN ������ >=  CONVERT(varchar(10), '2017-04-01', 126) AND ������ < CONVERT(varchar(10), '2017-05-01', 126) THEN '4��' 
	WHEN ������ >=  CONVERT(varchar(10), '2017-05-01', 126) AND ������ < CONVERT(varchar(10), '2017-06-01', 126) THEN '5��' 
	WHEN ������ >=  CONVERT(varchar(10), '2017-06-01', 126) AND ������ < CONVERT(varchar(10), '2017-07-01', 126) THEN '6��' 
	WHEN ������ >=  CONVERT(varchar(10), '2017-07-01', 126) AND ������ < CONVERT(varchar(10), '2017-08-01', 126) THEN '7��' 
	WHEN ������ >=  CONVERT(varchar(10), '2017-08-01', 126) AND ������ < CONVERT(varchar(10), '2017-09-01', 126) THEN '8��' 
	WHEN ������ >=  CONVERT(varchar(10), '2017-09-01', 126) AND ������ < CONVERT(varchar(10), '2017-10-01', 126) THEN '9��' 
	WHEN ������ >=  CONVERT(varchar(10), '2017-10-01', 126) THEN '10��' 
	END AS '���Կ�'
FROM
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ�������
WHERE
	������ >= CONVERT(varchar(10), '2017-01-01', 126)
GROUP BY
	���Կ�

SELECT SaleDate,
       Count(DISTINCT CASE
                        WHEN Customer IS NULL THEN CONVERT(VARCHAR(50), CustomerID)
                        ELSE Customer
                      END) AS UniqueCustomers
FROM   Yourtable
GROUP  BY SaleDate 


	
SELECT
	*
FROM
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������� S
WHERE
	������ >= CONVERT(varchar(10), '2017-01-01', 126) AND ������ < CONVERT(varchar(10), '2017-02-01', 126)