USE [work]
GO

select [dbo].[FN_GetNextWorkingDay]('2018-09-24')

ALTER FUNCTION 
	[dbo].[FN_GetNextWorkingDay](@givenDate DATE)
RETURNS DATE
	AS
BEGIN
	DECLARE @nextDate DATE 
	SET @nextDate = DATEADD(day, 1, @givenDate)
	BEGIN
		IF (@nextDate = CONVERT(DATE, '2018-01-01'))	BEGIN SET @nextDate = DATEADD(day, 1, @nextDate)	END		-- 신정
		IF (@nextDate = CONVERT(DATE, '2018-02-15'))	BEGIN SET @nextDate = DATEADD(day, 1, @nextDate)	END		-- 구정
		IF (@nextDate = CONVERT(DATE, '2018-02-16'))	BEGIN SET @nextDate = DATEADD(day, 1, @nextDate)	END		-- 구정
		IF (@nextDate = CONVERT(DATE, '2018-02-17'))	BEGIN SET @nextDate = DATEADD(day, 1, @nextDate)	END		-- 구정
		IF (@nextDate = CONVERT(DATE, '2018-03-01'))	BEGIN SET @nextDate = DATEADD(day, 1, @nextDate)	END		-- 삼일절
		IF (@nextDate = CONVERT(DATE, '2018-05-05'))	BEGIN SET @nextDate = DATEADD(day, 1, @nextDate)	END		-- 어린이날
		IF (@nextDate = CONVERT(DATE, '2018-05-07'))	BEGIN SET @nextDate = DATEADD(day, 1, @nextDate)	END		-- 어린이날 대체
		IF (@nextDate = CONVERT(DATE, '2018-05-22'))	BEGIN SET @nextDate = DATEADD(day, 1, @nextDate)	END		-- 부처님오신날
		IF (@nextDate = CONVERT(DATE, '2018-06-06'))	BEGIN SET @nextDate = DATEADD(day, 1, @nextDate)	END		-- 현충일
		IF (@nextDate = CONVERT(DATE, '2018-06-13'))	BEGIN SET @nextDate = DATEADD(day, 1, @nextDate)	END		-- 지방선거일
		IF (@nextDate = CONVERT(DATE, '2018-08-15'))	BEGIN SET @nextDate = DATEADD(day, 1, @nextDate)	END		-- 광복절
		IF (@nextDate = CONVERT(DATE, '2018-09-23'))	BEGIN SET @nextDate = DATEADD(day, 1, @nextDate)	END		-- 추석
		IF (@nextDate = CONVERT(DATE, '2018-09-24'))	BEGIN SET @nextDate = DATEADD(day, 1, @nextDate)	END		-- 추석
		IF (@nextDate = CONVERT(DATE, '2018-09-25'))	BEGIN SET @nextDate = DATEADD(day, 1, @nextDate)	END		-- 추석
		IF (@nextDate = CONVERT(DATE, '2018-09-26'))	BEGIN SET @nextDate = DATEADD(day, 1, @nextDate)	END		-- 추석 대체
		IF (@nextDate = CONVERT(DATE, '2018-10-03'))	BEGIN SET @nextDate = DATEADD(day, 1, @nextDate)	END		-- 개천절
		IF (@nextDate = CONVERT(DATE, '2018-10-09'))	BEGIN SET @nextDate = DATEADD(day, 1, @nextDate)	END		-- 한글날
		IF (@nextDate = CONVERT(DATE, '2018-12-25'))	BEGIN SET @nextDate = DATEADD(day, 1, @nextDate)	END		-- 크리스마스
	END
	IF (DATENAME(dw , @nextDate) = '토요일')
		BEGIN
			SET @nextDate = DATEADD(day, 2, @nextDate)			
		END
	ELSE IF (DATENAME(dw , @nextDate) = '일요일')
		BEGIN
			SET @nextDate = DATEADD(day, 1, @nextDate)
		END
	RETURN @nextDate
END
GO


