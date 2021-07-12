package kr.co.onpe.vo;

import java.util.List;

public class Exercise_Category_VO {
	
	private String exercise_code;
	private String exercise_name;
	private String exercise_category;
	private String exercise_type;
	private String exercise_area;
	private String exercise_detail_name;
	private String exercise_count;
	private String exercise_time;
	private String exercise_url;
	private String exercise_level;
	private List<String> exercise_area_temp;
	
	
	public List<String> getExercise_area_temp() {
		return exercise_area_temp;
	}
	public void setExercise_area_temp(List<String> exercise_area_temp) {
		this.exercise_area_temp = exercise_area_temp;
	}
	public String getExercise_code() {
		return exercise_code;
	}
	public void setExercise_code(String exercise_code) {
		this.exercise_code = exercise_code;
	}
	public String getExercise_name() {
		return exercise_name;
	}
	public void setExercise_name(String exercise_name) {
		this.exercise_name = exercise_name;
	}
	public String getExercise_category() {
		return exercise_category;
	}
	public void setExercise_category(String exercise_category) {
		this.exercise_category = exercise_category;
	}
	public String getExercise_type() {
		return exercise_type;
	}
	public void setExercise_type(String exercise_type) {
		this.exercise_type = exercise_type;
	}
	public String getExercise_area() {
		return exercise_area;
	}
	public void setExercise_area(String exercise_area) {
		this.exercise_area = exercise_area;
	}
	public String getExercise_detail_name() {
		return exercise_detail_name;
	}
	public void setExercise_detail_name(String exercise_detail_name) {
		this.exercise_detail_name = exercise_detail_name;
	}
	public String getExercise_count() {
		return exercise_count;
	}
	public void setExercise_count(String exercise_count) {
		this.exercise_count = exercise_count;
	}
	public String getExercise_time() {
		return exercise_time;
	}
	public void setExercise_time(String exercise_time) {
		this.exercise_time = exercise_time;
	}
	public String getExercise_url() {
		return exercise_url;
	}
	public void setExercise_url(String exercise_url) {
		this.exercise_url = exercise_url;
	}
	public String getExercise_level() {
		return exercise_level;
	}
	public void setExercise_level(String exercise_level) {
		this.exercise_level = exercise_level;
	}
	
	
}
