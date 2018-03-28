
--무의미한 콜 제거/제외 대상자 찾기 (특히 콜 기간이 긴 경우)
--(콜 할당시 조건과 현재 회원상태가 달라진 경우를 찾는다)
--1. 재시작콜 진행중이나 회원이 자발 재시작/ 자발 재개한 경우
--2. 특별일시콜
--3. 증액콜


--1. 재시작콜

SELECT *
FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 H
LEFT JOIN
    (SELECT 회원번호, 회원상태
     FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보
     WHERE 회원상태 = 'Normal'
    ) D
ON H.회원번호 = D.회원번호
LEFT JOIN
    (SELECT 회원번호, 기록분류, 기록분류상세, 기록일시
     FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록
     WHERE 기록분류 = 'cancellation'
    ) H2
ON H.회원번호 = H2.회원번호
WHERE H.기록분류 LIKE '%재시작%'
    AND H.처리진행사항 = 'SK-진행'
    AND (D.회원번호 IS NOT NULL
    OR H.기록일시 < H2.기록일시)


--2. 특별일시콜 제외대상


--3. 증액콜 제외대상
SELECT *
FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 H
LEFT JOIN
    (SELECT 회원번호, 기록분류, 기록분류상세, 기록일시
     FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록
     WHERE
	 기록분류 = 'cancellation'
	 OR
	 기록분류상세 IN ('후원금액downgrade','후원금액upgrade')
    ) H2
ON H.회원번호 = H2.회원번호
WHERE H.기록분류 LIKE '%증액%'
    AND H.처리진행사항 = 'SK-진행'
    AND H.기록일시 <= H2.기록일시


--증액콜 제외 추가(웹 자발 증액한 사람 - 변경이력)