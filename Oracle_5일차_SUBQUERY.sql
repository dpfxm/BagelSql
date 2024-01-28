-- ORACLE 5일차 서브쿼리

-- 서브쿼리(SubQuery)의 종류

-- 1. 단일행 서브쿼리
-- 2. 다중행 서브쿼리
-- 3. 다중열 서브쿼리서
-- 4. 다중행 다중열 서브쿼리
-- 5. 상(호연)관 서브쿼리
-- 6. 스칼라 서브쿼리


--------------------------------------------------------------------------------
--                                단일행 서브쿼리                                 --
--------------------------------------------------------------------------------

-- 하나의 SQL문 안에 포함되어 있는 또 다른 SQL문
-- 메인 쿼리가 서브 쿼리를 포함하는 종속적인 관계
-- 서브쿼리는 반드시 소괄호로 묶어야 함!
-- 서브쿼리 안에 ORDER BY는 지원 안 됨!


        -- EXAMPLE 1) 전지연 직원의 관리자 이름을 출력하세요.
        -- Step 1. 우선 전지연 직원의 정보를 확인해보자.
        SELECT MANAGER_ID FROM EMPLOYEE WHERE EMP_NAME LIKE '전지연';
        -- Step 2. MANAGER_ID가 214인 사람의 이름 확인.
        SELECT EMP_NAME FROM EMPLOYEE WHERE EMP_ID = '214'; --  > '방명수'인 것을 확인 완료
        -- < ----------  이 부분이 메인쿼리 ---------- >< -------------------  이 부분이 서브쿼리 ------------------- >
        SELECT EMP_NAME FROM EMPLOYEE WHERE EMP_ID = (SELECT MANAGER_ID FROM EMPLOYEE WHERE EMP_NAME LIKE '전지연');
        
        -- EXAMPLE 2) 전 직원의 평균 급여보다 많은 급여를 받고 있는 직원의 사번, 이름, 직급코드, 급여를 출력하세요.
        -- Step 1. 우선 전 직원의 평균 급여를 출력해보자.
        SELECT AVG(SALARY)
        FROM EMPLOYEE;
        -- Step 2. 서브쿼리 안에 평균 급여 코드를 삽입!
        SELECT EMP_ID AS "사번", EMP_NAME AS "이름", JOB_CODE AS "직급코드", SALARY AS "급여" FROM EMPLOYEE
        -- < ------------------------------------  이 부분이 메인쿼리 ------------------------------------ >
        WHERE SALARY > (SELECT AVG(SALARY) FROM EMPLOYEE);
        -- ----------> < ------  이 부분이 서브쿼리 ------ >


--------------------------------------------------------------------------------
--                                다중행 서브쿼리                                 --
--------------------------------------------------------------------------------

        -- EXAMPLE 1) 송종기나 박나라가 속한 부서에 속한 직원들의 전체 정보를 출력하세요
        -- Step 1. 우선 송종기와 박나라가 속한 부서의 정보를 확인해보자.
        SELECT * FROM EMPLOYEE WHERE DEPT_CODE = (SELECT DEPT_CODE FROM EMPLOYEE WHERE EMP_NAME LIKE '송종기')
        UNION
        SELECT * FROM EMPLOYEE WHERE DEPT_CODE = (SELECT DEPT_CODE FROM EMPLOYEE WHERE EMP_NAME LIKE '박나라');
        -- **다중행 서브쿼리를 이용 시 = 대신 IN을 사용!**
        SELECT * FROM EMPLOYEE 
        WHERE DEPT_CODE IN (SELECT DEPT_CODE FROM EMPLOYEE WHERE EMP_NAME IN ('송종기', '박나라'));
        
        -- EXAMPLE 2) 차태연, 전지연 사원의 급여등급과 같은 사원의 직급명, 사원명을 출력하세요.
        SELECT EMP_NAME "사원명", JOB_NAME "직급명" FROM EMPLOYEE
        JOIN JOB ON EMPLOYEE.JOB_CODE = JOB.JOB_CODE
        WHERE SAL_LEVEL IN (SELECT SAL_LEVEL FROM EMPLOYEE WHERE EMP_NAME IN ('차태연', '전지연'));
        
        -- EXAMPLE 3) ASIA1 지역에 근무하는 직원의 정보(부서코드 , 사원명)을 출력하세요.
        SELECT EMP_NAME AS "사원명", DEPT_CODE AS "부서코드" FROM EMPLOYEE
        WHERE DEPT_CODE  IN (SELECT DEPT_ID FROM DEPARTMENT
        JOIN LOCATION ON LOCATION_ID = LOCAL_CODE WHERE LOCAL_NAME = ('ASIA1'));
        
        
--------------------------------------------------------------------------------
--                              상(호연)관 서브쿼리                               --
--------------------------------------------------------------------------------

-- 메인쿼리의 값을 서브쿼리에 주고 서브쿼리를 수행한 다음 그 결과를 다시 메인쿼리로 반환해서 수행
-- 상호연관 관계를 가지고 실행하는 쿼리
-- > 서브쿼리의 WHERE절 수행을 위해서 메인쿼리가 먼저 수행되는 구조
-- > 메인쿼리 테이블의 레코드에 따라 서브쿼리의 결과값도 바뀜


        -- EXAMPLE 1) 부하직원이 한 명이라도 있는 직원의 정보를 출력하시오.
        SELECT * FROM EMPLOYEE WHERE 1 = 1;
        SELECT * FROM EMPLOYEE ORDER BY MANAGER_ID;
        -- EMP_ID로 MANAGER_ID를 조회했을 때 존재하면 해당 행을 출력하도록 하려면!
        -- < ---- 이 부분이 메인쿼리 ---- >< ---------------  이 부분이 서브쿼리 --------------- >
        SELECT * FROM EMPLOYEE E WHERE EXISTS (SELECT 1 FROM EMPLOYEE WHERE MANAGER_ID = E.EMP_ID);
        
        -- EXAMPLE 2-1) 가장 많은 급여를 받는 직원을 출력하시오.
        SELECT MAX(SALARY) FROM EMPLOYEE;
        SELECT * FROM EMPLOYEE WHERE SALARY = (SELECT MAX(SALARY) FROM EMPLOYEE);
        SELECT * FROM EMPLOYEE E WHERE EXISTS (SELECT 1 FROM EMPLOYEE WHERE SALARY > E.SALARY);
        SELECT * FROM EMPLOYEE E WHERE NOT EXISTS (SELECT 1 FROM EMPLOYEE WHERE SALARY > E.SALARY);
        -- EXAMPLE 2-2) 가장 적은 급여를 받는 직원을 출력하시오.
        SELECT MIN(SALARY) FROM EMPLOYEE;
        SELECT * FROM EMPLOYEE WHERE SALARY = (SELECT MIN(SALARY) FROM EMPLOYEE);
        SELECT * FROM EMPLOYEE E WHERE EXISTS (SELECT 1 FROM EMPLOYEE WHERE SALARY < E.SALARY);
        SELECT * FROM EMPLOYEE E WHERE NOT EXISTS (SELECT 1 FROM EMPLOYEE WHERE SALARY < E.SALARY);
        
        -- EXAMPLE 3) 심봉선과 같은 부서 사원의 부서코드, 사원명, 월평균 급여를 조회하시오.
        SELECT DEPT_CODE "부서코드", EMP_NAME "사원명", (SELECT FLOOR(AVG(SALARY)) FROM EMPLOYEE) "급여"
        FROM EMPLOYEE E WHERE EXISTS (SELECT 1 FROM EMPLOYEE WHERE DEPT_CODE = E.DEPT_CODE AND EMP_NAME = ('심봉선'));
        -- SELECT DEPT_CODE "부서코드", EMP_NAME "사원명", SALARY "급여"
        -- FROM EMPLOYEE E WHERE EXISTS (SELECT 1 FROM EMPLOYEE WHERE DEPT_CODE = E.DEPT_CODE AND EMP_NAME LIKE '심봉선');
        
        -- EXAMPLE 4) 직급이 J1, J2, J3이 아닌 사원 중에서 자신의 부서별 평균급여보다 많은 급여를 받는
        -- 직원의 부서코드, 사원명, 급여, (부서별 급여평균) 정보를 출력하시오.
        SELECT DEPT_CODE AS "부서코드", EMP_NAME AS "사원명", SALARY AS "급여", (SELECT FLOOR(AVG(SALARY)) FROM EMPLOYEE WHERE DEPT_CODE = E.DEPT_CODE) AS "부서별 급여평균"
        FROM EMPLOYEE E 
        WHERE JOB_CODE NOT IN ('J1', 'J2', 'J3') AND
        SALARY > (SELECT AVG(SALARY) FROM EMPLOYEE WHERE DEPT_CODE = E.DEPT_CODE);
        

--------------------------------------------------------------------------------
--                                스칼라 서브쿼리                                 --
--------------------------------------------------------------------------------

-- 결과값이 1개인 상관 서브쿼리, SELECT문 뒤에 사용됨
-- SQL에서 단일값을 스칼라 값이라고 함


        -- EXAMPLE 1) 모든 사원의 사번, 이름, 관리자 사번, 관리자명을 조회하시오.
        SELECT EMP_ID AS "사번", EMP_NAME AS "이름", MANAGER_ID AS "관리자 사번", (SELECT EMP_NAME FROM EMPLOYEE M WHERE E.MANAGER_ID = M.EMP_ID) AS "관리자명"
        FROM EMPLOYEE E;
        
        -- EXAMPLE 2) 사원명, 부서명, 부서의 평균 임금(자신이 속한 부서의 평균 임금)을 스칼라 서브쿼리를 이용해서 출력하시오.
        SELECT EMP_NAME AS "사원명", DEPT_TITLE AS "부서명", (SELECT FLOOR(AVG(SALARY)) FROM EMPLOYEE WHERE DEPT_CODE = E.DEPT_CODE) AS "부서 평균임금"
        FROM EMPLOYEE E
        JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;
        
        -- EXAMPLE 3) 직급이 J1이 아닌 사원 중에서 자신의 부서 평균 급여보다 적은 급여를 받는 사원을 출력하시오.
        -- 부서 코드, 사원명, 급여, 부서의 급여 평균을 출력하시오.
        SELECT DEPT_CODE AS "부서코드", EMP_NAME AS "사원명", SALARY AS "급여", (SELECT FLOOR(AVG(SALARY)) FROM EMPLOYEE WHERE DEPT_CODE = E.DEPT_CODE) AS "부서 평균임금"
        FROM EMPLOYEE E
        WHERE JOB_CODE != 'J1' AND -- JOB_CODE NOT IN ('J1') AND
        SALARY < (SELECT AVG(SALARY) FROM EMPLOYEE WHERE DEPT_CODE = E.DEPT_CODE)
        ORDER BY 1;
        
        -- EXAMPLE 4) 자신이 속한 직급의 평균 급여보다 많이 받는 직원의 이름, 직급, 급여를 출력하시오.
        SELECT JOB_CODE AS "직급", EMP_NAME AS "사원명", SALARY AS "급여"
        FROM EMPLOYEE E
        WHERE SALARY > (SELECT AVG(SALARY) FROM EMPLOYEE WHERE JOB_CODE = E.JOB_CODE)
        ORDER BY 1;
        
        -- EXAMPLE 5) 모든 직원의 사번, 이름, 소속 부서를 조회한 후 부서명을 오름차순으로 정렬하시오.
        SELECT EMP_ID AS "사번", EMP_NAME AS "사원명", (SELECT DEPT_TITLE FROM DEPARTMENT D WHERE D.DEPT_ID = E.DEPT_CODE) AS "부서명"
        FROM EMPLOYEE E
        ORDER BY 3 ASC;
        -- 간단한 방법
        SELECT EMP_ID AS "사번", EMP_NAME AS "사원명", DEPT_TITLE AS "부서명"
        FROM EMPLOYEE
        JOIN DEPARTMENT ON DEP한T_CODE = DEPT_ID
        ORDER BY 3 ASC;


-----------------------------------------------
                    COMMIT;
-----------------------------------------------