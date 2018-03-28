SELECT
	*
FROM
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록
WHERE
	기록분류 IN ('TM_특별일시후원', '특별일시후원 요청/문의') AND
	참고일 >= '2017-10-01' AND
	처리진행사항 IN ('SK-완료', 'IH-진행') AND
	기록분류상세 IN ( '통성-후원동의', '우편접수', '우편&전화접수','이메일접수','기타접수')
GO

SELECT
	CASE
	WHEN 처리진행사항='IH-진행' then 기록분류상세
	WHEN 제목 like 'MPC%' then 'MPC전화접수'
	WHEN 제목 like 'WV%' then 'WV전화접수'
	END AS 접수경로,
	회원번호,
	제목
FROM
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록
WHERE
	기록분류 IN ('TM_특별일시후원', '특별일시후원 요청/문의') AND
	참고일 >= '2017-10-01' AND
	처리진행사항 IN ('SK-완료', 'IH-진행') AND
	기록분류상세 IN ( '통성-후원동의', '우편접수', '우편&전화접수','이메일접수','기타접수')
GO

SELECT
	*
FROM
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록
		
SELECT
	*
FROM
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록
WHERE
	기록분류='특별일시후원 요청/문의' AND
	참고일 >= '2017-10-01' AND
	처리진행사항='IH-진행'
GO


SELECT
	*
FROM
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보
WHERE
	가입경로='Lead Conversion' AND
	가입일 >= '2017-01-01'
GO


SELECT
	COUNT(
	CASE
	WHEN 성별 is null then '성별모름'
	ELSE 성별
	END) AS 성별, 
	CASE 
	WHEN 가입일 >=  CONVERT(varchar(10), '2017-01-01', 126) AND 가입일 < CONVERT(varchar(10), '2017-02-01', 126) THEN '1월' 
	WHEN 가입일 >=  CONVERT(varchar(10), '2017-02-01', 126) AND 가입일 < CONVERT(varchar(10), '2017-03-01', 126) THEN '2월' 
	WHEN 가입일 >=  CONVERT(varchar(10), '2017-03-01', 126) AND 가입일 < CONVERT(varchar(10), '2017-04-01', 126) THEN '3월' 
	WHEN 가입일 >=  CONVERT(varchar(10), '2017-04-01', 126) AND 가입일 < CONVERT(varchar(10), '2017-05-01', 126) THEN '4월' 
	WHEN 가입일 >=  CONVERT(varchar(10), '2017-05-01', 126) AND 가입일 < CONVERT(varchar(10), '2017-06-01', 126) THEN '5월' 
	WHEN 가입일 >=  CONVERT(varchar(10), '2017-06-01', 126) AND 가입일 < CONVERT(varchar(10), '2017-07-01', 126) THEN '6월' 
	WHEN 가입일 >=  CONVERT(varchar(10), '2017-07-01', 126) AND 가입일 < CONVERT(varchar(10), '2017-08-01', 126) THEN '7월' 
	WHEN 가입일 >=  CONVERT(varchar(10), '2017-08-01', 126) AND 가입일 < CONVERT(varchar(10), '2017-09-01', 126) THEN '8월' 
	WHEN 가입일 >=  CONVERT(varchar(10), '2017-09-01', 126) AND 가입일 < CONVERT(varchar(10), '2017-10-01', 126) THEN '9월' 
	WHEN 가입일 >=  CONVERT(varchar(10), '2017-10-01', 126) THEN '10월' 
	END AS '가입월'
FROM
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보
WHERE
	가입일 >= CONVERT(varchar(10), '2017-01-01', 126)
GROUP BY
	가입월

SELECT SaleDate,
       Count(DISTINCT CASE
                        WHEN Customer IS NULL THEN CONVERT(VARCHAR(50), CustomerID)
                        ELSE Customer
                      END) AS UniqueCustomers
FROM   Yourtable
GROUP  BY SaleDate 


	
SELECT
	*
FROM
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보 S
WHERE
	가입일 >= CONVERT(varchar(10), '2017-01-01', 126) AND 가입일 < CONVERT(varchar(10), '2017-02-01', 126)