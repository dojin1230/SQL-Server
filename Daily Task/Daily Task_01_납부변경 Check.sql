SELECT DISTINCT CH.ȸ����ȣ, D.ȸ������
FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�����̷� CH
LEFT JOIN
MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�Ŀ������� D
ON CH.ȸ����ȣ = D.ȸ����ȣ
WHERE 
(CH.�����׸� = '�����ڷ��߰�' 
 OR CH.�����׸� LIKE '����%' 
 OR CH.�����׸� IN ('����', '���¹�ȣ','���αݾ�','���ι��','������') 
OR (CH.�����׸� = '���ο���' AND CH.������ = 'Y'))
--AND CH.�����Ͻ� >= GETDATE() - 1
 AND CH.�����Ͻ� >= GETDATE() - 4
AND D.ȸ������ IN ('Freezing','Canceled')
AND (D.���ι�� = '�ſ�ī��' OR D.���� != '' AND D.���ι�� = 'CMS')
AND D.���ο��� = 'Y'




-- ȸ�����º��� ������� Ȯ�� --

SELECT *
FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�����̷� CH
LEFT JOIN
	(SELECT * 
	FROM MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_�������
	WHERE ��Ϻз��� IN ('�뼺-����۵���', '�뼺-�簳����', '�ڹ�_Unfreezing','�ڹ�_Reactivation')
		AND ������ >= GETDATE() - 4
	) H
ON CH.ȸ����ȣ = H.ȸ����ȣ
WHERE CH.�����׸� = 'ȸ������'
	AND CH.�����Ͻ� >= GETDATE() - 3
	AND CH.������ = 'freezing'
	AND CH.������ = 'normal'
	AND H.ȸ����ȣ IS NULL
