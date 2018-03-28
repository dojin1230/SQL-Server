-- 최근 무응 3번인 사람 
use work
go

DROP TABLE IF EXISTS dbo.no_response

SELECT
	회원번호
INTO
	dbo.no_response
FROM
	(
	SELECT 
		회원번호, COUNT(1) AS 무응횟수
	FROM
		(SELECT
			회원번호, 기록분류상세
		FROM
			(SELECT
				회원번호, RANK() OVER (PARTITION BY 회원번호 ORDER BY 참고일 DESC) AS 최근참고일순서, 기록분류상세
			FROM
				MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 
			WHERE
				기록분류 like 'TM%' AND 기록분류상세 !=N'제외' AND 처리진행사항='SK-완료') RA
		WHERE
			최근참고일순서 <= 3
			AND 기록분류상세 in (N'무응',N'통성-X') ) NR
			--AND 기록분류상세 =N'무응' ) NR
	GROUP BY
		회원번호
	HAVING
		COUNT(회원번호) = 3
	) A
	
