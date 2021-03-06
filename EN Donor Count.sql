
-- dbo.en_campaign_email: All Data Capture Campaigns 이메일
-- dbo.en_all_users_email: All Users 이메일


-- EN All Data Capture Campaigns (캠페인 서명 이력 보유) 이메일 중 MRM등록된 이메일 건수 확인 --

SELECT *
FROM [work].[dbo].[en_all_email] EN
LEFT JOIN db0_clnt_i DB
ON EN.[Supporter Email] = DB.이메일
WHERE DB.이메일 IS NOT NULL
ORDER BY 최초입력일

-- EN의 모든 이메일 중 MRM에 등록된 이메일 건수 확인 --

SELECT *
FROM [work].[dbo].[en_all_users_email] EN
LEFT JOIN db0_clnt_i DB
ON EN.[email] = DB.이메일
WHERE DB.이메일 IS NOT NULL
ORDER BY 최초입력일


