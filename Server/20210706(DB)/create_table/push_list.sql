-- ----------------------------------------------------------------
--  TABLE push_list
-- ----------------------------------------------------------------

CREATE TABLE `ONPE_DEV`.push_list
(
   push_number              INT(11) NOT NULL AUTO_INCREMENT COMMENT '푸시 번호',
   push_title               VARCHAR(50)
                              CHARACTER SET utf8
                              COLLATE utf8_general_ci
                              NOT NULL
                              COMMENT '푸시 제목',
   push_content             TEXT
                              CHARACTER SET utf8
                              COLLATE utf8_general_ci
                              NOT NULL
                              COMMENT '푸시 내용',
   push_reservation_time    BIGINT(12)
                              NOT NULL
                              COMMENT '푸시 발송 시간(년도+월+일+시+분)',
   push_create_date         BIGINT(14) NOT NULL COMMENT '푸시 생성시간',
   push_state               CHAR(1)
                              CHARACTER SET utf8
                              COLLATE utf8_general_ci
                              NOT NULL
                              COMMENT '푸시 성공 여부 ( 0:성공, 1:실패 )',
   PRIMARY KEY(push_number)
)
COMMENT '푸시 관리 - 관리자 기능'
ENGINE INNODB
COLLATE 'utf8_general_ci'
ROW_FORMAT DEFAULT;


