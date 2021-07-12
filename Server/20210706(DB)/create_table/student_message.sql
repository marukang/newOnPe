-- ----------------------------------------------------------------
--  TABLE student_message
-- ----------------------------------------------------------------

CREATE TABLE `ONPE_DEV`.student_message
(
   message_number           INT(11)
                              NOT NULL
                              AUTO_INCREMENT
                              COMMENT '메세지 고유번호',
   message_class_code       VARCHAR(50)
                              CHARACTER SET utf8
                              COLLATE utf8_general_ci
                              NOT NULL
                              COMMENT '클래스 코드',
   message_title            VARCHAR(50)
                              CHARACTER SET utf8
                              COLLATE utf8_general_ci
                              NOT NULL
                              COMMENT '메시지 제목',
   message_text             TEXT
                              CHARACTER SET utf8
                              COLLATE utf8_general_ci
                              NOT NULL
                              COMMENT '메시지 내용',
   message_date             BIGINT(14) NOT NULL COMMENT '작성일자',
   message_id               VARCHAR(20)
                              CHARACTER SET utf8
                              COLLATE utf8_general_ci
                              NOT NULL
                              COMMENT '작성자 아이디',
   message_name             VARCHAR(6)
                              CHARACTER SET utf8
                              COLLATE utf8_general_ci
                              NOT NULL
                              COMMENT '작성자 이름',
   message_comment_state    CHAR(1)
                              CHARACTER SET utf8
                              COLLATE utf8_general_ci
                              NOT NULL
                              COMMENT '답변 상태 (미답변 : 0 / 답변 : 1)',
   message_comment          TEXT
                              CHARACTER SET utf8
                              COLLATE utf8_general_ci
                              NULL
                              COMMENT '답변내용',
   message_teacher_name     VARCHAR(6)
                              CHARACTER SET utf8
                              COLLATE utf8_general_ci
                              NULL
                              COMMENT '답변 작성 선생님 이름',
   message_teacher_id       VARCHAR(20)
                              CHARACTER SET utf8
                              COLLATE utf8_general_ci
                              NULL
                              COMMENT ' 답변 작성 선생님 아이디',
   message_comment_date     BIGINT(14) NULL COMMENT '답변 일자',
   PRIMARY KEY(message_number)
)
COMMENT '메세지'
ENGINE INNODB
COLLATE 'utf8_general_ci'
ROW_FORMAT DEFAULT;


