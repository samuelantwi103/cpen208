package com.skaa.cpen_208.models;

import java.time.LocalDate;

import io.micrometer.common.lang.NonNull;
import lombok.Data;
import lombok.RequiredArgsConstructor;

@Data
@RequiredArgsConstructor
public class student_data {
  private Long id;
  @NonNull private final String name;
  @NonNull private final String email;
  @NonNull private final LocalDate dob;
  @NonNull private final int age;
}
