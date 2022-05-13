 /*
    <DDL (Data Definition Language)>
        데이터 정의 언어로 오라클에서 제공하는 객체를 생성하고, 변경하고, 삭제하는 등
        실제 데이터 값이 아닌 데이터의 구조 자체를 정의하는 언어이다. (DB 관리자, 설계자)
        
    <CREATE>
        데이터베이스 객체(테이블, 뷰, 사용자 등)를 생성하는 구문이다.
        
    <테이블 생성>
        CREATE TABLE 테이블명 (
            컬럼명 자료형(크기) [DEFAULT 기본값] [제약조건],
            컬럼명 자료형(크기) [DEFAULT 기본값] [제약조건],
            컬럼명 자료형(크기) [DEFAULT 기본값] [제약조건],
            컬럼명 자료형(크기) [DEFAULT 기본값] [제약조건],
            ...
        );
 */
 
-- 회원에 대한 데이터를 담을 수 있는 MEMBER 테이블 생성
CREATE TABLE MEMBER (
    ID VARCHAR2(20),
    PASSWORD VARCHAR2(20),
    NAME VARCHAR2(15),
    ENROLL_DATE DATE DEFAULT SYSDATE 
    -- └ 회원가입 한 시점
    -- CTRL + ENTER → 해당 계정 [테이블] 새로고침 
);

-- DESC (DESCRIBE) : 테이블의 구조를 표시해주는 구문
DESC MEMBER; 

SELECT * FROM MEMBER;

/*
    데이터 딕셔너리
        - 자원을 효율적으로 관리하기 위해 다양한 객체들의 정보를 저장하는 시스템 테이블이다. 
        - 사용자가 객체를 생성하거나 변경하는 등의 작업을 할 때 데이터베이스에 의해서 
          자동으로 갱신되는 테이블이다. 
        - 데이터에 관한 데이터가 저장되어 있어서 [메타 데이터]라고도 한다.
        
    USER_TABLES : 사용자가 가지고 있는 테이블의 구조를 확인하는 뷰 테이블이다. 
    USER_TAB_COLUMNS : 테이블, 뷰의 컬럼과 관련된 정보를 조회하는 뷰 테이블이다. 
*/

-- 어떤 테이블을 가지고 있는지 조회
SELECT * 
FROM USER_TABLES; 

-- (특정)테이블컬럼에 대한 정보 조회
SELECT *
FROM USER_TAB_COLUMNS
WHERE TABLE_NAME = 'MEMBER'; 

/*
    <컬럼 주석>
        테이블 컬럼에 대한 설명을 작성할 수 있는 구문
        
        COMMENT ON COLUMN 테이블.컬럼명 IS '주석 내용';
*/

-- 한 줄에 하나의 컬럼 주석만 가능하므로 생성할 때마다 CTRL + ENTER로 실행해야 한다 → MEMBER 테이블 새로고침 후 확인 !
COMMENT ON COLUMN MEMBER.ID IS '회원 아이디';
COMMENT ON COLUMN MEMBER.PASSWORD IS '회원 비밀번호';
COMMENT ON COLUMN MEMBER.NAME IS '회원 이름';
COMMENT ON COLUMN MEMBER.ENROLL_DATE IS '회원 가입일';

-- 테이블에 샘플 데이터 추가
-- DML(INSERT)을 사용해서 만들어진 테이블에 샘플 데이터를 추가할 수 있다. 
-- INSERT INTO 테이블명[(컬럼명, ... , 컬럼명)] VALUES (값, ...., )
-- 지정하는 컬럼에만 넣고 싶을 때 컬럼명을 추가한다.
-- CTRL + ENTER : 행 삽입
INSERT INTO MEMBER VALUES ('USER1', '1234', '박현진', '2022-05-12');
INSERT INTO MEMBER VALUES ('USER2', '1234', '강지혜', SYSDATE);
INSERT INTO MEMBER VALUES ('USER3', '1234', '한송희', DEFAULT);
INSERT INTO MEMBER(ID, PASSWORD) VALUES ('USER4', '1234');
-- └ [USER4 	1234	(NULL)	22/05/12] 출력
-- ENROLL_DATE DATE DEFAULT SYSDATE : 테이블 만들 때 DEFAULT로 지정하면 
-- 값이 입력하지 않았을 경우 SYSDATE(현재시간)으로 INSERT 된다. 

SELECT * FROM MEMBER;

-- 위에서 추가한 데이터는 메모리 버퍼에 임시 저장된다. 
-- 위 데이터를 실제 데이터 베이스에 저장하려면 <COMMIT> 명령어를 사용하여 실제 테이블에 반영해야 한다. 
-- <COMMIT> 명령어를 사용하면 다른 계정이나 웹에서도 볼 수 있다
COMMIT;

-- INSERT 할 때마다 자동으로 COMMIT 할 수 있도록 한다.
-- 기본은 OFF 상태
SHOW AUTOCOMMIT;

-- ON 상태로 바꾸기
SET AUTOCOMMIT ON;
-- OFF 상태로 바꾸기
SET AUTOCOMMIT OFF;


/*
    <제약조건>
        사용자가 원하는 조건에 데이터만 유지하기 위해서 테이블 작성 시 컬럼에 대해 제약조건을 설정할 수 있다. 
        제약조건은 데이터 무결성 보장을 목적으로 한다. (데이터의 정확성과 일관성을 유지시키는 것)
        
        
    1. NOT NULL 제약조건
        해당 컬럼에 반드시 값이 있어야만 하는 경우에 사용한다. 
        삽입 / 수정 시 NULL 값을 허용하지 않도록 제한한다. 
*/
-- 기존 MEMBER 테이블은 값에 NULL이 있어도 행의 추가가 가능하다. 
INSERT INTO MEMBER VALUES(NULL, NULL, NULL, NULL);

-- NOT NULL 제약조건을 설정한 테이블 생성
DROP TABLE MEMBER; -- 테이블 삭제

CREATE TABLE MEMBER (
    ID VARCHAR2(20) NOT NULL,
    PASSWORD VARCHAR2(20) NOT NULL,
    NAME VARCHAR2(15) NOT NULL,
    ENROLL_DATE DATE DEFAULT SYSDATE
    );

-- NOT NULL 제약조건에 위배되어 오류 발생
INSERT INTO MEMBER VALUES(NULL, NULL, NULL, NULL);

-- NOT NULL 제약조건이 걸려있는 컬럼에는 반드시 값이 있어야 한다. 
INSERT INTO MEMBER VALUES('USER1', '1234', '박현진', NULL);
INSERT INTO MEMBER VALUES('USER1', '1234', '박현진', SYSDATE);
INSERT INTO MEMBER VALUES('USER1', '1234', '박현진', DEFAULT);
INSERT INTO MEMBER(ID, PASSWORD, NAME) VALUES('USER1', '1234', '박현진');

-- 테이블의 데이터를 수정하는 SQL 구문
UPDATE MEMBER
SET ID = NULL;


SELECT * FROM MEMBER;

-- 제약조건 확인
-- 사용자가 작성한 제약조건을 확인하는 뷰 테이블.
-- <컬럼명> 확인 불가
SELECT *
FROM USER_CONSTRAINTS;

-- 사용자가 작성한 제약조건이 걸려있는 컬럼을 확인하는 뷰 테이블.
-- <컬럼명> 확인 가능
SELECT *
FROM USER_CONS_COLUMNS;

SELECT UC.CONSTRAINT_NAME, 
       UC.TABLE_NAME, 
       UCC.COLUMN_NAME, 
       UC.CONSTRAINT_TYPE
FROM USER_CONSTRAINTS UC
JOIN USER_CONS_COLUMNS UCC ON (UC.CONSTRAINT_NAME = UCC.CONSTRAINT_NAME)
WHERE UC.TABLE_NAME = 'MEMBER';


/*
    2. UNIQUE 제약조건
        컬럼에 입력 값이 중복 값을 가질 수 없도록 제한하는 제약조건이다. 
*/

SELECT * FROM MEMBER;

-- 아이디가 중복되어도 성공적으로 데이터가 삽입된다. 
INSERT INTO MEMBER VALUES ('USER1', '1234', '박현진', DEFAULT);
INSERT INTO MEMBER VALUES ('USER1', '1234', '이경희', DEFAULT);

DROP TABLE MEMBER;

CREATE TABLE MEMBER (
    ID VARCHAR2(20) NOT NULL UNIQUE,
    PASSWORD VARCHAR2(20) NOT NULL,
    NAME VARCHAR2(15) NOT NULL,
    ENROLL_DATE DATE DEFAULT SYSDATE 
    );

INSERT INTO MEMBER VALUES ('USER1', '1234', '박현진', DEFAULT);
INSERT INTO MEMBER VALUES ('USER1', '1234', '함성은', DEFAULT);
-- └ UNIQUE 제약조건에 위배되어 INSERT 실패 <unique constraint violated>

DROP TABLE MEMBER;

-- 제약조건명 지정
-- 제약조건 이름 : 테이블명_컬럼명_제약조건
CREATE TABLE MEMBER (
    -- 제약조건명 지정 방법 1) 컬럼레벨
    NO NUMBER CONSTRAINT MEMBER_NO_NN NOT NULL, -- NN : NOT NULL 
    ID VARCHAR2(20) CONSTRAINT MEMBER_ID_NN NOT NULL, 
    PASSWORD VARCHAR2(20) CONSTRAINT MEMBER_PASSWORD_NN NOT NULL,
    NAME VARCHAR2(15) CONSTRAINT MEMBER_NAME_NN NOT NULL,
    ENROLL_DATE DATE DEFAULT SYSDATE,
    
    -- 제약조건명 지정 방법 2) 테이블 레벨
    CONSTRAINT MEMBER_ID_UQ UNIQUE(ID) 
    );
    
INSERT INTO MEMBER VALUES (1, 'USER1', '1234', '박현진', DEFAULT);
INSERT INTO MEMBER VALUES (2, 'USER1', '1234', '이경희', DEFAULT);
-- └ UNIQUE 제약조건에 위배되어 INSERT 실패 <unique constraint violated>

DROP TABLE MEMBER;

-- 여러 개의 컬럼을 묶어서 하나의 UNIQUE 제약조건으로 설정할 수 있다. (단, 반드시 테이블 레벨로만 설정이 가능하다.)
CREATE TABLE MEMBER (
    NO NUMBER NOT NULL,
    ID VARCHAR2(20) NOT NULL, 
    PASSWORD VARCHAR2(20) NOT NULL,
    NAME VARCHAR2(15) NOT NULL,
    ENROLL_DATE DATE DEFAULT SYSDATE,
    -- 테이블 레벨로만 설정 가능 !
    CONSTRAINT MEMBER_NO_ID_UQ UNIQUE(NO,ID) 
    );

-- 여러 컬럼을 묶어서 UNIQUE 제약조건이 설정되어 있으면 제약조건이 설정되어 있는 컬럼값이 모두 중복되는 경우에만 오류가 발생한다. 
INSERT INTO MEMBER VALUES (1, 'USER1', '1234', '박현진', DEFAULT);

INSERT INTO MEMBER VALUES (1, 'USER1', '1234', '이경희', DEFAULT);
-- └ UNIQUE 제약조건에 위배되어 INSERT 실패 <unique constraint violated>

INSERT INTO MEMBER VALUES (2, 'USER1', '1234', '이경희', DEFAULT);
INSERT INTO MEMBER VALUES (2, 'USER2', '1234', '이경희', DEFAULT);
-- └ NO와 ID가 동시에 같은게 아니므로, INSERT 성공

SELECT *
FROM MEMBER;

/*
    3. CHECK 제약조건
        컬럼에 기록되는 값에 조건을 설정하고 조건을 만족하는 값만 기록할 수 있다. 
        비교 값은 리터럴만 사용이 가능하다. 변하는 값이나 함수는 사용할 수 없다. 
        
        CHECK (비교연산자)
            CHECK(컬럼 [NOT ] IN(값, 값, ..., ))
            CHECK(컬럼 BETWEEN 값 AND 값) : 범위 표현
            CHECK(컬럼 LIKE '_문자')
            ...
*/


-- 성별, 나이에 유효한 값이 아닌 값들도 INSERT 된다. 
DROP TABLE MEMBER;

CREATE TABLE MEMBER (
     NO NUMBER NOT NULL, 
     ID VARCHAR2(20)  NOT NULL, 
     PASSWORD VARCHAR2(20) NOT NULL,
     NAME VARCHAR2(15) CONSTRAINT MEMBER_NAME_NN NOT NULL,
     GENDER CHAR(3),
     AGE NUMBER,
     ENROLL_DATE DATE DEFAULT SYSDATE,
     CONSTRAINT MEMBER_ID_UQ UNIQUE(ID) 
     );
     
INSERT INTO MEMBER VALUES (1, 'USER1', '1234', '박현진', '여', 25, DEFAULT);
INSERT INTO MEMBER VALUES (2, 'USER2', '1234', '이경희', '남', 18, DEFAULT);
INSERT INTO MEMBER VALUES (3, 'USER3', '1234', '강지혜', '강', 30, DEFAULT);
INSERT INTO MEMBER VALUES (4, 'USER4', '1234', '한송희', '남', -29, DEFAULT);

SELECT * FROM MEMBER;

SELECT UC.CONSTRAINT_NAME, 
       UC.TABLE_NAME, 
       UCC.COLUMN_NAME, 
       UC.CONSTRAINT_TYPE
FROM USER_CONSTRAINTS UC
JOIN USER_CONS_COLUMNS UCC ON (UC.CONSTRAINT_NAME = UCC.CONSTRAINT_NAME)
WHERE UC.TABLE_NAME = 'MEMBER';


DROP TABLE MEMBER;

CREATE TABLE MEMBER (
     NO NUMBER NOT NULL, 
     ID VARCHAR2(20)  NOT NULL, 
     PASSWORD VARCHAR2(20) NOT NULL,
     NAME VARCHAR2(15) CONSTRAINT MEMBER_NAME_NN NOT NULL,
     GENDER CHAR(3) CONSTRAINT MEMBER_GENDER_CH CHECK(GENDER IN ('남','여')),
     AGE NUMBER,
     ENROLL_DATE DATE DEFAULT SYSDATE,
     CONSTRAINT MEMBER_ID_UQ UNIQUE(ID),
     CONSTRAINT MEMBER_AGE_CK CHECK(AGE > 0)
     );


INSERT INTO MEMBER VALUES (1, 'USER1', '1234', '박현진', '여', 25, DEFAULT);
INSERT INTO MEMBER VALUES (2, 'USER2', '1234', '이경희', '남', 18, DEFAULT);
INSERT INTO MEMBER VALUES (3, 'USER3', '1234', '강지혜', '강', 30, DEFAULT);
-- GENDER 컬럼에 CHECK 제약조건으로 '남' 또는 '여'만 입력 가능하도록 설정이 되었기 때문에 에러가 발생한다. 
-- <check constraint violated>
INSERT INTO MEMBER VALUES (4, 'USER4', '1234', '한송희', '남', -29, DEFAULT);
-- AGE 컬럼에 CHECK 제약조건으로 0보다 큰 값만 입력 가능하도록 설정이 되었기 때문에 에러가 발생한다. 
-- <check constraint violated>

-- COMMIT 안할 경우, ROLLBACK하면 데이터가 다 사라진다. 
COMMIT;

UPDATE MEMBER
SET AGE = 29
--SET GENDER = '외'
--WHERE ID = 'USER2'
;
-- 행을 식별할 수 있는 값을 조건을 줘야한다. 

SELECT *
FROM MEMBER;

ROLLBACK; 

/*
    4. PRIMARY KEY(기본 키) 제약조건
        테이블에서 한 행의 정보를 식별하기 위해 사용할 컬럼에 부여하는 제약조건이다. 
        기본 키 제약조건을 설정하게 되면 자동으로 해당 컬럼에 NOT NULL, UNIQUE 제약조건이 설정된다. 
        한 테이블에 한 개만 설정할 수 있다. (단, 한 개 이상의 컬럼을 묶어서 기본 키 제약조건을 설정할 수 있다.)
        
*/

DROP TABLE MEMBER;

-- 비즈니스와 관계없는 NO 값을 기본 키로 사용하는 것이 좋다 
CREATE TABLE MEMBER (
     NO NUMBER,
--     NO NUMBER PRIMARY KEY, -- 컬럼 레벨 방식
     ID VARCHAR2(20) NOT NULL, 
     PASSWORD VARCHAR2(20) NOT NULL,
     NAME VARCHAR2(15) CONSTRAINT MEMBER_NAME_NN NOT NULL,
     GENDER CHAR(3) ,
     AGE NUMBER,
     ENROLL_DATE DATE DEFAULT SYSDATE,
     
     CONSTRAINT MEMBER_NO_PK PRIMARY KEY(NO), -- 테이블 레벨 방식
     CONSTRAINT MEMBER_ID_UQ UNIQUE(ID),
     CONSTRAINT MEMBER_GENDER_CH CHECK(GENDER IN ('남','여')),
     CONSTRAINT MEMBER_AGE_CK CHECK(AGE > 0)
     );

INSERT INTO MEMBER VALUES (1, 'USER1', '1234', '박현진', '여', 25, DEFAULT);
INSERT INTO MEMBER VALUES (2, 'USER2', '1234', '이경희', '남', 18, DEFAULT);
INSERT INTO MEMBER VALUES (3, 'USER3', '1234', '강지혜', '여', 30, DEFAULT);
INSERT INTO MEMBER VALUES (4, 'USER4', '1234', '한송희', '여', 20, DEFAULT);
INSERT INTO MEMBER VALUES (4, 'USER5', '1234', '김연주', '여', 16, DEFAULT);
-- └ 에러 발생 <unique constraint (KH.MEMBER_NO_PK) violated> 기본 키 중복으로 오류
-- PRIMARY KEY 제약조건을 걸었을 경우, 오류의 원인인 컬럼 NO 값이 중복되었다는 UNIQUE 제약조건도 자동으로 걸린다.
INSERT INTO MEMBER VALUES (NULL, 'USER5', '1234', '이경희', '여', 16, DEFAULT);
-- └ 에러 발생 <cannot insert NULL into ("KH"."MEMBER"."NO")> 기본 키가 NULL 이므로 오류
-- PRIMARY KEY 제약조건을 걸었을 경우, 오류의 원인인 데이터에 NULL값이 들어있다는 NOT NULL 계약조건도 자동으로 걸린다. 




DROP TABLE MEMBER;

CREATE TABLE MEMBER (
--     NO NUMBER,
     NO NUMBER PRIMARY KEY, -- 컬럼 레벨 방식
     ID VARCHAR2(20) NOT NULL PRIMARY KEY,  -- 에러 발생 <table can have only one primary key>
     PASSWORD VARCHAR2(20) NOT NULL,
     NAME VARCHAR2(15) CONSTRAINT MEMBER_NAME_NN NOT NULL,
     GENDER CHAR(3) ,
     AGE NUMBER,
     ENROLL_DATE DATE DEFAULT SYSDATE,
     
     CONSTRAINT MEMBER_NO_PK PRIMARY KEY(NO), -- 테이블 레벨 방식
     CONSTRAINT MEMBER_ID_UQ UNIQUE(ID),
     CONSTRAINT MEMBER_GENDER_CH CHECK(GENDER IN ('남','여'))
--     CONSTRAINT MEMBER_AGE_CK CHECK(AGE > 0)
     );


-- 컬럼을 묶어서 하나의 기본 키를 생성(복합키라고 한다.)
DROP TABLE MEMBER;

CREATE TABLE MEMBER (
     NO NUMBER,
     ID VARCHAR2(20) NOT NULL, 
     PASSWORD VARCHAR2(20) NOT NULL,
     NAME VARCHAR2(15) CONSTRAINT MEMBER_NAME_NN NOT NULL,
     GENDER CHAR(3) ,
     AGE NUMBER,
     ENROLL_DATE DATE DEFAULT SYSDATE,
     
     CONSTRAINT MEMBER_NO_ID_PK PRIMARY KEY(NO, ID), -- 컬럼 NO와 ID가 동시에 중복일 경우에만 에러 !
     CONSTRAINT MEMBER_ID_UQ UNIQUE(ID),
     CONSTRAINT MEMBER_GENDER_CH CHECK(GENDER IN ('남','여'))
--     CONSTRAINT MEMBER_AGE_CK CHECK(AGE > 0)
     );

INSERT INTO MEMBER VALUES (1, 'USER1', '1234', '박현진', '여', 25, DEFAULT);
INSERT INTO MEMBER VALUES (2, 'USER2', '1234', '이경희', '남', 18, DEFAULT);
INSERT INTO MEMBER VALUES (3, 'USER3', '1234', '강지혜', '여', 30, DEFAULT);
INSERT INTO MEMBER VALUES (4, 'USER4', '1234', '한송희', '여', 20, DEFAULT);

-- CONSTRAINT MEMBER_NO_ID_PK PRIMARY KEY(NO, ID) : NO와 ID 중 하나만 중복될 경우에는 에러가 발생하지 않는다. 
INSERT INTO MEMBER VALUES (4, 'USER5', '1234', '김연주', '여', 16, DEFAULT); 

-- CONSTRAINT MEMBER_ID_UQ UNIQUE(ID) 때문에 아이디가 동일한 값이 이미 존재하여 에러가 발생한다. <unique constraint violated>
INSERT INTO MEMBER VALUES (6, 'USER4', '1234', '이경희', '여', 16, DEFAULT); 

-- 기본 키로 설정된 컬럼에 NULL값이 있으면 에러가 발생한다. <cannot insert NULL into>
INSERT INTO MEMBER VALUES (NULL, 'USER5', '1234', '이경희', '여', 16, DEFAULT);
INSERT INTO MEMBER VALUES (5, NULL, '1234', '이경희', '여', 16, DEFAULT);



SELECT * FROM MEMBER;

SELECT UC.CONSTRAINT_NAME, 
       UC.TABLE_NAME, 
       UCC.COLUMN_NAME, 
       UC.CONSTRAINT_TYPE,
       UC.SEARCH_CONDITION
FROM USER_CONSTRAINTS UC
JOIN USER_CONS_COLUMNS UCC ON (UC.CONSTRAINT_NAME = UCC.CONSTRAINT_NAME)
WHERE UC.TABLE_NAME = 'MEMBER';



/*
    5. FOREIGN KEY(외래 키) 제약조건
        다른 테이블에 존재하는 값만을 가져야하는 컬럼에 부여하는 제약조건이다. (단, NULL 값도 가질 수 있다.)
        즉, 외래 키로 참조한 컬럼의 값만 기록할 수 있다. 
        
        1) 컬럼 레벨
            컬럼명 자료형(크기) [CONSTRAINT 제약조건명] REFERENCES 참조할 테이블명[(기본키)] [삭제룰]
            
        2) 테이블 레벨
            [CONSTRAINT 제약조건명] FOREIGN KEY(컬럼명) REFERENCES 참조할 테이블명 [(기본키)] [삭제룰]
            
        * 삭제룰
            부모 테이블의 데이터가 삭제되었을 때의 옵션을 지정해 놓을 수 있다. 
            1) ON DELETE RESTRICT   : 자식 테이블의 참조 키가 부모 테이블의 키 값을 참조하는 경우 부모 테이블의 행을 삭제할 수 없다. (기본값)
            2) ON DELETE SET NULL   : 부모 테이블의 데이터가 삭제 시 참조하고 있는 자식 테이블의 컬럼 값이 NULL로 변경된다. 
            3) ON DELETE CASCADE    : 부모 테이블의 데이터 삭제 시 참조하고 있는 자식 테이블의 행 전체가 삭제된다. 
        
            
*/
-- 회원 등급에 대한 데이터를 보관하는 테이블 (부모 테이블) 생성
CREATE TABLE MEMBER_GRADE(
    GRADE_CODE NUMBER,
    GRADE_NAME VARCHAR2(20) NOT NULL,
    CONSTRAINT MEMBER_GRADE_PK PRIMARY KEY(GRADE_CODE)
);

INSERT INTO MEMBER_GRADE VALUES(10, '일반회원');
INSERT INTO MEMBER_GRADE VALUES(20, '우수회원');
INSERT INTO MEMBER_GRADE VALUES(30, '특별회원');


DROP TABLE MEMBER;

CREATE TABLE MEMBER (
     NO NUMBER,
     ID VARCHAR2(20) NOT NULL, 
     PASSWORD VARCHAR2(20) NOT NULL,
     NAME VARCHAR2(15) NOT NULL,
     GENDER CHAR(3) ,
     AGE NUMBER,
     -- GRADE_ID는 MEMBER_GRADE에 있는 GRADE_CODE만 참조할 수 있다 !
     GRADE_ID NUMBER CONSTRAINT MEMBER_GRADE_ID_FK REFERENCES MEMBER_GRADE (GRADE_CODE), -- 1) 컬럼 레벨 방식
     ENROLL_DATE DATE DEFAULT SYSDATE,
     
     CONSTRAINT MEMBER_NO_PK PRIMARY KEY(NO),
     CONSTRAINT MEMBER_ID_UQ UNIQUE(ID),
     CONSTRAINT MEMBER_GENDER_CH CHECK(GENDER IN ('남','여')),
--     CONSTRAINT MEMBER_ID_FK FOREIGN KEY(GRADE_ID) REFERENCES MEMBER_GRADE /*(GRADE_CODE)*/, -- 2) 테이블 레벨 방식
     CONSTRAINT MEMBER_AGE_CK CHECK(AGE > 0)
     );

SELECT * FROM MEMBER_GRADE;
SELECT * FROM MEMBER;

INSERT INTO MEMBER VALUES (1, 'USER1', '1234', '박현진', '여', 25, 10, DEFAULT);
INSERT INTO MEMBER VALUES (2, 'USER2', '1234', '이경희', '남', 18, 50, DEFAULT);
-- └ 50이라는 값이 MEMBER_GRADE 테이블에 GRADE_CODE 컬럼에서 제공하는 값이 아니므로 외래 키 제약조건에 위배되어 에러가 발생한다. 
-- <parent key not found> 에러 발생
INSERT INTO MEMBER VALUES (3, 'USER3', '1234', '강지혜', '여', 30, NULL, DEFAULT);
-- GRADE_ID 컬럼에 NULL 사용 가능

-- MEMBER 테이블과 MEMBER_GRADE 테이블을 조인하여 아이디, 이름, 회원 등급을 조회
SELECT M.ID, M.NAME, MG.GRADE_NAME
FROM MEMBER M
--JOIN MEMBER_GRADE MG ON (M.GRADE_ID = MG.GRADE_CODE);
LEFT JOIN MEMBER_GRADE MG ON M.GRADE_ID = MG.GRADE_CODE;

COMMIT;


ROLLBACK;


-- MEMBER_GRADE 테이블에서 GRADE_CODE가 10인 데이터 지우기
DELETE FROM MEMBER_GRADE WHERE GRADE_CODE = 10;
-- └ PRIMARY KEY는 자식 테이블에서 참조하고 있는 값(10)이 있으면 부모 테이블에서 삭제할 수 없다. 

-- MEMBER_GRADE 테이블에서 GRADE_CODE가 30 데이터 지우기
DELETE FROM MEMBER_GRADE WHERE GRADE_CODE = 30;
-- 자식 테이블의 행들 중에 30을 사용하지 않기 때문에 삭제할 수 있다. 



-- ON DELETE SET NULL  

-- 회원 등급에 대한 데이터를 보관하는 테이블 (부모 테이블) 생성
CREATE TABLE MEMBER_GRADE(
    GRADE_CODE NUMBER,
    GRADE_NAME VARCHAR2(20) NOT NULL,
    CONSTRAINT MEMBER_GRADE_PK PRIMARY KEY(GRADE_CODE)
);

INSERT INTO MEMBER_GRADE VALUES(10, '일반회원');
INSERT INTO MEMBER_GRADE VALUES(20, '우수회원');
INSERT INTO MEMBER_GRADE VALUES(30, '특별회원');

DROP TABLE MEMBER;
DROP TABLE MEMBER_GRADE;

CREATE TABLE MEMBER (
     NO NUMBER,
     ID VARCHAR2(20) NOT NULL, 
     PASSWORD VARCHAR2(20) NOT NULL,
     NAME VARCHAR2(15) NOT NULL,
     GENDER CHAR(3) ,
     AGE NUMBER,
     GRADE_ID NUMBER CONSTRAINT MEMBER_GRADE_ID_FK REFERENCES MEMBER_GRADE (GRADE_CODE) ON DELETE SET NULL, 
     ENROLL_DATE DATE DEFAULT SYSDATE,
     CONSTRAINT MEMBER_NO_PK PRIMARY KEY(NO),
     CONSTRAINT MEMBER_ID_UQ UNIQUE(ID),
     CONSTRAINT MEMBER_GENDER_CH CHECK(GENDER IN ('남','여')),
     CONSTRAINT MEMBER_AGE_CK CHECK(AGE > 0)
     );

INSERT INTO MEMBER VALUES (1, 'USER1', '1234', '박현진', '여', 25, 10, DEFAULT);
INSERT INTO MEMBER VALUES (2, 'USER2', '1234', '이경희', '남', 18, NULL, DEFAULT);


-- MEMBER_GRADE 테이블에서 GRADE_CODE가 10인 데이터 지우기
DELETE FROM MEMBER_GRADE WHERE GRADE_CODE = 10;

SELECT * FROM MEMBER_GRADE;
SELECT * FROM MEMBER;




-- ON DELETE CASCADE 옵션이 추가된 자식 테이블 생성

-- 회원 등급에 대한 데이터를 보관하는 테이블 (부모 테이블) 생성
CREATE TABLE MEMBER_GRADE(
    GRADE_CODE NUMBER,
    GRADE_NAME VARCHAR2(20) NOT NULL,
    CONSTRAINT MEMBER_GRADE_PK PRIMARY KEY(GRADE_CODE)
);

INSERT INTO MEMBER_GRADE VALUES(10, '일반회원');
INSERT INTO MEMBER_GRADE VALUES(20, '우수회원');
INSERT INTO MEMBER_GRADE VALUES(30, '특별회원');

DROP TABLE MEMBER;
DROP TABLE MEMBER_GRADE;

CREATE TABLE MEMBER (
     NO NUMBER,
     ID VARCHAR2(20) NOT NULL, 
     PASSWORD VARCHAR2(20) NOT NULL,
     NAME VARCHAR2(15) NOT NULL,
     GENDER CHAR(3) ,
     AGE NUMBER,
     GRADE_ID NUMBER CONSTRAINT MEMBER_GRADE_ID_FK REFERENCES MEMBER_GRADE (GRADE_CODE) ON DELETE CASCADE, 
     ENROLL_DATE DATE DEFAULT SYSDATE,
     CONSTRAINT MEMBER_NO_PK PRIMARY KEY(NO),
     CONSTRAINT MEMBER_ID_UQ UNIQUE(ID),
     CONSTRAINT MEMBER_GENDER_CH CHECK(GENDER IN ('남','여')),
     CONSTRAINT MEMBER_AGE_CK CHECK(AGE > 0)
     );

INSERT INTO MEMBER VALUES (1, 'USER1', '1234', '박현진', '여', 25, 10, DEFAULT);
INSERT INTO MEMBER VALUES (2, 'USER2', '1234', '이경희', '남', 18, NULL, DEFAULT);


-- MEMBER_GRADE 테이블에서 GRADE_CODE가 10인 데이터 지우기
DELETE FROM MEMBER_GRADE WHERE GRADE_CODE = 10;

SELECT * FROM MEMBER_GRADE;
SELECT * FROM MEMBER;

ROLLBACK;

SELECT UC.CONSTRAINT_NAME, 
       UC.TABLE_NAME, 
       UCC.COLUMN_NAME, 
       UC.CONSTRAINT_TYPE,
       UC.SEARCH_CONDITION
FROM USER_CONSTRAINTS UC
JOIN USER_CONS_COLUMNS UCC ON (UC.CONSTRAINT_NAME = UCC.CONSTRAINT_NAME)
WHERE UC.TABLE_NAME = 'MEMBER';

/*
    <서브 쿼리를 이용한 테이블 생성>
*/

-- EMPLOYEE 테이블을 복사한 새로운 테이블 생성 (컬럼명, 데이터 타입, 값, NOT NULL 제약조건을 복사)
CREATE TABLE EMPLOYEE_COPY
AS SELECT *
    FROM EMPLOYEE;

CREATE TABLE MEMBER_COPY
AS SELECT * 
    FROM MEMBER;

SELECT *
FROM EMPLOYEE_COPY;

SELECT * 
FROM EMPLOYEE_COPY;


-- EMPLOYEE 테이블을 복사한 새로운 테이블 생성 (컬럼명, 데이터 타입, NOT NULL 제약조건을 복사)
CREATE TABLE EMPLOYEE_COPY2
AS SELECT *
    FROM EMPLOYEE
    WHERE 1 = 0; -- 모든 행에 대해서 매번 FALSE 이기 때문에 구조만 복사되고 데이터 값은 복사되지 않는다. 
    

-- EMPLOYEE 테이블에서 사번, 직원명, 급여, 연봉을 저장하는 테이블 생성
CREATE TABLE EMPLOYEE_COPY3
AS SELECT EMP_ID AS "사번",
          EMP_NAME AS "직원명",
          SALARY AS "급여",
          SALARY * 12 AS "연봉"
   FROM EMPLOYEE;
   
   
DROP TABLE EMPLOYEE_COPY;
DROP TABLE EMPLOYEE_COPY2;
DROP TABLE EMPLOYEE_COPY3;
DROP TABLE MEMBER_COPY;

---------------------------------------------------------------------
-- 실습 문제
-- 도서관리 프로그램을 만들기 위한 테이블 만들기
-- 이때, 제약조건에 이름을 부여하고, 각 컬럼에 주석 달기


-- 1. 출판사들에 대한 데이터를 담기 위한 출판사 테이블(TB_PUBLISHER) 
--  1) 컬럼 : PUB_NO(출판사 번호) -- 기본 키
--           PUB_NAME(출판사명) -- NOT NULL
--           PHONE(출판사 전화번호) -- 제약조건 없음

CREATE TABLE TB_PUBLISHER (
    PUB_NO NUMBER, 
    PUB_NAME VARCHAR2(50) CONSTRAINT TB_PUBLISHER_PUB_NN NOT NULL, 
    PHONE VARCHAR2(15),
    CONSTRAINT TB_PUBLISHER_PB_NO_PK PRIMARY KEY(PUB_NO)
);

COMMENT ON COLUMN TB_PUBLISHER.PUB_NO IS '출판사 번호';
COMMENT ON COLUMN TB_PUBLISHER.PUB_NAME IS '출판사명';
COMMENT ON COLUMN TB_PUBLISHER.PHONE IS '출판사 전화번호';

--  2) 3개 정도의 샘플 데이터 추가하기
INSERT INTO TB_PUBLISHER VALUES(1, 'KH북스', '02-1111-2222');
INSERT INTO TB_PUBLISHER VALUES(2, '조은출판사', '02-3333-4444');
INSERT INTO TB_PUBLISHER VALUES(3, '구린출판사', '02-5555-6666');

SELECT * FROM TB_PUBLISHER;
DROP TABLE TB_PUBLISHER;

-- 2. 도서들에 대한 데이터를 담기 위한 도서 테이블 (TB_BOOK)
--  1) 컬럼 : BK_NO (도서번호) -- 기본 키
--           BK_TITLE (도서명) -- NOT NULL
--           BK_AUTHOR(저자명) -- NOT NULL
--           BK_PRICE(가격)
--           BK_PUB_NO(출판사 번호) -- 외래 키 (TB_PUBLISHER 테이블을 참조하도록)
--                                  이때 참조하고 있는 부모 데이터 삭제 시 자식 데이터도 삭제 되도록 옵션 지정

CREATE TABLE TB_BOOK (
    BK_NO NUMBER,
    BK_TITLE VARCHAR2(100) CONSTRAINT TB_BOOK_BK_TITLE_NN NOT NULL,
    BK_AUTHOR VARCHAR2(50) CONSTRAINT TB_BOOK_BK_AUTHOR_NN NOT NULL,
    BK_PRICE NUMBER,
    BK_PUB_NO NUMBER,
    CONSTRAINT TB_BOOK_BK_NO_PK PRIMARY KEY(BK_NO),
    CONSTRAINT TB_BOOK_BK_PUB_NO_FK FOREIGN KEY(BK_PUB_NO) REFERENCES TB_PUBLISHER ON DELETE CASCADE
    );

COMMENT ON COLUMN TB_BOOK.BK_NO IS '도서번호';
COMMENT ON COLUMN TB_BOOK.BK_TITLE IS '도서명';
COMMENT ON COLUMN TB_BOOK.BK_AUTHOR IS '저자명';
COMMENT ON COLUMN TB_BOOK.BK_PRICE IS '가격';
COMMENT ON COLUMN TB_BOOK.PUB_NO IS '출판사 번호';

SELECT * FROM TB_BOOK;

--  2) 5개 정도의 샘플 데이터 추가하기

INSERT INTO TB_BOOK VALUES(1, '홍길동전', '허균', 15000, 1);
INSERT INTO TB_BOOK VALUES(2, '마블코믹스', '마블', 25000, 2);
INSERT INTO TB_BOOK VALUES(3, '7년의 밤', '정유정', 30000, 2);
INSERT INTO TB_BOOK VALUES(4, '나무', '베르나르베르베르', 18000, 1);
INSERT INTO TB_BOOK VALUES(5, '부동산 투자수업', '부읽남', 30000, 3);


-- 3. 회원에 대한 데이터를 담기 위한 회원 테이블 (TB_MEMBER)
--  1) 컬럼 : MEMBER_NO(회원번호) -- 기본 키
--           MEMBER_ID(아이디)   -- 중복 금지
--           MEMBER_PWD(비밀번호) -- NOT NULL
--           MEMBER_NAME(회원명) -- NOT NULL
--           GENDER(성별)        -- 'M' 또는 'F'로 입력되도록 제한
--           ADDRESS(주소)       
--           PHONE(연락처)       
--           STATUS(탈퇴 여부)     -- 기본값으로 'N'  그리고 'Y' 혹은 'N'으로 입력되도록 제약조건
--           ENROLL_DATE(가입일)  -- 기본값으로 SYSDATE, NOT NULL

CREATE TABLE TB_MEMBER (
    MEMBER_NO NUMBER, 
    MEMBER_ID VARCHAR2(20), 
    MEMBER_PWD VARCHAR2(30) CONSTRAINT TB_MEMBER_MEMBER_PWD_NN NOT NULL,
    MEMBER_NAME VARCHAR2(20) CONSTRAINT TB_MEMBER_MEMBER_NAME_NN NOT NULL, 
    GENDER CHAR(1),
    ADDRESS VARCHAR2 (150),
    PHONE VARCHAR2(15), 
    STATUS CHAR(1) DEFAULT 'N', 
    ENROLL_DATE DATE DEFAULT SYSDATE CONSTRAINT TB_MEMBER_ENROLL_DATE_NN NOT NULL,
    
    CONSTRAINT TB_MEMBER_MEMBER_NO_PK PRIMARY KEY(MEMBER_NO),
    CONSTRAINT TB_MEMBER_MEMBER_ID_UQ UNIQUE(MEMBER_ID),
    CONSTRAINT TB_MEMBER_GENDER_CK CHECK(GENDER IN('M', 'F')),
    CONSTRAINT TB_MAMBER_STATUS_CK CHECK(STATUS IN('Y', 'N'))
);


COMMENT ON COLUMN TB_MEMBER.MEMBER_NO IS '회원번호';
COMMENT ON COLUMN TB_MEMBER.MEMBER_ID IS '아이디';
COMMENT ON COLUMN TB_MEMBER.MEMBER_PWD IS '비밀번호';
COMMENT ON COLUMN TB_MEMBER.MEMBER_NAME IS '회원명';
COMMENT ON COLUMN TB_MEMBER.GENDER IS '성별';
COMMENT ON COLUMN TB_MEMBER.PHONE IS '연락처';
COMMENT ON COLUMN TB_MEMBER.ADDRESS IS '주소';
COMMENT ON COLUMN TB_MEMBER.STATUS IS '탈퇴 여부';
COMMENT ON COLUMN TB_MEMBER.ENROLL_DATE IS '가입일';


--  2) 3개 정도의 샘플 데이터 추가하기
INSERT INTO TB_MEMBER VALUES(1, 'ismoon', '1234', '문인수', 'M', '경기도 광주시', '01041794341', DEFAULT, DEFAULT);
INSERT INTO TB_MEMBER VALUES(2, 'yeonu', '1234', '정연우', 'M', '서울시 강남구', '01011112222', DEFAULT, DEFAULT);
INSERT INTO TB_MEMBER VALUES(3, 'user1', '1234', '정수연', 'F', '경기도 안산시', '01033334444', DEFAULT, DEFAULT);

SELECT * FROM TB_MEMBER;
DROP TABLE TB_MEMBER;


-- 4. 도서를 대여한 회원에 대한 데이터를 담기 위한 대여 목록 테이블(TB_RENT)
--  1) 컬럼 : RENT_NO(대여번호) -- 기본 키
--           RENT_MEM_NO(대여 회원번호) -- 외래 키 (TB_MEMBER와 참조하도록)
--                                      이때 부모 데이터 삭제 시 NULL 값이 되도록 옵션 설정
--           RENT_BOOK_NO(대여도서번호) -- 외래 키 ( TB_BOOK와 참조하도록)
--                                      이때 부모 데이터 삭제 시 NULL 값이 되도록 옵션 설정
--           RENT_DATE(대여일) -- 기본값 SYSDATE

CREATE TABLE TB_RENT (
    RENT_NO NUMBER,
    RENT_MEM_NO NUMBER,
    RENT_BOOK_NO NUMBER,
    RENT_DATE DATE DEFAULT SYSDATE,
    CONSTRAINT TB_RENT_RENT_NO_PK PRIMARY KEY(RENT_NO),
    CONSTRAINT TB_RENT_RENT_MEM_NO_FK FOREIGN KEY(RENT_MEM_NO) REFERENCES TB_MEMBER ON DELETE SET NULL,
    CONSTRAINT TB_RENT_RENT_BOOK_NO_FK FOREIGN KEY(RENT_BOOK_NO) REFERENCES TB_BOOK ON DELETE SET NULL
    );

COMMENT ON COLUMN TB_RENT.RENT_NO IS '대여 번호';
COMMENT ON COLUMN TB_RENT.RENT_MEM_NO IS '대여 회원번호';
COMMENT ON COLUMN TB_RENT.RENT_BOOK_NO IS '대여 도서번호';
COMMENT ON COLUMN TB_RENT.RENT_DATE IS '대여일';

--  2) 샘플 데이터 3개 정도 
INSERT INTO TB_RENT VALUES (1, 1, 2, DEFAULT);
INSERT INTO TB_RENT VALUES (2, 1, 3, DEFAULT);
INSERT INTO TB_RENT VALUES (3, 2, 1, DEFAULT);
INSERT INTO TB_RENT VALUES (4, 2, 2, DEFAULT);
INSERT INTO TB_RENT VALUES (5, 1, 5, DEFAULT);


SELECT * FROM TB_RENT;


-- 5. 2번 도서를 대여한 회원의 이름, 아이디, 대여일, 반납 예정일(대여일 + 7일)을 조회하시오
SELECT TM.MEMBER_NAME AS "회원 이름",
       TM.MEMBER_ID AS "회원의 이름",
       TR.RENT_DATE AS "대여일",
       TR.RENT_DATE + 7 AS "반납 예정일",
       TR.RENT_BOOK_NO
FROM TB_MEMBER TM 
INNER JOIN TB_RENT TR ON (TM.MEMBER_NO = TR.RENT_MEM_NO)
WHERE TR.RENT_BOOK_NO = 2;


-- 6. 회원번호가 1번인 회원이 대여한 도서들의 도서명, 출판사명, 대여일, 반납예정일을 조회하시오
SELECT TB.BK_TITLE AS "도서명",
       TP.PUB_NAME AS "출판사명",
       TR.RENT_DATE AS "대여일",
       TR.RENT_DATE + 7 AS "반납 예정일"
FROM TB_RENT TR
INNER JOIN TB_BOOK TB ON (TR.RENT_BOOK_NO = TB.BK_NO)
INNER JOIN TB_PUBLISHER TP ON (TB.BK_PUB_NO = TP.PUB_NO)
WHERE TR.RENT_MEM_NO = 1;


----------------------------------------------------------------------------------------------------------------





