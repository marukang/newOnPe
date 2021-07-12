-- ----------------------------------------------------------------
--  TABLE popup_list
-- ----------------------------------------------------------------

CREATE TABLE `ONPE_DEV`.popup_list
(
   popup_number         INT(11) NOT NULL AUTO_INCREMENT COMMENT '팝업 번호',
   popup_name           VARCHAR(50)
                          CHARACTER SET utf8
                          COLLATE utf8_general_ci
                          NOT NULL
                          COMMENT '제목',
   popup_content        TEXT
                          CHARACTER SET utf8
                          COLLATE utf8_general_ci
                          NOT NULL
                          COMMENT '내용',
   popup_x_size         INT(11) NOT NULL COMMENT '팝업 크기 - 가로',
   popup_y_size         INT(11) NOT NULL COMMENT '팝업 크기 - 세로',
   popup_x_location     INT(11)
                          NOT NULL
                          COMMENT '팝업 위치 - 가로위치',
   popup_y_location     INT(11)
                          NOT NULL
                          COMMENT '팝업 위치 - 세로위치',
   popup_start_date     CHAR(8)
                          CHARACTER SET utf8
                          COLLATE utf8_general_ci
                          NOT NULL
                          COMMENT '팝업 게시기간(시작)',
   popup_end_date       CHAR(8)
                          CHARACTER SET utf8
                          COLLATE utf8_general_ci
                          NOT NULL
                          COMMENT '팝업 게시기간(종료)',
   popup_create_date    INT(8) NOT NULL COMMENT '팝업 등록일',
   popup_attachments    TEXT
                          CHARACTER SET utf8
                          COLLATE utf8_general_ci
                          NOT NULL
                          COMMENT '첨부파일',
   popup_use            CHAR(1)
                          CHARACTER SET utf8
                          COLLATE utf8_general_ci
                          NOT NULL
                          COMMENT '사용여부(0:미사용, 1:사용)',
   PRIMARY KEY(popup_number)
)
COMMENT '팝업창 관리 - 관리자 기능'
ENGINE INNODB
COLLATE 'utf8_general_ci'
ROW_FORMAT DEFAULT;


