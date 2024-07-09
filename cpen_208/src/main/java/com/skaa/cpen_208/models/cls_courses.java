package com.skaa.cpen_208.models;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.web.bind.annotation.RequestParam;


public class cls_courses {
  public Connection con = null;

  // GET FUNCTIONS
  public String select_all_courses() {
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

  // outstanding fees
  public Object outstanding_fees(@RequestParam String studentID){
    Object result = null;
    String SQL = "SELECT student.calculate_outstanding_fees(?)";
    Connection conn = con;

    try {
      PreparedStatement pstmt = conn.prepareStatement(SQL);
      pstmt.setString(1, studentID);
      ResultSet rs = pstmt.executeQuery();
      while (rs.next()) {
        result = rs.getString("calculate_outstanding_fees");
      }
    } catch (SQLException e) {
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
  };

  // courses enrolled
  public Object courseenroll(@RequestParam String studentID){
    Object result = null;
    String SQL = "SELECT student.courseenroll(?)";
    Connection conn = con;

    try {
      PreparedStatement pstmt = conn.prepareStatement(SQL);
      pstmt.setString(1, studentID);
      ResultSet rs = pstmt.executeQuery();
      while (rs.next()) {
        result = rs.getString("courseenroll");
      }
    } catch (SQLException e) {
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
  };

  // Dashboard Details
  public Object dashdetails(@RequestParam String studentID){
    Object result = null;
    String SQL = "SELECT student.dashdetails(?)";
    Connection conn = con;

    try {
      PreparedStatement pstmt = conn.prepareStatement(SQL);
      pstmt.setString(1, studentID);
      ResultSet rs = pstmt.executeQuery();
      while (rs.next()) {
        result = rs.getString("dashdetails");
      }
    } catch (SQLException e) {
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
  };

  // Get Finance Videos
  public Object getfinance(@RequestParam String studentID){
    Object result = null;
    String SQL = "SELECT student.getfinance(?)";
    Connection conn = con;

    try {
      PreparedStatement pstmt = conn.prepareStatement(SQL);
      pstmt.setString(1, studentID);
      ResultSet rs = pstmt.executeQuery();
      while (rs.next()) {
        result = rs.getString("getfinance");
      }
    } catch (SQLException e) {
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
  };

  // authenticate student
  public Object auth_student_login(@RequestParam String studentID, @RequestParam String user_password){
    Object result = null;
    String SQL = "SELECT student.auth_student_login(?,?)";
    Connection conn = con;

    try {
      PreparedStatement pstmt = conn.prepareStatement(SQL);
      pstmt.setString(1, studentID);
      pstmt.setString(2, user_password);
      ResultSet rs = pstmt.executeQuery();
      while (rs.next()) {
        result = rs.getBoolean("auth_student_login");
      }
    } catch (SQLException e) {
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
  };

  // POST Functions
  public Object add_courses(String json_request) {
    System.out.println("SQL");
    Object result = null;
    String SQL = "SELECT * FROM ses.add_courses(?)";
    Connection conn = con;
    try {

      PreparedStatement pstmt = conn.prepareStatement(SQL);
      pstmt.setString(1, json_request);
      ResultSet rs = pstmt.executeQuery();
      while (rs.next()) {
        result = rs.getObject("add_courses");
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
