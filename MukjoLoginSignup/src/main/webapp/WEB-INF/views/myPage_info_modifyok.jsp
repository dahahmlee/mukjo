<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!-- SweetAlert창 바꾸기-->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.js"></script>
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<%
String log = "LOGIN";

HttpSession sess = request.getSession();

String loginedMemberSeq = (String)sess.getAttribute("loginedMemberSeq");
String welcome = "";

if(loginedMemberSeq != null) {
	welcome = (String)sess.getAttribute("loginedMemberName")+"님 환영합니다.";
	log = "LOGOUT";
	if (!loginedMemberSeq.equals("1")) {
	   		out.println ( "<script>");
	   		out.println( "alert('관리자만 관리자페이지에 들어갈 수 있습니다.');" );
			out.println ( "window.location.href = 'http://localhost:8080/main.do'");
			out.println ( "</script>");
	   	}
} else {
	out.println ( "<script>");
	out.println ( "window.location.href = 'http://localhost:8080/login.do'");
	out.println ( "</script>");
}

	int flag=(int)request.getAttribute("flag");
	
	out.println("<script type='text/javascript'>");
	if(flag == 0) {
		out.println("$().ready(function () {");
		out.println("	Swal.fire({");
		out.println("		title: '수정 성공',");
		out.println("		text: '성공적으로 수정했습니다.',");
		out.println("		icon: 'success',");
		out.println("	}).then(() => {");
		out.println("		location.href='./myPage_info_modify.do'");
		out.println("	})");
		out.println("});");
	} else {
		out.println("$().ready(function () {");
		out.println("	Swal.fire(");
		out.println("		'error',");
		out.println("		'수정하지 못했습니다.'");
		out.println("	).then(() => {");
		out.println("		history.back();");
		out.println("	})");
		out.println("});");
	}
	out.println("</script>");
%>