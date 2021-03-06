/****** SSMS의 SelectTopNRows 명령 스크립트 ******/
 
SELECT TOP (1000) [code]
      ,[name]
      ,[phone_number]
      ,[email]
      ,[last_call]
      ,[category]
      ,[agency]
      ,[update_date]
  FROM [work].[dbo].[lead_donotcall]
  order by update_date desc
-----
SELECT *
  FROM [work].[dbo].[petition_daily_code]
  where supporter_email='leeas55@hanmail.net'
-----
INSERT INTO
	[work].[dbo].[lead_donotcall]
SELECT
	CONCAT('SK0',[code_no]) AS [code],
	[korean_name] AS[name],
	[modified_number] AS[phone_number],
    [supporter_email] AS [email],
    [start_date] AS [last_call],
    '다른사람-카톡' AS [category],
    'MPC' AS [agency],
    GETDATE() AS [update_date]
from 
	[work].[dbo].[petition_daily_code]
where 
	supporter_email='simona_ar@naver.com'

 
-- [work].[dbo].[petition_daily_code] 에 없는 경우 [work].[dbo].[petition_all] 에서 
/*
INSERT INTO
	[work].[dbo].[lead_donotcall]
SELECT
	'미확인' AS [code],
	[Name_] AS[name],
	[modified_phone] AS[phone_number],
    [Mail] AS [email],
    Year_ AS [last_call],
    '추후전화거부-카카오톡' AS [category],
    'MPC' AS [agency],
    GETDATE() AS [update_date]
from 
	[work].[dbo].[petition_all]
where 
	Mail='leeas55@hanmail.net'
 
 */

 