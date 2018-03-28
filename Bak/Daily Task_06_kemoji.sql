/****** SSMS의 SelectTopNRows 명령 스크립트 ******/
SELECT 
      [Supporter_ID]
      ,[Supporter_Email]
      ,[Date_Created]
      ,[Date_Modified]
      
      ,[Campaign_ID]
      ,[Campaign_Date]
      ,[Campaign_Time]
      
      ,[utm_source]
      ,[utm_medium]
      ,[utm_campaign]
      ,[utm_content]
      ,[utm_term]
      ,[email]
      ,[Korean_name]
      
      ,[phone_number]
      
  FROM [work].[dbo].[en_data]

  where ([utm_term] = 'kemoji' or [utm_content] like '%kakao%')
	and email not in ('jnoh@greenpeace.org', 'leegygy@naver.com')
	--and [Campaign_Date] = convert(varchar(10),getdate()-0,126)  


	

