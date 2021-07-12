-- ----------------------------------------------------------------
--  TABLE admin_faq
-- ----------------------------------------------------------------

CREATE TABLE `ONPE`.admin_faq
(
   faq_number     INT(11) NOT NULL AUTO_INCREMENT COMMENT '번호',
   faq_target     CHAR(1)
                    CHARACTER SET utf8
                    COLLATE utf8_general_ci
                    NOT NULL
                    COMMENT '대상 설정',
   faq_title      VARCHAR(80)
                    CHARACTER SET utf8
                    COLLATE utf8_general_ci
                    NOT NULL
                    COMMENT '제목',
   faq_content    TEXT
                    CHARACTER SET utf8
                    COLLATE utf8_general_ci
                    NOT NULL
                    COMMENT '내용',
   faq_date       BIGINT(14) NOT NULL COMMENT '작성일',
   faq_type       VARCHAR(20)
                    CHARACTER SET utf8
                    COLLATE utf8_general_ci
                    NOT NULL
                    COMMENT '타입',
   PRIMARY KEY(faq_number)
)
COMMENT '자주 묻는 질문'
ENGINE INNODB
COLLATE 'utf8_general_ci'
ROW_FORMAT DEFAULT;


