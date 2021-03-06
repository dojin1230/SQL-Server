-- CMS 증빙자료 등록필요한 경우 (LC가입자/SK-지연) 에이전시에 전달

SELECT D.회원번호, D.납부방법, D.CMS상태, D.CARD상태, D.가입경로, D.소속, D.가입일, D.회원상태, D.납부여부, D.납부금액, D.최초입력일, D.CMS증빙자료등록필요
FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보 D
WHERE D.가입경로 = 'Lead Conversion'
AND D.CMS증빙자료등록필요 = 'Y'
AND D.회원상태 = 'Normal'
AND D.가입일 >= '2018-01-01'




-- CMS 증빙 콜 --

SELECT D.회원번호, D.납부방법, D.CMS상태, D.CARD상태, D.가입경로, D.가입일, D.회원상태, D.납부여부, D.납부금액, D.최초입력일, D.CMS증빙자료등록필요
FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보 D
LEFT JOIN
(SELECT 회원번호
FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록
WHERE 기록분류상세 = '결번'
OR 기록구분2 LIKE '%1%'
OR (기록분류 LIKE '%감사%' AND 처리진행사항 LIKE '%진행')
OR (기록분류 LIKE '%CMS%' AND 처리진행사항 LIKE '%진행')
OR 처리진행사항 = 'SK-지연'
OR (기록분류 = 'cancellation' AND 처리진행사항 LIKE '%지연')
) TMP1		-- 제외조건 1: 관리기록상 제외조건 (결번, 후원자반응, 감사진행, CMS진행, SK-지연, 캔슬지연)
ON D.회원번호 = TMP1.회원번호
LEFT JOIN
(SELECT 회원번호
FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보
WHERE 가입경로 = 'Lead Conversion'
AND CMS증빙자료등록필요 = 'Y'
AND 회원상태 = 'Normal'
AND 가입일 >= '2018-01-01'
) TMP2		-- 제외조건 2: TM에이전시에서 증빙 등록해야 하는 경우
ON D.회원번호 = TMP2.회원번호
LEFT JOIN
(SELECT 회원번호
FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보
WHERE 휴대전화번호 = '무'
OR 등록구분 = '외국인'
OR 최초등록구분 = '일시'   -- 확인필요
) TMP3		-- 제외조건 3: 번호없음, 외국인, 최초등록일시
ON D.회원번호 = TMP3.회원번호
WHERE D.회원상태 = 'Normal'
AND (
(D.CMS상태 LIKE '%대기' AND D.CMS증빙자료등록필요 = 'Y')
OR D.CMS상태 LIKE '%실패'
OR D.CARD상태 = '승인대기' )
AND D.최초입력일 < CONVERT(DATE,GETDATE())
AND TMP1.회원번호 IS NULL
AND TMP2.회원번호 IS NULL
AND TMP3.회원번호 IS NULL
