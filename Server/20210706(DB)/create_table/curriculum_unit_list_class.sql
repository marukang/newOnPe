-- ----------------------------------------------------------------
--  TABLE curriculum_unit_list_class
-- ----------------------------------------------------------------

CREATE TABLE `ONPE_DEV`.curriculum_unit_list_class
(
   unit_code                  VARCHAR(50)
                                CHARACTER SET utf8
                                COLLATE utf8_general_ci
                                NOT NULL
                                COMMENT '차시별(유닛별) 코드 (현재시간 + 클래스코드 + 선생님 아이디)',
   class_code                 VARCHAR(50)
                                CHARACTER SET utf8
                                COLLATE utf8_general_ci
                                NOT NULL
                                COMMENT '클래스코드',
   unit_class_type            CHAR(1)
                                CHARACTER SET utf8
                                COLLATE utf8_general_ci
                                NOT NULL
                                COMMENT '수업 타입 ( 0: 전체형 / 1: 맞춤형 )',
   unit_group_name            VARCHAR(50)
                                CHARACTER SET utf8
                                COLLATE utf8_general_ci
                                NULL
                                COMMENT '그룹명',
   unit_group_id_list         TEXT
                                CHARACTER SET utf8
                                COLLATE utf8_general_ci
                                NULL
                                COMMENT '학생 학생 번호',
   unit_class_name            VARCHAR(50)
                                CHARACTER SET utf8
                                COLLATE utf8_general_ci
                                NOT NULL
                                COMMENT '수업명',
   unit_class_text            TEXT
                                CHARACTER SET utf8
                                COLLATE utf8_general_ci
                                NOT NULL
                                COMMENT '수업 관련 텍스트',
   unit_start_date            BIGINT(14) NOT NULL COMMENT '수업 일시',
   unit_end_date              BIGINT(14) NOT NULL COMMENT '수업 데드라인',
   unit_youtube_url           TEXT
                                CHARACTER SET utf8
                                COLLATE utf8_general_ci
                                NULL
                                COMMENT '유튜브 영상 URL',
   unit_content_url           TEXT
                                CHARACTER SET utf8
                                COLLATE utf8_general_ci
                                NULL
                                COMMENT '수업 관련 링크',
   unit_attached_file         TEXT
                                CHARACTER SET utf8
                                COLLATE utf8_general_ci
                                NULL
                                COMMENT '참고자료',
   content_code_list          TEXT
                                CHARACTER SET utf8
                                COLLATE utf8_general_ci
                                NOT NULL
                                COMMENT '컨텐츠 분류',
   content_participation      TEXT
                                CHARACTER SET utf8
                                COLLATE utf8_general_ci
                                NULL
                                COMMENT '참여 학생',
   content_submit_task        TEXT
                                CHARACTER SET utf8
                                COLLATE utf8_general_ci
                                NULL
                                COMMENT '과제 제출',
   content_use_time           INT(11) NOT NULL COMMENT '이용시간',
   content_home_work          TEXT
                                CHARACTER SET utf8
                                COLLATE utf8_general_ci
                                NOT NULL
                                COMMENT '과제유무 ( 0: 과제없음, 1: 과제있음 )',
   content_test               TEXT
                                CHARACTER SET utf8
                                COLLATE utf8_general_ci
                                NOT NULL
                                COMMENT '평가유무 ( 0: 평가없음, 1: 평가있음 )',
   content_evaluation_type    TEXT
                                CHARACTER SET utf8
                                COLLATE utf8_general_ci
                                NOT NULL
                                COMMENT '평가방식 ( 0: 평가없음, 1:상중하, 2: 숫자입력, 3: 텍스트입력)'
)
COMMENT '차시별(단원별) 리스트'
ENGINE INNODB
COLLATE 'utf8_general_ci'
ROW_FORMAT DEFAULT;


