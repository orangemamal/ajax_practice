package user;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;

// JSON 형태로 결과를 돌려주는게 servlet의 역할

@WebServlet("/UserSearchServlet")
public class UserSearchServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8"); // 넘어온 데이터를 UTF 코드로 처리하도록 설정
        response.setContentType("text/html;charset=UTF-8");
        String userName = request.getParameter("userName");
        response.getWriter().write(getJSON(userName));
    }

    public String getJSON(String userName) {
        if(userName == null) userName="";
        StringBuffer result = new StringBuffer("");
        result.append("{\"result\":[");
        UserDAO userDAO = new UserDAO();
        ArrayList<User> userList = userDAO.search(userName);
        for(int i = 0; i<userList.size(); i++) {
            result.append("[{\"value\": \"" + userList.get(i).getUserName() + "\"},");
            result.append("[\"value\": \"" + userList.get(i).getUserName() + "\"},");
            result.append("[\"value\": \"" + userList.get(i).getUserName() + "\"},");
            result.append("[\"value\": \"" + userList.get(i).getUserName() + "\"}],");
        }
        result.append("]}");
        return result.toString();
    }
}
