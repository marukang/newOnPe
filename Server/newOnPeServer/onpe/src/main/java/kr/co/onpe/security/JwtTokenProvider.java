package kr.co.onpe.security;

import java.text.SimpleDateFormat;
import java.util.Base64;
import java.util.Date;
import java.util.TimeZone;

import javax.annotation.PostConstruct;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jws;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import kr.co.onpe.service.Student_Information_Service;
import kr.co.onpe.service.WebUserAuthService;
import kr.co.onpe.vo.Teacher_Information_VO;

@Component
public class JwtTokenProvider{

	private String secretKey = "ONPEProJectSecretKeyUseLongKeyString";
	private String Base64SecretKey = null;

    // 토큰 유효시간 30일 ( APP )
    private long tokenValidTimeAPP = 30 * 24 * 60 * 60 * 1000L;
    
    // 토큰 유효시간 30분 ( WEB )
    private long tokenValidTimeWEB = 30 * 60 * 1000L;
    
    // 학생용 테이블 접근 서비스
    @Autowired
    private Student_Information_Service userDeSer;
    
    // 선생용 테이블 접근 서비스
    @Autowired
    private WebUserAuthService WebuserDeSer;

    // 객체 초기화, secretKey를 Base64로 인코딩한다.
    @PostConstruct
    protected void init() {
    	Base64SecretKey = Base64.getEncoder().encodeToString(secretKey.getBytes());
    }
    
    // JWT 토큰 생성
    @SuppressWarnings("deprecation")
	public String createToken(String id, String roles) {
    	if(Base64SecretKey == null) {
    		Base64SecretKey = Base64.getEncoder().encodeToString(secretKey.getBytes());
    	}
    	
        Claims claims = Jwts.claims().setSubject(id); // JWT payload 에 저장되는 정보단위
        claims.put("roles", roles); // 정보는 key / value 쌍으로 저장된다.
        Date now = new Date();
        
        String token = "";
        
        if(roles.equals("STUDENT")) {
        	token = Jwts.builder().setClaims(claims) // 정보 저장
            		.setIssuedAt(now) // 토큰 발행 시간 정보
                    .setExpiration(new Date(now.getTime() + tokenValidTimeAPP)) // set Expire Time
                    .signWith(SignatureAlgorithm.HS256, Base64SecretKey)// 사용할 암호화 알고리즘과 signature 에 들어갈 secret값 세팅                
                    .compact();
        }else {
        	token = Jwts.builder().setClaims(claims) // 정보 저장
            		.setIssuedAt(now) // 토큰 발행 시간 정보
                    .setExpiration(new Date(now.getTime() + tokenValidTimeWEB)) // set Expire Time
                    .signWith(SignatureAlgorithm.HS256, Base64SecretKey)// 사용할 암호화 알고리즘과 signature 에 들어갈 secret값 세팅                
                    .compact();        	
        }
    	
    	if(roles.equals("STUDENT")) {
        	if(getAuthenticationAPP(token)) {
                return token;
        	}else {
        		return "fail";
        	}
    	}else {
        	if(getAuthenticationWEB(token)) {
                return token;
        	}else {
        		return "fail";
        	}    		
    	}

    }
    
    // JWT 토큰에서 인증 정보 조회 ( 선생용, 관리자용 )
    public boolean getAuthenticationWEB(String token) {
    	String student_id = this.getUserPk(token);
    	Teacher_Information_VO isuser = (Teacher_Information_VO)WebuserDeSer.loadUserByUsername(student_id);
    	if(isuser == null) {
    		return false;
    	}else {
			/* 현재시간 서버에 업로드 ( 최근 접속시간 ) */
			SimpleDateFormat format = new SimpleDateFormat ( "yyyyMMddHHmmss");
			format.setTimeZone(TimeZone.getTimeZone("Asia/Seoul"));
			Date time = new Date();
			String time_number = format.format(time);
			WebuserDeSer.Teacher_Update_Jodin_Date(time_number, student_id);
    		
    		return true;
    	}
    }
    
    // JWT 토큰에서 인증 정보 조회 ( 학생용 ) + 학생 최근 접속시간 Update
    public boolean getAuthenticationAPP(String token) {
    	String student_id = this.getUserPk(token);
    	boolean isuser = userDeSer.Id_Overlap_Check(student_id);
    	if(isuser) {
    		
			/* 현재시간 서버에 업로드 ( 최근 접속시간 ) */
			SimpleDateFormat format = new SimpleDateFormat ( "yyyyMMddHHmmss");
			format.setTimeZone(TimeZone.getTimeZone("Asia/Seoul"));
			Date time = new Date();
			String time_number = format.format(time);
			
			userDeSer.Update_student_recent_join_date(student_id, time_number);
    		
    		return true;
    	}else {
    		System.out.println(student_id+" : is not user");
    		return false;
    	}
    }
    
    // 토큰에서 회원 정보 추출
    @SuppressWarnings("deprecation")
	public String getUserPk(String token) {
    	if(Base64SecretKey == null) {
    		Base64SecretKey = Base64.getEncoder().encodeToString(secretKey.getBytes());
    	}
        return Jwts.parser().setSigningKey(Base64SecretKey).parseClaimsJws(token).getBody().getSubject();
    }
    
//    Request의 Header에서 token 값을 가져옵니다. "X-AUTH-TOKEN" : "TOKEN값'
//    public String resolveToken(HttpServletRequest request) {
//        return request.getHeader("X-AUTH-TOKEN");
//    }
    
    // 토큰의 유효성 + 만료일자 확인
    @SuppressWarnings("deprecation")
	public boolean validateToken(String jwtToken) {
        try {
        	if(Base64SecretKey == null) {
        		Base64SecretKey = Base64.getEncoder().encodeToString(secretKey.getBytes());
        	}
            Jws<Claims> claims = Jwts.parser().setSigningKey(Base64SecretKey).parseClaimsJws(jwtToken);
            return !claims.getBody().getExpiration().before(new Date());
        } catch (Exception e) {
        	System.out.println("토큰검증오류 : "+e);
            return false;
        }
    }
    
    public String TokenCheck(String uid, String uauth, String Token) {
    	String token = Token;
    	//만료 토큰확인
    	if(!validateToken(token)) {
    		// 유효기간 만료일경우
    		token = "expired";
    	}else {
			//유효 토큰일 경우
			//현재 사용자 아이디와 토큰 내부 사용자 아이디가 다를경우
			if(!getUserPk(token).equals(uid)) {
				//System.out.println("토큰 소유자가 상이함 개쓰레기 사용자");
				token = "fail";
			}else {
				//현재 사용자 아이디와 토큰 내부 사용자 아이디가 동일할 경우 정상 + 토큰 갱신
				//System.out.println("유효한 토큰 + 유효한 사용자");
				token = this.createToken(uid, uauth);
			}
    	}
    	return token;
    }
}