
  UPDATE [work].[dbo].[petition_daily_code]
  SET start_date = '2018-03-20' -- 수동 입력(다음 업무일)
  WHERE input_date = CONVERT(VARCHAR(10),GETDATE(),126)
  and source != '카카오-E'

  /*

  UPDATE [work].[dbo].[petition_daily_code]
  SET start_date = '2018-03-19' -- 수동 입력(다음주 첫 업무일 - 이모티콘 발송 후)
  WHERE input_date = CONVERT(VARCHAR(10),GETDATE(),126)
  and source = '카카오-E'

  select * from [work].[dbo].[petition_daily_code]
  WHERE start_date is null
  and source = '카카오-E'



  */


  -- select [dbo].FN_GetNextWorkingDay('2018-04-30')
