/*
    <PROCEDURE>
        PL/SQL문을 저장하는 객체이다.
        특정 로직을 처리하기만 하고 결과값을 반환하지는 않는다.
        
        [실행 방법]
            EXECUTE(또는 EXEC) 프로시저명[(매개값1, 매개값2, ...)];
*/
-- 테스트용 테이블 생성
CREATE TABLE EMP_COPY
AS SELECT * 
   FROM EMPLOYEE;

SELECT * FROM EMP_COPY;

-- EMP_COPY 데이터를 모두 삭제하는 프로시저 생성
CREATE PROCEDURE DEL_ALL_EMP
IS
BEGIN
    DELETE FROM EMP_COPY;
    
    COMMIT;
END;
/

-- DEL_ALL_EMP 프로시저 호출
EXECUTE DEL_ALL_EMP;

ROLLBACK; -- 안됨


-- 프로시저를 관리하는 데이터 딕셔너리
SELECT * FROM USER_SOURCE;

-- PROCEDURE 삭제
DROP PROCEDURE DEL_ALL_EMP;

DROP TABLE EMP_COPY;
DROP TABLE DEPT_COPY;
DROP TABLE EMP_COPY;


/*
    1. 매개변수가 있는 프로시저
*/
-- 사번을 입력 받아서 해당하는 사번의 사원을 삭제하는 프로시저 생성
CREATE PROCEDURE DEL_EMP_ID (
    P_EMP_ID EMPLOYEE.EMP_ID%TYPE
)
IS 
BEGIN
    DELETE FROM EMPLOYEE
    WHERE EMP_ID = P_EMP_ID;
END DEL_EMP_ID;
/

-- 프로시저 실행(매개 변수로 매개 값을 전달해야 한다.)
--EXEC DEL_EMP_ID; -- 에러 발생
EXEC DEL_EMP_ID('200');

SELECT * FROM EMPLOYEE;
EXEC DEL_EMP_ID('&사번');

ROLLBACK;

/*
    2. IN/OUT 매개변수가 있는 프로시저
*/
-- 사번을 입력 받아서 해당하는 사원의 정보를 전달하는 프로시저 생성
CREATE PROCEDURE SELECT_EMP_ID (
    P_EMP_ID IN EMPLOYEE.EMP_ID%TYPE,
    P_EMP_NAME OUT EMPLOYEE.EMP_NAME%TYPE,
    P_SALARY OUT EMPLOYEE.SALARY%TYPE,
    P_BONUS OUT EMPLOYEE.BONUS%TYPE
)
IS
BEGIN
    SELECT EMP_NAME, SALARY, BONUS
    INTO P_EMP_NAME, P_SALARY, P_BONUS
    FROM EMPLOYEE
    WHERE EMP_ID = P_EMP_ID;
END;
/

-- * 바인드 변수(VARIABLE 또는 VAR)
VARIABLE VAR_EMP_NAME VARCHAR2(30);
VARIABLE VAR_SALARY NUMBER;
VAR VAR_BONUS NUMBER;

-- 변수 자체를 참고하려면 변수명 앞에 ':' 을 붙여준다. 
EXEC SELECT_EMP_ID('205', :VAR_EMP_NAME, :VAR_SALARY, :VAR_BONUS);

-- 바인드 변수의 값을 출력하기 위해서 PRINT 명령을 사용한다. 
PRINT VAR_EMP_NAME;
PRINT VAR_SALARY;
PRINT VAR_BONUS;

-- PL/SQL 블럭에서 사용되는 바인드 변수에 값을 자동으로 출력한다. 
SET AUTOPRINT ON;

-- 프로시저 호출 뒤에 주석을 작성하면 에러 발생
EXEC SELECT_EMP_ID('&사번', :VAR_EMP_NAME, :VAR_SALARY, :VAR_BONUS);



/*
    <FUNCTION>
        프로시저와 다르게 OUT 변수를 사용하지 않아도 실행 결과를 되돌려 받을 수 있다. (RETURN)
*/
-- 사번을 입력받아 해당 사원의 보너스를 포함하는 연봉을 계산하고 리턴하는 함수 생성
CREATE FUNCTION BONUS_CALC 
(
    V_EMP_ID EMPLOYEE.EMP_ID%TYPE
)

RETURN NUMBER 
IS 
    SALARY EMPLOYEE.SALARY%TYPE;
    BONUS EMPLOYEE.BONUS%TYPE;
BEGIN
    SELECT SALARY, NVL(BONUS, 0)
    INTO SALARY, BONUS
    FROM EMPLOYEE
    WHERE EMP_ID = V_EMP_ID;
    
    RETURN (SALARY + (SALARY * BONUS)) * 12;
END;
/
-- 함수 호출 1) 
SELECT BONUS_CALC('200') FROM DUAL;

-- 함수 호출 2) 바인드 함수 호출 후 대입하여 호출
VAR VAR_BONUS_CALC NUMBER;
EXEC :VAR_BONUS_CALC := BONUS_CALC('200');

-- EMPLOYEE 테이블에서 전체 사원의 사번, 직원명, 급여, 보너스, 보너스를 포함한 연봉을 조회 (BONUS_CALC 함수 사용)
SELECT EMP_ID, EMP_NAME, SALARY, BONUS, BONUS_CALC(EMP_ID)
FROM EMPLOYEE;
