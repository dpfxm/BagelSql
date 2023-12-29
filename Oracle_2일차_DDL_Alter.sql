// DDL(CREATE, DROP, ALTER) - Data Definition Language

GRANT UNLIMITED TABLESPACE TO Kh;
// 데이터 권한 부여

// ALTER (오라클 객체)
// ALTER를 이용한 제약조건 추가, 수정, 이름변경 해보기
// ALTER를 이용한 컬럼 추가, 컬럼 수정, 컬럼명 수정, 컬럼 삭제, 테이블명 변경 해보기!


// 테이블에 컬럼 추가
ALTER TABLE USER_FOREIGN
ADD USER_DATE DATE;
// 컬럼 수정
ALTER TABLE USER_FOREIGN
MODIFY USER_DATE VARCHAR2(10);
// 테이블에 컬럼 삭제
ALTER TABLE USER_FOREIGN
DROP COLUMN USER_DATE;
// 삭제 확인
DESC USER_FOREIGN;


// 컬럼명 수정
ALTER TABLE USER_FOREIGN
RENAME COLUMN USER_DATE TO REG_DATE;
// 테이블명 수정
ALTER TABLE USER_FOREIGN
RENAME TO USER_ALTER_CHANGE;


// 제약조건 추가
// 1. pk 제약조건 추가
ALTER TABLE SHOP_BUY
ADD CONSTRAINT PK_BUY_NO primary key(BUY_NO);
// 2. foreign key 제약조건 추가 (reference 꼭 써야함!)
ALTER TABLE SHOP_BUY
ADD CONSTRAINT FK_USER_ID foreign key(USER_ID) REFERENCES SHOP_MEMBER(USER_ID);
// 3. default 제약조건 추가
ALTER TABLE SHOP_BUY
MODIFY REG_DATE default '23/12/07';


// 제약조건 삭제
//  - 삭제할때는 제약조건명이 필요함
//  - 제약조건명 확인하는 방법 1. 테이블 클릭 > 제약조건 탭 2. SELECT문
SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME = 'SHOP_BUY';
ALTER TABLE SHOP_BUY
DROP CONSTRAINT SYS_C007349;

// 제약조건 수정
-- > 삭제 후 추가

// 제약조건 이름변경
ALTER TABLE SHOP_BUY
RENAME CONSTRAINT PK_BUY_NO to PRIMARYKEY_BUY_NO;
// 제약조건 활성화/비활성화
ALTER TABLE SHOP_BUY
DISABLE CONSTRAINT FK_USER_ID;
ALTER TABLE SHOP_BUY
ENABLE CONSTRAINT FK_USER_ID;
// 제약조건 유무 확인
SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME = 'SHOP_MEMBER';
SELECT * FROM USER_CONSTRAINTS WHERE OWNER = 'KH';


-- P : PRIMARY KEY
-- C : CHECK OR NOT NULL
-- U : UNIQUE
-- R : FOREIGN KEY


-----------------------------------------------
                    COMMIT;
-----------------------------------------------