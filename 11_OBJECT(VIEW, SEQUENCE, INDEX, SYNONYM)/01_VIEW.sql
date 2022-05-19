 /*
    <VIEW>
        SELECT문을 저장할 수 있는 객체이다. (논리적인 가상 테이블)
        데이터를 저장하고 있지 않으며 테이블에 대한 SQL만 저장되어 있어 
        VIEW에 접근할 때 SQL을 수행하고 결과값을 가져온다. 
         
 */

-- 한국에서 근무하는 사원들의 사번, 직원명, 부서명, 급여, 근무 국가명을 조회
SELECT E.EMP_ID, E.EMP_NAME, D.DEPT_TITLE, E.SALARY, N.NATIONAL_NAME
FROM EMPLOYEE E
INNER JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
INNER JOIN LOCATION L ON (D.LOCATION_ID = L.LOCAL_CODE)
INNER JOIN NATIONAL N ON (L.NATIONAL_CODE = N.NATIONAL_CODE)
WHERE N.NATIONAL_NAME = '한국';
 
-- 러시아에서 근무하는 사원들의 사번, 직원명, 부서명, 급여, 근무 국가명을 조회
SELECT E.EMP_ID, E.EMP_NAME, D.DEPT_TITLE, E.SALARY, N.NATIONAL_NAME
FROM EMPLOYEE E
INNER JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
INNER JOIN LOCATION L ON (D.LOCATION_ID = L.LOCAL_CODE)
INNER JOIN NATIONAL N ON (L.NATIONAL_CODE = N.NATIONAL_CODE)
WHERE N.NATIONAL_NAME = '러시아';
 
-- 일본에서 근무하는 사원들의 사번, 직원명, 부서명, 급여, 근무 국가명을 조회
SELECT E.EMP_ID, E.EMP_NAME, D.DEPT_TITLE, E.SALARY, N.NATIONAL_NAME
FROM EMPLOYEE E
INNER JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
INNER JOIN LOCATION L ON (D.LOCATION_ID = L.LOCAL_CODE)
INNER JOIN NATIONAL N ON (L.NATIONAL_CODE = N.NATIONAL_CODE)
WHERE N.NATIONAL_NAME = '일본';

-- VIEW 권한이 없어서 생성 안된다. 
CREATE VIEW V_EMPLOYEE
AS SELECT E.EMP_ID, E.EMP_NAME, D.DEPT_TITLE, E.SALARY, N.NATIONAL_NAME
    FROM EMPLOYEE E
    INNER JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
    INNER JOIN LOCATION L ON (D.LOCATION_ID = L.LOCAL_CODE)
    INNER JOIN NATIONAL N ON (L.NATIONAL_CODE = N.NATIONAL_CODE);
 
-- 관리자 계정으로 CREATE VIEW 권한 부여 --
GRANT CREATE VIEW TO KH;
------------------------------------------
CREATE VIEW V_EMPLOYEE
AS SELECT E.EMP_ID, E.EMP_NAME, D.DEPT_TITLE, E.SALARY, N.NATIONAL_NAME
    FROM EMPLOYEE E
    INNER JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
    INNER JOIN LOCATION L ON (D.LOCATION_ID = L.LOCAL_CODE)
    INNER JOIN NATIONAL N ON (L.NATIONAL_CODE = N.NATIONAL_CODE);
    
-- 가상 테이블로 실제 데이터가 담겨있는 것은 아니다. 
SELECT * FROM V_EMPLOYEE;

-- TEXT 확인 
-- 접속한 계정이 가지고 있는 VIEW에 정보를 조회하고 있는 데이터 딕셔너리이다. 
SELECT * FROM USER_VIEWS;

-- VIEW는 테이블이 아니고 가상테이블이라서 VIEW에 대한 내용이 없다. 
SELECT * FROM USER_TABLES;

-- VIEW를 이용해서 조회
-- 한국에서 근무하는 사원들의 사번, 직원명, 부서명, 급여, 근무 국가명을 조회
SELECT *
FROM V_EMPLOYEE
WHERE NATIONAL_NAME = '한국';

-- 일본에서 근무하는 사원들의 사번, 직원명, 부서명, 급여, 근무 국가명을 조회
SELECT *
FROM V_EMPLOYEE
WHERE NATIONAL_NAME = '일본';


-- 서브 쿼리의 SELECT 절에 함수나 산술연산이 기술되어 있는 경우 반드시 컬럼에 별칭을 지정해야 한다. (인라인뷰와 비슷)
-- 직원들의 사번, 직원명, 성별, 근무년수 조회할 수 있는 뷰를 생성
SELECT EMP_ID, 
       EMP_NAME,
       DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남', '2', '여'),
       EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE)
FROM EMPLOYEE;

-- 1) 서브 쿼리에 별칭을 지정하는 방법
CREATE VIEW V_EMP_01
AS SELECT EMP_ID, 
          EMP_NAME,
          DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남', '2', '여') AS "성별",
          EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE) AS "근무년수"
  FROM EMPLOYEE;

-- 2) 뷰 생성 시 모든 컬럼에 별칭을 부여하는 방법
--    모든 컬럼에 별칭을 붙여줘야 한다. 
CREATE OR REPLACE VIEW V_EMP_01("사번", "직원명", "성별", "근무년수") -- OR REPLACE : 똑같은 이름의 VIEW를 만들 때, 덮어쓰기
AS SELECT EMP_ID, 
          EMP_NAME,
          DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남', '2', '여'),
          EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE) 
  FROM EMPLOYEE;

SELECT * FROM V_EMP_01;

DROP VIEW V_EMPLOYEE;
DROP VIEW V_EMP_01;

/*
    <VIEW를 이용해서 DML 사용>
        뷰를 통해서 데이터를 변경하게 되면 실제 데이터가 담겨있는 테이블에도 적용된다. 
*/

CREATE VIEW V_JOB
AS SELECT *
    FROM JOB;

-- VIEW에 SELECT 실행
SELECT JOB_CODE, JOB_NAME
FROM V_JOB;

-- VIEW에 INSERT 실행
INSERT INTO V_JOB VALUES('J8', '알바');

-- JOB 테이블도 동시에 변경된다. 
SELECT * FROM V_JOB;
SELECT * FROM JOB;

-- VIEW에 UPDATE 실행
UPDATE V_JOBㄴ
SET JOB_NAME = '인턴'
WHERE JOB_CODE = 'J8';

-- VIEW에 DELETE 실행
DELETE V_JOB
WHERE JOB_CODE = 'J8';

-- JOB 테이블 V_JOB이 동시에 변경된다. 
SELECT * FROM V_JOB;
SELECT * FROM JOB;


/*
    <DML 구문으로 VIEW 조작이 불가능한 경우>
*/

--  1. 뷰 정의에 포함되지 않은 컬럼을 조작하는 경우
CREATE OR REPLACE VIEW V_JOB
AS SELECT JOB_CODE
   FROM JOB;

-- 뷰에 정의되어 있지 않은 컬럼 JOB_NAME을 조작하는 DML 작성
-- INSERT
INSERT INTO V_JOB VALUES('J8');
INSERT INTO V_JOB VALUES('J8', '인턴'); -- <too many values>

SELECT * FROM JOB;
SELECT * FROM V_JOB;

-- UPDATE 

-- 없는 컬럼을 가지고 조작을 할 때 오류가 발생한다. 
-- <invalid identifier>
UPDATE V_JOB
SET JOB_NAME = '인턴'
WHERE JOB_CODE = 'J8';

-- 기존에 가지고 있던 컬럼을 변경하는 것은 가능하다. 
UPDATE V_JOB
SET JOB_CODE = 'J0'
WHERE JOB_CODE = 'J8';

-- DELETE 
-- 없는 컬럼을 가지고 조작을 할 때 오류가 발생한다. 
DELETE FROM V_JOB
WHERE JOB_NAME = '사원';

-- 기존에 가지고 있던 컬럼을 변경하는 것은 가능하다. 
DELETE FROM V_JOB
WHERE JOB_CODE = 'J0';




-- 2. 뷰에 포함되지 않은 컬럼 중에 베이스가 되는 컬럼이 NOT NULL 제약조건이 지정된 경우

CREATE OR REPLACE VIEW V_JOB
AS SELECT JOB_NAME
   FROM JOB;

-- INSERT
INSERT INTO V_JOB VALUES('인턴');
-- JOB_CODE에는 PK가 걸려있고 NOT NULL도 제약조건으로 되어있기 때문에 JOB 테이블에도 안된다. 

-- UPDATE
UPDATE V_JOB
SET JOB_NAME = '인턴'
WHERE JOB_NAME = '사원';
-- └ 기존에 있는 컬럼을 변경하는 것은 가능하다. 

-- DELETE

DELETE FROM V_JOB
WHERE JOB_NAME = '인턴';
-- 자식 테이블의 행들 중에서 부모테이블을 참조하고 있는 행들이 있기 때문에 삭제할 수 없다. (FK 제약조건)
-- 자식 EMPLOYEE 테이블이 JOB_CODE 컬럼으로 JOB 테이블을 부모 테이블로 참조하고 있다. 

ROLLBACK;

SELECT * FROM JOB;
SELECT * FROM V_JOB;





-- 3. 산술 표현식으로 정의된 경우
-- 사원들의 급여 정보를 조회하는 뷰
ALTER TABLE EMPLOYEE MODIFY JOB_CODE NULL;


CREATE OR REPLACE VIEW V_EMP_SAL
AS SELECT EMP_ID,
          EMP_NAME,
          EMP_NO,
          SALARY,
          SALARY * 12 AS "연봉"-- 산술 연산자가 들어갈 경우 컬럼에 <별칭>을 붙여줘야 한다.
    FROM EMPLOYEE;

SELECT * FROM V_EMP_SAL;

-- INSERT
-- 산술연산으로 정의된 컬럼은 데이터 삽입 불가능
-- VIEW(가상 테이블, V_EMP_SAL)에 DML작업을 하면 실제 테이블(EMPLOYEE)에 영향을 준다.
-- EMPLOYEE 테이블에는 <연봉>이라는 컬럼이 없고, V_EMP_SAL에 <연봉> 컬럼을 가상 테이블로 만들었다. 
-- 가상 테이블에 데이터를 입력하면 실제 테이블에 데이터를 입력한 것과 같은데 
-- 실제 테이블에는 <연봉> 컬럼이 없으므로 데이터를 입력할 수 없다. 
INSERT INTO V_EMP_SAL VALUES('1000', '홍길동', '940321-1111111', 3000000, 36000000); -- <virtual column not allowed here>

-- 산술연산과 무관한 컬럼은 데이터 삽입 가능
INSERT INTO V_EMP_SAL(EMP_ID, EMP_NAME, EMP_NO, SALARY) VALUES('100', '홍길동', '940321-1111111', 3000000);

-- 해당 테이블에는 <연봉> 컬럼이 없다
SELECT * FROM EMPLOYEE;

-- VIEW(가상 테이블, V_EMP_SAL)에 DML작업을 하면 실제 테이블(EMPLOYEE)에 영향을 준다.
-- EMPLOYEE 테이블에는 <연봉>이라는 컬럼이 없고, V_EMP_SAL에 <연봉> 컬럼을 가상 테이블로 만들었다. 
-- 가상 테이블에 데이터를 입력하면 실제 테이블에 데이터를 입력한 것과 같은데 
-- 실제 테이블에는 <연봉> 컬럼이 없으므로 데이터를 입력할 수 없다. 
SELECT * FROM V_EMP_SAL;


-- UPDATE
UPDATE V_EMP_SAL
SET "연봉" = 40000000
WHERE EMP_ID = 100;
-- <연봉> 컬럼은 가상 테이블에만 있으므로 ERROR 

-- 산술연산과 무관한 컬럼의 데이터 변경 가능
UPDATE V_EMP_SAL
SET SALARY = 50000
WHERE EMP_ID = 100;

-- DELETE
-- 가상테이블의 행을 선택에서 삭제하는 것은 가능
DELETE FROM V_EMP_SAL
WHERE "연봉" = 600000;

SELECT * FROM EMPLOYEE;
SELECT * FROM V_EMP_SAL;


-- 4. 그룹 함수나 GROUP BY 절을 포함한 경우
-- 부서별 급여의 합계, 급여 평균을 조회하는 뷰 생성
SELECT DEPT_CODE "부서 코드", SUM(SALARY) 합계, FLOOR(AVG(NVL(SALARY, 0))) "급여 평균"
FROM EMPLOYEE
GROUP BY DEPT_CODE;

CREATE OR REPLACE VIEW V_EMP_SAL
AS SELECT DEPT_CODE, 
          SUM(SALARY) 합계, 
          FLOOR(AVG(NVL(SALARY, 0))) "급여 평균"
   FROM EMPLOYEE
   GROUP BY DEPT_CODE;
   

-- INSERT
INSERT INTO V_EMP_SAL VALUES('D0', 8000000, 4000000); -- <virtual column not allowed here>
INSERT INTO V_EMP_SAL(DEPT_CODE) VALUES('D0');
-- 에러 이유 1) DEPT_CODE는 PK라서 NULL 또는 부모 테이블(DEPARTMENT)에서 참조하는 값만 넣을 수 있다.
-- 에러 이유 2) NOT NULL 조건, DEPT_CODE 말고 다른 키들 중 NOT NULL 제약 조건이 걸려서 넣을 수 없다.

-- UPDATE 
UPDATE V_EMP_SAL
SET "합계" = 8000000
WHERE DEPT_CODE = 'D1';
-- 에러 이유 1) D1은 부서코드가 D1인 사원들을 그룹핑한 값이라서 연산 자체가 문제가 있다. 
-- 에러 이유 2) 가상 테이블의 값이기 때문에 불가 

UPDATE V_EMP_SAL
SET DEPT_CODE = 'D3'
WHERE DEPT_CODE = 'D1';

-- DELETE 
DELETE FROM V_EMP_SAL
WHERE DEPT_CODE = 'D1';

SELECT * FROM V_EMP_SAL; -- data manipulation operation not legal on this view


-- 5. DISTINCT를 포함한 경우
CREATE VIEW V_EMP_JOB
AS SELECT DISTINCT JOB_CODE
   FROM EMPLOYEE;
   

-- INSERT
INSERT INTO V_EMP_JOB VALUES('J7'); -- <data manipulation operation not legal on this view>

-- UPDATE
UPDATE V_EMP_JOB
SET JOB_CODE = 'J6'
WHERE JOB_CODE = 'J7'; -- <data manipulation operation not legal on this view>

-- DELETE 
DELETE FROM V_EMP_JOB
WHERE JOB_CODE = 'J7'; -- <data manipulation operation not legal on this view>

SELECT * FROM V_EMP_JOB;
SELECT * FROM EMPLOYEE WHERE JOB_CODE = 'J7';
SELECT * FROM EMPLOYEE;


-- 6. JOIN을 이용해 여러 테이블을 연결한 경우
-- JOIN과 관계있는 테이블의 값은 변경할 수 없다. 
-- 직원들의 사번, 직원명, 부서명을 조회하는 뷰를 생성
CREATE OR REPLACE VIEW V_EMP
AS SELECT E.EMP_ID, E.EMP_NAME, E.EMP_NO, D.DEPT_TITLE
   FROM EMPLOYEE E
   INNER JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID);


SELECT * FROM V_EMP;

-- INSERT
INSERT INTO V_EMP VALUES('100', '임영웅', '990101-1111111', '마케팅부'); -- <cannot modify more than one base table>
INSERT INTO V_EMP(EMP_ID, EMP_NAME, EMP_NO) VALUES('100', '임영웅', '990101-1111111'); 

SELECT * FROM EMPLOYEE;

-- UPDATE 
-- JOIN과 관계있는 테이블의 값은 변경할 수 없다. 
UPDATE V_EMP
SET DEPT_TITLE = '마케팅부'
WHERE EMP_ID = '200'; 

-- 기존 테이블에 있던 컬럼의 값은 변경할 수 있다. 
UPDATE V_EMP
SET EMP_NAME = '서동일'
WHERE EMP_ID = '200'; 


-- DELETE 

-- EMPLOYEE 테이블에 있는 <총무부> 사원만 삭제
-- 서브쿼리의 FROM절에 테이블에만 영향을 끼쳐서 삭제가 되고 메인쿼리의 FROM절에 테이블에는 영향이 없다. 
DELETE FROM V_EMP
WHERE DEPT_TITLE = '총무부';


-- 기존 테이블에 있던 컬럼의 값은 변경할 수 있다. 
DELETE FROM V_EMP
WHERE EMP_ID = '200';




SELECT * FROM V_EMP;
SELECT * FROM EMPLOYEE;

ROLLBACK;

/*
    <VIEW 옵션>
    
    1. OR REPLACE
        기존에 동일한 뷰가 있을 경우 덮어쓰고, 존재하지 않으면 뷰를 새로 생성한다. 
*/

CREATE OR REPLACE VIEW V_EMP_01
AS SELECT EMP_ID, EMP_NAME, SALARY, HIRE_DATE
   FROM EMPLOYEE;
   
SELECT * FROM V_EMP_01;
SELECT * FROM USER_VIEWS;


/*
    2. NOFORCE / FORCE
        1) NOFORCE
            서브 쿼리에 기술된 테이블이 존재해야만 뷰가 생성된다. (기본값)
*/

CREATE /*NOFORCE*/ VIEW V_EMP_02
AS SELECT *
   FROM TEST_TABLE;
   
/*
        2) FORCE 
            서브 쿼리에 기술된 테이블이 존재하지 않아도 뷰가 생성된다. 
*/
CREATE FORCE VIEW V_EMP_02
AS SELECT *
   FROM TEST_TABLE;

SELECT * FROM USER_VIEWS;
SELECT * FROM V_EMP_02;  -- TEST_TABLE 테이블이 만들어지기 전에는 오류

CREATE TABLE TEST_TABLE (
    TCODE NUMBER,
    TNAME VARCHAR2(20)
)
-- TEST_TABLE 테이블 생성 후 V_EMP_02 조회가 가능하고 사용할 수 있다. 
SELECT * FROM V_EMP_02;




/*
    3. WITH CHECK OPTION	
        서브 쿼리에 기술된 조건에 부합하지 않는 값으로 수정하는 경우 오류를 발생시킨다.
*/
CREATE VIEW V_EMP_03
AS SELECT * 
   FROM EMPLOYEE
   WHERE SALARY >= 3000000;

-- 선동일 사장님의 급여를 200만원으로 변경 → 서브 쿼리의 조건에 부합하지 않아도 변경이 가능하다. 
UPDATE V_EMP_03 
SET SALARY = 2000000
WHERE EMP_ID = '200';

ROLLBACK;

-- 위 쿼리문에서 사장님의 급여가 200만원으로 바껴서 V_EMP_03 조회할 때 300만원 이상이라는 조건을 만족하지 않아
-- 조회가 되지 않는다. 데이터는 그대로 있다. 
SELECT * FROM V_EMP_03;
SELECT * FROM EMPLOYEE;


CREATE OR REPLACE VIEW V_EMP_03
AS SELECT * 
   FROM EMPLOYEE
   WHERE SALARY >= 3000000
WITH CHECK OPTION;

-- 선동일 사장님의 급여를 200만원으로 변경 → 서브 쿼리의 조건에 부합하지 않기 때문에 변경이 불가능하다. 
UPDATE V_EMP_03 
SET SALARY = 2000000
WHERE EMP_ID = '200'; -- <view WITH CHECK OPTION where-clause violation>

-- 선동일 사장님의 급여를 400만원으로 변경 → 서브 쿼리의 조건에 부합하기 때문에 변경이 가능하다. 
UPDATE V_EMP_03 
SET SALARY = 4000000
WHERE EMP_ID = '200';


SELECT * FROM V_EMP_03;
SELECT * FROM EMPLOYEE;
SELECT * FROM USER_VIEWS;



/*
    4. WITH READ ONLY	
        뷰에 대해 조회만 가능하다. (DML 수행 불가)
*/
CREATE VIEW V_DEPT
AS SELECT * 
   FROM DEPARTMENT
WITH READ ONLY;

-- INSERT
-- <cannot perform a DML operation on a read-only view>
INSERT INTO V_DEPT VALUES('D0','해외영업5부', 'L2'); 

-- UPDATE
-- <cannot perform a DML operation on a read-only view>
UPDATE V_DEPT
SET LOCATION_ID = 'L2'
WHERE DEPT_ID = 'D9';

-- DELETE
-- <cannot perform a DML operation on a read-only view>
DELETE FROM V_DEPT;

SELECT * FROM V_DEPT;

/*
    <VIEW 삭제>
*/
DROP VIEW V_DEPT;
DROP VIEW V_EMP_01;
DROP VIEW V_EMP_02;
DROP VIEW V_EMP_03;
DROP VIEW V_EMP;
DROP VIEW V_EMP_JOB;
DROP VIEW V_EMP_SAL;
DROP VIEW JOB;

SELECT * FROM USER_VIEWS;



/*


*/




