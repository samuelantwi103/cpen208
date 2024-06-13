package com.skaa.cpen_208.db_connector;

import java.time.Month;
import java.time.LocalDate;
import java.util.List;

// import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;

import com.skaa.cpen_208.models.student_data;

// import scala.collection.immutable.List;

@Service
public class student_service {
  public List<student_data> getStudent() {
    return List.of(
        new student_data("hello",
            "hello@gmail.com",
            LocalDate.of(2005, Month.JANUARY, 5),
            15));
  }
}
