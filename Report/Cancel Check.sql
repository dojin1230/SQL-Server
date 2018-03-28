use work
GO

ALTER VIEW dbo.cancelCheck
AS 
SELECT 
	YEAR(H.참고일) AS 취소년, MONTH(H.참고일) AS 취소월, H.회원번호, H.기록분류상세, H.참고일, 
	SUBSTRING(H.제목,1,1) AS 제목1, 
	SUBSTRING(H.제목,2,2) AS 제목2,
	CASE 
	WHEN S.가입경로=N'거리모집' THEN 'DDC' 
	WHEN S.가입경로=N'지인소개' THEN 'acquaintance'
	WHEN S.가입경로=N'브로슈어' THEN 'brochure'
	WHEN S.가입경로=N'기타' THEN 'ETC'
	WHEN S.가입경로=N'인터넷/홈페이지' THEN 'Web'
	WHEN S.가입경로=N'전화' THEN 'Call'
	ELSE S.가입경로 END AS 가입경로,
	S.가입일,
	DATEDIFF(month,S.가입일,GETDATE()) AS 후원기간,
	DATEDIFF(year,S.생년월일,GETDATE()) AS 나이,
	S.총납부건수,
	CASE
	WHEN H.기록분류상세 like '%Canceled' THEN 1
	ELSE 0
	END AS 취소여부,
	CASE
	WHEN H.기록분류상세 like 'SS-%' THEN 1
	ELSE 0
	END AS 시도여부,
	CASE
	WHEN H.기록분류상세 = 'SS-DGamount' THEN P2.금액 
	ELSE NULL 
	END AS 이전금액,
	P1.금액 AS 최근금액
FROM
	(
	SELECT
		회원번호, 참고일, 기록분류상세, 제목
	FROM
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록
	WHERE
		기록분류='Cancellation' 
		AND 처리진행사항=N'IH-완료'
		--AND 참고일 >= CONVERT(varchar(10), '2017-10-01', 126) AND 참고일 < CONVERT(varchar(10), '2017-11-01', 126)
	) H
LEFT JOIN
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보 S
ON
	H.회원번호 = S.회원번호
LEFT JOIN
(
	SELECT
		회원번호, 금액
	FROM
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원약정금액정보		
	WHERE 
		종료여부='N'
) P1
ON
	H.회원번호 = P1.회원번호
LEFT JOIN
(
	SELECT
		회원번호, 금액
	FROM
		(
		SELECT
			회원번호, RANK() OVER (PARTITION BY 회원번호 ORDER BY 종료년월 DESC, 신청일 DESC) AS 최근순서, 금액
		FROM
			MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원약정금액정보
		WHERE 
			종료여부='Y'
		) A
	WHERE 최근순서 = 1
) P2
ON
	H.회원번호 = P2.회원번호