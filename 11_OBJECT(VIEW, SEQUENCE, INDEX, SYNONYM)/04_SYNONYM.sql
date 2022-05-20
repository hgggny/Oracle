/*
    <SYNONYM>
        SYNONYM은 오라클에서 제공하는 객체로 데이터베이스 객체에 별칭을 생성한다.
*/

-- 비공개 SYNONYM 생성
-- KH 계정으로 접속
CREATE SYNONYM EMP FOR EMPLOYEE;
-- 권한이 없어서 오류

-- 관리자 계정으로 KH 계정에 SYNONYM 생성 권한을 준다.
GRANT CREATE SYNONYM TO KH;

-- 다시 KH 계정으로 돌아오기
-- 비공개 SYNONYM 생성
CREATE SYNONYM EMP FOR EMPLOYEE;

SELECT * FROM EMPLOYEE;
SELECT * FROM EMP;

-- 공개 SYNONYM 생성
-- 관리자 계정으로 접속
CREATE PUBLIC SYNONYM DEPT FOR KH.DEPARTMENT;

SELECT * FROM KH.DEPARTMENT;
SELECT * FROM DEPT;
-- 현재는 다른 계정으로는 접근이 불가능하다. 

-- PUBLIC이지만 객체에 대한 권한이 있어야 접근이 가능하다. 
-- 관리자 계정으로 접속해서 STUDY 계정에 권한주기 
GRANT SELECT ON KH.DEPARTMENT TO STUDY;

-- SYNONYM 삭제
-- 비공개 SYNONYM 삭제 (사용자 계정)
DROP SYNONYM EMP;

-- 공개 SYNONYM 삭제 (관리자 계정)
DROP PUBLIC SYNONYM DEPT;





