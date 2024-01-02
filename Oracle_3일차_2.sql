//  오라클 함수 종류 1

//  1. 단일행 함수 - 결과값 여러개
//  2. 다중행 함수 - 결과값 1개(그룹함수)


--------------------------------------------------------------------------------

//  오라클 함수의 종류 2

//  1. 문자 처리 함수

//      A. LENGTH, LENGTHB : 길이 구함 (1)
//      B. INSTR, INSTRB : 위치 구함 (4)
//      C. LPAD, RPAD : 빈 곳에 채워줌 (3)
//      D. LTRIM, RTRIM : 특정문자 제거(공백제거) (4)
//      E. TRIM
//      F. SUBSTR : 문자열 잘라줌 (3)
//      G. CONCAT / || : 문자열 합쳐줌 (2)
//      H. REPLACE : 문자열 바꿔줌 (3)

--------------------------------------------------------------------------------

//  2. 숫자 처리 함수

//      ABS, FLOOR, CEIL (1), MOD, ROUND, TRUNC(2)

--------------------------------------------------------------------------------

//  3. 날짜 처리 함수

//      A. SYSDATE
        SELECT SYSDATE FROM DUAL;
        
//      B. MONTHS_BETWEEN
        SELECT MONTHS_BETWEEN(SYSDATE, HIRE_DATE) FROM EMPLOYEE;
        SELECT MONTHS_BETWEEN('24/04/25', SYSDATE) FROM DUAL;
        
        -- EXAMPLE 1) EMPLOYEE 테이블에서 사원의 이름, 입사일, 입사 후 3개월의 날짜를 구하시오.
        SELECT EMP_NAME "사원명", HIRE_DATE "입사일", ADD_MONTHS(HIRE_DATE, 3) "입사 후 3개월"
        FROM EMPLOYEE;
        -- EXAMPLE 2) EMPLOYEE 테이블에서 사원의 이름, 입사일, 근무 개월 수를 조회하시오.
        SELECT EMP_NAME "사원명", HIRE_DATE "입사일", FLOOR(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)) "근무 개월 수"
        , TRUNC(MONTHS_BETWEEN(SYSDATE, HIRE_DATE),1) "근무 개월 수(소수점 한 자리)"
        FROM EMPLOYEE;
        
//      C. ADD_MONTHS
        SELECT ADD_MONTHS(SYSDATE, 4) FROM DUAL;
        
//      D. LAST_DAY
        SELECT LAST_DAY(SYSDATE) FROM DUAL;
        SELECT LAST_DAY('24/04/05') FROM DUAL;
        SELECT LAST_DAY('23/11/13') FROM DUAL;
        
        -- EXAMPLE 1) EMPLOYEE 테이블에서 사원이름, 입사일, 입사월의 마지막 날을 구하시오.
        SELECT EMP_NAME "사원명", HIRE_DATE "입사일", LAST_DAY(HIRE_DATE) "입사월의 마지막 날"
        FROM EMPLOYEE;
        
//      E. EXTRACT

        -- EXAMPLE 1) EMPLOYEE 테이블에서 사원이름, 입사일, 입사일의 연도, 월, 일을 구하시오.
        SELECT EMP_NAME "사원명", HIRE_DATE "입사일", EXTRACT(YEAR FROM HIRE_DATE) "입사 년"
        , EXTRACT(MONTH FROM HIRE_DATE) "입사 월", EXTRACT(DAY FROM HIRE_DATE) "입사 일"
        FROM EMPLOYEE;
        -- EXAMPLE 2) 오늘부러 이정용씨가 군대에 입대합니다. 군복무 기간이 1년 6개월을 한다라고 가정하면
        -- 첫번째, 제대일자는 언제인지 구하고 두번째, 제대일자까지 먹어야 할 삼시세끼의 총 그릇수를 구해주세요!!
        SELECT SYSDATE "입대일자", ADD_MONTHS(SYSDATE, 18) "제대일자", (ADD_MONTHS(SYSDATE,18)-SYSDATE)*3 "대식가가 될 때까지"
        FROM DUAL;

--------------------------------------------------------------------------------

//  4. NULL 처리 함수

        -- EXAMPLE 1)
        SELECT * FROM EMPLOYEE;
        SELECT EMP_NAME, SALARY, SALARY*NVL(BONUS,0), NVL(MANAGER_ID,'없음') FROM EMPLOYEE;

--------------------------------------------------------------------------------

//  5. 형변환 함수

//      A. TO_CHAR()

        -- EXAMPLE 1)
        SELECT TO_CHAR(SYSDATE, 'YY/MON, DAY, DY')
        FROM DUAL;
        -- EXMAPLE 2)
        SELECT HIRE_DATE, TO_CHAR(HIRE_DATE, 'YYYY-MM-DD') FROM EMPLOYEE;

//      B. TO_DATE()

        -- EXAMPLE 1)
        SELECT TO_DATE(20231218, 'YYYYMMDD')
        FROM DUAL;
        -- EXAMPLE 2-1) 입사일이 00/01/01 ~ 10/01/01 사이인 직원의 정보를 출력하시오
        SELECT *
        FROM EMPLOYEE
        WHERE HIRE_DATE BETWEEN '00/01/01' AND '10/01/01'; -- > 하지만 여기서의 날짜는 '' 안에 들어간 문자형!
        -- EXAMPLE 2-2) 입사일이 00/01/01 ~ 10/01/01 사이인 직원의 정보를 출력하시오
        SELECT *
        FROM EMPLOYEE
        WHERE HIRE_DATE BETWEEN TO_DATE('00/01/01') AND TO_DATE('10/01/01');
        
//      C. TO_NUMBER

        SELECT TO_NUMBER('1,000,000', '9,000,000') - TO_NUMBER('540,000', '999,999') FROM DUAL;
        SELECT TO_NUMBER('1000000') - TO_NUMBER('500000') FROM DUAL;

--------------------------------------------------------------------------------

//  6. DECODE / CASE 함수 (* 기타함수)
        
//      A. DECODE(IF문)
        
        SELECT DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남', '2', '여', '3', '남', '4', '여', '없음') "성별"
        FROM EMPLOYEE;
        
//      B. CASE(SWITCH문)
        
        SELECT
            CASE
                WHEN SUBSTR(EMP_NO, 8, 1) = '1' THEN '남'
                WHEN SUBSTR(EMP_NO, 8, 1) = '2' THEN '여'
                WHEN SUBSTR(EMP_NO, 8, 1) = '3' THEN '남'
                WHEN SUBSTR(EMP_NO, 8, 1) = '4' THEN '여'
                ELSE '없음'
            END "성별"
        FROM EMPLOYEE;

--------------------------------------------------------------------------------

// @ 함수 최종실습문제

// 1. 직원명과 이메일 , 이메일 길이를 출력하시오
//        이름	     이메일	      이메일길이
//    ex) 홍길동   hong@kh.or.kr   	 13

SELECT EMP_NAME "이름", EMAIL "이메일", LENGTH(EMAIL) "이메일 길이"
FROM EMPLOYEE;


// 2. 직원의 이름과 이메일 주소중 아이디 부분만 출력하시오
//	  ex) 노옹철	no_hc
//	  ex) 정중하	jung_jh

SELECT EMP_NAME "이름", SUBSTR(EMAIL, 1, INSTR(EMAIL, '@', 1, 1) -1) "아이디 1", REPLACE(EMAIL, '@kh.or.kr','')  "아이디 2"
FROM EMPLOYEE;


// 3. 60년대에 태어난 직원명과 년생, 보너스 값을 출력하시오. 그때 보너스 값이 null인 경우에는 0 이라고 출력 되게 만드시오
//	      직원명    년생      보너스
//	  ex) 선동일	  1962	    0.3
//	  ex) 송은희	  1963  	 0

SELECT EMP_NAME "직원명", '19' || SUBSTR(EMP_NO,0,2) "년생", NVL(BONUS,0) "보너스"
FROM EMPLOYEE
WHERE EMP_NO LIKE '6_%'; -- SUBSTR(EMP_NO,1,2) BETWEEN 60 AND 69


// 4. '010' 핸드폰 번호를 쓰지 않는 사람의 전체 정보를 출력하시오.

SELECT *
FROM EMPLOYEE
WHERE PHONE NOT LIKE '010%';


// 5. 직원명과 입사년월을 출력하시오 
//    단, 아래와 같이 출력되도록 만들어 보시오
//	      직원명		  입사년월
//	  ex) 전형돈		2012년 12월
//	  ex) 전지연		1997년 3월

SELECT EMP_NAME "직원명", 
TO_CHAR(HIRE_DATE, 'YYYY"년" MM"월"') "입사년월 1",
EXTRACT(YEAR FROM HIRE_DATE) || '년 ' || EXTRACT(MONTH FROM HIRE_DATE) || '월' "입사년월 2"
FROM EMPLOYEE;


// 6. 직원명과 주민번호를 조회하시오
//	  단, 주민번호 9번째 자리부터 끝까지는 '*' 문자로 채워서 출력 하시오
//	  ex) 홍길동 771120-1******

SELECT EMP_NAME "직원명", SUBSTR(EMP_NO, 1, 8) || '******' "주민번호 1"
FROM EMPLOYEE;


// 7. 직원명, 직급코드, 연봉(원) 조회
//    단, 연봉은 ￦57,000,000 으로 표시되게 함
//    연봉은 보너스포인트가 적용된 1년치 급여임

SELECT EMP_NAME "직원명", JOB_CODE "직급코드", TO_CHAR(SALARY*12+(SALARY*NVL(BONUS,0)), 'L999,999,999') "연봉(원)"
FROM EMPLOYEE;


// 8. 부서코드가 D5, D9인 직원들 중에서 2004년도에 입사한 직원중에 조회함.
//    사번 사원명 부서코드 입사일

SELECT EMP_ID "사번", EMP_NAME "사원명", DEPT_CODE "부서코드", HIRE_DATE "입사일"
FROM EMPLOYEE
WHERE DEPT_CODE IN ('D5','D9') AND TO_CHAR(HIRE_DATE, 'YYYY') = 2004;-- AND HIRE_DATE LIKE '04%';
-- SELECT TO_CHAR(HIRE_DATE, 'YYYY'), EXTRACT(YEAR FROM HIRE_DATE) FROM EMPLOYEE;


// 9. 직원명, 입사일, 오늘까지의 근무일수 조회 
//    * 주말도 포함 , 소수점 아래는 버림

SELECT EMP_NAME "직원명", HIRE_DATE "입사일", FLOOR(SYSDATE - HIRE_DATE) "오늘까지의 근무일수"
FROM EMPLOYEE;


// 10. 직원명, 부서코드, 생년월일, 나이(만) 조회
//     단, 생년월일은 주민번호에서 추출해서, 
//     ㅇㅇㅇㅇ년 ㅇㅇ월 ㅇㅇ일로 출력되게 함.
//     나이는 주민번호에서 추출해서 날짜데이터로 변환한 다음, 계산함
//	   * 주민번호가 이상한 사람들은 제외시키고 진행 하도록(200,201,214 번 제외)
//	   * HINT : NOT IN 사용

SELECT EMP_NAME "직원명", DEPT_CODE "부서코드", '19' || TO_CHAR(TO_DATE(SUBSTR(EMP_NO,1,6), 'YY/MM/DD'), 'YY"년" MM"월" DD"일"') "생년월일"
-- , SUBSTR(EMP_NO, 1,2) || '년' 
-- SUBSTR(EMP_NO, 3,2) || '월' 
-- SUBSTR(EMP_NO, 5,2) || '일' "생년월일" 
, EXTRACT(YEAR FROM SYSDATE) - (1900 + SUBSTR(EMP_NO,1,2)) "나이(만)"
FROM EMPLOYEE;


// 11. 사원명과, 부서명을 출력하세요.
//     부서코드가 D5이면 총무부, D6이면 기획부, D9이면 영업부로 처리하시오.(case 사용)
//     단, 부서코드가 D5, D6, D9 인 직원의 정보만 조회하고, 부서코드 기준으로 오름차순 정렬함.

SELECT EMP_NAME "사원명", CASE
    WHEN DEPT_CODE = 'D5' THEN '총무부'
    WHEN DEPT_CODE = 'D6' THEN '기획부'
    WHEN DEPT_CODE = 'D9' THEN '영업부'
    END "부서명"
FROM EMPLOYEE
WHERE DEPT_CODE IN ('D5', 'D6', 'D9') ORDER BY DEPT_CODE ASC;


-----------------------------------------------
                    COMMIT;
-----------------------------------------------