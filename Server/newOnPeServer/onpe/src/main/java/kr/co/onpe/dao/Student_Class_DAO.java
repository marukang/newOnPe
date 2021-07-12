package kr.co.onpe.dao;

import javax.inject.Inject;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import kr.co.onpe.vo.Content_List_VO;

/* 사용자 클래스 관련 DAO */

@Repository
public class Student_Class_DAO {

	 @Inject
	 private SqlSessionTemplate sqlSession;
	    
	// 매퍼 식별 값
	private String namespace = "kr.co.mappers.StudentClassMapper";
	
	
	/* ############################################################ Method #################################################################### */

	/* 존재하는 클래스인지 확인 */
    public boolean Get_Class_Code(String class_code) {
    	
    	if(sqlSession.selectOne(namespace + ".Get_Class_Code", class_code) != null) {
    		return true;
    	}
    	
    	return false;
    }
    
	/* 클래스 참여인원 늘리기 */
    public boolean Update_Class_People_Count_Up(String class_code) {
    	
    	if(sqlSession.update(namespace + ".Update_Class_People_Count_Up", class_code) == 1) {
    		return true;
    	}
    	
    	return false;
    }
    
	/* 클래스 참여인원 줄이기 */
    public boolean Update_Class_People_Count_Down(String class_code) {
    	
    	if(sqlSession.update(namespace + ".Update_Class_People_Count_Down", class_code) == 1) {
    		return true;
    	}
    	
    	return false;
    }
    
    /* 클래스 임장하기 */
    public String Get_Class_Unit_List(String class_code) {
    	return sqlSession.selectOne(namespace + ".Get_Class_Unit_List", class_code);
    }
    
    /* 컨텐츠 목록 하나 가져오기 */
    public Content_List_VO Get_Content_List(String content_code) {
    	return sqlSession.selectOne(namespace + ".Get_Content_List", content_code);
    }
}
