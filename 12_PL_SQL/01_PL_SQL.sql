/*
    <PL/SQL>
        오라클에서 내장되어 있는 절차적 언어로 SQL 문장 내에서 변수를 정의, 조건 처리(IF), 반복 처리(LOOP, WHITE, FOR)등을 지원한다. 
*/
-- 출력 기능 활성화 (환경 변수를 ON으로 바꿔준다.)
SET SERVEROUTPUT ON;

-- HELLO ORACLE 출력
BEGIN 
    DBMS_OUTPUT.PUT_LINE('HELLO ORACLE');
END;
/



/*
    1. 선언부
        변수 및 상수를 선언하는 영역이다. (선언과 동시에 초기화도 가능)
        일반 타입, 레퍼런스 타입, ROW 타입 변수로 선언해서 사용할 수 있다. 
*/


-- 1) 일반 타입 변수 선언 및 초기화 
DECLARE 
    EID NUMBER;
    ENAME VARCHAR2(15) := '박현진'; -- 선언과 동시에 초기화
    PI CONSTANT NUMBER := 3.14; -- 상수 선언, 선언과 동시에 초기화 해야한다. 
BEGIN
    EID := 300; -- (오라클에서 =는 동등 연산자, :=는 대입 연산자)
--    PI := 3.15; -- 한번 선언하면 다시 바뀌지 않는다. 

    DBMS_OUTPUT.PUT_LINE('EID : '|| EID); -- || : 연결 연산자
    DBMS_OUTPUT.PUT_LINE('ENAME : '|| ENAME);
    DBMS_OUTPUT.PUT_LINE('PI : '|| PI);
END;
/

-- 2) 레퍼런스 타입 변수 선언 및 초기화
DECLARE 
    EID EMPLOYEE.EMP_ID%TYPE; -- EMPLOYEE 테이블에 EMP_ID와 동일한 타입으로 지정하겠다 - VARCHAR2(3)
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
BEGIN
    -- 노옹철 사원의 사번, 직원명, 급여 정보를 EID, ENAME, SAL 변수에 대입 후 출력한다.
    SELECT EMP_ID, EMP_NAME, SALARY 
    INTO EID, ENAME, SAL -- 반드시 한 줄에 담아줘야 한다.
    FROM EMPLOYEE
--    WHERE EMP_NAME = '노옹철';
    WHERE EMP_NAME = '&직원명'; -- 대체 변수 : 사용자에게 입력 받아 검색해서 찾을 수 있다
    
    DBMS_OUTPUT.PUT_LINE('EID : '|| EID);
    DBMS_OUTPUT.PUT_LINE('ENAME : '|| ENAME);
    DBMS_OUTPUT.PUT_LINE('SAL : '|| SAL);
END;
/

SELECT EMP_ID, EMP_NAME, SALARY 
FROM EMPLOYEE
WHERE EMP_NAME = '노옹철';


---------------실습 문제------------------
/*
    레퍼런스 타입 변수로 EID, ENAME, JCODE, DITITLE, SAL를 선언하고 
    각 변수의 자료형은 EMPLOYEE 테이블의 EMP_ID, EMP_NAME, JOB_CODE, SALARY 컬럼과 DEPARTMENT 테이블의
    DEPT_TITLE 컬럼의 자료형을 참조한다. 
    사용자가 입력한 사번과 일치하는 사원을 조회(사번, 직원명, 직급 코드, 부서명, 급여)한 후에 조회 결과를 각 변수에 대입하여 출력한다.
*/

DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    JCODE EMPLOYEE.JOB_CODE%TYPE;
    DTITLE DEPARTMENT.DEPT_TITLE%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
BEGIN
    SELECT E.EMP_ID, 
           E.EMP_NAME, 
           E.JOB_CODE, 
           D.DEPT_TITLE,
           E.SALARY
    INTO EID, ENAME, JCODE, DTITLE, SAL
    FROM EMPLOYEE E 
    INNER JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
    WHERE EMP_ID = '&사번';
    
    DBMS_OUTPUT.PUT_LINE('사번 : ' || EID);
    DBMS_OUTPUT.PUT_LINE('직원명 : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('직급 코드 : ' || JCODE);
    DBMS_OUTPUT.PUT_LINE('부서명 : ' || DTITLE);
    DBMS_OUTPUT.PUT_LINE('급여 : ' || SAL);

END;
/


SELECT E.EMP_ID, E.EMP_NAME, E.JOB_CODE, D.DEPT_TITLE, E.SALARY
FROM EMPLOYEE E 
INNER JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID); 


-- 3. ROW 타입 변수 선언 및 초기화
DECLARE 
    EMP EMPLOYEE%ROWTYPE;
BEGIN
    SELECT *
    INTO EMP
    FROM EMPLOYEE
    WHERE EMP_NAME = '&직원명'; -- 데이터 개수가 같아야 한다.
    
    DBMS_OUTPUT.PUT_LINE('사번 : ' || EMP.EMP_ID);
    DBMS_OUTPUT.PUT_LINE('이름 : ' || EMP.EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('주민번호 : ' || EMP.EMP_NO);
    DBMS_OUTPUT.PUT_LINE('이메일 : ' || EMP.EMAIL);
    DBMS_OUTPUT.PUT_LINE('전화번호 : ' || EMP.PHONE);
    DBMS_OUTPUT.PUT_LINE('부서 코드 : ' || EMP.DEPT_CODE);
    DBMS_OUTPUT.PUT_LINE('직급 코드 : ' || EMP.JOB_CODE);
    DBMS_OUTPUT.PUT_LINE('급여 : ' || TO_CHAR(EMP.SALARY, 'FML99,999,999'));
    DBMS_OUTPUT.PUT_LINE('입사일 : ' || TO_CHAR(EMP.HIRE_DATE, 'YYYY"년" MM"월" DD"일"'));
END;
/


SELECT *
FROM EMPLOYEE
WHERE EMP_NAME = '송은희';



/*
    2. 실행부
        제어문, 반복문, 함수 정의 등 로직을 기술하는 영역이다.
*/

-- 1) 선택문
-- 1-1) 단일 IF문
-- 사번을 입력받은 후 해당 사원의 사번, 이름, 급여, 보너스를 출력
-- 단, 보너스를 받지 않은 사원은 보너스 출력 전에 '보너스를 지급받지 않은 사원입니다.'라는 문구를 출력한다. 
DECLARE 
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SALARY EMPLOYEE.SALARY%TYPE;
    BONUS EMPLOYEE.BONUS%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME, SALARY, BONUS
    INTO EID, ENAME, SALARY, BONUS
    FROM EMPLOYEE
    WHERE EMP_ID = '&사번';
    
    DBMS_OUTPUT.PUT_LINE('사번 : ' || EID);
    DBMS_OUTPUT.PUT_LINE('이름 : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('급여 : ' || SALARY);
    
    IF (BONUS IS NULL) THEN
        DBMS_OUTPUT.PUT_LINE('보너스를 지급받지 않는 사원입니다.');
    END IF;
    DBMS_OUTPUT.PUT_LINE('보너스 : ' || BONUS);
END;
/

SELECT EMP_ID, EMP_NAME, SALARY, BONUS
FROM EMPLOYEE
WHERE EMP_ID = 200;


-- 1-2) IF ~ ELSE 구문

-- 위의 PL/SQL 구문은 IF ~ ELSE 문으로 변경하여 작성 
DECLARE 
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SALARY EMPLOYEE.SALARY%TYPE;
    BONUS EMPLOYEE.BONUS%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME, SALARY, NVL(BONUS, 0)
    INTO EID, ENAME, SALARY, BONUS
    FROM EMPLOYEE
    WHERE EMP_ID = '&사번';
    
    DBMS_OUTPUT.PUT_LINE('사번 : ' || EID);
    DBMS_OUTPUT.PUT_LINE('이름 : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('급여 : ' || SALARY);
    
--    IF (BONUS IS NULL) THEN
    IF (BONUS = 0) THEN
        DBMS_OUTPUT.PUT_LINE('보너스를 지급받지 않는 사원입니다.');
    ELSE 
        DBMS_OUTPUT.PUT_LINE('보너스율 : ' || BONUS * 100 || '%');
    END IF;
    
END;
/

-- 사번을 입력 받아서 해당 사원의 사번, 이름, 부서명, 국가 코드를 조회한 후 출력
-- 단, 국가 코드가 'KO'이면 국내팀 그 외는 해외팀으로 출력한다. 

DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    DTITLE DEPARTMENT.DEPT_TITLE%TYPE;
    NCODE LOCATION.NATIONAL_CODE%TYPE;
BEGIN
    SELECT E.EMP_ID, 
           E.EMP_NAME,
           D.DEPT_TITLE,
           L.NATIONAL_CODE
    INTO EID, ENAME, DTITLE, NCODE
    FROM EMPLOYEE E
    INNER JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
    INNER JOIN LOCATION L ON (D.LOCATION_ID = L.LOCAL_CODE)
    WHERE EMP_ID = '203';
    
    DBMS_OUTPUT.PUT_LINE('사번 : ' || EID);
    DBMS_OUTPUT.PUT_LINE('이름 : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('부서명 : ' || DTITLE);
    
    IF (NCODE = 'KO') THEN
        DBMS_OUTPUT.PUT_LINE('소속 : 국내팀');
    ELSE
        DBMS_OUTPUT.PUT_LINE('소속 : 해외팀');
    END IF;
END;
/

SELECT E.EMP_ID, 
       E.EMP_NAME,
       D.DEPT_TITLE,
       L.NATIONAL_CODE
FROM EMPLOYEE E
INNER JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
INNER JOIN LOCATION L ON (D.LOCATION_ID = L.LOCAL_CODE)
WHERE EMP_ID = '200';



-- 1-3) FI ~ ELSIF ~ ELSE 구문
-- 사용자에게 점수를 입력 받아서 SCORE 변수에 저장한 후 학점은 입력된 점수에 따라 GRADE 변수에 저장한다. 
-- 90점 이상은 'A'학점
-- 80점 이상은 'B'학점
-- 70점 이상은 'C'학점
-- 60점 이상은 'D'학점
-- 60점 미만은 'F'학점
-- 출력은 '당신의 점수는 95점이고, 학점은 A학점입니다.'와 같이 출력한다.

DECLARE
    SCORE NUMBER;
    GRADE CHAR(1);
BEGIN
    SCORE := '&점수';
    
    IF (SCORE <= 100 AND SCORE >= 0) THEN
        IF(SCORE >= 90) THEN
            GRADE := 'A';
        ELSIF (SCORE >= 80) THEN
            GRADE := 'B';
        ELSIF (SCORE >= 70) THEN
            GRADE := 'C';
        ELSIF (SCORE >= 60) THEN
            GRADE := 'D';
        ELSE
            GRADE := 'F';
        END IF;    
        
        DBMS_OUTPUT.PUT_LINE('당신의 점수는 ' || SCORE || '점이고, 학점은 ' || GRADE || '학점입니다.');   
    ELSE    
        DBMS_OUTPUT.PUT_LINE('점수를 잘못 입력하였습니다.');
    END IF;
    
--    IF (SCORE > 100 OR SCORE < 0) THEN
--        DBMS_OUTPUT.PUT_LINE('점수를 잘못 입력하였습니다.');
--       
--        RETURN;
--    END IF;
--    
--    IF(SCORE >= 90) THEN
--        GRADE := 'A';
--    ELSIF (SCORE >= 80) THEN
--        GRADE := 'B';
--    ELSIF (SCORE >= 70) THEN
--        GRADE := 'C';
--    ELSIF (SCORE >= 60) THEN
--        GRADE := 'D';
--    ELSE
--        GRADE := 'F';
--    END IF;          
    
--    IF (SCORE > 100 OR SCORE < 0) THEN
--        DBMS_OUTPUT.PUT_LINE('점수를 잘못 입력하였습니다.');
--        
--        RETURN;
--    ELSIF(SCORE >= 90) THEN
--        GRADE := 'A';
--    ELSIF (SCORE >= 80) THEN
--        GRADE := 'B';
--    ELSIF (SCORE >= 70) THEN
--        GRADE := 'C';
--    ELSIF (SCORE >= 60) THEN
--        GRADE := 'D';
--    ELSE
--        GRADE := 'F';
--    END IF;    
    
--    DBMS_OUTPUT.PUT_LINE('당신의 점수는 ' || SCORE || '점이고, 학점은 ' || GRADE || '학점입니다.');

END;
/

-- 사용자에게 입력받은 사번과 일치하는 사원의 급여 조회 후 출력한다. 
-- 500만원 이상이면 '고급'
-- 300만원 이상이면 '중급'
-- 300만원 미만이면 '초급'
-- 출력은 '해당 사원의 급여 등급은 고급입니다.'와 같이 출력한다. 

DECLARE
    SALARY EMPLOYEE.SALARY%TYPE;
    GRADE VARCHAR2(10);
BEGIN
    SELECT SALARY
    INTO SALARY
    FROM EMPLOYEE
    WHERE EMP_ID = 200;
    
    IF (SALARY >= 5000000) THEN
        GRADE := '고급';
    ELSIF (SALARY >= 3000000) THEN
        GRADE := '중급';
    ELSE 
        GRADE := '초급';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('해당 사원의 급여 등급은 ' || GRADE || '입니다.');
END;
/

DECLARE
    SAL EMPLOYEE.SALARY%TYPE;
    GRADE SAL_GRADE.SAL_LEVEL%TYPE;
BEGIN
    SELECT SALARY
    INTO SAL
    FROM EMPLOYEE
    WHERE EMP_ID = '&사번';
    
    SELECT SAL_LEVEL
    INTO GRADE
    FROM SAL_GRADE
    WHERE SAL BETWEEN MIN_SAL AND MAX_SAL;
    
    DBMS_OUTPUT.PUT_LINE('해당 사원의 급여 등급은 ' || GRADE || '입니다.');
END;
/


-- 1-4) CASE 구문
-- 사용자로부터 사번을 입력받은 후에 사원의 모든 컬럼에 데이터를 EMP에 대입하고 DEPT_CODE에 따라 알맞은 부서를 출력한다. 
DECLARE
    EMP EMPLOYEE%ROWTYPE;
    DTITLE VARCHAR2(30);
BEGIN
    SELECT *
    INTO EMP
    FROM EMPLOYEE
    WHERE EMP_ID = '&사번';
    
    DTITLE := CASE EMP.DEPT_CODE
                   WHEN 'D1' THEN '인사관리부'
                   WHEN 'D2' THEN '회계관리부'
                   WHEN 'D3' THEN '마케팅부'
                   WHEN 'D4' THEN '국내영업부'
                   WHEN 'D5' THEN '해외영업1부'
                   WHEN 'D6' THEN '해외영업2부'
                   WHEN 'D7' THEN '해외영업3부'
                   WHEN 'D8' THEN '기술지원부'
                   WHEN 'D9' THEN '총무부'
                   ELSE '부서없음'
               END; 
    
    DBMS_OUTPUT.PUT_LINE('사번 : ' || EMP.EMP_ID);
    DBMS_OUTPUT.PUT_LINE('이름 : ' || EMP.EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('부서 코드 : ' || EMP.DEPT_CODE);
    DBMS_OUTPUT.PUT_LINE('부서명 : ' || DTITLE);
END;
/