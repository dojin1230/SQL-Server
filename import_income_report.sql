INSERT INTO
	[HK].[Korea Report Data].[dbo].[Table_Report_IncomeReport]
	([Comparison], [ConstituentID], [Region], [Paymentmethod], [PaidDate], [Year], [Month], [GL_Middle], [GL_SuffixFormula], [Actual], [Type])
SELECT	
	'Actual' AS [Comparison], 
	[Donor ID] AS [ConstituentID],
	--NULL AS [OpportunityID],
	--NULL AS [TransactionID],
	'Korea' AS [Region],
	[Payment Method] AS [Paymentmethod], 
	[Debit success date] AS [PaidDate], 
	CAST(2017 AS INT) AS [Year], 
	[Settlement month] AS [Month], 
	[Account code] AS [GL_Middle], 
	COCOA AS [GL_SuffixFormula],
	CASE 
	WHEN [Regular-One-off]='Regular' then [Regular amount] 
	WHEN [Regular-One-off]='One-off' then [Oneoff amount] 
	END AS [Actual],
	--NULL AS [Budget], 
	[Regular-One-off] AS [Type]
	--NULL AS [CardType], 
	--NULL AS [ExpiredCardType], 
	--NULL AS [TLIID], 
	--NULL AS [RGLIID], 
	--'' AS [CreatedDate], 
	--NULL AS [Status]
FROM
	[dbo].[income_report_gpkr]
GO
