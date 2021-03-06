------------------------------------------------------------------------------------------

SELECT count(*)
FROM [work].[dbo].[kemoji_en_data]
WHERE [utm_term] = 'kemoji'

------------------------------------------------------------------------------------------



DROP TABLE IF EXISTS #001

SELECT
	ROW_NUMBER() OVER(ORDER BY phone_number) AS row_no, [phone_number] ,[Korean_name],[email],[Campaign_Date],[utm_term]
INTO #001
FROM [work].[dbo].[kemoji_en_data]
WHERE [utm_term] = 'kemoji' -- or [utm_content] like '%kakao%')
	--and email not in ('jnoh@greenpeace.org', 'leegygy@naver.com')
	--and [Campaign_Date] = convert(varchar(10),getdate()-0,126)  

DROP TABLE IF EXISTS #002
SELECT #001.*
INTO #002
FROM #001
LEFT JOIN
	(SELECT A.row_no
	FROM #001 A
	INNER JOIN
		(SELECT MAX(row_no) as row_max, phone_number, count(*) as count
		FROM #001
		GROUP BY phone_number
		HAVING COUNT(*) > 1) B
	ON A.phone_number = B.phone_number
		AND A.row_no != B.row_max) EX
ON #001.row_no = EX.row_no
WHERE EX.row_no IS NULL



DROP TABLE IF EXISTS #003
SELECT * 
INTO #003
FROM #002
LEFT JOIN
	(SELECT [성명],[회원번호],REPLACE([휴대전화번호],'-','') AS db0_phone,[이메일],[최초입력일],[가입경로상세]
	FROM [work].[dbo].[db0_clnt_i]
	WHERE 최초입력일 BETWEEN '2018-03-01' AND '2018-03-31' AND 가입경로상세 = 'event') DB0
ON #002.phone_number = DB0.db0_phone
WHERE DB0.db0_phone IS NULL -- 3월 / 가입경로 event 제외


DROP TABLE IF EXISTS #004
SELECT #003.*
INTO #004
FROM #003
LEFT JOIN
[work].[dbo].[kemoji_all]
ON #003.phone_number = kemoji_all.phone
WHERE
kemoji_all.phone IS NULL -- Kemoji_all 제외



INSERT INTO [work].[dbo].[kemoji_all](input_date, phone, name, email, campaign_date, utm_term)
SELECT 
	CONVERT(DATE, GETDATE()),
	#004.phone_number, #004.korean_name, #004.email, #004.campaign_date, #004.utm_term
FROM #004

SELECT * FROM [work].[dbo].[kemoji_all]
WHERE input_date >= '2018-03-13'
	--input_date = CONVERT(DATE, GETDATE())
