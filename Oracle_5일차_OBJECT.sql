-- ORACLE 5일차 오라클 객체

-- 1. VIEW
-- 2. 데이터 딕셔너리(DD, DATA DICTIONARY)


--------------------------------------------------------------------------------
--                                    VIEW                                    --
--------------------------------------------------------------------------------

-- 정보를 공개하는 방법?

-- FROM 절 뒤에 적는 서브쿼리에 이름을 붙여 가상의 테이블로 사용하는 것
-- 실제 테이블에 근거한 논리적인 가상의 테이블(사용자에게 하나의 테이블처럼 사용 가능하게 함)
-- 이름을 붙이기 전은 INLINE VIEW, 이름을 붙인 건 STORE VIEW

-- INLINE VIEW
SELECT * FROM (SELECT EMP_ID, EMP_NAME, DEPT_CODE, MANAGER_ID FROM EMPLOYEE);
-- STORE VIEW
CREATE VIEW EMP_VIEW1 AS SELECT EMP_ID, EMP_NAME, DEPT_CODE, MANAGER_ID FROM EMPLOYEE;
SELECT * FROM EMP_VIEW1;권


-- 1. VIEW의 특징
-- 테이블에 있는 데이터를 보여줄 뿐이며, 데이터 자체를 포함하고 있는 것은 아님
-- - 저장장치 내에 물리적으로 존재하지 않고, 가상 테이블로 만들어진다
-- * 뷰를 사용하면 특정 사용자가 원본 테이블에 접근하여 모든 데이터를 보게 하는 것을 방지할 수 있음
--  - 원본 테이블이 아닌 뷰를 통한 특정 데이터만 보여게 만듦
-- * 뷰를 만들기 위해서는 권한이 필요함! (기본 RESOURCE 롤에 포함 안 됨, CREATIVE VIEW 권한)


-- 2. VIEW의 특징 2
-- 칼럼 뿐만 아니라 산술 연산처리함, VIEW 생성도 가능함

        --  EXAMPLE 1) 연봉 정보를 가지고 있는 VIEW를 생성하시오.
        --  사번, 이름, 급여, 연봉 (ANNUAL SALARY VIEW)
        CREATE VIEW ANNUAL_SALARY_VIEW
        AS SELECT EMP_ID "사번", EMP_NAME "이름", SALARY "급여", (SALARY*12) "연봉"
        FROM EMPLOYEE;
        
        -- EXAMPLE 2) JOIN을 활용한 VIEW 생성도 가능함
        -- 전체 직원의 사번, 이름, 직급명, 부서명, 지역명을 볼 수 있는 VIEW를 생성하시오 (ALL_INFO_VIEW)
        CREATE VIEW ALL_INFO_VIEW
        AS SELECT EMP_ID "사번", EMP_NAME "이름", DEPT_TITLE "부서명", LOCAL_NAME "지역명"
        FROM EMPLOYEE
        JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
        JOIN LOCATION ON LOCATION_ID = LOCAL_CODE;
        
        
-- 3. VIEW 수정

CREATE VIEW V_EMPLOYEE
AS SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE
FROM EMPLOYEE;

UPDATE V_EMPLOYEE SET DEPT_CODE = 'D8' WHERE EMP_NAME = '선동일';


-- VIEW 옵션
-- 1. OR REPLACE

    -- EXAMPLE 1)
    CREATE OR REPLACE VIEW V_EMPLOYEE
    AS SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE FROM EMPLOYEE
    WITH READ ONLY;
    
    
-- 2. FORCE / NOFORCE : 기본 테이블이 존재하지 않더라도 뷰를 생성하는 옵션
-- 3. WITH CHECK OPTION : WHERE 절 조건에 사용한 칼럼의 값을 수정하지 못하게 함
-- 4. WITH READ ONLY : VIEW에 대해 조회만 가능하며 DML 불가능하게 함
    

--------------------------------------------------------------------------------
--                      데이터 딕셔너리(DD, DATA DICTIONARY)                      --
--------------------------------------------------------------------------------

-- > 자원을 효율적으로 관리하기 위해 다양한 정보를 저장한 **시스템 테이블**
-- > 데이터 딕셔너리는 **사용자가 테이블을 생성하거나 사용자를 변경하는 등의 작업을 할 때**
-- 데이터베이스 서버(오라클)에 의해 자동으로 갱신되는 테이블
-- 사용자는 데이터 딕셔너리의 내용을 직접 수정하거나 삭제할 수 없음
-- 데이터 딕셔너리 안에는 중요한 정보가 많이 있기 때문에 사용자는 이를 활용하기 위해서
-- 데이터 딕셔너리 뷰를 사용하게 됨
    
    SELECT * FROM USER_VIEWS;
    SELECT * FROM USER_ROLE_PRIVS;
    SELECT * FROM USER_SYS_PRIVS;
    
    
-- 데이터 딕셔너리(DD, DATA DICTIONARY) VIEW의 종류
-- 1. USER_XXX : 자신의 계정이 소유한 객체 등에 관한 정보를 조회함    
    
    SELECT * FROM USER_TABLES;
    SELECT * FROM USER_VIEWS;
    
    
-- 2. ALL_XXX : 자신의 계정이 소유한 객체 등에 관한 정보를 모두 조회함(권한 부여 받은 것)
   
    SELECT * FROM ALL_TABLES;
    SELECT * FROM ALL_VIEWS;


-- 3. DBA_XXX : 데이터베이스 관리자만 접근이 가능한 객체 등의 정보 조회
    
    SELECT * FROM DBA_TABLES; -- 관리자 계정에서 실행해야함

    
--------------------------------------------------------------------------------

@ 종합 실습 예제

-- 1. KH 계정 소유의 한 EMPLOYEE, JOB, DEPARTMENT 테이블의 일부 정보를 사용자에게 공개하려고 한다.
--    사원 아이디, 사원명, 직급명, 부서명, 관리자명, 입사일의 컬럼정보를 뷰(V_EMP_INFO)를 (읽기 전용으로) 생성하여라.
        
        CREATE OR REPLACE VIEW V_EMP_INFO
        AS SELECT EMP_ID
        , EMP_NAME
        , JOB_NAME
        , DEPT_TITLE
        , NVL((SELECT EMP_NAME FROM EMPLOYEE WHERE EMP_ID = E.MANAGER_ID), '없음')
        , HIRE_DATE
        FROM EMPLOYEE E
        JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
        JOIN JOB ON E.JOB_CODE = JOB.JOB_CODE
        WITH READ ONLY;
      

-----------------------------------------------
                    COMMIT;
-----------------------------------------------