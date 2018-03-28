USE report
go

-- TM report
ALTER VIEW [dbo].[vw_telemarketing]
AS
SELECT
	H.회원번호 AS [DonorID], 
	Year(H.참고일) AS [ProgramYear], 
	Month(H.참고일) AS [ProgramMonth], 
	H.참고일,
	CASE
	WHEN H.기록분류 = 'TM_감사'				THEN 'Welcome'
	WHEN H.기록분류 = 'TM_감사3개월'			THEN 'Welcome 3M'
	WHEN H.기록분류 = 'TM_감사6개월'			THEN 'Welcome 6M'
	WHEN H.기록분류 like 'TM_결제실패_%'		THEN 'Debit Fail'
	WHEN H.기록분류 = 'TM_후원증액'			THEN 'New Donor Upgrade'
	WHEN H.기록분류 = 'TM_후원증액_연간'		THEN 'Annual Upgrade'
	WHEN H.기록분류 like 'TM_후원재개_%'		THEN 'Unfreeze'
	WHEN H.기록분류 = 'TM_후원재시작'			THEN 'Monthly Reactivation'
	WHEN H.기록분류 = 'TM_후원재시작_연간'	THEN 'Annual Reactivation'
	WHEN H.기록분류 = 'TM_신용카드종료예정'	THEN 'Card Expiry'
	WHEN H.기록분류 = 'TM_특별일시후원'		THEN 'Special Appeal'
	WHEN H.기록분류 = 'TM_CMS증빙'			THEN 'CMS Proof'
	END AS Category,
	CASE
	WHEN H.처리진행사항 like 'IH%' THEN 'Inhouse'
	WHEN H.처리진행사항 like 'SK%' AND 제목 like '%WV%'	THEN 'WV'
	WHEN H.처리진행사항 like 'SK%' AND 제목 like '%MPC%'	THEN 'MPC'
	WHEN H.처리진행사항 like 'SK%' AND 제목 like '%세일%'	THEN 'Sale'
	END AS Telemarketer,
	CASE WHEN H.기록분류상세 ='제외' THEN 1 ELSE 0 END	AS OptedOut,
	CASE WHEN H.기록분류상세 ='결번' THEN 1 ELSE 0 END	AS Unknown,
	CASE 
	WHEN H.기록분류상세 in ('제외','결번') THEN null 
	WHEN H.기록분류상세 != '무응' AND H.기록분류상세 != '통성-설명X' AND H.기록분류상세 != '제외' AND H.기록분류상세 != '결번' THEN 1 		
	ELSE 0 END	AS Reached,
	CASE
	WHEN H.기록분류상세 in ('무응','제외','결번', '통성-설명X') THEN NULL --OR H.처리진행사항 like '%진행' OR H.처리진행사항 like '%지연' THEN null 
	WHEN H.기록분류상세 like '%동의' THEN 1 	    
	WHEN H.기록분류상세 like '%성공' THEN 1 	    
	ELSE 0 END	AS Accepted,
	CASE 
	WHEN H.기록분류상세 not like '%동의' AND H.기록분류상세 not like '%성공' THEN NULL
	WHEN PR.회원번호 is not null THEN 1
	WHEN PR.회원번호 is not null THEN 1	
	ELSE 0 END AS Honored,
	H.기록분류,
	H.기록분류상세
FROM
	MRMRT.그린피스동아시아서울사무소0868.DBO.UV_GP_관리기록 H
LEFT JOIN
	MRMRT.그린피스동아시아서울사무소0868.DBO.UV_GP_후원자정보 D
ON
	H.회원번호 = D.회원번호
LEFT JOIN
	(
	SELECT
		*
	FROM
		MRMRT.그린피스동아시아서울사무소0868.DBO.UV_GP_결제정보 
	WHERE
		환불상태=''
	) PR
ON
	H.회원번호 = PR.회원번호 AND Month(H.참고일) = Month(PR.납부일) AND PR.납부일 >= H.참고일
WHERE
	H.기록분류 like 'TM%' 
	AND H.처리진행사항 like '%완료'
	AND CONVERT(DATE,H.참고일,126) >= CONVERT(DATE, '2018-01-01', 126)
GROUP BY
	H.회원번호, PR.회원번호, 
	H.기록분류, H.기록분류상세, H.처리진행사항, H.참고일, H.제목, D.CMS상태, D.CARD상태
