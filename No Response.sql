-- �ֱ� ���� 3���� ��� 
use work
go

DROP TABLE IF EXISTS dbo.no_response

SELECT
	ȸ����ȣ
INTO
	dbo.no_response
FROM
	(
	SELECT 
		ȸ����ȣ, COUNT(1) AS ����Ƚ��
	FROM
		(SELECT
			ȸ����ȣ, ��Ϻз���
		FROM
			(SELECT
				ȸ����ȣ, RANK() OVER (PARTITION BY ȸ����ȣ ORDER BY ������ DESC) AS �ֱ������ϼ���, ��Ϻз���
			FROM
				MRMRT.�׸��ǽ����ƽþƼ���繫��0868.dbo.UV_GP_������� 
			WHERE
				��Ϻз� like 'TM%' AND ��Ϻз��� !=N'����' AND ó���������='SK-�Ϸ�') RA
		WHERE
			�ֱ������ϼ��� <= 3
			AND ��Ϻз��� in (N'����',N'�뼺-X') ) NR
			--AND ��Ϻз��� =N'����' ) NR
	GROUP BY
		ȸ����ȣ
	HAVING
		COUNT(ȸ����ȣ) = 3
	) A
	
