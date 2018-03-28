USE REPORT
GO
-- ���� ������ ��� �ޱ�
--

select * from
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.DBO.UV_GP_�Ŀ������� D

SELECT -- Non-Reactivation
	D.ȸ����ȣ AS [Constituent_id], 
	D.������ AS [Join Date],
	Year(D.������) AS [Year],
	Month(D.������) AS [Month],
	CASE 
	WHEN D.���԰�� = N'�Ÿ�����' THEN 'DDC'
	WHEN D.���԰�� = N'���ͳ�/Ȩ������' THEN 'Web'
	WHEN D.���԰�� = N'Lead Conversion' THEN D.���԰��
	ELSE 'Other'
	END AS [Source],
	CASE 
	WHEN D.�Ҽ� is null OR D.�Ҽ� ='Inhouse' THEN 'Inhouse'
	ELSE 'OutSourcing'
	END AS [SubSource],
	CASE WHEN EOMONTH(D.������,3) >= PRMIN.���ʳ����� THEN 0 ELSE 1 END AS [Predebit],
	SUM	(CASE WHEN SUBSTRING(D.������,1,7) = PR.�ͼӳ�� THEN 1 ELSE 0 END) AS [1],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, D.������)+1, 0), 126) = PR.�ͼӳ�� THEN 1 
	WHEN DATEADD(mm, DATEDIFF(mm, 0, D.������)+1, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [2],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, D.������)+2, 0), 126) = PR.�ͼӳ�� THEN 1 
	WHEN DATEADD(mm, DATEDIFF(mm, 0, D.������)+2, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [3],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, D.������)+3, 0), 126) = PR.�ͼӳ�� THEN 1
	WHEN DATEADD(mm, DATEDIFF(mm, 0, D.������)+3, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [4],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, D.������)+4, 0), 126) = PR.�ͼӳ�� THEN 1
	WHEN DATEADD(mm, DATEDIFF(mm, 0, D.������)+4, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [5],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, D.������)+5, 0), 126) = PR.�ͼӳ�� THEN 1
	WHEN DATEADD(mm, DATEDIFF(mm, 0, D.������)+5, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [6],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, D.������)+6, 0), 126) = PR.�ͼӳ�� THEN 1
	WHEN DATEADD(mm, DATEDIFF(mm, 0, D.������)+6, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [7],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, D.������)+7, 0), 126) = PR.�ͼӳ�� THEN 1
	WHEN DATEADD(mm, DATEDIFF(mm, 0, D.������)+7, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [8],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, D.������)+8, 0), 126) = PR.�ͼӳ�� THEN 1
	WHEN DATEADD(mm, DATEDIFF(mm, 0, D.������)+8, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [9],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, D.������)+9, 0), 126) = PR.�ͼӳ�� THEN 1
	WHEN DATEADD(mm, DATEDIFF(mm, 0, D.������)+9, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [10],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, D.������)+10, 0), 126) = PR.�ͼӳ�� THEN 1
	WHEN DATEADD(mm, DATEDIFF(mm, 0, D.������)+10, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [11],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, D.������)+11, 0), 126) = PR.�ͼӳ�� THEN 1
	WHEN DATEADD(mm, DATEDIFF(mm, 0, D.������)+11, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [12],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, D.������)+12, 0), 126) = PR.�ͼӳ�� THEN 1
	WHEN DATEADD(mm, DATEDIFF(mm, 0, D.������)+12, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [13],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, D.������)+13, 0), 126) = PR.�ͼӳ�� THEN 1
	WHEN DATEADD(mm, DATEDIFF(mm, 0, D.������)+13, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [14],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, D.������)+14, 0), 126) = PR.�ͼӳ�� THEN 1
	WHEN DATEADD(mm, DATEDIFF(mm, 0, D.������)+14, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [15],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, D.������)+15, 0), 126) = PR.�ͼӳ�� THEN 1
	WHEN DATEADD(mm, DATEDIFF(mm, 0, D.������)+15, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [16],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, D.������)+16, 0), 126) = PR.�ͼӳ�� THEN 1
	WHEN DATEADD(mm, DATEDIFF(mm, 0, D.������)+16, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [17],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, D.������)+17, 0), 126) = PR.�ͼӳ�� THEN 1
	WHEN DATEADD(mm, DATEDIFF(mm, 0, D.������)+17, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [18],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, D.������)+18, 0), 126) = PR.�ͼӳ�� THEN 1
	WHEN DATEADD(mm, DATEDIFF(mm, 0, D.������)+18, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [19],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, D.������)+19, 0), 126) = PR.�ͼӳ�� THEN 1
	WHEN DATEADD(mm, DATEDIFF(mm, 0, D.������)+19, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [20],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, D.������)+20, 0), 126) = PR.�ͼӳ�� THEN 1
	WHEN DATEADD(mm, DATEDIFF(mm, 0, D.������)+20, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [21],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, D.������)+21, 0), 126) = PR.�ͼӳ�� THEN 1
	WHEN DATEADD(mm, DATEDIFF(mm, 0, D.������)+21, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [22],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, D.������)+22, 0), 126) = PR.�ͼӳ�� THEN 1
	WHEN DATEADD(mm, DATEDIFF(mm, 0, D.������)+22, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [23],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, D.������)+23, 0), 126) = PR.�ͼӳ�� THEN 1
	WHEN DATEADD(mm, DATEDIFF(mm, 0, D.������)+23, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [24],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, D.������)+35, 0), 126) = PR.�ͼӳ�� THEN 1
	WHEN DATEADD(mm, DATEDIFF(mm, 0, D.������)+35, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [36],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, D.������)+47, 0), 126) = PR.�ͼӳ�� THEN 1
	WHEN DATEADD(mm, DATEDIFF(mm, 0, D.������)+47, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [48]
INTO
	[report].[dbo].[success_rate]
FROM
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.DBO.UV_GP_�Ŀ������� D
LEFT JOIN
	(
	SELECT
		ȸ����ȣ, �ͼӳ��
	FROM
		MRMRT.�׸��ǽ����ƽþƼ���繫��0868.DBO.UV_GP_�������� 
	WHERE
		������� = N'����' AND ȯ�һ��� != N'��üȯ��'
	GROUP BY
		ȸ����ȣ, �ͼӳ��
	) PR	
ON
	D.ȸ����ȣ = PR.ȸ����ȣ
LEFT JOIN
	(
	SELECT
		ȸ����ȣ, MIN(������) AS ���ʳ�����
	FROM
		MRMRT.�׸��ǽ����ƽþƼ���繫��0868.DBO.UV_GP_�������� 
	WHERE
		������� = N'����' AND ȯ�һ��� != N'��üȯ��'
	GROUP BY
		ȸ����ȣ
	) PRMIN	
ON
	D.ȸ����ȣ = PRMIN.ȸ����ȣ
WHERE
	D.���ʵ�ϱ��� = N'����'
	AND D.������ < DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0)
GROUP BY
	D.ȸ����ȣ, D.���԰��, D.������, D.���ʳ��γ��, D.�Ҽ�, PRMIN.���ʳ�����
UNION ALL		
SELECT -- Reactivation
	H.ȸ����ȣ AS [Constituent_id], 
	H.������ AS [Join Date],
	Year(H.������) AS [Year],
	Month(H.������) AS [Month],
	'Reactivation' AS [Source],
	'Inhouse' AS [SubSource],
	CASE WHEN EOMONTH(H.������,3) >= PRMIN.���ʳ����� THEN 0 ELSE 1 END AS [Predebit],
	SUM	(CASE WHEN SUBSTRING(H.������,1,7) = PRPAY.�ͼӳ�� THEN 1 ELSE 0 END) AS [1],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, H.������)+1, 0), 126) = PRPAY.�ͼӳ�� THEN 1 
	WHEN DATEADD(mm, DATEDIFF(mm, 0, H.������)+1, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [2],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, H.������)+2, 0), 126) = PRPAY.�ͼӳ�� THEN 1 
	WHEN DATEADD(mm, DATEDIFF(mm, 0, H.������)+2, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [3],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, H.������)+3, 0), 126) = PRPAY.�ͼӳ�� THEN 1
	WHEN DATEADD(mm, DATEDIFF(mm, 0, H.������)+3, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [4],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, H.������)+4, 0), 126) = PRPAY.�ͼӳ�� THEN 1
	WHEN DATEADD(mm, DATEDIFF(mm, 0, H.������)+4, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [5],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, H.������)+5, 0), 126) = PRPAY.�ͼӳ�� THEN 1
	WHEN DATEADD(mm, DATEDIFF(mm, 0, H.������)+5, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [6],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, H.������)+6, 0), 126) = PRPAY.�ͼӳ�� THEN 1
	WHEN DATEADD(mm, DATEDIFF(mm, 0, H.������)+6, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [7],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, H.������)+7, 0), 126) = PRPAY.�ͼӳ�� THEN 1
	WHEN DATEADD(mm, DATEDIFF(mm, 0, H.������)+7, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [8],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, H.������)+8, 0), 126) = PRPAY.�ͼӳ�� THEN 1
	WHEN DATEADD(mm, DATEDIFF(mm, 0, H.������)+8, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [9],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, H.������)+9, 0), 126) = PRPAY.�ͼӳ�� THEN 1
	WHEN DATEADD(mm, DATEDIFF(mm, 0, H.������)+9, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [10],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, H.������)+10, 0), 126) = PRPAY.�ͼӳ�� THEN 1
	WHEN DATEADD(mm, DATEDIFF(mm, 0, H.������)+10, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [11],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, H.������)+11, 0), 126) = PRPAY.�ͼӳ�� THEN 1
	WHEN DATEADD(mm, DATEDIFF(mm, 0, H.������)+11, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [12],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, H.������)+12, 0), 126) = PRPAY.�ͼӳ�� THEN 1
	WHEN DATEADD(mm, DATEDIFF(mm, 0, H.������)+12, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [13],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, H.������)+13, 0), 126) = PRPAY.�ͼӳ�� THEN 1
	WHEN DATEADD(mm, DATEDIFF(mm, 0, H.������)+13, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [14],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, H.������)+14, 0), 126) = PRPAY.�ͼӳ�� THEN 1
	WHEN DATEADD(mm, DATEDIFF(mm, 0, H.������)+14, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [15],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, H.������)+15, 0), 126) = PRPAY.�ͼӳ�� THEN 1
	WHEN DATEADD(mm, DATEDIFF(mm, 0, H.������)+15, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [16],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, H.������)+16, 0), 126) = PRPAY.�ͼӳ�� THEN 1
	WHEN DATEADD(mm, DATEDIFF(mm, 0, H.������)+16, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [17],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, H.������)+17, 0), 126) = PRPAY.�ͼӳ�� THEN 1
	WHEN DATEADD(mm, DATEDIFF(mm, 0, H.������)+17, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [18],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, H.������)+18, 0), 126) = PRPAY.�ͼӳ�� THEN 1
	WHEN DATEADD(mm, DATEDIFF(mm, 0, H.������)+18, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [19],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, H.������)+19, 0), 126) = PRPAY.�ͼӳ�� THEN 1
	WHEN DATEADD(mm, DATEDIFF(mm, 0, H.������)+19, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [20],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, H.������)+20, 0), 126) = PRPAY.�ͼӳ�� THEN 1
	WHEN DATEADD(mm, DATEDIFF(mm, 0, H.������)+20, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [21],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, H.������)+21, 0), 126) = PRPAY.�ͼӳ�� THEN 1
	WHEN DATEADD(mm, DATEDIFF(mm, 0, H.������)+21, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [22],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, H.������)+22, 0), 126) = PRPAY.�ͼӳ�� THEN 1
	WHEN DATEADD(mm, DATEDIFF(mm, 0, H.������)+22, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [23],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, H.������)+23, 0), 126) = PRPAY.�ͼӳ�� THEN 1
	WHEN DATEADD(mm, DATEDIFF(mm, 0, H.������)+23, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [24],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, H.������)+35, 0), 126) = PRPAY.�ͼӳ�� THEN 1
	WHEN DATEADD(mm, DATEDIFF(mm, 0, H.������)+35, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [36],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, H.������)+47, 0), 126) = PRPAY.�ͼӳ�� THEN 1
	WHEN DATEADD(mm, DATEDIFF(mm, 0, H.������)+47, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [48]
FROM
	(
	SELECT
		ȸ����ȣ, MAX(������) AS ������
	FROM
		MRMRT.�׸��ǽ����ƽþƼ���繫��0868.DBO.UV_GP_�������
	WHERE
		��Ϻз� like N'TM_�Ŀ������%' AND ��Ϻз���=N'�뼺-����۵���'
	GROUP BY
		ȸ����ȣ
	) H
LEFT JOIN
	(
	SELECT
		A.ȸ����ȣ, MIN(PR.������) ���ʳ�����
	FROM
		(
		SELECT
			ȸ����ȣ, MAX(������) AS ������
		FROM
			MRMRT.�׸��ǽ����ƽþƼ���繫��0868.DBO.UV_GP_�������
		WHERE
			��Ϻз� like N'TM_�Ŀ������%' AND ��Ϻз���=N'�뼺-����۵���'
		GROUP BY
			ȸ����ȣ
		) A
	LEFT JOIN
		(
		SELECT
			ȸ����ȣ, ������
		FROM
			MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�������� 
		WHERE
			������� = N'����' AND ȯ�һ��� != N'��üȯ��'
		) PR
	ON	
		A.ȸ����ȣ = PR.ȸ����ȣ
	WHERE
		PR.������ >= A.������
	GROUP BY
		A.ȸ����ȣ
	) PRMIN
ON
	H.ȸ����ȣ = PRMIN.ȸ����ȣ
LEFT JOIN
	(
	SELECT
		B.ȸ����ȣ, PR.�ͼӳ��
	FROM
		(
		SELECT
			ȸ����ȣ, MAX(������) AS ������
		FROM
			MRMRT.�׸��ǽ����ƽþƼ���繫��0868.DBO.UV_GP_�������
		WHERE
			��Ϻз� like N'TM_�Ŀ������%' AND ��Ϻз���=N'�뼺-����۵���'
		GROUP BY
			ȸ����ȣ
		) B
	LEFT JOIN
		(
		SELECT
			ȸ����ȣ, �ͼӳ��
		FROM
			MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�������� 
		WHERE
			������� = N'����' AND ȯ�һ��� != N'��üȯ��'		
		) PR
	ON	
		B.ȸ����ȣ = PR.ȸ����ȣ
	WHERE
		CONCAT(PR.�ͼӳ��,'-01') >= CONVERT(varchar(10), DATEADD(mm, DATEDIFF(mm, 0, B.������), 0), 126)
	GROUP BY
		B.ȸ����ȣ, PR.�ͼӳ��
	) PRPAY
ON
	H.ȸ����ȣ = PRPAY.ȸ����ȣ
WHERE
	H.������ < DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0)
GROUP BY
	H.ȸ����ȣ, H.������, PRMIN.���ʳ�����