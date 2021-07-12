-- ----------------------------------------------------------------
--  TABLE student_class_record
-- ----------------------------------------------------------------

CREATE TABLE `ONPE_DEV`.student_class_record
(
   number                   INT(11) NOT NULL AUTO_INCREMENT COMMENT '번호(정렬용)',
   unit_code                VARCHAR(50)
                              CHARACTER SET utf8
                              COLLATE utf8_general_ci
                              NOT NULL
                              COMMENT '시차별(단원별) 코드',
   class_code               VARCHAR(50)
                              CHARACTER SET utf8
                              COLLATE utf8_general_ci
                              NOT NULL
                              COMMENT '클래스 코드',
   student_id               VARCHAR(50)
                              CHARACTER SET utf8
                              COLLATE utf8_general_ci
                              NOT NULL
                              COMMENT '학생아이디',
   student_name             VARCHAR(6)
                              CHARACTER SET utf8
                              COLLATE utf8_general_ci
                              NOT NULL
                              COMMENT '학생이름',
   student_grade            CHAR(1)
                              CHARACTER SET utf8
                              COLLATE utf8_general_ci
                              NOT NULL
                              COMMENT '학생 학년',
   student_group            VARCHAR(2)
                              CHARACTER SET utf8
                              COLLATE utf8_general_ci
                              NOT NULL
                              COMMENT '학급 반',
   student_number           VARCHAR(2)
                              CHARACTER SET utf8
                              COLLATE utf8_general_ci
                              NOT NULL
                              COMMENT '번호',
   student_participation    CHAR(1)
                              CHARACTER SET utf8
                              COLLATE utf8_general_ci
                              NOT NULL
                              COMMENT '출석여부(0: No 1: Yes)',
   student_practice         CHAR(1)
                              CHARACTER SET utf8
                              COLLATE utf8_general_ci
                              NOT NULL
                              COMMENT '최종제출여부(0미제출 1 제출)',
   evaluation_type_1        TEXT
                              CHARACTER SET utf8
                              COLLATE utf8_general_ci
                              NULL
                              COMMENT '평가 점수(상:3,중:2,하:1,없음:0)',
   evaluation_type_2        TEXT
                              CHARACTER SET utf8
                              COLLATE utf8_general_ci
                              NULL
                              COMMENT '평가 점수(숫자)',
   evaluation_type_3        TEXT
                              CHARACTER SET utf8
                              COLLATE utf8_general_ci
                              NULL
                              COMMENT '평가 점수(Text)',
   image_confirmation       TEXT
                              CHARACTER SET utf8
                              COLLATE utf8_general_ci
                              NULL
                              COMMENT '본인확인 이미지',
   class_practice           TEXT
                              CHARACTER SET utf8
                              COLLATE utf8_general_ci
                              NULL
                              COMMENT '수업 실습',
   task_practice            TEXT
                              CHARACTER SET utf8
                              COLLATE utf8_general_ci
                              NULL
                              COMMENT '과제 실습',
   evaluation_practice      TEXT
                              CHARACTER SET utf8
                              COLLATE utf8_general_ci
                              NULL
                              COMMENT '평가 실습',
   PRIMARY KEY(number)
)
COMMENT '학생 시차(단원)별 기록 리스트'
ENGINE INNODB
COLLATE 'utf8_general_ci'
ROW_FORMAT DEFAULT;


