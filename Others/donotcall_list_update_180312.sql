

insert into  [work].[dbo].[lead_donotcall] ([code]
      ,[name]
      ,[phone_number]
      ,[email]
      ,[last_call]
      ,[category]
      ,[agency]
      ,[update_date])
SELECT [code]
      ,[name]
      ,substring([phone],2,20)
      ,[email]
      ,convert(varchar(10),[lastcall]) lastcall
      ,[category]
	  ,'MPC'
	  ,getdate()
  FROM [work].[dbo].[donotcall_180312_2] -- csv파일 임포트하여 업데이트