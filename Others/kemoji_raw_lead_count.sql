/****** SSMS의 SelectTopNRows 명령 스크립트 ******/
SELECT 
      [campaign_date]
      ,[source]
      , count(*) as lead_count
  FROM [work].[dbo].[petition_daily_code]
  where source like '%카카오-E%'
  group by campaign_date, source
  order by 1


drop table if exists #111
select distinct Supporter_Email, Campaign_Date, Campaign_Data_33
into #111
FROM [work].[dbo].[kemoji_en_data]

select 
      [campaign_date]
      , count(*) as unique_email_count
FROM #111
  where campaign_data_33 like '%kemoji%'
  group by campaign_date
  order by 1



  SELECT campaign_date, count(*)

  FROM [work].[dbo].[kemoji_en_data]
  where campaign_data_33 like '%kemoji%'
  group by campaign_date
  order by 1

  