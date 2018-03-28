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
		IF (@nextDate = CONVERT(DATE, '2018-01-01'))	BEGIN SET @nextDate = DATEADD(day, 1, @nextDate)	END		-- ����
		IF (@nextDate = CONVERT(DATE, '2018-02-15'))	BEGIN SET @nextDate = DATEADD(day, 1, @nextDate)	END		-- ����
		IF (@nextDate = CONVERT(DATE, '2018-02-16'))	BEGIN SET @nextDate = DATEADD(day, 1, @nextDate)	END		-- ����
		IF (@nextDate = CONVERT(DATE, '2018-02-17'))	BEGIN SET @nextDate = DATEADD(day, 1, @nextDate)	END		-- ����
		IF (@nextDate = CONVERT(DATE, '2018-03-01'))	BEGIN SET @nextDate = DATEADD(day, 1, @nextDate)	END		-- ������
		IF (@nextDate = CONVERT(DATE, '2018-05-05'))	BEGIN SET @nextDate = DATEADD(day, 1, @nextDate)	END		-- ��̳�
		IF (@nextDate = CONVERT(DATE, '2018-05-07'))	BEGIN SET @nextDate = DATEADD(day, 1, @nextDate)	END		-- ��̳� ��ü
		IF (@nextDate = CONVERT(DATE, '2018-05-22'))	BEGIN SET @nextDate = DATEADD(day, 1, @nextDate)	END		-- ��ó�Կ��ų�
		IF (@nextDate = CONVERT(DATE, '2018-06-06'))	BEGIN SET @nextDate = DATEADD(day, 1, @nextDate)	END		-- ������
		IF (@nextDate = CONVERT(DATE, '2018-06-13'))	BEGIN SET @nextDate = DATEADD(day, 1, @nextDate)	END		-- ���漱����
		IF (@nextDate = CONVERT(DATE, '2018-08-15'))	BEGIN SET @nextDate = DATEADD(day, 1, @nextDate)	END		-- ������
		IF (@nextDate = CONVERT(DATE, '2018-09-23'))	BEGIN SET @nextDate = DATEADD(day, 1, @nextDate)	END		-- �߼�
		IF (@nextDate = CONVERT(DATE, '2018-09-24'))	BEGIN SET @nextDate = DATEADD(day, 1, @nextDate)	END		-- �߼�
		IF (@nextDate = CONVERT(DATE, '2018-09-25'))	BEGIN SET @nextDate = DATEADD(day, 1, @nextDate)	END		-- �߼�
		IF (@nextDate = CONVERT(DATE, '2018-09-26'))	BEGIN SET @nextDate = DATEADD(day, 1, @nextDate)	END		-- �߼� ��ü
		IF (@nextDate = CONVERT(DATE, '2018-10-03'))	BEGIN SET @nextDate = DATEADD(day, 1, @nextDate)	END		-- ��õ��
		IF (@nextDate = CONVERT(DATE, '2018-10-09'))	BEGIN SET @nextDate = DATEADD(day, 1, @nextDate)	END		-- �ѱ۳�
		IF (@nextDate = CONVERT(DATE, '2018-12-25'))	BEGIN SET @nextDate = DATEADD(day, 1, @nextDate)	END		-- ũ��������
	END
	IF (DATENAME(dw , @nextDate) = '�����')
		BEGIN
			SET @nextDate = DATEADD(day, 2, @nextDate)			
		END
	ELSE IF (DATENAME(dw , @nextDate) = '�Ͽ���')
		BEGIN
			SET @nextDate = DATEADD(day, 1, @nextDate)
		END
	RETURN @nextDate
END
GO


