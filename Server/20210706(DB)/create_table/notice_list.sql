-- ----------------------------------------------------------------
--  TABLE notice_list
-- ----------------------------------------------------------------

CREATE TABLE `ONPE_DEV`.notice_list
(
   notice_number        INT(11) NOT NULL AUTO_INCREMENT COMMENT '소식 번호',
   notice_class_code    VARCHAR(50)
                          CHARACTER SET utf8
                          COLLATE utf8_general_ci
                          NOT NULL
                          COMMENT '클래스 코드',
   notice_title         VARCHAR(50)
                          CHARACTER SET utf8
                          COLLATE utf8_general_ci
                          NOT NULL
                          COMMENT '타이틀(소식 큰 제목)',
   notice_content       TEXT
                          CHARACTER SET utf8
                          COLLATE utf8_general_ci
                          NOT NULL
                          COMMENT '공지 내용(소식 내용)',
   notice_type          CHAR(1)
                          CHARACTER SET utf8
                          COLLATE utf8_general_ci
                          NOT NULL
                          COMMENT '소식 타입',
   notice_date          BIGINT(14) NOT NULL COMMENT '소식 작성일자',
   notice_id            VARCHAR(50)
                          CHARACTER SET utf8
                          COLLATE utf8_general_ci
                          NOT NULL
                          COMMENT '작성자 아이디(선생님)',
   notice_name          VARCHAR(6)
                          CHARACTER SET utf8
                          COLLATE utf8_general_ci
                          NOT NULL
                          COMMENT '작성자 이름(선생님)',
   PRIMARY KEY(notice_number)
)
COMMENT '소식 List'
ENGINE INNODB
COLLATE 'utf8_general_ci'
ROW_FORMAT DEFAULT;


