package com.funidea.newonpe.network;

public interface NetworkConstants {

    String BASE_URL = "https://onpe.co.kr/staging/"; // 개발서버
    // String BASE_URL = "https://onpe.co.kr/"; // 실서버
    String APP_LOGIN = "app/login";
    String SNS_LOGIN = "app/sns_login";
    String CHECK_DUPLICATED_ID = "app/id_overlap_check";
    String SEARCH_ID = "app/find_id";
    String SEARCH_PW = "app/find_pw";
    String CHANGE_PW = "app/find_change_pw";
    String SIGN_UP = "app/sign_up";
    String CLASS_LIST = "app/class/get_class_list";
    String CLASS_UNIT_LIST = "app/class/get_class_unit_list";
    String REGISTER_NEW_CLASS = "app/class/student_class_update";
    String GET_CLASS_UNIT_DETAILED = "app/curriculum/student_get_curriculum";
    String PARTICIPATION_CLASS_UNIT = "app/curriculum/student_update_participation";
    String CREATION_STUDENT_RECORD = "app/record/create_student_class_record";
    String CONTENT_GROUP_CARD = "app/class/get_content_groupcard";
    String GET_SUBJECT_RECORD = "app/record/get_student_class_record";
}
