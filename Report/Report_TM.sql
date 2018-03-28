USE report
go

-- TM report
ALTER VIEW [dbo].[vw_telemarketing]
AS
SELECT
	H.ȸ����ȣ AS [DonorID], 
	Year(H.������) AS [ProgramYear], 
	Month(H.������) AS [ProgramMonth], 
	H.������,
	CASE
	WHEN H.��Ϻз� = 'TM_����'				THEN 'Welcome'
	WHEN H.��Ϻз� = 'TM_����3����'			THEN 'Welcome 3M'
	WHEN H.��Ϻз� = 'TM_����6����'			THEN 'Welcome 6M'
	WHEN H.��Ϻз� like 'TM_��������_%'		THEN 'Debit Fail'
	WHEN H.��Ϻз� = 'TM_�Ŀ�����'			THEN 'New Donor Upgrade'
	WHEN H.��Ϻз� = 'TM_�Ŀ�����_����'		THEN 'Annual Upgrade'
	WHEN H.��Ϻз� like 'TM_�Ŀ��簳_%'		THEN 'Unfreeze'
	WHEN H.��Ϻз� = 'TM_�Ŀ������'			THEN 'Monthly Reactivation'
	WHEN H.��Ϻз� = 'TM_�Ŀ������_����'	THEN 'Annual Reactivation'
	WHEN H.��Ϻз� = 'TM_�ſ�ī�����Ό��'	THEN 'Card Expiry'
	WHEN H.��Ϻз� = 'TM_Ư���Ͻ��Ŀ�'		THEN 'Special Appeal'
	WHEN H.��Ϻз� = 'TM_CMS����'			THEN 'CMS Proof'
	END AS Category,
	CASE
	WHEN H.ó��������� like 'IH%' THEN 'Inhouse'
	WHEN H.ó��������� like 'SK%' AND ���� like '%WV%'	THEN 'WV'
	WHEN H.ó��������� like 'SK%' AND ���� like '%MPC%'	THEN 'MPC'
	WHEN H.ó��������� like 'SK%' AND ���� like '%����%'	THEN 'Sale'
	END AS Telemarketer,
	CASE WHEN H.��Ϻз��� ='����' THEN 1 ELSE 0 END	AS OptedOut,
	CASE WHEN H.��Ϻз��� ='���' THEN 1 ELSE 0 END	AS Unknown,
	CASE 
	WHEN H.��Ϻз��� in ('����','���') THEN null 
	WHEN H.��Ϻз��� != '����' AND H.��Ϻз��� != '�뼺-����X' AND H.��Ϻз��� != '����' AND H.��Ϻз��� != '���' THEN 1 		
	ELSE 0 END	AS Reached,
	CASE
	WHEN H.��Ϻз��� in ('����','����','���', '�뼺-����X') THEN NULL --OR H.ó��������� like '%����' OR H.ó��������� like '%����' THEN null 
	WHEN H.��Ϻз��� like '%����' THEN 1 	    
	WHEN H.��Ϻз��� like '%����' THEN 1 	    
	ELSE 0 END	AS Accepted,
	CASE 
	WHEN H.��Ϻз��� not like '%����' AND H.��Ϻз��� not like '%����' THEN NULL
	WHEN PR.ȸ����ȣ is not null THEN 1
	WHEN PR.ȸ����ȣ is not null THEN 1	
	ELSE 0 END AS Honored,
	H.��Ϻз�,
	H.��Ϻз���
FROM
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.DBO.UV_GP_������� H
LEFT JOIN
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.DBO.UV_GP_�Ŀ������� D
ON
	H.ȸ����ȣ = D.ȸ����ȣ
LEFT JOIN
	(
	SELECT
		*
	FROM
		MRMRT.�׸��ǽ����ƽþƼ���繫��0868.DBO.UV_GP_�������� 
	WHERE
		ȯ�һ���=''
	) PR
ON
	H.ȸ����ȣ = PR.ȸ����ȣ AND Month(H.������) = Month(PR.������) AND PR.������ >= H.������
WHERE
	H.��Ϻз� like 'TM%' 
	AND H.ó��������� like '%�Ϸ�'
	AND CONVERT(DATE,H.������,126) >= CONVERT(DATE, '2018-01-01', 126)
GROUP BY
	H.ȸ����ȣ, PR.ȸ����ȣ, 
	H.��Ϻз�, H.��Ϻз���, H.ó���������, H.������, H.����, D.CMS����, D.CARD����
