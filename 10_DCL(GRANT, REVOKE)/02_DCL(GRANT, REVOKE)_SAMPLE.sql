-- CREATE TABLE 권한이 없기 때문에 오류 발생한다.
-- 테이블 스페이스를 할당 받지 않았기 때문에 오류가 발생한다
-- 해결 : 01_DCL의 3-4번 진행 
CREATE TABLE TEST (
    TID NUMBER
);

-- 어떤 권한들이 있는지 확인
SELECT * FROM USER_SYS_PRIVS; 

-- 계정이 소유하고 있는 테이블들은 바로 조작이 가능하다. 
SELECT * FROM TEST;
INSERT INTO TEST VALUES(1);
DROP TABLE TEST;

-- SAMPLE 계정으로 접속시
-- 다른 계정의 테이블에 접근할 수 있는 권한이 없기 때문에 오류가 발생한다. 
SELECT * FROM KH.EMPLOYEE;

-- 01_DCL의 5번 실행 후, 접속 가능
SELECT * FROM KH.EMPLOYEE;

-- 권한 부여하기 전에는 접속이 불가능하다.
-- 01_DCL의 6번 실행 후, 접속 가능
-- 객체 단위로 권한을 준다. 
SELECT * FROM KH.DEPARTMENT;

-- INSERT 할 수 있는 권한이 없어 접근할 수 없다. 
-- 01_DCL의 7번 실행 후, 접속 가능
INSERT INTO KH.DEPARTMENT
VALUES ('D0', '비서실', 'L1');

ROLLBACK;

SELECT * FROM KH.LOCATION;
SELECT * FROM STUDY.TB_CLASS;
