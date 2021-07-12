-- ----------------------------------------------------------------
--  TABLE recommend_exercise_combination_list
-- ----------------------------------------------------------------

CREATE TABLE `ONPE_DEV`.recommend_exercise_combination_list
(
   combination_code             INT(11)
                                  NOT NULL
                                  AUTO_INCREMENT
                                  COMMENT '운동 조합 코드',
   combination_category         VARCHAR(10)
                                  CHARACTER SET utf8
                                  COLLATE utf8_general_ci
                                  NOT NULL
                                  COMMENT '종목',
   exercise_category            VARCHAR(20)
                                  CHARACTER SET utf8
                                  COLLATE utf8_general_ci
                                  NOT NULL
                                  COMMENT '종목 대분류',
   combination_title            VARCHAR(20)
                                  CHARACTER SET utf8
                                  COLLATE utf8_general_ci
                                  NOT NULL
                                  COMMENT '종목 제목',
   combination_provider         VARCHAR(50)
                                  CHARACTER SET utf8
                                  COLLATE utf8_general_ci
                                  NOT NULL
                                  COMMENT '종목 생산자',
   class_level                  CHAR(1)
                                  CHARACTER SET utf8
                                  COLLATE utf8_general_ci
                                  NOT NULL
                                  COMMENT '학교',
   class_grade                  CHAR(1)
                                  CHARACTER SET utf8
                                  COLLATE utf8_general_ci
                                  NOT NULL
                                  COMMENT '학년',
   combination_date             BIGINT(8) NOT NULL COMMENT '등록일',
   combination_exercise_list    TEXT
                                  CHARACTER SET utf8
                                  COLLATE utf8_general_ci
                                  NOT NULL
                                  COMMENT '종목 리스트 코드',
   PRIMARY KEY(combination_code)
)
COMMENT '추천 조합 관리 - 추천 운동조합 리스트 ( 현재 미사용 )'
ENGINE INNODB
COLLATE 'utf8_general_ci'
ROW_FORMAT DEFAULT;


