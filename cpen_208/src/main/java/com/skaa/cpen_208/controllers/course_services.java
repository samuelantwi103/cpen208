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

  @PostMapping("/add_courses")
  public String add_courses(@RequestBody String json_request) {
    course_l.con = cls_db_config.getCon();
    String result = course_l.add_courses(json_request);
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
