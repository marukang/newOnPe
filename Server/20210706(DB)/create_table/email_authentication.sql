-- ----------------------------------------------------------------
--  TABLE email_authentication
-- ----------------------------------------------------------------

CREATE TABLE `ONPE_DEV`.email_authentication
(
   email                  VARCHAR(200)
                            CHARACTER SET utf8
                            COLLATE utf8_general_ci
                            NOT NULL
                            COMMENT '인증중인 이메일',
   authentication_code    CHAR(6)
                            CHARACTER SET utf8
                            COLLATE utf8_general_ci
                            NOT NULL
                            COMMENT '인증코드 6자리 숫자'
)
COMMENT '이메일 인증테이블'
ENGINE INNODB
COLLATE 'utf8_general_ci'
ROW_FORMAT DEFAULT;


