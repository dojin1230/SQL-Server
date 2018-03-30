

  UPDATE [work].[dbo].[petition_daily_code]
  SET start_date = convert(VARCHAR(10),[dbo].[FN_GetNextBusinessDate](getdate())) 
  WHERE input_date = CONVERT(VARCHAR(10),GETDATE(),126)
  and source != '카카오-E' 

  /*

  UPDATE [work].[dbo].[petition_daily_code]
  SET start_date = '2018-03-19' -- 수동 입력(이모티콘 발송 후)
  WHERE start_date is null
  and source = '카카오-E'
  
  
  select *
  from [work].[dbo].[petition_daily_code]
  WHERE input_date = CONVERT(VARCHAR(10),GETDATE(),126)   -- 남극해 리드 전달 보류
  and source != '카카오-E' and campaign_name_kr = '남극해'

  */
  


drop table if exists [work].[dbo].[petition_daily_code_sheet1]
SELECT 'SK0' + CONVERT(VARCHAR,[code_no]) AS code
      ,[korean_name]
      ,[modified_number]
      ,[supporter_email]
      ,[campaign_date]
      ,[campaign_name_kr]
      ,[source]
	  ,'MPC' as agency
	  ,start_date
into [work].[dbo].[petition_daily_code_sheet1]
FROM [work].[dbo].[petition_daily_code]
where start_date = convert(VARCHAR(10),[dbo].[FN_GetNextBusinessDate](getdate())) 
ORDER BY code


drop table if exists [work].[dbo].[petition_daily_code_kemoji]
SELECT 'SK0' + CONVERT(VARCHAR,[code_no]) AS code
      ,[korean_name]
      ,[modified_number]
      ,[supporter_email]
      ,[campaign_date]
      ,[campaign_name_kr]
      ,[source]
	  ,'MPC' AS agency
	  ,start_date
	  --,[input_date]
into [work].[dbo].[petition_daily_code_kemoji]
FROM [work].[dbo].[petition_daily_code]
where source = '카카오-E'
and start_date is null
ORDER BY code




