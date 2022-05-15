/*
    <ALTER>
        오라클에서 제공하는 객체를 수정하는 구문이다.
*/
-- 실습에 사용할 테이블 생성
CREATE TABLE DEPT_COPY
AS SELECT *
   FROM DEPARTMENT;
   
SELECT * FROM DEPT_COPY;

/*
    1. 컬럼 추가 / 수정 / 삭제 / 이름 변경
        1) 컬럼 추가 (ADD)
            ALTER TABLE 테이블명 ADD 컬럼명 데이터타입 [DEFAULT 기본값];
*/

-- CNAME 컬럼을 테이블 맨 뒤에 추가한다.
-- 기본값을 지정하지 않으면 새로 추가된 컬럼은 NULL 값으로 채워진다. 
ALTER TABLE DEPT_COPY ADD CNAME VARCHAR2(20);

-- LNAME 컬럼을 기본값을 지정하여 추가
ALTER TABLE DEPT_COPY ADD LNAME VARCHAR2(20) DEFAULT '대한민국';

SELECT * FROM DEPT_COPY;

/*
        2) 컬럼 수정 (MODIFY)
            ALTER TABLE 테이블명 MODIFY 컬럼명 (변경할)데이터타입;
            ALTER TABLE 테이블명 MODIFY 컬럼명 (변경할)데이터타입 DEFAULT (변경할)기본값;
*/
-- DEPT_ID 컬럼의 데이터 타입을 CHAR(5)으로 변경
ALTER TABLE DEPT_COPY MODIFY DEPT_ID CHAR(5);

-- 변경하려고 하려는 자료형의 크기보다 이미 큰 값의 데이터가 존재하면 에러 발생
-- 현재보다 작은 값으로 바꾸면 에러 발생 
ALTER TABLE DEPT_COPY MODIFY DEPT_ID CHAR(3);

-- 컬럼(CNAME)에 값이 없으면 데이터 타입 변경이 가능하다.
ALTER TABLE DEPT_CODY MODIFY CNAME NUMBER;

-- DEPT_COPY 테이블에서 
-- DEPT_TITLE 컬럼의 데이터 타입을 VARCHAR2(40) 
ALTER TABLE DEPT_COPY MODIFY DEPT_TITLE VARCHAR2(40);

-- LOCATION_ID 컬럼의 데이터 타입을 VARCHAR2(2)
ALTER TABLE DEPT_COPY MODIFY LOCATION_ID VARCHAR2(2);

-- LNAME 컬럼의 기본값을 미국으로 변경하기
ALTER TABLE DEPT_COPY MODIFY LNAME DEFAULT '미국';

-- 한꺼번에 수정하기
ALTER TABLE DEPT_COPY 
MODIFY DEPT_TITLE VARCHAR2(40)
MODIFY LOCATION_ID VARCHAR2(2)
MODIFY LNAME DEFAULT '미국';



SELECT * FROM DEPT_COPY;
