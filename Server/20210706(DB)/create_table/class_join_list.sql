-- ----------------------------------------------------------------
--  TABLE class_join_list
-- ----------------------------------------------------------------

CREATE TABLE `ONPE_DEV`.class_join_list
(
   class_code    VARCHAR(50)
                   CHARACTER SET utf8
                   COLLATE utf8_general_ci
                   NOT NULL
                   COMMENT '클래스코드',
   student_id    VARCHAR(20)
                   CHARACTER SET utf8
                   COLLATE utf8_general_ci
                   NOT NULL
                   COMMENT '사용자 아이디'
)
COMMENT '학급 구성 관리에서 학생 조회 및 정보 수정시 학생 정보를 JOIN하기 위한 Table'
ENGINE INNODB
COLLATE 'utf8_general_ci'
ROW_FORMAT DEFAULT;


