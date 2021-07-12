-- ----------------------------------------------------------------
--  TABLE class_community_comment
-- ----------------------------------------------------------------

CREATE TABLE `ONPE_DEV`.class_community_comment
(
   comment_number              INT(11) NOT NULL AUTO_INCREMENT COMMENT '댓글 번호',
   comment_community_number    INT(11) NOT NULL COMMENT '게시글 번호',
   comment_id                  VARCHAR(50)
                                 CHARACTER SET utf8
                                 COLLATE utf8_general_ci
                                 NOT NULL
                                 COMMENT '댓글 작성자 아이디',
   comment_name                VARCHAR(6)
                                 CHARACTER SET utf8
                                 COLLATE utf8_general_ci
                                 NOT NULL
                                 COMMENT '댓글 작성자 이름',
   comment_content             TEXT
                                 CHARACTER SET utf8
                                 COLLATE utf8_general_ci
                                 NOT NULL
                                 COMMENT '댓글 내용',
   comment_date                BIGINT(14) NOT NULL COMMENT '댓글 작성일',
   comment_auth                CHAR(1)
                                 CHARACTER SET utf8
                                 COLLATE utf8_general_ci
                                 NULL
                                 COMMENT '권한확인(학생과, 선생의 아이디가 중복될수있어서)',
   PRIMARY KEY(comment_number)
)
COMMENT '학급 커뮤니티 댓글'
ENGINE INNODB
COLLATE 'utf8_general_ci'
ROW_FORMAT DEFAULT;


