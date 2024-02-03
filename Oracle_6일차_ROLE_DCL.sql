-------------------------------------------------------
        -- 오라클 6일차 객체 롤(ROLE) --
-------------------------------------------------------

-- 사용자에게 여러 개의 권한을 한 번에 부여할 수 있는 데이터베이스 객체
-- 사용자에게 권한을 부여할 때 한 개씩 부여하게 되면 권한 부여 및 회수가 불편함

    CREATE USER KH IDENTIFIED BY KH;
    GRANT CONNECT, RESOURCE TO KH;
    
    ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;
    CREATE ROLE VIEWRESOURCE;
    GRANT CREATE VIEW TO VIEWRESOURCE;
    
    SELECT * FROM ROLE_SYS_PRIVS
    WHERE ROLE = 'RESOURCE';
    
    SELECT * FROM USER_SYS_PRIVS;
    
    SELECT * FROM ROLE_SYS_PRIVS
    WHERE ROLE = 'VIEWRESOURCE';


-------------------------------------------------------
            -- DCL(Data Control Language) --
-------------------------------------------------------

-- DCL(Data Control Language) : GRANT / REVOKE
-- 권한부여 및 회수는 관리자 세션(빨간색)에서 사용 가능

-- 관리자 계정
-- 1. sys : DB 생성/삭제 권한 있음, 로그인 옵션으로 AS SYSDBA 지정
-- 2. system : 일반관리자

-- ROLE에 부여된 시스템 권한

    SELECT * FROM DBA_SYS_PRIVS WHERE GRANTEE = 'CONNECT';      -- (관리자 계정에서 사용)
    SELECT * FROM DBA_SYS_PRIVS WHERE GRANTEE = 'RESOURCE';     -- (관리자 계정에서 사용)
    SELECT * FROM ROLDE_SYS_PRIVS WHERE ROLE = 'RESOURCE';      -- (KH 계정에서 사용)
    
-- ROLE에 부여된 테이블 권한
    SELECT * FROM ROLE_TAB_PRIVS;   -- (KH 계정에서 사용)
    SELECT * FROM DBA_TAB_PRIVS;    -- (관리자 계정에서 사용)


--------------------------------------------------------------------------------

@ GRANT 실습 (KH 계정) --


    CREATE TABLE COFFEE
    (
        PRODUCT_NAME VARCHAR2(20) PRIMARY KEY,
        PRICE NUMBER NOT NULL,
        COMPANY VARCHAR2(20) NOT NULL
    );
    
    INSERT INTO COFFEE VALUES ('큐브라떼', 4200, 'MGC');
    INSERT INTO COFFEE VALUES ('자허블', 5300, 'STARBUCKS');
    INSERT INTO COFFEE VALUES ('딸기라떼', 3100, 'COMPOSE');
    INSERT INTO COFFEE VALUES ('토피넛라떼', 3300, 'MAMMOTH');
    SELECT * FROM COFFEE;


-- 1. KHUSER02 계정에서 실행

    -- 실행 중인 계정명 확인
    SHOW USER;
    -- KHUSER02에서 KH 계정에 있는 COFFEE 테이블을 조회하고자 함
    SELECT * FROM KH.COFFEE; -- ORA-00942: 테이블 또는 뷰가 존재하지 않습니다

    -- KHUSER02는 KH 계정의 COFFEE 테이블을 조회할 권한이 없음
    -- > 조회할 수 있는 권한을 부여해보자!

-- 2. 시스템 계정에서 실행
--    KHUSER02가 KH 계정의 COFFEE를 조회할 수 있도록 권한을 부여
--    > 시스템계정에서 해야함
    
    GRANT SELECT ON KH.COFFEE TO KHUSER02;
    -- * Grant을(를) 성공했습니다.
    
-- 3. KHUSER02 계정에서 실행

    -- 실행 중인 계정명 확인
    SHOW USER;
    -- * USER이(가) "KHUSER02"입니다.
    SELECT * FROM KH.COFFEE;
    -- COFFEE 테이블이 없다는 오류 메시지는 안나옴. 권한부여 성공하여 조회 가능해짐
    -- > BUT 데이터가 조회되지 않음 !
    -- > INSERT하고 커밋을 안해서 !
    -- > KH에서 커밋 후 데이터 조회 가능 !
    
    -- 권한 회수 후,
    -- ORA-00942: 테이블 또는 뷰가 존재하지 않습니다

-- 4. 시스템 계정에서 실행

    -- 권한 회수
    REVOKE SELECT ON KH.COFFEE FROM KHUSER02;
    -- * Revoke을(를) 성공했습니다.

-- 5. KHUSER02 계정에서 실행

    SELECT * FROM KH.COFFEE;
    -- 권한 회수 후,
    -- ORA-00942: 테이블 또는 뷰가 존재하지 않습니다
    
    
--------------------------------------------------------------------------------

@ INSERT 권한 부여 실습 (KH 계정) --

-- 1. KHUSER02 계정에서 실행

    -- 실행 중인 계정명 확인
    SHOW USER;
    INSERT INTO KH.COFFEE VALUES ('녹차라떼', 3300, 'EDIYA');
    -- ORA-00942: 테이블 또는 뷰가 존재하지 않습니다
    COMMIT;

-- 2. 시스템 계정에서 실행
--    KHUSER02가 KH 계정의 COFFEE를 조회할 수 있도록 권한을 부여
--    > 시스템계정에서 해야함
    
    GRANT INSERT ON KH.COFFEE TO KHUSER02;
    -- * Grant을(를) 성공했습니다.
    
    -- 권한 회수
    REVOKE INSERT ON KH.COFFEE FROM KHUSER02;
    -- * Revoke을(를) 성공했습니다.


----------------------------------------------------------
                        COMMIT;
----------------------------------------------------------    