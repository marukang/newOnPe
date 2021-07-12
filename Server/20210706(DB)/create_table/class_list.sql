-- ----------------------------------------------------------------
--  TABLE class_list
-- ----------------------------------------------------------------

CREATE TABLE `ONPE_DEV`.class_list
(
   number                       INT(8) NOT NULL AUTO_INCREMENT COMMENT '정렬용 번호',
   teacher_id                   VARCHAR(50)
                                  CHARACTER SET utf8
                                  COLLATE utf8_general_ci
                                  NOT NULL
                                  COMMENT '클래스 소유자 아이디',
   class_code                   VARCHAR(50)
                                  CHARACTER SET utf8
                                  COLLATE utf8_general_ci
                                  NOT NULL
                                  COMMENT '클래스 코드',
   class_year                   CHAR(4)
                                  CHARACTER SET utf8
                                  COLLATE utf8_general_ci
                                  NOT NULL
                                  COMMENT '클래스년도',
   class_semester               CHAR(1)
                                  CHARACTER SET utf8
                                  COLLATE utf8_general_ci
                                  NOT NULL
                                  COMMENT '클래스 학기',
   class_grade                  CHAR(1)
                                  CHARACTER SET utf8
                                  COLLATE utf8_general_ci
                                  NOT NULL
                                  COMMENT '클래스 학년',
   class_group                  VARCHAR(2)
                                  CHARACTER SET utf8
                                  COLLATE utf8_general_ci
                                  NOT NULL
                                  COMMENT '클래스 학급',
   class_people_count           INT(2) NOT NULL DEFAULT 0 COMMENT '클래스 정원',
   class_people_max_count       INT(2)
                                  NOT NULL
                                  COMMENT '클래스 최대 정원',
   class_name                   VARCHAR(50)
                                  CHARACTER SET utf8
                                  COLLATE utf8_general_ci
                                  NULL
                                  COMMENT '클래스 수업명',
   class_start_date             BIGINT(8)
                                  NULL
                                  COMMENT '클래스 수업 시작일',
   class_end_date               BIGINT(8)
                                  NULL
                                  COMMENT '클래스 수업 종료일',
   class_project_submit_type    TEXT
                                  CHARACTER SET utf8
                                  COLLATE utf8_general_ci
                                  NULL
                                  COMMENT '클래스 과제 제출 타입',
   class_state                  CHAR(1)
                                  CHARACTER SET utf8
                                  COLLATE utf8_general_ci
                                  NULL
                                  DEFAULT '0'
                                  COMMENT '클래스 상태(0:준비중, 1:진행중, 2:수업종료, 3:최종 마감)',
   class_unit_list              TEXT
                                  CHARACTER SET utf8
                                  COLLATE utf8_general_ci
                                  NULL
                                  COMMENT '차시별 수업 리스트',
   PRIMARY KEY(class_code),
   UNIQUE KEY number(number)
)
COMMENT '선생님 클래스 리스트 - Step 1'
ENGINE INNODB
COLLATE 'utf8_general_ci'
ROW_FORMAT DEFAULT;


