-- ----------------------------------------------------------------
--  TABLE hi_score_list
-- ----------------------------------------------------------------

CREATE TABLE `ONPE_DEV`.hi_score_list
(
   student_id              VARCHAR(50)
                             CHARACTER SET utf8
                             COLLATE utf8_general_ci
                             NOT NULL
                             COMMENT '학생 아이디',
   student_age             VARCHAR(2)
                             CHARACTER SET utf8
                             COLLATE utf8_general_ci
                             NOT NULL
                             COMMENT '나이 (만)',
   recent_exercise_date    BIGINT(14)
                             NOT NULL
                             DEFAULT 0
                             COMMENT '최근 운동일',
   student_score           INT(4) NOT NULL COMMENT 'Hi_Score 점수'
)
COMMENT 'Hi-Score List(학생 Hi-Score 등록) '
ENGINE INNODB
COLLATE 'utf8_general_ci'
ROW_FORMAT DEFAULT;


