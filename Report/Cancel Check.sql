use work
GO

ALTER VIEW dbo.cancelCheck
AS 
SELECT 
	YEAR(H.������) AS ��ҳ�, MONTH(H.������) AS ��ҿ�, H.ȸ����ȣ, H.��Ϻз���, H.������, 
	SUBSTRING(H.����,1,1) AS ����1, 
	SUBSTRING(H.����,2,2) AS ����2,
	CASE 
	WHEN S.���԰��=N'�Ÿ�����' THEN 'DDC' 
	WHEN S.���԰��=N'���μҰ�' THEN 'acquaintance'
	WHEN S.���԰��=N'��ν���' THEN 'brochure'
	WHEN S.���԰��=N'��Ÿ' THEN 'ETC'
	WHEN S.���԰��=N'���ͳ�/Ȩ������' THEN 'Web'
	WHEN S.���԰��=N'��ȭ' THEN 'Call'
	ELSE S.���԰�� END AS ���԰��,
	S.������,
	DATEDIFF(month,S.������,GETDATE()) AS �Ŀ��Ⱓ,
	DATEDIFF(year,S.�������,GETDATE()) AS ����,
	S.�ѳ��ΰǼ�,
	CASE
	WHEN H.��Ϻз��� like '%Canceled' THEN 1
	ELSE 0
	END AS ��ҿ���,
	CASE
	WHEN H.��Ϻз��� like 'SS-%' THEN 1
	ELSE 0
	END AS �õ�����,
	CASE
	WHEN H.��Ϻз��� = 'SS-DGamount' THEN P2.�ݾ� 
	ELSE NULL 
	END AS �����ݾ�,
	P1.�ݾ� AS �ֱٱݾ�
FROM
	(
	SELECT
		ȸ����ȣ, ������, ��Ϻз���, ����
	FROM
		MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�������
	WHERE
		��Ϻз�='Cancellation' 
		AND ó���������=N'IH-�Ϸ�'
		--AND ������ >= CONVERT(varchar(10), '2017-10-01', 126) AND ������ < CONVERT(varchar(10), '2017-11-01', 126)
	) H
LEFT JOIN
	MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������� S
ON
	H.ȸ����ȣ = S.ȸ����ȣ
LEFT JOIN
(
	SELECT
		ȸ����ȣ, �ݾ�
	FROM
		MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������ݾ�����		
	WHERE 
		���Ῡ��='N'
) P1
ON
	H.ȸ����ȣ = P1.ȸ����ȣ
LEFT JOIN
(
	SELECT
		ȸ����ȣ, �ݾ�
	FROM
		(
		SELECT
			ȸ����ȣ, RANK() OVER (PARTITION BY ȸ����ȣ ORDER BY ������ DESC, ��û�� DESC) AS �ֱټ���, �ݾ�
		FROM
			MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������ݾ�����
		WHERE 
			���Ῡ��='Y'
		) A
	WHERE �ֱټ��� = 1
) P2
ON
	H.ȸ����ȣ = P2.ȸ����ȣ