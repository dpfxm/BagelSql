-- ORACLE 4일차

-- 1. 그룹함수 
-- 특정한 행들의 집합으로 그룹이 형성되어 적용됨,
-- 그룹당 1개의 결과를 반환, 결과 딱 1행만 나옴.

SELECT TO_CHAR(SALARY, 'L999,999,999') FROM EMPLOYEE;
SELECT SUM(SALARY) FROM EMPLOYEE;
SELECT AVG(SALARY) FROM EMPLOYEE;
SELECT COUNT(SALARY) FROM EMPLOYEE;
SELECT MAX(SALARY) FROM EMPLOYEE;
SELECT MIN(SALARY) FROM EMPLOYEE;


--------------------------------------------------------------------------------
--                                GROUP BY 절                                 --
--------------------------------------------------------------------------------

-- 별도의 그룹 지정업이 사용한 그룹함수는 단 한 개의 결과값만 산출함
-- 그룹함수를 이용하여 여러개의 결과값을 산출하기 위해서는 그룹함수가 적용됨
-- 그룹의 기준을 GROUP BY 절에 기술하여 사용하면 됨

        -- EXAMPLE 1) EMPLOYEE 테이블에서 부서별 사원의 월급의 합을 구하시오.
        SELECT SUM(SALARY), DEPT_CODE FROM EMPLOYEE
        GROUP BY DEPT_CODE;
        -- EXAMPLE 2) EMPLOYEE 테이블에서 직급별 사원의 월급의 합을 구하시오.
        SELECT SUM(SALARY), JOB_CODE FROM EMPLOYEE
        GROUP BY JOB_CODE;


--------------------------------------------------------------------------------
--                                 HAVING 절                                  --
--------------------------------------------------------------------------------    

-- SELECT * FROM EMPLOYEE WHERE ~ (WHERE 조건절)
-- SELECT SUM(SALARY) FROM EMPLOYEE GROUP BY DEPT_CODE HAVING (HAVING 조건절)
-- 그룹함수로 값을 구해온 그룹에 대해 조건을 설정할 때 사용함
-- WHERE 절과 구별해서 사용할 줄 알아야 함

        -- EXAMPLE 1) EMPLOYEE 테이블에서 부서별 인원이 5명보다 많은 부서를 구하시오.
        SELECT DEPT_CODE, COUNT(*) AS "부서별 인원"
        FROM EMPLOYEE
        GROUP BY DEPT_CODE HAVING COUNT(*) > 5;
        -- EXAMPLE 2) EMPLOYEE 테이블에서 부서 내에서 직급별로 인원수가 3명 이상인 부서 코드, 
        -- 직급 코드, 인원수를 구하시오.
        SELECT DEPT_CODE, JOB_CODE, COUNT(SALARY) AS "직급별 인원"
        FROM EMPLOYEE
        GROUP BY DEPT_CODE, JOB_CODE HAVING COUNT(*) >= 3
        ORDER BY 2;
        -- EXAMPLE 3) 매니저가 관리하는 사원이 2명 이상인 매니저 아이디와 관리하는 사원수를 출력하시오.
        SELECT MANAGER_ID, COUNT(*) AS "관리하는 사원수"
        FROM EMPLOYEE
        -- WHERE MANAGER_ID IS NOT NULL
        GROUP BY MANAGER_ID HAVING COUNT(*) >= 2 AND MANAGER_ID IS NOT NULL -- 결과값 자체에서 뺄 때
        ORDER BY 1;


--------------------------------------------------------------------------------
--                                 ROLLUP 절                                  --
--------------------------------------------------------------------------------  

-- 인자로 전달받은 그룹 중에 가장 먼저 지정한 그룹별 합계와 총 합계를 구한다.

        -- EXAMPLE 1) EMPLOYEE 테이블에서 부서별 급여 합계를 ROLLUP으로 출력해보시오.
        SELECT DEPT_CODE, SUM(SALARY)
        FROM EMPLOYEE
        GROUP BY ROLLUP(DEPT_CODE);
        -- HAVING DEPT_CODE IS NOT NULL; -- > 결과값 전에 빼려면 WHERE 사용하기
        -- EXAMPLE 2) EMPLOYEE 테이블에서 부서 내 직급별 급여 합계를 ROLLUP으로 출력해보시오.
        SELECT DEPT_CODE, JOB_CODE, SUM(SALARY)
        FROM EMPLOYEE
        GROUP BY ROLLUP(DEPT_CODE, JOB_CODE);


--------------------------------------------------------------------------------
--                                  CUBE 절                                   --
--------------------------------------------------------------------------------  

-- 그룹으로 지정된 모든 그룹에 대한 합계와 총 합계를 구한다.
-- ROLLUP보다 출력되는 결과가 많음!

        -- EXAMPLE 1) EMPLOYEE 테이블에서 부서별 급여 합계를 ROLLUP으로 출력해보시오.
        SELECT DEPT_CODE, SUM(SALARY)
        FROM EMPLOYEE
        GROUP BY CUBE(DEPT_CODE);
        -- EXAMPLE 2) EMPLOYEE 테이블에서 부서 내 직급별 급여 합계를 ROLLUP으로 출력해보시오.
        SELECT DEPT_CODE, JOB_CODE, SUM(SALARY)
        FROM EMPLOYEE
        GROUP BY CUBE(DEPT_CODE, JOB_CODE);
        -- 직급 별 할계를 추가해서 출력해줌
        

--------------------------------------------------------------------------------
        
-- 2. 집합 연산자 (SET OPERTION)

-- UNION, UNION ALL
-- 조건 1. 컬럼의 갯수가 같을 것
-- 조건 2. 컬럼의 타입이 같을 것

        -- EXAMPLE 1) UNION
        SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
        FROM EMPLOYEE
        WHERE DEPT_CODE = 'D5'
        UNION
        SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
        FROM EMPLOYEE
        WHERE SALARY > 3000000;
        -- EXAMPLE 1-1) UNION, 컬럼의 이름이 다를 때
        SELECT EMP_ID, EMP_NAME, JOB_CODE AS "DEPT_OR_JOB_CODE", SALARY
        FROM EMPLOYEE
        WHERE DEPT_CODE = 'D5'
        UNION
        SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
        FROM EMPLOYEE
        WHERE SALARY > 3000000;
        -- EXAMPLE 2) UNION ALL
        SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
        FROM EMPLOYEE
        WHERE DEPT_CODE = 'D5'
        UNION ALL
        SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
        FROM EMPLOYEE
        WHERE SALARY > 3000000;
        -- EXAMPLE 3) INTERSECT(교집합, 겹쳐진거)
        SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
        FROM EMPLOYEE
        WHERE DEPT_CODE = 'D5'
        INTERSECT
        SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
        FROM EMPLOYEE
        WHERE SALARY > 3000000;
        -- EXAMPLE 3) MINUS (차집합)
        SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
        FROM EMPLOYEE
        WHERE DEPT_CODE = 'D5'
        MINUS
        SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
        FROM EMPLOYEE
        WHERE SALARY > 3000000;
        -- EXAMPLE 4) ROLLUP 설명시 UNION 사용
        SELECT DEPT_CODE, SUM(SALARY)
        FROM EMPLOYEE
        GROUP BY DEPT_CODE
        MINUS
        SELECT SUM(SALARY), NULL
        FROM EMPLOYEE;
        

--------------------------------------------------------------------------------

@ 실습 예제

-- 1. EMPLOYEE 테이블에서 부서코드 그룹별 급여희 합계, 그룹별 급여의 평균(정수처리), 인원수를 조회하고 
--    부서코드 순으로 정렬하시오.

SELECT DEPT_CODE "부서코드", SUM(SALARY) "급여의 합계", FLOOR(AVG(SALARY)) "급여의 평균", COUNT(*) "인원수"
FROM EMPLOYEE
-- WHERE DEPT_CODE IS NOT NULL
GROUP BY DEPT_CODE
ORDER BY DEPT_CODE;


-- 2. EMPLOYEE 테이블에서 부서코드 그룹별, 보너스를 지급받는 사원 수를 조회하고 부서코드 순으로 정렬하시오,
--    BONUS 칼럼의 값이 존재한다면 그 행을 1로 카운팅, 보너스를 지급받는 사원이 없는 부서도 았음.

SELECT DEPT_CODE "부서코드", COUNT(BONUS) "보너스를 지급받는 사원 수"
FROM EMPLOYEE
WHERE BONUS IS NOT NULL
GROUP BY DEPT_CODE
ORDER BY DEPT_CODE;


-- 3. EMPLOYEE 테이블에서 직급이 J1인 사람들을 제외하고 직급별 사원수 및 평균급여를 출력하세요.

SELECT JOB_CODE AS "직급코드", FLOOR(AVG(SALARY)) AS "평균급여", COUNT(*) AS "사원수"
FROM EMPLOYEE
WHERE JOB_CODE != 'J1'
-- WHERE JOB_CODE NOT IN ('J1')
GROUP BY JOB_CODE
ORDER BY JOB_CODE;


-- 4. EMPLOYEE 테이블에서 직급이 J1인 사람들을 제외하고 입사년도별 인원수를 조회해서,
--    입사년도 기준으로 오름파순으로 정렬하세요.

SELECT COUNT(HIRE_DATE) AS "입사년도별 인원수", EXTRACT(YEAR FROM HIRE_DATE)
FROM EMPLOYEE
WHERE JOB_CODE <> 'J1'
GROUP BY EXTRACT(YEAR FROM HIRE_DATE)
ORDER BY EXTRACT(YEAR FROM HIRE_DATE);


-- 5. EMPLOYEE 테이블에서 EMP_NO의 8번째 자리가 1, 3이면 '남', 2, 4이면 '여'로 결과를 조회하고,
--    성별별 급여의 평균(정수처리), 급여의 합계, 인원수를 조회한 뒤 인원수로 내림차순을 정렬하시오.

SELECT DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남', '2', '여') AS "성별", COUNT(*) AS "인원수", 
FLOOR(AVG(SALARY)) AS "급여평균", SUM(SALARY) AS "급여합"
FROM EMPLOYEE
GROUP BY DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남', '2', '여')
ORDER BY COUNT(DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남', '2', '여'));


-- 6. 부서 내 직급별 급여의 합계를 구하시오.

SELECT DEPT_CODE, JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE, JOB_CODE
ORDER BY DEPT_CODE;


-- 7. 부서 내 성별 인원수를 구하시오.

SELECT DEPT_CODE, DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남', '2', '여') AS "성별", COUNT(*) || '명' "인원수"
FROM EMPLOYEE
GROUP BY DEPT_CODE, DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남', '2', '여')
ORDER BY DEPT_CODE;


-----------------------------------------------
                    COMMIT;
-----------------------------------------------