

-- IH ����� ó�� --

--IH-����� ����
--1. ��Ϻз���: SS-canceled / Canceled -> ĵ�� ó�� Ȯ��
--2. ��Ϻз���: SS-DGamount -> ���� Ȯ��
--3. ��Ϻз���: SS-tempstop -> �Ͻ����� Ȯ��
--4. ����: Iī�庯�� -> ����Ȯ��
--5. ����: I���º��� -> ����Ȯ��
--6. ����: I�ݾ׺��� -> ����Ȯ��
--7. ��Ϻз���: �ڹ�_Unfreezeing -> ��� �� �������� ����Ȯ��
--8. ��Ϻз���: �Ŀ��ݾ�downgrade -> ���� Ȯ��
--9. ��Ϻз���: �Ŀ��ݾ�upgrade -> ���� Ȯ��

/*
����/����/�ݾ׺��濡�� �Ͻ��Ŀ��ݾ��� �����ϴ� ������� ���۳��=�������� �׸���� ���� ����ϴµ� ���� ��Ȯ�� ��� ���� �ʿ�
*/

--1. ��Ϻз���: SS-canceled / Canceled -> ĵ�� ó�� Ȯ��

SELECT H.*, D.ȸ������
FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_������� H
LEFT JOIN
(SELECT ȸ����ȣ, ȸ������
FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ�������
WHERE ȸ������ = 'canceled') D
ON H.ȸ����ȣ = D.ȸ����ȣ
WHERE 
��Ϻз��� IN ('SS-Canceled', 'Canceled')
AND CONVERT(DATE,������) >= CONVERT(DATE,GETDATE() - 5)
AND D.ȸ����ȣ IS NULL


-- �ֱٰ��׸�� --

--SELECT *
--FROM
--  (
--  SELECT ROW_NUMBER() OVER(PARTITION BY ȸ����ȣ ORDER BY �Ϸù�ȣ DESC) AS ROWN, *
--  FROM
--  (SELECT A.*
--  FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������ݾ����� A
--  LEFT JOIN
--  (SELECT ȸ����ȣ
--  FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������ݾ�����
--  GROUP BY ȸ����ȣ
--  HAVING COUNT(ȸ����ȣ) > 1) B
--  ON A.ȸ����ȣ = B.ȸ����ȣ
--  WHERE A.���۳�� != A.������
--  AND B.ȸ����ȣ IS NOT NULL) C -- ���� �ݾ� ���۳�� ������ �ٸ��ǵ� �� ���ΰǼ� �� �̻��� ȸ���� ����
--  ) T1
--CROSS JOIN
--  (
--  SELECT ROW_NUMBER() OVER(PARTITION BY ȸ����ȣ ORDER BY �Ϸù�ȣ DESC) AS ROWN, *
--  FROM
--  (SELECT A.*
--  FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������ݾ����� A
--  LEFT JOIN
--  (SELECT ȸ����ȣ
--  FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������ݾ�����
--  GROUP BY ȸ����ȣ
--  HAVING COUNT(ȸ����ȣ) > 1) B
--  ON A.ȸ����ȣ = B.ȸ����ȣ
--  WHERE A.���۳�� != A.������
--  AND B.ȸ����ȣ IS NOT NULL) C -- ���� �ݾ� ���۳�� ������ �ٸ��ǵ� �� ���ΰǼ� �� �̻��� ȸ���� ����
--  ) T2
--WHERE
--  T1.ȸ����ȣ = T2.ȸ����ȣ
--  AND T1.�Ϸù�ȣ > T2.�Ϸù�ȣ
--  AND T1.�ݾ� < T2.�ݾ�
--  AND T1.ROWN = 1
--  AND T1.���۳�� >= CONVERT(VARCHAR(7), GETDATE()-30, 126)	-- ���۳���� ���⼭ ����
--  AND T2.ROWN = 2

-- 2. ��Ϻз���: SS-DGamount -> ���� Ȯ�� (������� ������ �ߴµ��� ������ ���: ���� ���α���� ���۳��/�������� ���� ��)

SELECT H.*, DG.*
FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_������� H
LEFT JOIN
	(SELECT T1.ȸ����ȣ, T1.���ο���, T1.���� AS ����1, T1.��û�� AS ��û��1, T1.�ݾ� AS �ݾ�1, T2.���� AS ����2, T2.��û�� AS ��û��2, T2.�ݾ� AS �ݾ�2
	FROM
	  (
	  SELECT ROW_NUMBER() OVER(PARTITION BY ȸ����ȣ ORDER BY �Ϸù�ȣ DESC) AS ROWN, *
	  FROM
	  (SELECT A.*
	  FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������ݾ����� A
	  LEFT JOIN
	  (SELECT ȸ����ȣ
	  FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������ݾ�����
	  GROUP BY ȸ����ȣ
	  HAVING COUNT(ȸ����ȣ) > 1) B
	  ON A.ȸ����ȣ = B.ȸ����ȣ
	  WHERE A.���۳�� != A.������
	  AND B.ȸ����ȣ IS NOT NULL) C -- ���� �ݾ� ���۳�� ������ �ٸ��ǵ� �� ���ΰǼ� �� �̻��� ȸ���� ����
	  ) T1
	CROSS JOIN
	  (
	  SELECT ROW_NUMBER() OVER(PARTITION BY ȸ����ȣ ORDER BY �Ϸù�ȣ DESC) AS ROWN, *
	  FROM
	  (SELECT A.*
	  FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������ݾ����� A
	  LEFT JOIN
	  (SELECT ȸ����ȣ
	  FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������ݾ�����
	  GROUP BY ȸ����ȣ
	  HAVING COUNT(ȸ����ȣ) > 1) B
	  ON A.ȸ����ȣ = B.ȸ����ȣ
	  WHERE A.���۳�� != A.������
	  AND B.ȸ����ȣ IS NOT NULL) C -- ���� �ݾ� ���۳�� ������ �ٸ��ǵ� �� ���ΰǼ� �� �̻��� ȸ���� ����
	  ) T2
	WHERE
	  T1.ȸ����ȣ = T2.ȸ����ȣ
	  AND T1.�Ϸù�ȣ > T2.�Ϸù�ȣ
	  AND T1.�ݾ� < T2.�ݾ�
	  AND T1.ROWN = 1
	  AND T1.���۳�� >= CONVERT(VARCHAR(7), GETDATE()-30, 126)	-- ���۳���� ���⼭ ����
	  AND T2.ROWN = 2
	  ) DG
ON H.ȸ����ȣ = DG.ȸ����ȣ
WHERE 
��Ϻз��� LIKE '%DG%'
AND CONVERT(DATE,������) >= CONVERT(DATE,GETDATE() - 5)
AND DG.ȸ����ȣ IS NULL






--3. ��Ϻз���: SS-tempstop -> �Ͻ����� Ȯ��

SELECT H.*, D.ȸ������
FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_������� H
LEFT JOIN
(SELECT ȸ����ȣ, ȸ������
FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ�������
WHERE ȸ������ = 'stop_tmp') D
ON H.ȸ����ȣ = D.ȸ����ȣ
WHERE
(H.���� LIKE '%����%'
OR H.��Ϻз��� LIKE '%����%'   -- �����׽�Ʈ
OR H.��Ϻз� LIKE '%����%')	-- �����׽�Ʈ
AND CONVERT(DATE,������) >= CONVERT(DATE,GETDATE() - 3)
AND D.ȸ����ȣ IS NULL



--4. ����: Iī�庯�� -> ����Ȯ��

SELECT H.*, CA.������
FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_������� H
LEFT JOIN
(SELECT ȸ����ȣ, ������
FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�ſ�ī���������
WHERE CONVERT(DATE,������) >= CONVERT(DATE,GETDATE() - 3)) CA
ON H.ȸ����ȣ = CA.ȸ����ȣ
WHERE
���� LIKE '%ī�庯��'
AND CONVERT(DATE,������) >= CONVERT(DATE,GETDATE() - 3)
AND CA.ȸ����ȣ IS NULL


--5. ����: I���º��� -> ����Ȯ��


SELECT H.*, CH.*
FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_������� H
LEFT JOIN
	(SELECT *
	FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�����̷�
	WHERE �����׸� IN ('����', '���¹�ȣ')
	AND CONVERT(DATE,�����Ͻ�) >= CONVERT(DATE,GETDATE()-3)
	) CH
ON H.ȸ����ȣ = CH.ȸ����ȣ
WHERE
���� LIKE '%���º���'
AND CONVERT(DATE,������) >= CONVERT(DATE,GETDATE() - 3)
AND CH.ȸ����ȣ IS NULL

--6. ����: I�ݾ׺��� -> ����Ȯ��

-- �ֱٱݾ׺����� --

--SELECT T1.ȸ����ȣ
--FROM
--  (
--  SELECT ROW_NUMBER() OVER(PARTITION BY ȸ����ȣ ORDER BY �Ϸù�ȣ DESC) AS ROWN, *
--  FROM
--  (SELECT A.*
--  FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������ݾ����� A
--  LEFT JOIN
--  (SELECT ȸ����ȣ
--  FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������ݾ�����
--  GROUP BY ȸ����ȣ
--  HAVING COUNT(ȸ����ȣ) > 1) B
--  ON A.ȸ����ȣ = B.ȸ����ȣ
--  WHERE A.���۳�� != A.������
--  AND B.ȸ����ȣ IS NOT NULL) C -- ���� �ݾ� ���۳�� ������ �ٸ��ǵ� �� ���ΰǼ� �� �̻��� ȸ���� ����
--  ) T1
--CROSS JOIN
--  (
--  SELECT ROW_NUMBER() OVER(PARTITION BY ȸ����ȣ ORDER BY �Ϸù�ȣ DESC) AS ROWN, *
--  FROM
--  (SELECT A.*
--  FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������ݾ����� A
--  LEFT JOIN
--  (SELECT ȸ����ȣ
--  FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������ݾ�����
--  GROUP BY ȸ����ȣ
--  HAVING COUNT(ȸ����ȣ) > 1) B
--  ON A.ȸ����ȣ = B.ȸ����ȣ
--  WHERE A.���۳�� != A.������
--  AND B.ȸ����ȣ IS NOT NULL) C -- ���� �ݾ� ���۳�� ������ �ٸ��ǵ� �� ���ΰǼ� �� �̻��� ȸ���� ����
--  ) T2
--WHERE
--  T1.ȸ����ȣ = T2.ȸ����ȣ
--  AND T1.�Ϸù�ȣ > T2.�Ϸù�ȣ
--  AND T1.�ݾ� != T2.�ݾ�
--  AND T1.ROWN = 1
--  AND T1.���۳�� >= CONVERT(VARCHAR(7), GETDATE()-30, 126)	-- ���۳���� ���⼭ ����
--  AND T2.ROWN = 2

SELECT H.*, TMP1.*
FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_������� H
LEFT JOIN
	(
	SELECT T1.ȸ����ȣ
	FROM
	  (
	  SELECT ROW_NUMBER() OVER(PARTITION BY ȸ����ȣ ORDER BY �Ϸù�ȣ DESC) AS ROWN, *
	  FROM
	  (SELECT A.*
	  FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������ݾ����� A
	  LEFT JOIN
	  (SELECT ȸ����ȣ
	  FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������ݾ�����
	  GROUP BY ȸ����ȣ
	  HAVING COUNT(ȸ����ȣ) > 1) B
	  ON A.ȸ����ȣ = B.ȸ����ȣ
	  WHERE A.���۳�� != A.������
	  AND B.ȸ����ȣ IS NOT NULL) C -- ���� �ݾ� ���۳�� ������ �ٸ��ǵ� �� ���ΰǼ� �� �̻��� ȸ���� ����
	  ) T1
	CROSS JOIN
	  (
	  SELECT ROW_NUMBER() OVER(PARTITION BY ȸ����ȣ ORDER BY �Ϸù�ȣ DESC) AS ROWN, *
	  FROM
	  (SELECT A.*
	  FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������ݾ����� A
	  LEFT JOIN
	  (SELECT ȸ����ȣ
	  FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������ݾ�����
	  GROUP BY ȸ����ȣ
	  HAVING COUNT(ȸ����ȣ) > 1) B
	  ON A.ȸ����ȣ = B.ȸ����ȣ
	  WHERE A.���۳�� != A.������
	  AND B.ȸ����ȣ IS NOT NULL) C -- ���� �ݾ� ���۳�� ������ �ٸ��ǵ� �� ���ΰǼ� �� �̻��� ȸ���� ����
	  ) T2
	WHERE
	  T1.ȸ����ȣ = T2.ȸ����ȣ
	  AND T1.�Ϸù�ȣ > T2.�Ϸù�ȣ
	  AND T1.�ݾ� != T2.�ݾ�
	  AND T1.ROWN = 1
	  AND T1.���۳�� >= CONVERT(VARCHAR(7), GETDATE()-30, 126)	-- ���۳���� ���⼭ ����
	  AND T2.ROWN = 2
	) TMP1
ON H.ȸ����ȣ = TMP1.ȸ����ȣ
WHERE
���� LIKE '%�ݾ׺���'
AND CONVERT(DATE,������) >= CONVERT(DATE,GETDATE() - 5)
AND TMP1.ȸ����ȣ IS NULL

--7. ��Ϻз���: �ڹ�_Unfreezing -> ��� �� �������� ����Ȯ��

SELECT H.*, D.ȸ������, CH.�����׸�
FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_������� H
LEFT JOIN
	(SELECT ȸ����ȣ, ȸ������
	FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ�������
	WHERE ȸ������ = 'Normal'
	) D
ON H.ȸ����ȣ = D.ȸ����ȣ
LEFT JOIN
	(SELECT ȸ����ȣ, �����׸�
	FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�����̷�
	WHERE �����׸� IN ('���¹�ȣ', '����', '���ι��', '�����ڷ� �߰�')
    AND CONVERT(DATE,�����Ͻ�) >= CONVERT(DATE,GETDATE()-3)
  ) CH
ON H.ȸ����ȣ = CH.ȸ����ȣ
LEFT JOIN
	(SELECT ȸ����ȣ, ��û��
	FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_CMS��������
	WHERE ��û�� >= CONVERT(DATE,GETDATE()-3)
	UNION ALL
	SELECT ȸ����ȣ, ������
	FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�ſ�ī���������
	WHERE ������ >= CONVERT(DATE,GETDATE()-3) 
	) BCA
ON H.ȸ����ȣ  = BCA.ȸ����ȣ

WHERE ��Ϻз��� = '�ڹ�_Unfreezing'
	AND CONVERT(DATE,������) >= CONVERT(DATE,GETDATE()-3)
	AND (D.ȸ����ȣ IS NULL
	OR 
		(CH.ȸ����ȣ IS NULL AND BCA.ȸ����ȣ IS NULL) )
	
	
--9. ��Ϻз���: �Ŀ��ݾ�upgrade -> ���� Ȯ��
SELECT H.* 
FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_������� H
LEFT JOIN
	(SELECT T1.ȸ����ȣ
	FROM
	  (
	  SELECT ROW_NUMBER() OVER(PARTITION BY ȸ����ȣ ORDER BY �Ϸù�ȣ DESC) AS ROWN, *
	  FROM
	  (SELECT A.*
	  FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������ݾ����� A
	  LEFT JOIN
	  (SELECT ȸ����ȣ
	  FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������ݾ�����
	  GROUP BY ȸ����ȣ
	  HAVING COUNT(ȸ����ȣ) > 1) B
	  ON A.ȸ����ȣ = B.ȸ����ȣ
	  WHERE A.���۳�� != A.������
	  AND B.ȸ����ȣ IS NOT NULL) C -- ���� �ݾ� ���۳�� ������ �ٸ��ǵ� �� ���ΰǼ� �� �̻��� ȸ���� ����
	  ) T1
	CROSS JOIN
	  (
	  SELECT ROW_NUMBER() OVER(PARTITION BY ȸ����ȣ ORDER BY �Ϸù�ȣ DESC) AS ROWN, *
	  FROM
	  (SELECT A.*
	  FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������ݾ����� A
	  LEFT JOIN
	  (SELECT ȸ����ȣ
	  FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������ݾ�����
	  GROUP BY ȸ����ȣ
	  HAVING COUNT(ȸ����ȣ) > 1) B
	  ON A.ȸ����ȣ = B.ȸ����ȣ
	  WHERE A.���۳�� != A.������
	  AND B.ȸ����ȣ IS NOT NULL) C -- ���� �ݾ� ���۳�� ������ �ٸ��ǵ� �� ���ΰǼ� �� �̻��� ȸ���� ����
	  ) T2
	WHERE
	  T1.ȸ����ȣ = T2.ȸ����ȣ
	  AND T1.�Ϸù�ȣ > T2.�Ϸù�ȣ
	  AND T1.�ݾ� > T2.�ݾ�
	  AND T1.ROWN = 1
	  AND T1.���۳�� >= CONVERT(VARCHAR(7), GETDATE()-30, 126)	-- ���۳���� ���⼭ ����
	  AND T2.ROWN = 2
	) TMP1
ON H.ȸ����ȣ = TMP1.ȸ����ȣ
WHERE ��Ϻз��� = '�Ŀ��ݾ�upgrade'
	AND CONVERT(DATE,������) >= CONVERT(DATE,GETDATE()-3)
	AND TMP1.ȸ����ȣ IS NULL


-- ���� �з� �� ī�װ��� ���� �ʴ� �� Ȯ�� --
-- ��: I�ݾ׺��� �� 



-- ����: ������û -> ����Ȯ�� --

SELECT H.*, D.ȸ������
FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_������� H
LEFT JOIN
(SELECT ȸ����ȣ, ȸ������
FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ�������
WHERE ȸ������ = 'stop_tmp') D
ON H.ȸ����ȣ = D.ȸ����ȣ
WHERE
(H.���� LIKE '%����%'
OR H.��Ϻз��� LIKE '%����%'   -- �����׽�Ʈ
OR H.��Ϻз� LIKE '%����%')	-- �����׽�Ʈ
AND CONVERT(DATE,������) >= CONVERT(DATE,GETDATE() - 3)
AND D.ȸ����ȣ IS NULL


-- ��Ÿ ���� Ȯ�� --
-- ����: I���Ǻ��� -- 


SELECT H.*, CH.�����׸�
FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_������� H
LEFT JOIN
(SELECT ȸ����ȣ, �����׸�
FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�����̷�
WHERE �����׸� = '����'
	AND CONVERT(DATE,�����Ͻ�) >= CONVERT(DATE,GETDATE() - 3)
) CH
ON H.ȸ����ȣ = CH.ȸ����ȣ
WHERE
	H.���� LIKE '%���Ǻ���'
	AND CONVERT(DATE,������) >= CONVERT(DATE,GETDATE() - 3)
	AND CH.ȸ����ȣ IS NULL
