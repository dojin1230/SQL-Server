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

 
 /*
 INSERT INTO [work].[dbo].[lead_donotcall]
 VALUES ('SK0164673','이채현','010-5103-1517','leech6703@naver.com
','2018-02-26','결번(제3자)','MPC', getdate())
 */