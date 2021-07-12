-- ----------------------------------------------------------------
--  TABLE teacher_information
-- ----------------------------------------------------------------

CREATE TABLE `ONPE_DEV`.teacher_information
(
   teacher_id                   VARCHAR(50)
                                  CHARACTER SET utf8
                                  COLLATE utf8_general_ci
                                  NOT NULL
                                  COMMENT '아이디',
   teacher_name                 VARCHAR(10)
                                  CHARACTER SET utf8
                                  COLLATE utf8_general_ci
                                  NOT NULL
                                  COMMENT '이름',
   teacher_password             VARCHAR(100)
                                  CHARACTER SET utf8
                                  COLLATE utf8_general_ci
                                  NOT NULL
                                  COMMENT '비밀번호',
   teacher_email                VARCHAR(50)
                                  CHARACTER SET utf8
                                  COLLATE utf8_general_ci
                                  NOT NULL
                                  COMMENT '이메일',
   teacher_phone                VARCHAR(11)
                                  CHARACTER SET utf8
                                  COLLATE utf8_general_ci
                                  NOT NULL
                                  COMMENT '핸드폰번호',
   teacher_birth                CHAR(8)
                                  CHARACTER SET utf8
                                  COLLATE utf8_general_ci
                                  NOT NULL
                                  COMMENT '생년월일',
   teacher_sex                  CHAR(1)
                                  CHARACTER SET utf8
                                  COLLATE utf8_general_ci
                                  NOT NULL
                                  COMMENT '성별',
   teacher_school               VARCHAR(30)
                                  CHARACTER SET utf8
                                  COLLATE utf8_general_ci
                                  NOT NULL
                                  COMMENT '학교',
   teacher_state                VARCHAR(1)
                                  CHARACTER SET utf8
                                  COLLATE utf8_general_ci
                                  NOT NULL
                                  COMMENT '가입 상태 ( 0: 정상 가입 / 1: 회원 탈퇴 )',
   teacher_email_agreement      CHAR(1)
                                  CHARACTER SET utf8
                                  COLLATE utf8_general_ci
                                  NOT NULL
                                  COMMENT '이메일 수신 동의 ( 동의 : 1 / 비동의 : 0 )',
   teacher_message_agreement    CHAR(1)
                                  CHARACTER SET utf8
                                  COLLATE utf8_general_ci
                                  NOT NULL
                                  COMMENT '문자 수신 동의 ( 동의 : 1 / 비동의 : 0 )',
   teacher_join_date            BIGINT(14) NOT NULL COMMENT '가입일',
   teacher_recent_join_date     BIGINT(14) NULL COMMENT '최근 접속일',
   admin_auth                   VARCHAR(30)
                                  CHARACTER SET utf8
                                  COLLATE utf8_general_ci
                                  NOT NULL
                                  COMMENT '관리자 ( ADMIN 판단용 )',
   PRIMARY KEY(teacher_id),
   UNIQUE KEY teacher_email(teacher_email),
   UNIQUE KEY teacher_phone(teacher_phone)
)
COMMENT '선생님 정보'
ENGINE INNODB
COLLATE 'utf8_general_ci'
ROW_FORMAT DEFAULT;


