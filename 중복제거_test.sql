use work
go


SELECT
	*
FROM
	(
	SELECT
		modified_number
	FROM 
		[work].[dbo].[petition_daily_after]
	GROUP BY
		modified_number
	HAVING
		COUNT(modified_number) >= 2
	) A
LEFT JOIN
	[work].[dbo].[petition_daily_after] B
ON
	A.modified_number = B.modified_number




SELECT
	modified_number, ROW_NUMBER() OVER(ORDER BY modified_number) AS ROWN
FROM 
	[work].[dbo].[petition_daily_after] PA1
GROUP BY
	modified_number
HAVING
	COUNT(modified_number) >= 2


SELECT
	*, ROW_NUMBER() OVER(ORDER BY modified_number) AS ROWN
INTO
	[work].[dbo].[petition_daily_after_test]
FROM 
	[work].[dbo].[petition_daily_after] 


SELECT
	*
FROM 
	[work].[dbo].[petition_daily_after] 
WHERE
	modified_number in ('010-2778-7083','010-4718-1910','010-5778-5295','010-7656-0155','010-8892-7372')



SELECT
	A.*, B.*
FROM
	[work].[dbo].[petition_daily_after_test] A
LEFT JOIN
	(
	SELECT 
		modified_number, RANK() OVER (PARTITION BY modified_number ORDER BY ROWN ASC) AS DD
	FROM 
		[work].[dbo].[petition_daily_after_test]
	) B
ON
	A.modified_number = B.modified_number
WHERE
	B.DD = 1
	

SELECT 
	B.*
FROM 
(
SELECT
	A.[modified_number], MAX(A.ROWN)
FROM 
	(
	SELECT
		*, ROW_NUMBER() OVER(ORDER BY modified_number) AS ROWN
	FROM
		[work].[dbo].[petition_daily_after]
	GROUP BY
		[korean_name], [modified_number], supporter_email, campaign_date, campaign_name_kr, source
	) A
GROUP BY
	A.[modified_number]
) B
LEFT JOIN
	[work].[dbo].[petition_daily_after]