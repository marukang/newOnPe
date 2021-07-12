-- ----------------------------------------------------------------
--  TABLE admin_notice
-- ----------------------------------------------------------------

CREATE TABLE `ONPE_DEV`.admin_notice
(
   admin_notice_number     INT(11) NOT NULL AUTO_INCREMENT COMMENT '번호',
   admin_notice_target     CHAR(1)
                             CHARACTER SET utf8
                             COLLATE utf8_general_ci
                             NOT NULL
                             COMMENT '대상 설정 (0:전체, 1:학생, 2:선생)',
   admin_notice_title      VARCHAR(80)
                             CHARACTER SET utf8
                             COLLATE utf8_general_ci
                             NOT NULL
                             COMMENT '제목',
   admin_notice_content    TEXT
                             CHARACTER SET utf8
                             COLLATE utf8_general_ci
                             NOT NULL
                             COMMENT '내용',
   admin_notice_date       BIGINT(14) NOT NULL COMMENT '작성일',
   PRIMARY KEY(admin_notice_number)
)
COMMENT '관리자 공지사항 ( 선생님 <--> 관리자 )'
ENGINE INNODB
COLLATE 'utf8_general_ci'
ROW_FORMAT DEFAULT;


