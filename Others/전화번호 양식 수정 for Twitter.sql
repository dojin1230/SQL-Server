/****** SSMS의 SelectTopNRows 명령 스크립트 ******/
--SELECT modified_phone
--  FROM [work].[dbo].[petition_all]
--  where left(modified_phone,4) IN ('010-','011-','016-','019-')
	

--  order by modified_phone



--CREATE FUNCTION func_getNumeric (@strAlphaNumeric VARCHAR(256)) 
--returns VARCHAR(256) 
--AS 
--  BEGIN 
--      DECLARE @intAlpha INT 

--      SET @intAlpha = Patindex('%[^0-9]%', @strAlphaNumeric) 

--      BEGIN 
--          WHILE @intAlpha > 0 
--            BEGIN 
--                SET @strAlphaNumeric = Stuff(@strAlphaNumeric, @intAlpha, 1, '') 
--                SET @intAlpha = Patindex('%[^0-9]%', @strAlphaNumeric) 
--            END 
--      END 

--      RETURN Isnull(@strAlphaNumeric, 0) 
--  END 

--GO

--SELECT func_getNumeric(modified_phone) 
--from [work].[dbo].[petition_all]



CREATE FUNCTION dbo.udf_GetNumeric
(@strAlphaNumeric VARCHAR(256))
RETURNS VARCHAR(256)
AS
BEGIN
DECLARE @intAlpha INT
SET @intAlpha = PATINDEX('%[^0-9]%', @strAlphaNumeric)
BEGIN
WHILE @intAlpha > 0
BEGIN
SET @strAlphaNumeric = STUFF(@strAlphaNumeric, @intAlpha, 1, '' )
SET @intAlpha = PATINDEX('%[^0-9]%', @strAlphaNumeric )
END
END
RETURN ISNULL(@strAlphaNumeric,0)
END

SELECT dbo.udf_GetNumeric(modified_phone) AS phone
INTO #T1
from [work].[dbo].[petition_all]

SELECT distinct phone 
INTO #T2
FROM #T1
WHERE len(phone) between 10 and 11
	and left(phone,2) = '01'

SELECT '82'+RTRIM(SUBSTRING(phone,2,10)) as phone_82
INTO #T_P
FROM #T2
order by 1




SELECT dbo.udf_GetNumeric(휴대전화번호) AS phone
INTO #T5
from [work].[dbo].[db0_clnt_i]

SELECT distinct phone 
INTO #T6
FROM #T5
WHERE len(phone) between 10 and 11
	and left(phone,2) = '01'

SELECT '82'+RTRIM(SUBSTRING(phone,2,10)) as phone_82
INTO #T_D
FROM #T6
order by 1

SELECT *
INTO phone_twitter_ex FROM
	(SELECT DISTINCT phone_82
	FROM #T_P
	UNION
	SELECT DISTINCT phone_82
	FROM #T_D) TMP