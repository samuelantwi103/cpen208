package com.skaa.cpen_208.models;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class cls_courses {
  public Connection con = null;

  public String select_all_courses() {
    System.out.println("SQL");
    String result = null;
    String SQL = "SELECT * FROM ses.select_all_courses()";
    Connection conn = con;
    try {

      PreparedStatement pstmt = conn.prepareStatement(SQL);
      ResultSet rs = pstmt.executeQuery();
      while (rs.next()) {
        result = rs.getString("select_all_courses");
      }
    } catch (SQLException e) {
      // Print Errors in console.
      System.out.println(e.getMessage());
    } finally {
      if (conn != null) {
        try {
          conn.close();
        } catch (SQLException ex) {
          ex.printStackTrace();
        }
      }
    }
    return result;

  }
  public String add_courses(String json_request) {
    System.out.println("SQL");
    String result = null;
    String SQL = "SELECT * FROM ses.add_courses(?)";
    Connection conn = con;
    try {

      PreparedStatement pstmt = conn.prepareStatement(SQL);
      pstmt.setString(1, json_request);
      ResultSet rs = pstmt.executeQuery();
      while (rs.next()) {
        result = rs.getString("add_courses");
      }
    } catch (SQLException e) {
      // Print Errors in console.
      System.out.println(e.getMessage());
    } finally {
      if (conn != null) {
        try {
          conn.close();
        } catch (SQLException ex) {
          ex.printStackTrace();
        }
      }
    }
    return result;

  }
}
