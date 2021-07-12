-- ----------------------------------------------------------------
--  TABLE exercise_category
-- ----------------------------------------------------------------

CREATE TABLE `ONPE_DEV`.exercise_category
(
   exercise_code           INT(11)
                             NOT NULL
                             AUTO_INCREMENT
                             COMMENT '운동 종목 번호',
   exercise_name           VARCHAR(10)
                             CHARACTER SET utf8
                             COLLATE utf8_general_ci
                             NOT NULL
                             COMMENT '종목 이름',
   exercise_category       VARCHAR(20)
                             CHARACTER SET utf8
                             COLLATE utf8_general_ci
                             NOT NULL
                             COMMENT '종목 대분류',
   exercise_type           CHAR(1)
                             CHARACTER SET utf8
                             COLLATE utf8_general_ci
                             NOT NULL
                             COMMENT '종목 타입(0 : 평가 가능 1: 과제 가능 2: 평가과제 전부)',
   exercise_area           VARCHAR(100)
                             CHARACTER SET utf8
                             COLLATE utf8_general_ci
                             NOT NULL
                             COMMENT '운동 종목 영역',
   exercise_detail_name    VARCHAR(30)
                             CHARACTER SET utf8
                             COLLATE utf8_general_ci
                             NOT NULL
                             COMMENT '운동 동작 명',
   exercise_count          VARCHAR(3)
                             CHARACTER SET utf8
                             COLLATE utf8_general_ci
                             NOT NULL
                             COMMENT '운동 횟수',
   exercise_time           VARCHAR(3)
                             CHARACTER SET utf8
                             COLLATE utf8_general_ci
                             NOT NULL
                             COMMENT '운동 시간',
   exercise_url            TEXT
                             CHARACTER SET utf8
                             COLLATE utf8_general_ci
                             NOT NULL
                             COMMENT '해당 운동 관련 URL',
   exercise_level          CHAR(1)
                             CHARACTER SET utf8
                             COLLATE utf8_general_ci
                             NOT NULL
                             COMMENT '운동 난이도(없음 : 0  하 : 1 중 : 2 상 : 3)',
   PRIMARY KEY(exercise_code)
)
COMMENT '종목 관리 - 관리자 추가'
ENGINE INNODB
COLLATE 'utf8_general_ci'
ROW_FORMAT DEFAULT;


