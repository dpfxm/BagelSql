-------------------------------------------------------
        -- 오라클 6일차 객체 시퀀스(SEQUENCE) --
-------------------------------------------------------

-- 순차적으로 정수 값을 자동으로 생성하는 객체, 자동 번호 발생기(채번기)의 역할을 함
-- CREATE SEQUENCE [시퀀스명]; > 기본값으로 생성
-- CREATE SEQUENCE [시퀀스명]

    CREATE TABLE SEQUENCE_TBL
    (
        NUM NUMBER PRIMARY KEY,
        NAME VARCHAR2(20) NOT NULL,
        AGE NUMBER NOT NULL
    );
    
    INSERT INTO SEQUENCE_TBL VALUES (SEQ_USER_NO.NEXTVAL, '일루미', '31');
    INSERT INTO SEQUENCE_TBL VALUES (SEQ_USER_NO.NEXTVAL, '이루미', '18');
    INSERT INTO SEQUENCE_TBL VALUES (SEQ_USER_NO.NEXTVAL, '삼루미', '55');
    
    SELECT * FROM SEQUENCE_TBL;

    CREATE SEQUENCE SEQ_USER_NO;
    SELECT * FROM USER_SEQUENCES;


-------------------------------------------------------
                  -- 시퀀스의 옵션 --
-------------------------------------------------------

-- MINVALUE : 발생시킬 최소값 지정
-- MAXVALUE : 발생시킬 최대값 지정
-- START WITH : 처음 발생시킬 시작 값 지정, 기본값 1
-- INCREMENT BY : 다음 값에 대한 증가치, 기본값 1
-- NOCYCLE : 시퀀스 값이 최대값까지 증가를 완료하면 CYCLE은 START WITH으로 다시 시작함
-- NOCACHE; : 메모리상에서 시퀀스 값을 관리, 기본값 20, 시퀀스 객체의 접근빈도를 즐여서 효율적인 운영 가능


-------------------------------------------------------
                 -- 시퀀스 사용방법 --
-------------------------------------------------------

-- 1. 시퀀스명.NEXTVAL : 최초로 호출한 후에 사용해야함
-- 2. 시퀀스명.CURRVAL : 현재 LAST_NUMBER를 알려줌(NEXTVAL을 1번 이상 한 후에 사용 가능)
    
    CREATE SEQUENCE SEQ_KH_MEMBER_NO;
    SELECT * FROM USER_SEQUENCES;
    SELECT SEQ_KH_MEMBER_NO.NEXTVAL FROM DUAL;
    SELECT SEQ_KH_MEMBER_NO.CURRVAL FROM DUAL;


--------------------------------------------------------------------------------

@ 종합 실습 예제 1

-- 1. 고객이 상품 주문시 사용할 테이블 ORDER_TBL을 만들고, 다음과 같이 칼럼을 구성하세요
--    ORDER_NO(주문 NO) : PK
--    USER_ID(고객아이디)
--    PRODUCT_ID(상품코드)
--    PRODUCT_CNT(주문갯수)
--    ORDER_DATE : DEFAULT SYSDATE

    CREATE TABLE ORDER_TBL
    (
        ORDER_NO NUMBER PRIMARY KEY,
        USER_ID VARCHAR2(40),
        PRODUCT_ID VARCHAR2(40),
        PRODUCT_CNT NUMBER,
        ORDER_DATE DATE DEFAULT SYSDATE
    );
    
    SELECT * FROM ORDER_TBL;
    
    COMMENT ON COLUMN ORDER_TBL.ORDER_NO IS '주문번호';
    COMMENT ON COLUMN ORDER_TBL.USER_ID IS '고객아이디';
    COMMENT ON COLUMN ORDER_TBL.PRODUCT_ID IS '상품코드';
    COMMENT ON COLUMN ORDER_TBL.PRODUCT_CNT IS '주문갯수';
    COMMENT ON COLUMN ORDER_TBL.ORDER_DATE IS '주문날짜';
    
    DROP TABLE ORDER_TBL;
    
-- 2. SEQ_ORDER_NO 시퀀스를 생성하여 다음의 데이터를 추가하세요
    
    CREATE SEQUENCE SEQ_ORDER_NO;
    SELECT * FROM USER_SEQUENCES;
    
    DROP SEQUENCE SEQ_ORDER_NO;
    
    -- * kang님이 saewookkang 상품을 5개 주문하셨습니다.
    -- * gam님이 gamjakkang 상품을 30개 주문하셨습니다.
    -- * ring님이 onionring 상품을 50개 주문하셨습니다.
    
    INSERT INTO ORDER_TBL VALUES (SEQ_ORDER_NO.NEXTVAL, 'kang', 'saewookkang', '5', DEFAULT);
    INSERT INTO ORDER_TBL VALUES (SEQ_ORDER_NO.NEXTVAL, 'gam', 'gamjakkang', '30', DEFAULT);
    INSERT INTO ORDER_TBL VALUES (SEQ_ORDER_NO.NEXTVAL, 'ring', 'onionring', '50', DEFAULT);


--------------------------------------------------------------------------------

@ 종합 실습 예제 1-2

    CREATE TABLE ORDER_TBL_NEW
    (
        ORDER_NO VARCHAR2(30) CONSTRAINT PK_ORDER_NO PRIMARY KEY,
        USER_ID VARCHAR2(40) NOT NULL,
        PRODUCT_ID VARCHAR2(40) NOT NULL,
        PRODUCT_CNT NUMBER(3),
        ORDER_DATE DATE DEFAULT SYSDATE
    );
    
    SELECT * FROM ORDER_TBL;
    
    COMMENT ON COLUMN ORDER_TBL_NEW.ORDER_NO IS '주문번호';
    COMMENT ON COLUMN ORDER_TBL_NEW.USER_ID IS '고객아이디';
    COMMENT ON COLUMN ORDER_TBL_NEW.PRODUCT_ID IS '상품코드';
    COMMENT ON COLUMN ORDER_TBL_NEW.PRODUCT_CNT IS '주문갯수';
    COMMENT ON COLUMN ORDER_TBL_NEW.ORDER_DATE IS '주문날짜';

    
    CREATE SEQUENCE SEQ_NEW_ORDER_NO;
    SELECT * FROM USER_SEQUENCES;
    SELECT * FROM USER_TABLES;
    SELECT * FROM USER_VIEWS;
    
    INSERT INTO ORDER_TBL_NEW VALUES ('kh-'||TO_CHAR(SYSDATE, 'YYMMDD')||'-'||SEQ_NEW_ORDER_NO.NEXTVAL
    , 'kang', 'saewookkang', '5', DEFAULT);
    INSERT INTO ORDER_TBL_NEW VALUES ('kh-'||TO_CHAR(SYSDATE, 'YYMMDD')||'-'||SEQ_NEW_ORDER_NO.NEXTVAL
    , 'gam', 'gamjakkang', '30', DEFAULT);
    INSERT INTO ORDER_TBL_NEW VALUES ('kh-'||TO_CHAR(SYSDATE, 'YYMMDD')||'-'||SEQ_NEW_ORDER_NO.NEXTVAL
    , 'ring', 'onionring', '50', DEFAULT);

    
--------------------------------------------------------------------------------

@ 종합 실습 예제 2

-- 1. KH_MEMBER 테이블을 생성하세요
--    칼럼 : MEMBER_ID, MEMBER_NAME, MEMBER_AGE, MEMBER_JOIN_COM
--    자료형 : NUMBER, VARCHAR2(20), NUMBER, NUMBER


    CREATE TABLE KH_MEMBER
    (
        MEMBER_ID NUMBER,
        MEMBER_NAME VARCHAR2(20),
        MEMBER_AGE NUMBER,
        MEMBER_JOIN_COM NUMBER
    );
    
    DROP TABLE KH_MEMBER;
    
    CREATE SEQUENCE SEQ_MEMBER_ID START WITH 500 INCREMENT BY 10 NOCYCLE NOCACHE;
    DROP SEQUENCE SEQ_MEMBER_ID;
    CREATE SEQUENCE SEQ_MEMBER_JOIN_COM;
    
    INSERT INTO KH_MEMBER VALUES (SEQ_MEMBER_ID.NEXTVAL, '홍길동', 20, SEQ_MEMBER_JOIN_COM.NEXTVAL);
    INSERT INTO KH_MEMBER VALUES (SEQ_MEMBER_ID.NEXTVAL, '청길동', 30, SEQ_MEMBER_JOIN_COM.NEXTVAL);
    INSERT INTO KH_MEMBER VALUES (SEQ_MEMBER_ID.NEXTVAL, '외길동', 40, SEQ_MEMBER_JOIN_COM.NEXTVAL);
    INSERT INTO KH_MEMBER VALUES (SEQ_MEMBER_ID.NEXTVAL, '고길동', 40, SEQ_MEMBER_JOIN_COM.NEXTVAL);
    
    
-------------------------------------------------------
                   -- 시퀀스 수정 --
-------------------------------------------------------

    SELECT * FROM USER_SEQUENCES;
    
    ALTER SEQUENCE SEQ_KH_MEMBER_NO
    INCREMENT BY 1
    MAXVALUE 100000
    CYCLE;
    
    -- 단, START WITH은 안 됨! 다시 만들어야 함! DROP 후 재생성!
    
    
-----------------------------------------------
                    COMMIT;
-----------------------------------------------