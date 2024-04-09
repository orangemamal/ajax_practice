package user;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class UserDAO {

    private Connection conn;
    private PreparedStatement pstmt;
    private ResultSet rs;

    public UserDAO() {
        try {
            String dbURL = "jdbc:mysql://localhost:3306/practice";
            String dbID = "root";
            String dbPassword = "dhwhdals12";
            Class.forName("com.mysql.jdbc.Driver"); // 드라이버를 검색할 수 있게 해줌
            conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // DB에 저장된 회원정보를 ArrayList로 가져오는 것
    public ArrayList<User> search(String userName) { // 파라미터 : String = key(모든 키값은 String타입) ,
        // LIKE 매개변수로 가져온 값을 포함하는지 체크
        // '나'만 검색해도 이름에 나가 포함된 정보를 가져올 수 있다.
        String SQL = "SELECT * FROM USER WHERE userName LIKE ?";
        ArrayList<User> userList = new ArrayList<User>(); // userlist 초기화
        try {
            pstmt = conn.prepareStatement(SQL);
            // 상단에 private PreparedStatement pstmt; 에서
            // PreparedStatment 인스턴스 안에 실제 연결된 DB SQL 언어를 넣을 수 있도록 해줌
            pstmt.setString(1, userName);
            //  파라미터에 넘어온 userName을 ? 자리에 넣어주는 것
            rs = pstmt.executeQuery();
            // 결과를 실행해서 담아주는 것
            while (rs.next()) { // 결과물을 하나하나 읽어가면서 userList에 사용자 정보를 담기 위한 작업
                User user = new User();
                // set 함수를 사용해서 rs에 담겨있는 사용자 정보를 가져와서 위에 user라는 인스턴스로 만들어주는 것
                user.setUserName(rs.getString(1));
                user.setUserAge(rs.getInt(2));
                user.setUnserGender(rs.getString(3));
                user.setUserEmail(rs.getString(4));
                userList.add(user); // list에 추가해주기
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return userList; // return을 통해 함수를 불러온 쪽에 userList에 담긴 모든 사용자 정보를 전부 넘겨줌
        // 결과적으로 serach라는 함수를 통해 사용자의 정보를 검색할 수 있는 기능을 구현함
    }
}
