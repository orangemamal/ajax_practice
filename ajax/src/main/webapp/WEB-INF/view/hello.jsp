<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Insert title here</title>
    <script src="https://code.jquery.com/jquery-3.6.3.js" integrity="sha256-nQLuAZGRRcILA+6dMBOvcRh5Pe310sBpanc6+QBmyVM=" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js" integrity="sha384-w76AqPfDkMBDXo30jS1Sgez6pr3x5MlQ1ZAGC+nuZB+EYdgRZgiwxhTBTkF7CXvN" crossorigin="anonymous"></script>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
    <script type="text/javascript">
      var request = new XMLHttpRequest();
      function searchFunction() {
        request.open("Post", "./UserSearchServlet?userName" + encodeURIComponent(document.getElementById("userName").value), true);
        request.onreadystatechange = searchProcess;
        request.send(null);
      }
      function searchProcess() {
        var table = document.getElementById("ajaxTable");
        table.innerHTML = "";
        if(request.readyState == 4 && request.status == 200) {
          var object = eval('(' + request.responseText + ')');
          var result = object.result;
          for(var i = 0; i < result[i].length; j++) {
            var cell = row.insertCell(j);
            cell.innerHTML = result[i][j].value;
          }
        }
      }
    </script>
</head>
<body>
   <br>
   <div class="container">
       <div class="form-group row pull-right">
           <div class="col-xs-8">
               <input class="form-control" id="userName" onkeyup="searchFunction()" type="text" size="20">
           </div>
           <div class="col-xs-2">
               <button class="btn btn-primary" type="button" onclick="searchFunction()">검색</button>
           </div>
       </div>
       <table class="table" style="test-align: center; border: 1px solid #dddddd;">
        <tr>
          <thead>
            <th style="background-color: #fafafa; text-align: center;">이름</th>
            <th style="background-color: #fafafa; text-align: center;">나이</th>
            <th style="background-color: #fafafa; text-align: center;">성별</th>
            <th style="background-color: #fafafa; text-align: center;">이메일</th>
           </thead>
           <tbody id="ajaxTable">
           </tbody>
        </tr>
       </table>
   </div>
<script>
    function ajax() {

        let member = {
            "name": "morpheus",
            "job": "leader"
        }

        $.ajax({
            url : 'https://reqres.in/api/users', // 화면단과 백단이 통신할 url
            type : 'post', // 메소드 타입
            data : member, // 보낼 데이터
            dataType : 'json', // 보낼 데이터의 타입 보통 json만 씀
            success : function(data) {
                // 성공시 실행할 함수 (파라미터로는 백단에서 주는 데이터)
                console.log(data)
            },
            error : function(error) {
                // ajax 통신 실패시 실행할 함수
                console.log(error)
            }
        })

    }

</script>
</body>
</html>