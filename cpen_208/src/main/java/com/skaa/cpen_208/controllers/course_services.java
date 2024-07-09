package com.skaa.cpen_208.controllers;

// import java.time.LocalDate;
// import java.time.Month;
// // import java.time.Month;
// import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;


import com.skaa.cpen_208.db_connector.db_settings;
import com.skaa.cpen_208.models.cls_courses;
// import com.skaa.cpen_208.models.student_data;

@RestController
@RequestMapping("/course_services")
public class course_services {
  cls_courses course_l = new cls_courses();

  @Autowired
  private db_settings cls_db_config;

  @GetMapping("/list_of_courses")
  public String list_of_courses() {
    course_l.con = cls_db_config.getCon();
    String result = course_l.select_all_courses();
    return result;
  }

  @GetMapping("/outstanding_fees")
  public Object outstanding_fees(@RequestParam String studentID) {
    course_l.con = cls_db_config.getCon();
    Object result = course_l.outstanding_fees(studentID);
    return result;
  }

  @GetMapping("/courseenroll")
  public Object courseenroll(@RequestParam String studentID) {
    course_l.con = cls_db_config.getCon();
    Object result = course_l.courseenroll(studentID);
    return result;
  }

  @GetMapping("/dashdetails")
  public Object dashdetails(@RequestParam String studentID) {
    course_l.con = cls_db_config.getCon();
    Object result = course_l.dashdetails(studentID);
    return result;
  }

  @GetMapping("/getfinance")
  public Object getfinance(@RequestParam String studentID) {
    course_l.con = cls_db_config.getCon();
    Object result = course_l.getfinance(studentID);
    return result;
  }

  @GetMapping("/auth_student_login")
  public Object auth_student_login(@RequestParam String studentID, @RequestParam String user_password) {
    course_l.con = cls_db_config.getCon();
    Object result = course_l.auth_student_login(studentID,user_password);
    return result;
  }

  @PostMapping("/add_courses")
  public Object add_courses(@RequestBody String json_request) {
    course_l.con = cls_db_config.getCon();
    Object result = course_l.add_courses(json_request);
    return result;
  }

  // @GetMapping("/list_of_students")
  // public List<student_data> list_of_students() {
  // return List.of(

  // // new student_data(
  // // 1L,
  // // "Samuel",
  // // "sam@gmail.com",
  // // LocalDate.of(2000, Month.JANUARY, 5),
  // // 15),
  // // new student_data(),
  // // new student_data(),
  // new student_data( "hello", "email", LocalDate.now(), 12),
  // new student_data("Samuel", "sam@gmail.com", LocalDate.of(2023, Month.JANUARY,
  // 21), 12));
  // }
}
