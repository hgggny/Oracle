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




