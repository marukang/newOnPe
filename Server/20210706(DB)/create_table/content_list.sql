-- ----------------------------------------------------------------
--  TABLE content_list
-- ----------------------------------------------------------------

CREATE TABLE `ONPE_DEV`.content_list
(
   content_code                VARCHAR(50)
                                 CHARACTER SET utf8
                                 COLLATE utf8_general_ci
                                 NOT NULL
                                 COMMENT '컨텐츠 코드 ( 양식 미정 )',
   content_value               VARCHAR(12)
                                 CHARACTER SET utf8
                                 COLLATE utf8_general_ci
                                 NOT NULL
                                 COMMENT '코드분류 ( 0: 추천조합 , 1: 커스텀조합 )',
   content_title               VARCHAR(20)
                                 CHARACTER SET utf8
                                 COLLATE utf8_general_ci
                                 NOT NULL
                                 COMMENT '컨텐츠 타이틀 ( ex: 공다루기 단원 )',
   content_name                VARCHAR(20)
                                 CHARACTER SET utf8
                                 COLLATE utf8_general_ci
                                 NOT NULL
                                 COMMENT '컨텐츠 종목',
   content_category            VARCHAR(30)
                                 CHARACTER SET utf8
                                 COLLATE utf8_general_ci
                                 NOT NULL
                                 COMMENT '컨텐츠 대분류',
   content_user                VARCHAR(10)
                                 CHARACTER SET utf8
                                 COLLATE utf8_general_ci
                                 NOT NULL
                                 COMMENT '컨텐츠 생산자 ( 교육부 or 선생님 ID )',
   content_class_level         VARCHAR(10)
                                 CHARACTER SET utf8
                                 COLLATE utf8_general_ci
                                 NOT NULL
                                 COMMENT '컨텐츠 학교급 ( ex: 초등학교 )',
   content_class_grade         CHAR(1)
                                 CHARACTER SET utf8
                                 COLLATE utf8_general_ci
                                 NOT NULL
                                 COMMENT '컨텐츠 학년 ( 1, 2, 3 )',
   content_write_date          BIGINT(14) NOT NULL COMMENT '컨텐츠 등록일',
   content_number_list         TEXT
                                 CHARACTER SET utf8
                                 COLLATE utf8_general_ci
                                 NOT NULL
                                 COMMENT '종목 번호',
   content_name_list           TEXT
                                 CHARACTER SET utf8
                                 COLLATE utf8_general_ci
                                 NOT NULL
                                 COMMENT '종목 이름',
   content_cateogry_list       TEXT
                                 CHARACTER SET utf8
                                 COLLATE utf8_general_ci
                                 NOT NULL
                                 COMMENT '종목 대분류',
   content_type_list           TEXT
                                 CHARACTER SET utf8
                                 COLLATE utf8_general_ci
                                 NOT NULL
                                 COMMENT '종목 타입',
   content_area_list           TEXT
                                 CHARACTER SET utf8
                                 COLLATE utf8_general_ci
                                 NOT NULL
                                 COMMENT '종목 영역',
   content_detail_name_list    TEXT
                                 CHARACTER SET utf8
                                 COLLATE utf8_general_ci
                                 NOT NULL
                                 COMMENT '동작 명',
   content_count_list          TEXT
                                 CHARACTER SET utf8
                                 COLLATE utf8_general_ci
                                 NOT NULL
                                 COMMENT '운동 횟수',
   content_time                TEXT
                                 CHARACTER SET utf8
                                 COLLATE utf8_general_ci
                                 NOT NULL
                                 COMMENT '운동 시간',
   content_url                 TEXT
                                 CHARACTER SET utf8
                                 COLLATE utf8_general_ci
                                 NOT NULL
                                 COMMENT '운동 관련 비디오 url',
   content_level_list          TEXT
                                 CHARACTER SET utf8
                                 COLLATE utf8_general_ci
                                 NOT NULL
                                 COMMENT '운동 난이도',
   PRIMARY KEY(content_code)
)
COMMENT '콘텐츠 리스트'
ENGINE INNODB
COLLATE 'utf8_general_ci'
ROW_FORMAT DEFAULT;


