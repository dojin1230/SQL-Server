SELECT 
	sum(���αݾ�)
FROM
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�������� 
WHERE
	ȸ����ȣ IN ('82000154','82032414')
	and ������ >= CONVERT(DATE, '2017-01-01') 
		AND ������ < CONVERT(DATE, '2018-01-01') 
		AND ȯ�һ���=''


select
	sum(���αݾ�)
FROM
	(
	SELECT 
		ȸ����ȣ, ���αݾ�
	FROM
		MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�������� 
	WHERE
		������ >= CONVERT(DATE, '2017-01-01') 
		AND ������ < CONVERT(DATE, '2018-01-01') 
		AND ȯ�һ���=''
	) PR
LEFT JOIN
	(
	select 
		ȸ����ȣ, MIN(������) ù������
	from 
		MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�������� 
	group by ȸ����ȣ
	) DE
ON
	PR.ȸ����ȣ = DE.ȸ����ȣ
WHERE
	DE.ù������ >= CONVERT(DATE, '2017-01-01') 




select 
	sum(���αݾ�)
FROM
	(
	SELECT 
		ȸ����ȣ, ���αݾ�
	FROM
		MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�������� 
	WHERE
		������ >= CONVERT(DATE, '2017-01-01') 
		AND ������ < CONVERT(DATE, '2018-01-01') 
		AND ȯ�һ���=''
	) PR
LEFT JOIN	
	(
	SELECT
		H.ȸ����ȣ, MIN(PR.������) ù������
	FROM
		(
		SELECT
			ȸ����ȣ, ������ AS ������
		FROM
			MRMRT.�׸��ǽ����ƽþƼ���繫��0868.DBO.UV_GP_�������
		WHERE
			��Ϻз�=N'TM_�Ŀ������'
			AND ��Ϻз���=N'�뼺-����۵���'
			AND ������ >= CONVERT(DATE, '2017-01-01') 
			AND ������ < CONVERT(DATE, '2018-01-01') 
		) H
	LEFT JOIN
		MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�������� PR
	ON	
		H.ȸ����ȣ = PR.ȸ����ȣ
	WHERE
		PR.������ >= H.������
	GROUP BY
		H.ȸ����ȣ
	) A
ON
	PR.ȸ����ȣ = A.ȸ����ȣ
WHERE	
	A.ù������ >= CONVERT(DATE, '2017-01-01') 
	AND A.ù������ < CONVERT(DATE, '2018-01-01') 

-------------

select
	ȸ����ȣ, ù������
from
	(
	select 
		ȸ����ȣ, MIN(������) ù������
	from 
		MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�������� 
	group by ȸ����ȣ
	) DE
WHERE
	DE.ù������ >= CONVERT(DATE, '2017-01-01') 
	and DE.ù������ < CONVERT(DATE, '2018-01-01') 



select 
*
from
	(
	SELECT
		H.ȸ����ȣ, MIN(PR.������) ù������
	FROM
		(
		SELECT
			ȸ����ȣ, ������ AS ������
		FROM
			MRMRT.�׸��ǽ����ƽþƼ���繫��0868.DBO.UV_GP_�������
		WHERE
			��Ϻз�=N'TM_�Ŀ������'
			AND ��Ϻз���=N'�뼺-����۵���'
			AND ������ >= CONVERT(DATE, '2017-01-01') 
			AND ������ < CONVERT(DATE, '2018-01-01') 
		) H
	LEFT JOIN
		MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�������� PR
	ON	
		H.ȸ����ȣ = PR.ȸ����ȣ
	WHERE
		PR.������ >= H.������
	GROUP BY
		H.ȸ����ȣ
	) A
WHERE	
	A.ù������ >= CONVERT(DATE, '2017-01-01') 
	AND A.ù������ < CONVERT(DATE, '2018-01-01') 
