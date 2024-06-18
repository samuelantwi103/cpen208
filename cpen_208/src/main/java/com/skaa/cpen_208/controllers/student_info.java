package com.skaa.cpen_208.controllers;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.skaa.cpen_208.db_connector.student_service;
import com.skaa.cpen_208.models.student_data;

@RestController
@RequestMapping(path = "/student")
public class student_info {

  private final student_service student_service;

  @Autowired
  public student_info(student_service studentService){
    this.student_service = studentService;
  }
  @GetMapping("/student_data")
  public List<student_data> getStudent() {
    return student_service.getStudent();
  }
}
