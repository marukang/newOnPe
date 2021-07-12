package kr.co.onpe.security;

import java.security.NoSuchAlgorithmException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;

import kr.co.onpe.WebDefaultController;
import kr.co.onpe.service.WebUserAuthService;
import kr.co.onpe.vo.Teacher_Information_VO;

public class WebAuthProvider implements AuthenticationProvider {
	
	private static final Logger logger = LoggerFactory.getLogger(WebDefaultController.class);
	
	@Autowired	
    private WebUserAuthService userDeSer;

	@SuppressWarnings("unchecked")
	@Override
	public Authentication authenticate(Authentication authentication) throws AuthenticationException {
		String username = (String)authentication.getPrincipal();		
		String password = (String)authentication.getCredentials();
		
		try {
			String sha256pw = kr.co.onpe.common.common.sha256(password);
			
			System.out.println("회원로그인 : " + username);
			
			Teacher_Information_VO user = userDeSer.loadUserByUsername(username);
			
	        if(!matchPassword(sha256pw, user.getPassword())) {
	            throw new BadCredentialsException(username);
	        }
	 
	        if(!user.isEnabled()) {
	            throw new BadCredentialsException(username);
	        }
	        
	        
	        UsernamePasswordAuthenticationToken result = new UsernamePasswordAuthenticationToken(username, sha256pw, user.getAuthorities());
	        result.setDetails(user);
	        return result;
			
		} catch (NoSuchAlgorithmException e) {
			e.printStackTrace();
			throw new BadCredentialsException(username);
		}
	}

	@Override
	public boolean supports(Class<?> authentication) {
//		return authentication.equals(UsernamePasswordAuthenticationToken.class);
		return true;
	}
	
    private boolean matchPassword(String loginPwd, String password) {
        return loginPwd.equals(password);
    }

}
