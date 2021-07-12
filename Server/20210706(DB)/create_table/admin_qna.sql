-- ----------------------------------------------------------------
--  TABLE admin_qna
-- ----------------------------------------------------------------

CREATE TABLE `ONPE_DEV`.admin_qna
(
   question_number           INT(11)
                               NOT NULL
                               AUTO_INCREMENT
                               COMMENT '문의글 번호',
   question_date             BIGINT(14) NOT NULL COMMENT '문의글 작성일',
   question_id               VARCHAR(20)
                               CHARACTER SET utf8
                               COLLATE utf8_general_ci
                               NOT NULL
                               COMMENT '문의글 작성자 아이디',
   question_name             VARCHAR(6)
                               CHARACTER SET utf8
                               COLLATE utf8_general_ci
                               NOT NULL
                               COMMENT '문의글 작성자 이름',
   question_belong           VARCHAR(50)
                               CHARACTER SET utf8
                               COLLATE utf8_general_ci
                               NOT NULL
                               COMMENT '문의글 작성자 소속',
   question_phonenumber      CHAR(11)
                               CHARACTER SET utf8
                               COLLATE utf8_general_ci
                               NOT NULL
                               COMMENT '문의 작성자 연락처',
   question_title            VARCHAR(80)
                               CHARACTER SET utf8
                               COLLATE utf8_general_ci
                               NOT NULL
                               COMMENT '문의 제목',
   question_type             VARCHAR(30)
                               CHARACTER SET utf8
                               COLLATE utf8_general_ci
                               NOT NULL
                               COMMENT '문의 분류',
   question_content          TEXT
                               CHARACTER SET utf8
                               COLLATE utf8_general_ci
                               NOT NULL
                               COMMENT '문의 내용',
   question_image_content    TEXT
                               CHARACTER SET utf8
                               COLLATE utf8_general_ci
                               NULL
                               COMMENT '문의 이미지 파일',
   question_state            CHAR(1)
                               CHARACTER SET utf8
                               COLLATE utf8_general_ci
                               NOT NULL
                               COMMENT '관리자 답변 여부(0:미답변 / 1:답변)',
   question_comment          TEXT
                               CHARACTER SET utf8
                               COLLATE utf8_general_ci
                               NULL
                               COMMENT '관리자 답변 내용',
   question_comment_date     BIGINT(14)
                               NULL
                               COMMENT '관리자 답변 날짜',
   PRIMARY KEY(question_number)
)
COMMENT '관리자 문의함 - ( 선생님 <---> 관리자 )'
ENGINE INNODB
COLLATE 'utf8_general_ci'
ROW_FORMAT DEFAULT;


