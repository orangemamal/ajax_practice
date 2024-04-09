package user;

import java.sql.*;

public class DbTest {
    private static final String dbURL = "com.mysql.jdbc.Driver";
    private static final String dbID = "root";
    private static final String dbPassword = "dhwhdals12";
    public static Statement stmt;


    public static void main(String[] args) {
        Connection conn = null;


        try {
            //드라이버 연결

            //접속 URL, mysql 유저 아이디, 비밀번호로 접속
            conn = DriverManager.getConnection(dbURL, dbID, dbPassword);

            //접속성공 메세지
            System.out.println("working!!!");
        } catch (Exception e) {

            //예외 발생시 메세지
            System.err.println("fail!!!");
            System.err.println(e.getMessage());
            e.printStackTrace();
        }
        finally {
            if (conn != null) {
                try {
                    conn.close();

                    System.out.println("cancel!!!");
                } catch (Exception e) {}
            }
        }
    }
}
