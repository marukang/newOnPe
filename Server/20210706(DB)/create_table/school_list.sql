-- ----------------------------------------------------------------
--  TABLE school_list
-- ----------------------------------------------------------------

CREATE TABLE `ONPE_DEV`.school_list
(
   school_name    VARCHAR(50)
                    CHARACTER SET utf8
                    COLLATE utf8_general_ci
                    NOT NULL
)
COMMENT '학교리스트'
ENGINE INNODB
COLLATE 'utf8_general_ci'
ROW_FORMAT DEFAULT;


