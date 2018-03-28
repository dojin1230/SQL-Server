USE REPORT
GO
-- 원래 데이터 백업 받기
--

select * from
	MRMRT.그린피스동아시아서울사무소0868.DBO.UV_GP_후원자정보 D

SELECT -- Non-Reactivation
	D.회원번호 AS [Constituent_id], 
	D.가입일 AS [Join Date],
	Year(D.가입일) AS [Year],
	Month(D.가입일) AS [Month],
	CASE 
	WHEN D.가입경로 = N'거리모집' THEN 'DDC'
	WHEN D.가입경로 = N'인터넷/홈페이지' THEN 'Web'
	WHEN D.가입경로 = N'Lead Conversion' THEN D.가입경로
	ELSE 'Other'
	END AS [Source],
	CASE 
	WHEN D.소속 is null OR D.소속 ='Inhouse' THEN 'Inhouse'
	ELSE 'OutSourcing'
	END AS [SubSource],
	CASE WHEN EOMONTH(D.가입일,3) >= PRMIN.최초납부일 THEN 0 ELSE 1 END AS [Predebit],
	SUM	(CASE WHEN SUBSTRING(D.가입일,1,7) = PR.귀속년월 THEN 1 ELSE 0 END) AS [1],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, D.가입일)+1, 0), 126) = PR.귀속년월 THEN 1 
	WHEN DATEADD(mm, DATEDIFF(mm, 0, D.가입일)+1, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [2],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, D.가입일)+2, 0), 126) = PR.귀속년월 THEN 1 
	WHEN DATEADD(mm, DATEDIFF(mm, 0, D.가입일)+2, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [3],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, D.가입일)+3, 0), 126) = PR.귀속년월 THEN 1
	WHEN DATEADD(mm, DATEDIFF(mm, 0, D.가입일)+3, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [4],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, D.가입일)+4, 0), 126) = PR.귀속년월 THEN 1
	WHEN DATEADD(mm, DATEDIFF(mm, 0, D.가입일)+4, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [5],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, D.가입일)+5, 0), 126) = PR.귀속년월 THEN 1
	WHEN DATEADD(mm, DATEDIFF(mm, 0, D.가입일)+5, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [6],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, D.가입일)+6, 0), 126) = PR.귀속년월 THEN 1
	WHEN DATEADD(mm, DATEDIFF(mm, 0, D.가입일)+6, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [7],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, D.가입일)+7, 0), 126) = PR.귀속년월 THEN 1
	WHEN DATEADD(mm, DATEDIFF(mm, 0, D.가입일)+7, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [8],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, D.가입일)+8, 0), 126) = PR.귀속년월 THEN 1
	WHEN DATEADD(mm, DATEDIFF(mm, 0, D.가입일)+8, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [9],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, D.가입일)+9, 0), 126) = PR.귀속년월 THEN 1
	WHEN DATEADD(mm, DATEDIFF(mm, 0, D.가입일)+9, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [10],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, D.가입일)+10, 0), 126) = PR.귀속년월 THEN 1
	WHEN DATEADD(mm, DATEDIFF(mm, 0, D.가입일)+10, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [11],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, D.가입일)+11, 0), 126) = PR.귀속년월 THEN 1
	WHEN DATEADD(mm, DATEDIFF(mm, 0, D.가입일)+11, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [12],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, D.가입일)+12, 0), 126) = PR.귀속년월 THEN 1
	WHEN DATEADD(mm, DATEDIFF(mm, 0, D.가입일)+12, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [13],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, D.가입일)+13, 0), 126) = PR.귀속년월 THEN 1
	WHEN DATEADD(mm, DATEDIFF(mm, 0, D.가입일)+13, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [14],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, D.가입일)+14, 0), 126) = PR.귀속년월 THEN 1
	WHEN DATEADD(mm, DATEDIFF(mm, 0, D.가입일)+14, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [15],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, D.가입일)+15, 0), 126) = PR.귀속년월 THEN 1
	WHEN DATEADD(mm, DATEDIFF(mm, 0, D.가입일)+15, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [16],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, D.가입일)+16, 0), 126) = PR.귀속년월 THEN 1
	WHEN DATEADD(mm, DATEDIFF(mm, 0, D.가입일)+16, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [17],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, D.가입일)+17, 0), 126) = PR.귀속년월 THEN 1
	WHEN DATEADD(mm, DATEDIFF(mm, 0, D.가입일)+17, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [18],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, D.가입일)+18, 0), 126) = PR.귀속년월 THEN 1
	WHEN DATEADD(mm, DATEDIFF(mm, 0, D.가입일)+18, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [19],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, D.가입일)+19, 0), 126) = PR.귀속년월 THEN 1
	WHEN DATEADD(mm, DATEDIFF(mm, 0, D.가입일)+19, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [20],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, D.가입일)+20, 0), 126) = PR.귀속년월 THEN 1
	WHEN DATEADD(mm, DATEDIFF(mm, 0, D.가입일)+20, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [21],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, D.가입일)+21, 0), 126) = PR.귀속년월 THEN 1
	WHEN DATEADD(mm, DATEDIFF(mm, 0, D.가입일)+21, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [22],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, D.가입일)+22, 0), 126) = PR.귀속년월 THEN 1
	WHEN DATEADD(mm, DATEDIFF(mm, 0, D.가입일)+22, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [23],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, D.가입일)+23, 0), 126) = PR.귀속년월 THEN 1
	WHEN DATEADD(mm, DATEDIFF(mm, 0, D.가입일)+23, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [24],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, D.가입일)+35, 0), 126) = PR.귀속년월 THEN 1
	WHEN DATEADD(mm, DATEDIFF(mm, 0, D.가입일)+35, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [36],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, D.가입일)+47, 0), 126) = PR.귀속년월 THEN 1
	WHEN DATEADD(mm, DATEDIFF(mm, 0, D.가입일)+47, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [48]
INTO
	[report].[dbo].[success_rate]
FROM
	MRMRT.그린피스동아시아서울사무소0868.DBO.UV_GP_후원자정보 D
LEFT JOIN
	(
	SELECT
		회원번호, 귀속년월
	FROM
		MRMRT.그린피스동아시아서울사무소0868.DBO.UV_GP_결제정보 
	WHERE
		정기수시 = N'정기' AND 환불상태 != N'전체환불'
	GROUP BY
		회원번호, 귀속년월
	) PR	
ON
	D.회원번호 = PR.회원번호
LEFT JOIN
	(
	SELECT
		회원번호, MIN(납부일) AS 최초납부일
	FROM
		MRMRT.그린피스동아시아서울사무소0868.DBO.UV_GP_결제정보 
	WHERE
		정기수시 = N'정기' AND 환불상태 != N'전체환불'
	GROUP BY
		회원번호
	) PRMIN	
ON
	D.회원번호 = PRMIN.회원번호
WHERE
	D.최초등록구분 = N'정기'
	AND D.가입일 < DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0)
GROUP BY
	D.회원번호, D.가입경로, D.가입일, D.최초납부년월, D.소속, PRMIN.최초납부일
UNION ALL		
SELECT -- Reactivation
	H.회원번호 AS [Constituent_id], 
	H.가입일 AS [Join Date],
	Year(H.가입일) AS [Year],
	Month(H.가입일) AS [Month],
	'Reactivation' AS [Source],
	'Inhouse' AS [SubSource],
	CASE WHEN EOMONTH(H.가입일,3) >= PRMIN.최초납부일 THEN 0 ELSE 1 END AS [Predebit],
	SUM	(CASE WHEN SUBSTRING(H.가입일,1,7) = PRPAY.귀속년월 THEN 1 ELSE 0 END) AS [1],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, H.가입일)+1, 0), 126) = PRPAY.귀속년월 THEN 1 
	WHEN DATEADD(mm, DATEDIFF(mm, 0, H.가입일)+1, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [2],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, H.가입일)+2, 0), 126) = PRPAY.귀속년월 THEN 1 
	WHEN DATEADD(mm, DATEDIFF(mm, 0, H.가입일)+2, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [3],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, H.가입일)+3, 0), 126) = PRPAY.귀속년월 THEN 1
	WHEN DATEADD(mm, DATEDIFF(mm, 0, H.가입일)+3, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [4],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, H.가입일)+4, 0), 126) = PRPAY.귀속년월 THEN 1
	WHEN DATEADD(mm, DATEDIFF(mm, 0, H.가입일)+4, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [5],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, H.가입일)+5, 0), 126) = PRPAY.귀속년월 THEN 1
	WHEN DATEADD(mm, DATEDIFF(mm, 0, H.가입일)+5, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [6],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, H.가입일)+6, 0), 126) = PRPAY.귀속년월 THEN 1
	WHEN DATEADD(mm, DATEDIFF(mm, 0, H.가입일)+6, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [7],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, H.가입일)+7, 0), 126) = PRPAY.귀속년월 THEN 1
	WHEN DATEADD(mm, DATEDIFF(mm, 0, H.가입일)+7, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [8],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, H.가입일)+8, 0), 126) = PRPAY.귀속년월 THEN 1
	WHEN DATEADD(mm, DATEDIFF(mm, 0, H.가입일)+8, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [9],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, H.가입일)+9, 0), 126) = PRPAY.귀속년월 THEN 1
	WHEN DATEADD(mm, DATEDIFF(mm, 0, H.가입일)+9, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [10],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, H.가입일)+10, 0), 126) = PRPAY.귀속년월 THEN 1
	WHEN DATEADD(mm, DATEDIFF(mm, 0, H.가입일)+10, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [11],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, H.가입일)+11, 0), 126) = PRPAY.귀속년월 THEN 1
	WHEN DATEADD(mm, DATEDIFF(mm, 0, H.가입일)+11, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [12],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, H.가입일)+12, 0), 126) = PRPAY.귀속년월 THEN 1
	WHEN DATEADD(mm, DATEDIFF(mm, 0, H.가입일)+12, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [13],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, H.가입일)+13, 0), 126) = PRPAY.귀속년월 THEN 1
	WHEN DATEADD(mm, DATEDIFF(mm, 0, H.가입일)+13, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [14],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, H.가입일)+14, 0), 126) = PRPAY.귀속년월 THEN 1
	WHEN DATEADD(mm, DATEDIFF(mm, 0, H.가입일)+14, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [15],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, H.가입일)+15, 0), 126) = PRPAY.귀속년월 THEN 1
	WHEN DATEADD(mm, DATEDIFF(mm, 0, H.가입일)+15, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [16],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, H.가입일)+16, 0), 126) = PRPAY.귀속년월 THEN 1
	WHEN DATEADD(mm, DATEDIFF(mm, 0, H.가입일)+16, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [17],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, H.가입일)+17, 0), 126) = PRPAY.귀속년월 THEN 1
	WHEN DATEADD(mm, DATEDIFF(mm, 0, H.가입일)+17, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [18],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, H.가입일)+18, 0), 126) = PRPAY.귀속년월 THEN 1
	WHEN DATEADD(mm, DATEDIFF(mm, 0, H.가입일)+18, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [19],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, H.가입일)+19, 0), 126) = PRPAY.귀속년월 THEN 1
	WHEN DATEADD(mm, DATEDIFF(mm, 0, H.가입일)+19, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [20],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, H.가입일)+20, 0), 126) = PRPAY.귀속년월 THEN 1
	WHEN DATEADD(mm, DATEDIFF(mm, 0, H.가입일)+20, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [21],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, H.가입일)+21, 0), 126) = PRPAY.귀속년월 THEN 1
	WHEN DATEADD(mm, DATEDIFF(mm, 0, H.가입일)+21, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [22],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, H.가입일)+22, 0), 126) = PRPAY.귀속년월 THEN 1
	WHEN DATEADD(mm, DATEDIFF(mm, 0, H.가입일)+22, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [23],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, H.가입일)+23, 0), 126) = PRPAY.귀속년월 THEN 1
	WHEN DATEADD(mm, DATEDIFF(mm, 0, H.가입일)+23, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [24],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, H.가입일)+35, 0), 126) = PRPAY.귀속년월 THEN 1
	WHEN DATEADD(mm, DATEDIFF(mm, 0, H.가입일)+35, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [36],
	SUM	(CASE WHEN CONVERT(varchar(7), DATEADD(mm, DATEDIFF(mm, 0, H.가입일)+47, 0), 126) = PRPAY.귀속년월 THEN 1
	WHEN DATEADD(mm, DATEDIFF(mm, 0, H.가입일)+47, 0) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) THEN NULL ELSE 0 	END) AS [48]
FROM
	(
	SELECT
		회원번호, MAX(참고일) AS 가입일
	FROM
		MRMRT.그린피스동아시아서울사무소0868.DBO.UV_GP_관리기록
	WHERE
		기록분류 like N'TM_후원재시작%' AND 기록분류상세=N'통성-재시작동의'
	GROUP BY
		회원번호
	) H
LEFT JOIN
	(
	SELECT
		A.회원번호, MIN(PR.납부일) 최초납부일
	FROM
		(
		SELECT
			회원번호, MAX(참고일) AS 가입일
		FROM
			MRMRT.그린피스동아시아서울사무소0868.DBO.UV_GP_관리기록
		WHERE
			기록분류 like N'TM_후원재시작%' AND 기록분류상세=N'통성-재시작동의'
		GROUP BY
			회원번호
		) A
	LEFT JOIN
		(
		SELECT
			회원번호, 납부일
		FROM
			MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_결제정보 
		WHERE
			정기수시 = N'정기' AND 환불상태 != N'전체환불'
		) PR
	ON	
		A.회원번호 = PR.회원번호
	WHERE
		PR.납부일 >= A.가입일
	GROUP BY
		A.회원번호
	) PRMIN
ON
	H.회원번호 = PRMIN.회원번호
LEFT JOIN
	(
	SELECT
		B.회원번호, PR.귀속년월
	FROM
		(
		SELECT
			회원번호, MAX(참고일) AS 가입일
		FROM
			MRMRT.그린피스동아시아서울사무소0868.DBO.UV_GP_관리기록
		WHERE
			기록분류 like N'TM_후원재시작%' AND 기록분류상세=N'통성-재시작동의'
		GROUP BY
			회원번호
		) B
	LEFT JOIN
		(
		SELECT
			회원번호, 귀속년월
		FROM
			MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_결제정보 
		WHERE
			정기수시 = N'정기' AND 환불상태 != N'전체환불'		
		) PR
	ON	
		B.회원번호 = PR.회원번호
	WHERE
		CONCAT(PR.귀속년월,'-01') >= CONVERT(varchar(10), DATEADD(mm, DATEDIFF(mm, 0, B.가입일), 0), 126)
	GROUP BY
		B.회원번호, PR.귀속년월
	) PRPAY
ON
	H.회원번호 = PRPAY.회원번호
WHERE
	H.가입일 < DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0)
GROUP BY
	H.회원번호, H.가입일, PRMIN.최초납부일