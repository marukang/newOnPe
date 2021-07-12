-- ----------------------------------------------------------------
--  TABLE content_list_admin
-- ----------------------------------------------------------------

CREATE TABLE `ONPE_DEV`.content_list_admin
(
   content_number         INT(11)
                            NOT NULL
                            AUTO_INCREMENT
                            COMMENT '컨텐츠 번호',
   content_youtube_url    TEXT
                            CHARACTER SET utf8
                            COLLATE utf8_general_ci
                            NOT NULL
                            COMMENT 'Youtube 주소',
   content_id             VARCHAR(20)
                            CHARACTER SET utf8
                            COLLATE utf8_general_ci
                            NOT NULL
                            COMMENT '컨텐츠 작성자',
   content_date           BIGINT(14) NOT NULL COMMENT '컨텐츠 작성일',
   PRIMARY KEY(content_number)
)
COMMENT '콘텐츠 관'
ENGINE INNODB
COLLATE 'utf8_general_ci'
ROW_FORMAT DEFAULT;


