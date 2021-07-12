package kr.co.onpe.vo;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

@SuppressWarnings("serial")
public class Teacher_Information_VO implements UserDetails {
	
	private String teacher_id;
	private String teacher_password;
    private String teacher_name;
    private String teacher_email;
    private String teacher_phone;
    private String teacher_sex;
    private String teacher_school;
    private String teacher_state;
    private String teacher_email_agreement;
    private String teacher_message_agreement;
    private String teacher_join_date;
    private String teacher_recent_join_date;
    private String admin_auth;
    private String teacher_birth;
    
	public String getTeacher_birth() {
		return teacher_birth;
	}

	public void setTeacher_birth(String teacher_birth) {
		this.teacher_birth = teacher_birth;
	}

	public String getTeacher_name() {
		return teacher_name;
	}

	public void setTeacher_name(String teacher_name) {
		this.teacher_name = teacher_name;
	}

	public String getTeacher_email() {
		return teacher_email;
	}

	public void setTeacher_email(String teacher_email) {
		this.teacher_email = teacher_email;
	}

	public String getTeacher_phone() {
		return teacher_phone;
	}

	public void setTeacher_phone(String teacher_phone) {
		this.teacher_phone = teacher_phone;
	}

	public String getTeacher_sex() {
		return teacher_sex;
	}

	public void setTeacher_sex(String teacher_sex) {
		this.teacher_sex = teacher_sex;
	}

	public String getTeacher_school() {
		return teacher_school;
	}

	public void setTeacher_school(String teacher_school) {
		this.teacher_school = teacher_school;
	}

	public String getTeacher_state() {
		return teacher_state;
	}

	public void setTeacher_state(String teacher_state) {
		this.teacher_state = teacher_state;
	}

	public String getTeacher_email_agreement() {
		return teacher_email_agreement;
	}

	public void setTeacher_email_agreement(String teacher_email_agreement) {
		this.teacher_email_agreement = teacher_email_agreement;
	}

	public String getTeacher_message_agreement() {
		return teacher_message_agreement;
	}

	public void setTeacher_message_agreement(String teacher_message_agreement) {
		this.teacher_message_agreement = teacher_message_agreement;
	}

	public String getTeacher_join_date() {
		return teacher_join_date;
	}

	public void setTeacher_join_date(String teacher_join_date) {
		this.teacher_join_date = teacher_join_date;
	}

	public String getTeacher_recent_join_date() {
		return teacher_recent_join_date;
	}

	public void setTeacher_recent_join_date(String student_recent_join_date) {
		this.teacher_recent_join_date = student_recent_join_date;
	}

	public String getAdmin_auth() {
		return admin_auth;
	}

	public void setAdmin_auth(String admin_auth) {
		this.admin_auth = admin_auth;
	}

	@Override
	public Collection<? extends GrantedAuthority> getAuthorities() {
		ArrayList<GrantedAuthority> authorities = new ArrayList<GrantedAuthority>();    
        authorities.add(new SimpleGrantedAuthority(admin_auth));
        
        return authorities;
	}

	@Override
	public String getPassword() {
		return teacher_password;
	}

	@Override
	public String getUsername() {
		return teacher_id;
	}

	@Override
	public boolean isAccountNonExpired() {
		return true;
	}

	@Override
	public boolean isAccountNonLocked() {
		return true;
	}

	@Override
	public boolean isCredentialsNonExpired() {
		return true;
	}

	@Override
	public boolean isEnabled() {
		return true;
	}
}
