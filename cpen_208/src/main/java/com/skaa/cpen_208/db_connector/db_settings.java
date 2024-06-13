package com.skaa.cpen_208.db_connector;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;
import java.sql.Connection;
import java.sql.DriverManager;

import lombok.Data;

@Component
@Data
@ConfigurationProperties(prefix = "spring.datasource")
public class db_settings {
  String url;
  String username;
  String password;

  static Connection con = null;

  // static Connection con = null;

  public Connection getCon() {
    try {
      // System.out.println("DB Url: "+getUrl());
      Class.forName("org.postgresql.Driver");
      String url = getUrl() + "?user=" + getUsername() + "&password=" + getPassword()
          + "&pooling=true&minpoolsize=1&maxpoolsize=100&connectionlifetime=15&connect_timeout=10000&max_active=100&max_idle=&30&max_wait=100";
      con = DriverManager.getConnection(url);
      // con = DriverManager.getConnection(getUrl(), getUsername(), getPassword());
      // Server=127.0.0.1;Port=5432;Database=myDataBase;Userid=myUsername;Password=myPassword;Protocol=3;Pooling=true;MinPoolSize=1;MaxPoolSize=20;ConnectionLifeTime=15;

      // String url =
      // "jdbc:postgresql://localhost/test?user=fred&password=secret&ssl=true";
      // con = DriverManager.getConnection(url, "");
      // MaxIdleTime

    } catch (Exception ex) {
      System.out.println(ex);
    }
    return con;
  }
}
