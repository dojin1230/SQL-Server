
  UPDATE [work].[dbo].[petition_daily_code]
  SET start_date = '2018-03-14' -- 수동 입력(다음 업무일)
  WHERE input_date = CONVERT(VARCHAR(10),GETDATE(),126)