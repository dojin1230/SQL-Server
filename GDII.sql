-- Account/Person Level
SELECT
	PR.ȸ����ȣ			AS [Account ID], 
	CASE
	WHEN D.������� is not null THEN Year(D.�������)		
	ELSE ''
	END AS [Year of Birth], 
	CASE 
	WHEN D.����='��' THEN 'F'
	WHEN D.����='��' THEN 'M'
	ELSE 'U'
	END AS [Gender], 
	'' AS [Legacy Status],
	CASE 
	WHEN D.���԰��='�Ÿ�����'			THEN 'F2F'
	WHEN D.���԰��='���ͳ�/Ȩ������'		THEN 'DT'
	WHEN D.���԰��='Lead Conversion'	THEN 'TM'
	ELSE 'Others'
	END AS [Original Recruitment Channel],
	''	AS [Original Recruitment Response Mechanism],
	D.������				AS [Original Recruitment Date],
	CASE 
	WHEN D.�Ҽ� is null OR D.�Ҽ� = 'Inhouse' THEN 'IN'
	ELSE 'AG'
	END AS [Original Recruitment In-House/Agency],
	CASE
	WHEN D.���ʵ�ϱ���='����' THEN 'RP'
	WHEN D.���ʵ�ϱ���='�Ͻ�' THEN 'S'
	END	AS [Original Recruitment Type],
	PRMIN.���ʳ�����		AS [First Payment Date],
	CASE WHEN RG.ȸ����ȣ is not null THEN 'Y' ELSE 'N' END	AS 	[Have Given Regular Gift],
	CASE WHEN SG.ȸ����ȣ is not null THEN 'Y' ELSE 'N' END	AS 	[Have Given Single Gift]
FROM
	(
	SELECT
		ȸ����ȣ
	FROM
		MRMRT.�׸��ǽ����ƽþƼ���繫��0868.DBO.UV_GP_��������
	WHERE
		������ >= CONVERT(DATE, '2017-01-01') AND ������ < CONVERT(DATE, '2018-01-01')
	GROUP BY
		ȸ����ȣ
	) PR
LEFT JOIN
(
	SELECT
		ȸ����ȣ, MIN(������) AS ���ʳ�����
	FROM
		MRMRT.�׸��ǽ����ƽþƼ���繫��0868.DBO.UV_GP_��������
	GROUP BY
		ȸ����ȣ
	) PRMIN
ON
	PR.ȸ����ȣ = PRMIN.ȸ����ȣ
LEFT JOIN
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.DBO.UV_GP_�Ŀ������� D
ON
	PR.ȸ����ȣ = D.ȸ����ȣ
LEFT JOIN
	(
	SELECT
		ȸ����ȣ
	FROM
		MRMRT.�׸��ǽ����ƽþƼ���繫��0868.DBO.UV_GP_��������
	WHERE
		������ >= CONVERT(DATE, '2017-01-01') AND ������ < CONVERT(DATE, '2018-01-01')
		AND �������='����'
	GROUP BY
		ȸ����ȣ
	) RG
ON
	PR.ȸ����ȣ = RG.ȸ����ȣ
LEFT JOIN
	(
	SELECT
		ȸ����ȣ
	FROM
		MRMRT.�׸��ǽ����ƽþƼ���繫��0868.DBO.UV_GP_��������
	WHERE
		������ >= CONVERT(DATE, '2017-01-01') AND ������ < CONVERT(DATE, '2018-01-01')
		AND �������='����'
	GROUP BY
		ȸ����ȣ
	) SG
ON
	PR.ȸ����ȣ = SG.ȸ����ȣ
ORDER BY
	1

-- Gift Level
SELECT
	PR.�Ϸù�ȣ AS [Gift ID],
	PR.ȸ����ȣ AS [Account ID],
	PR.������ AS [Gift Date],
	PR.���αݾ� AS [Gift Amount],
	CASE 
	WHEN D.���԰��='�Ÿ�����'			THEN 'F2F'
	WHEN D.���԰��='���ͳ�/Ȩ������'		THEN 'DT'
	WHEN D.���԰��='Lead Conversion'	THEN 'TM'
	ELSE 'Others'
	END AS [Source Channel],
	'' AS [Gift Response Mechanism],
	CASE 
	WHEN PR.������� = '����' THEN 'RP'
	WHEN PR.������� = '����' THEN 'S'
	END AS [Gift Type],
	CASE WHEN PR.������� = '����' THEN 'M' 
	ELSE '' END AS [Frequency],
	CASE 
	WHEN D.�Ҽ� is null OR D.�Ҽ� = 'Inhouse' THEN 'IN'
	ELSE 'AG'
	END AS [Inhouse / Agency],
	CASE
	WHEN PR.���ι�� = '�ſ�ī��'			THEN 'CC'
	WHEN PR.���ι�� = '������ü'			THEN 'BT'
	WHEN PR.���ι�� = 'CMS'				THEN 'DD'
	WHEN PR.���ι�� = 'GP���������Ա�'	THEN 'BT'
	WHEN PR.���ι�� = '���ݳ���'			THEN 'CS'
	END AS [Payment Method],
	'N' AS [Emergency],
	'N' AS [Child Sponsorship],
	'N' AS [Legacy],
	'N' AS [Restricted],
	'N' AS [Symbolic Gift],
	'N' AS [Event Sponsorship],
	'' AS [Source Code],
	CASE WHEN PR.ȯ�һ��� = '' THEN 'Y'
	ELSE 'N' 
	END AS [Gift Status]
FROM
	(
	SELECT
		*
	FROM
		MRMRT.�׸��ǽ����ƽþƼ���繫��0868.DBO.UV_GP_��������
	WHERE
		������ >= CONVERT(DATE, '2017-01-01') AND ������ < CONVERT(DATE, '2018-01-01') 
	) PR
LEFT JOIN
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.DBO.UV_GP_�Ŀ������� D
ON
	PR.ȸ����ȣ = D.ȸ����ȣ

--Regular Giving Pledge
SELECT
	PR.�Ϸù�ȣ	AS [Regular Giving Pledge ID],
	PR.ȸ����ȣ	AS [Account ID],
	PR.������	AS [Regular Giving Pledge Date],
	PR.���αݾ�	AS [Regular Giving Pledge Gift Amount],
	CASE 
	WHEN D.���԰��='�Ÿ�����'			THEN 'F2F'
	WHEN D.���԰��='���ͳ�/Ȩ������'		THEN 'DT'
	WHEN D.���԰��='Lead Conversion'	THEN 'TM'
	ELSE 'Others'
	END AS [Regular Giving Pledge Source Channel],
	'' AS [Regular Giving Pledge Response Mechanism],
	'M' AS [Regular Giving Pledge Frequency],
	CASE
	WHEN PR.���ι�� = '�ſ�ī��'			THEN 'CC'
	WHEN PR.���ι�� = '������ü'			THEN 'BT'
	WHEN PR.���ι�� = 'CMS'				THEN 'DD'
	WHEN PR.���ι�� = 'GP���������Ա�'	THEN 'BT'
	WHEN PR.���ι�� = '���ݳ���'			THEN 'CS'
	END AS [Regular Giving Pledge Payment Method],
	CASE 
	WHEN D.�Ҽ� is null OR D.�Ҽ� = 'Inhouse' THEN 'IN'
	ELSE 'AG'
	END AS [Regular Giving Pledge In-House/Agency],
	'N' AS [Regular Giving Pledge Child Sponsorship],
	'' AS [Regular Giving Pledge Source Code]
FROM
	(
	SELECT
		*
	FROM
		MRMRT.�׸��ǽ����ƽþƼ���繫��0868.DBO.UV_GP_��������
	WHERE
		������ >= CONVERT(DATE, '2017-01-01') AND ������ < CONVERT(DATE, '2018-01-01') 
		AND �������='����'
	) PR
LEFT JOIN
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.DBO.UV_GP_�Ŀ������� D
ON
	PR.ȸ����ȣ = D.ȸ����ȣ



