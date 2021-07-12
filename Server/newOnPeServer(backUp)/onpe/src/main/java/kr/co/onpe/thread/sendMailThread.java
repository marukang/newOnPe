package kr.co.onpe.thread;

import java.io.InputStream;

import javax.mail.internet.MimeMessage;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.MailException;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.mail.javamail.MimeMessagePreparator;

public class sendMailThread implements Runnable{
	
	/* root-context.xml에 등록한 Bean 호출 ( 의존성 주입 **Autowired ) */
	@Autowired
	private JavaMailSender mailSender;
	
	String targetMail = "";
	String new_password = "";
	
	public sendMailThread(String mail, String password, JavaMailSender ms) {
		this.targetMail = mail;
		this.new_password = password;
		this.mailSender = ms;
	}

	@Override
	public void run() {
		// 메일 제목
		String subject = "온체육 비밀번호 찾기";
		// 보내는 사람
		String from ="온체육 <complexionco@naver.com>";
		// 받는 사람
		String to = targetMail;
		
		try {
			System.out.println(mailSender);
			MimeMessage mail = mailSender.createMimeMessage();
			// 메일 내용 넣을 객체와, 이를 도와주는 Helper 객체 생성
			MimeMessageHelper mailHelper = new MimeMessageHelper(mail,true,"UTF-8");

			// 메일 내용을 채워줌
			mailHelper.setFrom(from);	// 보내는 사람 셋팅
			mailHelper.setTo(to);		// 받는 사람 셋팅
			mailHelper.setSubject(subject);	// 제목 셋팅
			mailHelper.setText("<div style='width:100%; padding:20px 0; text-align:center;'><div style='vertical-align:center; display:inline-block; width:400px; padding:30px 5px;'>" +
					"<div style='float:left; width:100%; text-align:center; font-size:22px; font-weight:bold;'>온체육 비밀번호 찾기</div>" +
					"<div style='float:left; margin:10px 0; border-top:3px solid; width:100%; height:1px;'></div>" +
					"<div style='float:left; width:100%; text-align:center; font-size:18px; font-weight:bold;'>비밀번호 : "+ new_password +"</div></div></div>", true);	// 내용 셋팅

			// 메일 전송
			mailSender.send(mail);
			
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
}
