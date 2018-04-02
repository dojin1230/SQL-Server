

------------------------------------------------------------------------------------------

--SELECT count(*)
--FROM [work].[dbo].[kemoji_en_data]
--WHERE [utm_term] = 'kemoji'

------------------------------------------------------------------------------------------
/* 리스트 전달 셀렉트
drop table if exists #999
SELECT case
	when len(phone) = 8 and left(phone,1) not in ('0','1') then '010'+phone
	else phone
	end as [phone],[name],[email]
into #999
FROM [work].[dbo].[kemoji_all]
where input_date > '2018-03-17'    -- 인풋데이트 수정


SELECT *,
	case
		when len(phone) = 11 and left(phone, 3) in ('010','011','016','017','018','019') and substring(phone,4,1) NOT IN ('0','1') then 'T'
		when len(phone) = 10 and left(phone, 3) in ('011','016','017','018','019') then 'T'
		else 'F'
	end as TF
from #999
order by TF,phone

*/
-------------------------------------------------------------------------------------------



DROP TABLE IF EXISTS #001

SELECT
	ROW_NUMBER() OVER(ORDER BY phone_number) AS row_no, [phone_number] ,[Korean_name],[email],[Campaign_Date],[utm_term]
INTO #001
FROM [work].[dbo].[kemoji_en_data]
WHERE Campaign_Data_33 like '%kemoji%' and (Campaign_Data_33 like '%20180315_kakaotwad1%' or Campaign_Data_33 like '%20180315_kakaotwad2%' or
Campaign_Data_33 like '%20180319_kakaotwad3%' or Campaign_Data_33 like '%20180306_kakaotalkbuddy%' or Campaign_Data_33 like '%20180321_kakaotwad4%' or Campaign_Data_33 like '%20180328_kakaotalkbuddy2%')
--and campaign_date <= '2018-03-22' -- 18년 3월 23일 오후 1시 이전 서명자

	-- and utm_term  =''
	-- or [utm_content] like '%kakao%')
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



--DROP TABLE IF EXISTS #003
--SELECT *
--INTO #003
--FROM #002
--LEFT JOIN
--	(SELECT [성명],[회원번호],REPLACE([휴대전화번호],'-','') AS db0_phone,[이메일],[최초입력일],[가입경로상세]
--	FROM [work].[dbo].[db0_clnt_i]
--	WHERE 최초입력일 BETWEEN '2018-03-01' AND '2018-03-31' AND 가입경로상세 = 'event') DB0
--ON #002.phone_number = DB0.db0_phone
--WHERE DB0.db0_phone IS NULL -- 3월 / 가입경로 event 제외


DROP TABLE IF EXISTS #003
SELECT #002.*
INTO #003
FROM #002
LEFT JOIN
[work].[dbo].[kemoji_all]
ON #002.phone_number = kemoji_all.phone
WHERE
kemoji_all.phone IS NULL -- Kemoji_all 제외



INSERT INTO [work].[dbo].[kemoji_all](input_date, phone, name, email, campaign_date, utm_term)
SELECT
	CONVERT(DATE, GETDATE()),
	#003.phone_number, #003.korean_name, #003.email, #003.campaign_date, #003.utm_term
FROM #003




	drop table if exists #999
SELECT case
	when len(phone) = 8 and left(phone,1) not in ('0','1') then '010'+phone
	else phone
	end as [phone],[name],[email]
into #999
FROM [work].[dbo].[kemoji_all]
where input_date between '2018-03-31' and '2018-04-02'  -- 인풋데이트 수정


SELECT *,
	case
		when len(phone) = 11 and left(phone, 3) in ('010','011','016','017','018','019') and substring(phone,4,1) NOT IN ('0','1') then 'T'
		when len(phone) = 10 and left(phone, 3) in ('011','016','017','018','019') then 'T'
		else 'F'
	end as TF
from #999
order by TF,phone








  -- where input_date between '2018-03-12' and '2018-03-16' : 3584
  -- where input_date between '2018-03-17' and '2018-03-21' : 4643
  -- where input_date between '2018-03-22' and '2018-03-23' : 19939
  -- where input_date between '2018-03-24' and '2018-03-30' : 2495
  -- where input_date between '2018-03-31' and '2018-04-02' : 1194