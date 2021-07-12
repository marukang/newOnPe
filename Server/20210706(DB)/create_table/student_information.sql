-- ----------------------------------------------------------------
--  TABLE student_information
-- ----------------------------------------------------------------

CREATE TABLE `ONPE_DEV`.student_information
(
   student_id                      VARCHAR(20)
                                     CHARACTER SET utf8
                                     COLLATE utf8_general_ci
                                     NOT NULL
                                     COMMENT '학생 아이디',
   student_name                    VARCHAR(6)
                                     CHARACTER SET utf8
                                     COLLATE utf8_general_ci
                                     NOT NULL
                                     COMMENT '학생 이름',
   student_password                VARCHAR(100)
                                     CHARACTER SET utf8
                                     COLLATE utf8_general_ci
                                     NOT NULL
                                     COMMENT '학생 비밀번호(암호화)',
   student_email                   VARCHAR(50)
                                     CHARACTER SET utf8
                                     COLLATE utf8_general_ci
                                     NOT NULL
                                     COMMENT '학생 이메일',
   student_phone                   CHAR(13)
                                     CHARACTER SET utf8
                                     COLLATE utf8_general_ci
                                     NULL
                                     COMMENT '학생 핸드폰번호("-" 포함)',
   student_push_agreement          CHAR(1)
                                     CHARACTER SET utf8
                                     COLLATE utf8_general_ci
                                     NOT NULL
                                     COMMENT '푸시 수신 동의(동의 : 1 // 비동의 : 0  )',
   student_email_agreement         CHAR(1)
                                     CHARACTER SET utf8
                                     COLLATE utf8_general_ci
                                     NOT NULL
                                     COMMENT '이메일 수신 동의(동의 : 1 // 비동의 : 0  )',
   student_message_agreement       CHAR(1)
                                     CHARACTER SET utf8
                                     COLLATE utf8_general_ci
                                     NOT NULL
                                     COMMENT '문자 수신 동의(동의 : 1 // 비동의 : 0  )',
   student_image_url               TEXT
                                     CHARACTER SET utf8
                                     COLLATE utf8_general_ci
                                     NULL
                                     COMMENT '프로필 이미지',
   student_content                 TEXT
                                     CHARACTER SET utf8
                                     COLLATE utf8_general_ci
                                     NULL
                                     COMMENT '자기소개',
   student_tall                    VARCHAR(3)
                                     CHARACTER SET utf8
                                     COLLATE utf8_general_ci
                                     NULL
                                     COMMENT '키',
   student_weight                  VARCHAR(3)
                                     CHARACTER SET utf8
                                     COLLATE utf8_general_ci
                                     NULL
                                     COMMENT '몸무게',
   student_age                     VARCHAR(2)
                                     CHARACTER SET utf8
                                     COLLATE utf8_general_ci
                                     NULL
                                     COMMENT '나이',
   student_sex                     CHAR(1)
                                     CHARACTER SET utf8
                                     COLLATE utf8_general_ci
                                     NULL
                                     COMMENT '성별(m:남자, f:여자)',
   student_school                  VARCHAR(30)
                                     CHARACTER SET utf8
                                     COLLATE utf8_general_ci
                                     NULL
                                     COMMENT '학교 이름( 000고등학교 )',
   student_level                   CHAR(1)
                                     CHARACTER SET utf8
                                     COLLATE utf8_general_ci
                                     NULL
                                     COMMENT '학급 ( 1 ~ 6 ) -> 학년',
   student_class                   VARCHAR(2)
                                     CHARACTER SET utf8
                                     COLLATE utf8_general_ci
                                     NULL
                                     COMMENT '반 ( 1 ~ 20 )',
   student_number                  VARCHAR(3)
                                     CHARACTER SET utf8
                                     COLLATE utf8_general_ci
                                     NULL
                                     COMMENT '번호 ( 1 ~ 40 )',
   student_state                   CHAR(1)
                                     CHARACTER SET utf8
                                     COLLATE utf8_general_ci
                                     NOT NULL
                                     DEFAULT '0'
                                     COMMENT '학생 가입 상태 ( 0: 정상가입 / 1: 회원탈퇴 )',
   news_state                      CHAR(1)
                                     CHARACTER SET utf8
                                     COLLATE utf8_general_ci
                                     NOT NULL
                                     DEFAULT '0'
                                     COMMENT '새 소식함, 소식이 없는 경우 : 0 / 소식이 있는 경우 : 1 ',
   new_messgae_state               CHAR(1)
                                     CHARACTER SET utf8
                                     COLLATE utf8_general_ci
                                     NOT NULL
                                     DEFAULT '0'
                                     COMMENT '메시지 함, 메시지가 없는 경우 : 0 / 메시지가 있는 경우 : 1',
   student_classcode               TEXT
                                     CHARACTER SET utf8
                                     COLLATE utf8_general_ci
                                     NULL
                                     COMMENT '학생 보유 클래스 코드 ///////////Ex) {[key(00고등학교11589) : value([그룹번호 1,수업 명],   …..}',
   student_create_date             BIGINT(14)
                                     NOT NULL
                                     DEFAULT 0
                                     COMMENT '학생 가입일(계정 생성일)',
   student_recent_join_date        BIGINT(14)
                                     NOT NULL
                                     DEFAULT 0
                                     COMMENT '최근 접속일',
   student_recent_exercise_date    BIGINT(14)
                                     NULL
                                     COMMENT '학생 최근 운동일',
   student_token                   VARCHAR(200)
                                     CHARACTER SET utf8
                                     COLLATE utf8_general_ci
                                     NULL
                                     COMMENT '학생FCM 토큰',
   PRIMARY KEY(student_id)
)
COMMENT '학생정보 테이블'
ENGINE INNODB
COLLATE 'utf8_general_ci'
ROW_FORMAT DEFAULT;


