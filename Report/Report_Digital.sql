--ALTER VIEW [vw_digital_monitor]
--AS
SELECT
	D.회원번호, D.납부방법, D.나이, D.가입일, Year(D.가입일) AS JoinYear, Month(D.가입일) AS JoinMonth, 1 AS DonorCount, NULL AS BudgetCount, DATEPART(week, D.가입일) AS weeknum, 
	CASE 
	WHEN D.가입경로='인터넷/홈페이지' THEN 'Web'
	ELSE D.가입경로
	END AS 가입경로, I.가입경로상세, D.최초등록구분, 
	CASE
	WHEN PL.회원번호 is not null THEN PL.금액
	WHEN PL.회원번호 is null AND D.최초등록구분 = '정기' THEN D.납부금액 
	WHEN PL.회원번호 is null AND D.최초등록구분 = '일시' THEN D.총납부금액 
	END
	AS IncomeAmount, NULL AS BudgetAmount
FROM
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보 D
LEFT JOIN
	[work].[dbo].[db0_clnt_i] I	
ON
	D.회원번호 = I.회원번호
LEFT JOIN
	(
	SELECT
		*
	FROM
		회원번호, 금액
		(
		SELECT
			회원번호, 신청일, RANK() OVER (PARTITION BY 회원번호 ORDER BY 신청일 ASC) AS 신청순서, 금액
		FROM
			MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원약정금액정보 
		) A
	WHERE
		A.신청순서 =1
	) PL
ON
	D.회원번호 = PL.회원번호
WHERE
	D.가입경로 in ('인터넷/홈페이지', 'Lead Conversion')
UNION ALL
SELECT
	NULL, NULL, NULL, B.JoinDate, Year(B.JoinDate) AS JoinYear, Month(B.JoinDate) AS JoinMonth, NULL, B.DonorCount, DATEPART(week, B.JoinDate) AS weeknum, B.가입경로, NULL, B.최초등록구분, NULL, B.Amount AS BudgetAmount
FROM
	[report].[dbo].[web_lc_budget] B
