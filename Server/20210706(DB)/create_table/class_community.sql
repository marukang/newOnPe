-- ----------------------------------------------------------------
--  TABLE class_community
-- ----------------------------------------------------------------

CREATE TABLE `ONPE_DEV`.class_community
(
   community_number        INT(11)
                             NOT NULL
                             AUTO_INCREMENT
                             COMMENT '커뮤니티 게시글 번호',
   community_class_code    VARCHAR(50)
                             CHARACTER SET utf8
                             COLLATE utf8_general_ci
                             NOT NULL
                             COMMENT '클래스 코드',
   community_id            VARCHAR(50)
                             CHARACTER SET utf8
                             COLLATE utf8_general_ci
                             NOT NULL
                             COMMENT '게시글 작성자 아이디',
   community_name          VARCHAR(6)
                             CHARACTER SET utf8
                             COLLATE utf8_general_ci
                             NOT NULL
                             COMMENT '게시글 작성자 이름',
   community_title         VARCHAR(50)
                             CHARACTER SET utf8
                             COLLATE utf8_general_ci
                             NOT NULL
                             COMMENT '게시글 제목',
   community_text          TEXT
                             CHARACTER SET utf8
                             COLLATE utf8_general_ci
                             NOT NULL
                             COMMENT '게시글 내용',
   community_date          BIGINT(14) NOT NULL COMMENT '작성일자',
   community_file1         TEXT
                             CHARACTER SET utf8
                             COLLATE utf8_general_ci
                             NULL
                             COMMENT '첨부파일1',
   community_file2         TEXT
                             CHARACTER SET utf8
                             COLLATE utf8_general_ci
                             NULL
                             COMMENT '첨부파일2',
   community_count         INT(4) NOT NULL DEFAULT 0 COMMENT '댓글 수 ',
   community_auth          CHAR(1)
                             CHARACTER SET utf8
                             COLLATE utf8_general_ci
                             NULL
                             COMMENT '권한확인(학생과, 선생의 아이디가 중복될수있어서)',
   PRIMARY KEY(community_number)
)
COMMENT '학급 커뮤니티'
ENGINE INNODB
COLLATE 'utf8_general_ci'
ROW_FORMAT DEFAULT;


