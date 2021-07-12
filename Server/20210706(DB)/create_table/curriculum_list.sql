-- ----------------------------------------------------------------
--  TABLE curriculum_list
-- ----------------------------------------------------------------

CREATE TABLE `ONPE_DEV`.curriculum_list
(
   curriculum_code        VARCHAR(50)
                            CHARACTER SET utf8
                            COLLATE utf8_general_ci
                            NOT NULL
                            COMMENT '커리큘럼 코드 ( 양식 미정 )',
   class_level            CHAR(1)
                            CHARACTER SET utf8
                            COLLATE utf8_general_ci
                            NOT NULL
                            COMMENT '학교(초중고)',
   class_grade            CHAR(1)
                            CHARACTER SET utf8
                            COLLATE utf8_general_ci
                            NOT NULL
                            COMMENT '학년',
   class_semester         CHAR(1)
                            CHARACTER SET utf8
                            COLLATE utf8_general_ci
                            NOT NULL
                            COMMENT '클래스 학기',
   curriculum_provider    VARCHAR(100)
                            CHARACTER SET utf8
                            COLLATE utf8_general_ci
                            NOT NULL
                            COMMENT '제공자(생성자)',
   curriculum_title       VARCHAR(100)
                            CHARACTER SET utf8
                            COLLATE utf8_general_ci
                            NOT NULL
                            COMMENT '제목',
   curriculum_date        BIGINT(8) NOT NULL COMMENT '커리큘럼 등록일',
   class_code_list        TEXT
                            CHARACTER SET utf8
                            COLLATE utf8_general_ci
                            NOT NULL
                            COMMENT '차시별 코드',
   curriculum_info        TEXT
                            CHARACTER SET utf8
                            COLLATE utf8_general_ci
                            NOT NULL
                            COMMENT '커리큘럼 설명 TEXT',
   PRIMARY KEY(curriculum_code)
)
COMMENT '커리큘럼 리스트'
ENGINE INNODB
COLLATE 'utf8_general_ci'
ROW_FORMAT DEFAULT;


