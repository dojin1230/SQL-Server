
-- 3�ֵ� ������ ���� --

-- 1. �Ŀ����� --
SELECT *
FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_������� H
LEFT JOIN
	(SELECT ȸ����ȣ
	 FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ�������
	 WHERE
	 (���ι�� = '�ſ�ī��' AND CARD���� = '���οϷ�')
	 OR (���ι�� = 'CMS' AND CMS���� IN ('�űԿϷ�', '�ű�����'))
	 OR (���ι�� = 'CMS' AND CMS���� = '�űԴ��' AND CMS�����ڷ����ʿ� = 'N')
	 ) D	 
ON H.ȸ����ȣ = D.ȸ����ȣ
WHERE H.��Ϻз��� = '�뼺-�Ŀ�����'
	AND H.��Ϻз� = 'TM_����'
	AND CONVERT(DATE,����Ͻ�) = CONVERT(DATE, GETDATE()-21)
	AND D.ȸ����ȣ IS NULL


-- 2. �Ŀ�����(����) --

SELECT *
FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_������� H
LEFT JOIN
	(SELECT ȸ����ȣ
	 FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�������
	 WHERE ������ >= CONVERT(DATE, GETDATE()-21)
		AND ��Ϻз� = 'Cancellation'
	) H2
ON H.ȸ����ȣ = H2.ȸ����ȣ
WHERE H.��Ϻз��� = '�뼺-�Ŀ�����(����)'
	AND H.��Ϻз� = 'TM_����'
	AND CONVERT(DATE,H.����Ͻ�) = CONVERT(DATE, GETDATE()-21)
	AND H2.ȸ����ȣ IS NULL


-- 3. ��� --
SELECT *
FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_������� H
LEFT JOIN
	(SELECT ȸ����ȣ
	 FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ�������
	 WHERE
	 (���ι�� = '�ſ�ī��' AND CARD���� = '���οϷ�')
	 OR 
	 (���ι�� = 'CMS' AND CMS���� = '�űԿϷ�')
	 OR 
	 ȸ������ = 'Freezing'
	  ) D	 
ON H.ȸ����ȣ = D.ȸ����ȣ
WHERE H.��Ϻз��� = '���'
	AND H.��Ϻз� = 'TM_����'
	AND CONVERT(DATE,����Ͻ�) = CONVERT(DATE, GETDATE()-21)
	AND D.ȸ����ȣ IS NULL


-- 4. SK-����� ���� (����¡ �ʿ�� Ȯ��) -- 

SELECT *
FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_������� H
LEFT JOIN
	(SELECT ȸ����ȣ
	 FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ�������
	 WHERE
	 (���ι�� = '�ſ�ī��' AND CARD���� = '���οϷ�')
	 OR 
	 (���ι�� = 'CMS' AND CMS���� = '�űԿϷ�')
	 OR 
	 ȸ������ = 'Freezing'
	  ) D	 
ON H.ȸ����ȣ = D.ȸ����ȣ
WHERE H.ó��������� = 'SK-����'
	AND H.��Ϻз� = 'TM_����'
	AND CONVERT(DATE,����Ͻ�) = CONVERT(DATE, GETDATE()-21)
	AND D.ȸ����ȣ IS NULL



