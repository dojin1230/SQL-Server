use work
GO

SELECT
	H.ȸ����ȣ,
	CASE 
	WHEN H.��Ϻз��� = '�뼺-�������(����)' THEN 'Cancellation-canceled' 
	ELSE 'Freezing - CC/CMS problems' 
	END AS [��Ϻз�/�󼼺з�],
	CONVERT(date,GETDATE()) AS ����, 
	'IH-�Ϸ�' AS ����1,
	CASE 
	WHEN H.��Ϻз��� = '�뼺-�������(����)' THEN 'T' 
	ELSE 'F' 
	END AS ����,	
	CONVERT(DATE,GETDATE(),126) AS ������
FROM
	(
	SELECT
		*
	FROM
		MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_������� 
	WHERE
		��Ϻз� = 'TM_��������_����_��������'
		AND CONVERT(DATE, ����Ͻ�) >= CONVERT(DATE,GETDATE()-25) 
	) H
LEFT JOIN
	(
	SELECT 
		*
    FROM 
		MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�������
    WHERE 
		��Ϻз� = 'cancellation'
        AND CONVERT(DATE,����Ͻ�) >= CONVERT(DATE,GETDATE()-25)
	) C
ON
	H.ȸ����ȣ = C.ȸ����ȣ
LEFT JOIN
	(
	SELECT 
		ȸ����ȣ
	FROM 
		MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�ſ�ī���������
    WHERE 
		�����Ͻ� >= '2018-03-26 17:05'									---- �ſ�ī�� > ���ⳳ����Ȳ > ���ν�û�Ͻð� ������ ��
	UNION ALL
	SELECT 
		ȸ����ȣ
	FROM 
		MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_CMS��������
    WHERE 
		��û�� >= '2018-03-26'											----- ��¥�� ���ν�û�Ͻð����� ������ ��								
		AND ó����� != '���ν���'
	) CR
ON	
	H.ȸ����ȣ = CR.ȸ����ȣ
LEFT JOIN
	(
	SELECT 
		*
	FROM
		MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_��������
	WHERE
		�ͼӳ�� = SUBSTRING(CONVERT(varchar(10), DATEADD(mm, DATEDIFF(mm, 0, GETDATE())-1, 0), 126), 1, 7)
	) PL
ON
	H.ȸ����ȣ = PL.ȸ����ȣ 
WHERE
	C.ȸ����ȣ is null									-- ĵ�� ��� �ɰ��� �ִ� ��� ����
	AND CR.ȸ����ȣ is null								-- ������ ���� ���Ŀ� CMS�� CARD ���ε� ��� ����
	AND PL.ȸ����ȣ is null								-- 3���� ������ ��� ����
	AND H.��Ϻз��� not in ('����', '�뼺-���浿��')	-- ���ܳ� ���浿�� ����
ORDER BY
	2