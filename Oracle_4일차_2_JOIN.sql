-- ORACLE 4일차 JOIN

-- 1. JOIN
-- 두 개 이상의 테이블에서 연관성을 가지고 있는 데이터들을
-- 따로 분류하여 새로운 가상의 테이블을 만듬
-- > 여러 테이블의 레코드를 조합하여 하나의 레코드로 만듦

-- 1. ANSI 표준 구문

SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;


-- 2. ORACLE 전용 구문

SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT WHERE DEPT_CODE = DEPT_ID;


--------------------------------------------------------------------------------

@ 실습 예제

-- 1. 부서명과 지역명을 출력하세요.(DEPARTMENT, LOCATION에 테이블 이용)

SELECT DEPT_ID, DEPT_TITLE, LOCAL_NAME
FROM DEPARTMENT
JOIN LOCATION ON LOCATION_ID = LOCAL_CODE
ORDER BY 1;


-- 2. 사원명과 부서명을 출력하세요.
--    부서코드가 D5이면 총무부, D6이면 기획부, D9이면 영업부로 처리하시오.

SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
WHERE DEPT_CODE IN ('D5','D6','D9')
ORDER BY 2;


-- 3. 사원명과 직급명을 출력하세요.

SELECT EMP_NAME, JOB_NAME
FROM EMPLOYEE
-- JOIN JOB ON EMPLOYEE.JOB_CODE = JOB.JOB_CODE;
-- JOIN JOB J ON E.JOB_CODE = J.JOB_CODE;
JOIN JOB J USING(JOB_CODE); -- 컬럼명이 같을 때 USING 키워드 사용 가능


-- 4. 지역명과 국가명을 출력하세요

SELECT LOCAL_CODE, NATIONAL_NAME
FROM LOCATION
-- JOIN NATIONAL ON NATIONAL.NATIONAL_CODE = LOCATION.NATIONAL_CODE;
JOIN NATIONAL N USING(NATIONAL_CODE);


--------------------------------------------------------------------------------

-- JOIN의 종류
-- 1. INNER_JOIN : 교집합, 일반적으로 사용하는 조인
-- 2. OUTER_JOIN : 합집합, 모두 출력하는 조인 (LEFT, RIGHT)
-- 3. FULL_OUTER_JOIN


        -- EXAMPLE 1) 사원명과 부서명을 출력하시오 (교집합)
        SELECT EMP_NAME, DEPT_TITLE
        FROM EMPLOYEE
        JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;
        -- EXAMPLE 2-1) 사원명과 부서명을 출력하시오 (합집합)
        SELECT EMP_NAME, DEPT_TITLE
        FROM EMPLOYEE
        LEFT OUTER JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;
        -- LEFT에 있는 테이블 요소는 다 나오게 하도록 함
        -- EXAMPLE 2-2) 사원명과 부서명을 출력하시오 (합집합)
        SELECT EMP_NAME, DEPT_TITLE
        FROM EMPLOYEE
        RIGHT OUTER JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;
        -- RIGHT에 있는 테이블 요소는 다 나오게 하도록 함
        -- EXAMPLE 3) 사원명과 부서명을 출력하시오 (합집합)
        SELECT EMP_NAME, DEPT_TITLE
        FROM EMPLOYEE
        FULL OUTER JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;
        -- 교집합 없는 요소들 다
        
        
-- ORACLE JOIN의 종류
-- 1. INNER_JOIN : 교집합, 일반적으로 사용하는 조인
-- 2. OUTER_JOIN : 합집합, 모두 출력하는 조인 (LEFT, RIGHT)
-- 3. FULL_OUTER_JOIN -- >  없음

        -- EXAMPLE 1) 사원명과 부서명을 출력하시오 (교집합)
        SELECT EMP_NAME, DEPT_TITLE
        FROM EMPLOYEE, DEPARTMENT WHERE DEPT_CODE = DEPT_ID;
        -- EXAMPLE 2-1) 사원명과 부서명을 출력하시오 (합집합)
        SELECT EMP_NAME, DEPT_TITLE
        FROM EMPLOYEE, DEPARTMENT WHERE DEPT_CODE = DEPT_ID(+);
        -- LEFT에 있는 테이블 요소는 다 나오게 하도록 함
        -- EXAMPLE 2-2) 사원명과 부서명을 출력하시오 (합집합)
        SELECT EMP_NAME, DEPT_TITLE
        FROM EMPLOYEE, DEPARTMENT WHERE DEPT_CODE(+) = DEPT_ID;
        -- RIGHT에 있는 테이블 요소는 다 나오게 하도록 함
        
        
--------------------------------------------------------------------------------

@ JOIN 종합 실습 예제

-- 1. 주민번호가 1970년대 생이면서 성별이 여자이고, 
--    성이 전씨인 직원들의 사원명, 주민번호, 부서명, 직급명을 조회하시오.

SELECT EMP_NAME AS "사원명", EMP_NO AS "주민번호", DEPT_TITLE AS "부서명", JOB_NAME AS "직급명"
FROM EMPLOYEE
JOIN JOB ON EMPLOYEE.JOB_CODE = JOB.JOB_CODE
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
WHERE EMP_NAME LIKE '전%' AND EMP_NO LIKE '7_%-2%';


-- 2. 이름에 '형'자가 들어가는 직원들의 사번, 사원명, 부서명을 조회하시오.

SELECT EMP_ID AS "사번", EMP_NAME AS "사원명", DEPT_TITLE AS "부서명"
FROM EMPLOYEE
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
WHERE EMP_NAME LIKE '%형%';


-- 3. 해외영업부에 근무하는 사원명, 직급명, 부서코드, 부서명을 조회하시오.

SELECT EMP_NAME AS "사원명", JOB_NAME AS "직급명", DEPT_CODE AS "부서코드", DEPT_TITLE AS "부서명"
FROM EMPLOYEE
JOIN JOB ON EMPLOYEE.JOB_CODE = JOB.JOB_CODE
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
WHERE DEPT_CODE IN ('D5', 'D6', 'D7') -- LIKE '해외영업_부';
ORDER BY 4;


-- 4. 보너스포인트를 받는 직원들의 사원명, 보너스포인트, 부서명, 근무지역명을 조회하시오.

SELECT EMP_NAME AS "사원명", BONUS AS "보너스포인트", DEPT_TITLE AS "부서명", LOCAL_NAME AS "근무지역명"
FROM EMPLOYEE
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
JOIN LOCATION ON LOCATION_ID = LOCAL_CODE
WHERE BONUS IS NOT NULL
ORDER BY 3;


-- 5. 부서코드가 D2인 직원들의 사원명, 직급명, 부서명, 근무지역명을 조회하시오.

SELECT EMP_NAME AS "사원명", JOB_NAME AS "직급명", DEPT_TITLE AS "부서명", LOCAL_NAME AS "근무지역명"
FROM EMPLOYEE
JOIN JOB ON EMPLOYEE.JOB_CODE = JOB.JOB_CODE
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
JOIN LOCATION ON LOCATION_ID = LOCAL_CODE
WHERE DEPT_CODE IN ('D2'); -- WHERE DEPT_CODE = 'D2';


-- 6. 급여등급테이블의 최대급여(MAX_SAL)보다 많이 받는 직원들의 사원명, 직급명, 급여, 연봉을 조회하시오.
--    (사원테이블과 급여등급테이블을 SAL_LEVEL컬럼기준으로 조인할 것)
--    답 : 데이터 없음!

SELECT EMP_NAME AS "사원명", JOB_NAME AS "직급명", SALARY AS "급여", (SALARY*12) AS "연봉"
FROM EMPLOYEE
JOIN JOB ON EMPLOYEE.JOB_CODE = JOB.JOB_CODE -- JOIN JOB USING(JOB_CODE)
JOIN SAL_GRADE ON EMPLOYEE.SAL_LEVEL = SAL_GRADE.SAL_LEVEL -- JOIN SAL_GRADE USING(SAL_LEVEL)
WHERE SALARY > SAL_GRADE.MAX_SAL;


-- 7. 한국(KO)과 일본(JP)에 근무하는 직원들의 사원명, 부서명, 지역명, 국가명을 조회하시오.

SELECT EMP_NAME AS "사원명", DEPT_TITLE AS "부서명", LOCAL_NAME AS "지역명", NATIONAL_NAME AS "국가명"
FROM EMPLOYEE
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
JOIN LOCATION ON LOCATION_ID = LOCAL_CODE
JOIN NATIONAL N USING(NATIONAL_CODE)
-- WHERE LOCATION.LOCAL_CODE IN ('L1', 'L2')
WHERE NATIONAL_NAME IN ('한국', '일본')
ORDER BY 3;


--8. 보너스포인트가 없는 직원들 중에서 직급이 차장과 사원인 직원들의 사원명, 직급명, 급여를 조회하시오. 
--   단, join과 IN 사용할 것

SELECT EMP_NAME AS "사원명", JOB_NAME AS "직급명", SALARY AS "급여"
FROM EMPLOYEE
JOIN JOB ON EMPLOYEE.JOB_CODE = JOB.JOB_CODE
WHERE BONUS IS NULL AND JOB.JOB_CODE IN ('J4', 'J7')
ORDER BY 2;


-- 9. 재직중인 직원과 퇴사한 직원의 수를 조회하시오.

SELECT DECODE(ENT_YN, 'Y', '퇴사한 직원', 'N', '재직 중인 직원') AS "퇴사여부", COUNT(*) AS "인원수"
FROM EMPLOYEE
GROUP BY ENT_YN, DECODE(ENT_YN, 'Y', '퇴사한 직원', 'N', '재직 중인 직원');


-----------------------------------------------
                    COMMIT;
-----------------------------------------------