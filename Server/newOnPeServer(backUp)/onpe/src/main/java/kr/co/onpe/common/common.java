package kr.co.onpe.common;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Random;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;

import org.springframework.util.StringUtils;

public class common {
	
	public static final String IS_MOBILE = "MOBILE";
	private static final String IS_PHONE = "PHONE";
	public static final String IS_TABLET = "TABLET";
	public static final String IS_PC = "PC";

	/**
	 * 모바일,타블렛,PC구분
	 * @param req
	 * @return
	 */
	public static String isDevice(HttpServletRequest req) {
	    String userAgent = req.getHeader("User-Agent").toUpperCase();
	    System.out.println(userAgent);
		
	    if(userAgent.indexOf(IS_MOBILE) > -1) {
	        if(userAgent.indexOf(IS_PHONE) == -1)
		    return IS_MOBILE;
		else
		    return IS_TABLET;
	    } else
		return IS_PC;
	}
	
	// SHA256 암호화
	public static String sha256(String msg)  throws NoSuchAlgorithmException {
		try{

			MessageDigest digest = MessageDigest.getInstance("SHA-256");
			byte[] hash = digest.digest(msg.getBytes("UTF-8"));
			StringBuffer hexString = new StringBuffer();

			for (int i = 0; i < hash.length; i++) {
				String hex = Integer.toHexString(0xff & hash[i]);
				if(hex.length() == 1) hexString.append('0');
				hexString.append(hex);
			}

			return hexString.toString();
			
		} catch(Exception ex){
//			throw new RuntimeException(ex);
			return "fail";
		}

	}
	
	
	/* 인증번호 6자리 생성 */
	/**
     * 전달된 파라미터에 맞게 난수를 생성한다
     * @param len : 생성할 난수의 길이
     * @param dupCd : 중복 허용 여부 (1: 중복허용, 2:중복제거)
     */
    public static String numberGen(int len, int dupCd ) {
        
        Random rand = new Random();
        String numStr = ""; //난수가 저장될 변수
        
        for(int i=0;i<len;i++) {
            
            //0~9 까지 난수 생성
            String ran = Integer.toString(rand.nextInt(10));
            
            if(dupCd==1) {
                //중복 허용시 numStr에 append
                numStr += ran;
            }else if(dupCd==2) {
                //중복을 허용하지 않을시 중복된 값이 있는지 검사한다
                if(!numStr.contains(ran)) {
                    //중복된 값이 없으면 numStr에 append
                    numStr += ran;
                }else {
                    //생성된 난수가 중복되면 루틴을 다시 실행한다
                    i-=1;
                }
            }
        }
        return numStr;
    }

	
	/* 비밀번호 정규식 체크 메서드 */
	public static boolean passwordCheck(String password) {
		String pwPattern = "^(?=.*\\d)(?=.*[~`!@#$%\\^&*()-])(?=.*[a-zA-Z]).{6,12}$";
		Matcher matcher = Pattern.compile(pwPattern).matcher(password);
		if(matcher.matches()){	//패턴확인
			if(!password.contains(" ")){	//공백 확인
			    return true;
			}
		}
		return false;
	}
	
	/* 비밀번호 정규식 체크 메서드 ( 선생님용 ) */
	public static boolean teacher_passwordCheck(String password) {
		String pwPattern = "^(?=.*\\d)(?=.*[~`!@#$%\\^&*()-])(?=.*[a-zA-Z]).{8,20}$";
		Matcher matcher = Pattern.compile(pwPattern).matcher(password);
		if(matcher.matches()){	//패턴확인
			if(!password.contains(" ")){	//공백 확인
			    return true;
			}
		}
		return false;
	}
	
	/** * Comment : 정상적인 이메일 인지 검증. */ 
	public static boolean isValidEmail(String email) { 
		boolean err = false; 
		String regex = "^[_a-z0-9-]+(.[_a-z0-9-]+)*@(?:\\w+\\.)+\\w+$"; 
		Pattern p = Pattern.compile(regex); 
		Matcher m = p.matcher(email); 
		if(m.matches()) { 
			err = true; 
		} 
		return err; 
	}
	
	/* 이미지 파일인지 판단할 메서드 */
	public static boolean checkImageType(String fileName) {
		final String[] PERMISSION_FILE_EXT_ARR = {"JPEG", "JPG", "PNG"};
		
		if( !StringUtils.hasText(fileName) ) {
			return false;
		}
		
		String[] fileNameArr = fileName.split("\\.");
		
		if( fileNameArr.length == 0 ) {
			return false;
		}
		
		String ext = fileNameArr[fileNameArr.length - 1].toUpperCase();
		 
		boolean isPermissionFileExt = false;
		
		for( int i = 0; i < PERMISSION_FILE_EXT_ARR.length; i++ ) {
			if( PERMISSION_FILE_EXT_ARR[i].equals(ext) ) {
				isPermissionFileExt = true;
				break;
			}
		}
		
		return isPermissionFileExt;
	}
	
	/* 이미지 파일 또는 PDF파일인지 판단할 메서드 */
	public static boolean checkImageorPdfType(String fileName) {
		final String[] PERMISSION_FILE_EXT_ARR = {"JPEG", "JPG", "PNG", "PDF"};
		
		if( !StringUtils.hasText(fileName) ) {
			return false;
		}
		
		String[] fileNameArr = fileName.split("\\.");
		
		if( fileNameArr.length == 0 ) {
			return false;
		}
		
		String ext = fileNameArr[fileNameArr.length - 1].toUpperCase();
		 
		boolean isPermissionFileExt = false;
		
		for( int i = 0; i < PERMISSION_FILE_EXT_ARR.length; i++ ) {
			if( PERMISSION_FILE_EXT_ARR[i].equals(ext) ) {
				isPermissionFileExt = true;
				break;
			}
		}
		return isPermissionFileExt;
	}
	
	/* 문자열 마스킹처리 */
	public static String maskingStr(String str) {
		
		int length = str.length();
		
		StringBuilder builder = new StringBuilder(str);
		
		for( int i=0 ; i < length - (length - length / 2) ; i++ ) {
			builder.setCharAt(i, '*');
		}
		return builder.toString();
	}
	
	/* 랜덤 비밀번호 생성 */
	public static String makePassword() {
		int pwLength = (int)(Math.random()*4 + 8);
		char[] passwordTable =  { 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 
                'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X',
                'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j',
                'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 
                'w', 'x', 'y', 'z', '!', '@', '#', '$', '%', '^', '&', '*',
                '(', ')', '1', '2', '3', '4', '5', '6', '7', '8', '9', '0' };
		
		Random random = new Random(System.currentTimeMillis());
        int tablelength = passwordTable.length;
        StringBuffer buf = new StringBuffer();
        
        for(int i = 0; i < pwLength; i++) {
            buf.append(passwordTable[random.nextInt(tablelength)]);
        }
        
        return buf.toString();
	}
	
	/* 정수 판별 함수 */
	public static boolean isInteger(String s) { //정수 판별 함수
		try {
	     	Integer.parseInt(s);
	    	return true;
	    } catch(NumberFormatException e) {  //문자열이 나타내는 숫자와 일치하지 않는 타입의 숫자로 변환 시 발생
	    	return false;
	    }
	}
	
	public static boolean isLong(String s) {
		try {
	     	Long.parseLong(s);
	    	return true;
	    } catch(NumberFormatException e) {  //문자열이 나타내는 숫자와 일치하지 않는 타입의 숫자로 변환 시 발생
	    	return false;
	    }
	}
}
