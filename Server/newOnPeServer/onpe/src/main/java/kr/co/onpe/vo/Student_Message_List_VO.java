package kr.co.onpe.vo;

public class Student_Message_List_VO {
	
	private String message_number;
	private String message_title;
	private String message_date;
	private String message_comment_state;
	
	public String getMessage_comment_state() {
		return message_comment_state;
	}
	public void setMessage_comment_state(String message_comment_state) {
		this.message_comment_state = message_comment_state;
	}
	public String getMessage_number() {
		return message_number;
	}
	public void setMessage_number(String message_number) {
		this.message_number = message_number;
	}
	public String getMessage_title() {
		return message_title;
	}
	public void setMessage_title(String message_title) {
		this.message_title = message_title;
	}
	public String getMessage_date() {
		return message_date;
	}
	public void setMessage_date(String message_date) {
		this.message_date = message_date;
	}
	
}
