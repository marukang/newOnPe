-- ----------------------------------------------------------------
--  TABLE common_message
-- ----------------------------------------------------------------

CREATE TABLE `ONPE_DEV`.common_message
(
   message_number      INT(11) NOT NULL AUTO_INCREMENT COMMENT 'key',
   id                  VARCHAR(20)
                         CHARACTER SET utf8
                         COLLATE utf8_general_ci
                         NOT NULL
                         COMMENT '작성자 아이디',
   name                VARCHAR(10)
                         CHARACTER SET utf8
                         COLLATE utf8_general_ci
                         NOT NULL
                         COMMENT '작성자 이름',
   message_content     TEXT
                         CHARACTER SET utf8
                         COLLATE utf8_general_ci
                         NOT NULL
                         COMMENT '내용',
   target_id           VARCHAR(20)
                         CHARACTER SET utf8
                         COLLATE utf8_general_ci
                         NOT NULL
                         COMMENT '상대방 아이디',
   message_date        BIGINT(14) NOT NULL DEFAULT 0 COMMENT '작성일자',
   target_authority    VARCHAR(50)
                         CHARACTER SET utf8
                         COLLATE utf8_general_ci
                         NOT NULL
                         COMMENT '상대방(STUDENT, TEACHER)',
   PRIMARY KEY(message_number)
)
COMMENT '선생님, 학생이 공통으로 사용하는 메세지 테이블'
ENGINE INNODB
COLLATE 'utf8_general_ci'
ROW_FORMAT DEFAULT;


