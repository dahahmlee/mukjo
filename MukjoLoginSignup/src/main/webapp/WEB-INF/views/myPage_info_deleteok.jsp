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
		out.println("		title: '회원탈퇴 성공',");
		out.println("		text: '먹조를 사랑해주셔서 감사합니다.',");
		out.println("		icon: 'success',");
		out.println("	}).then(() => {");
		out.println("		location.href='./logoutok2.do'");
		out.println("	})");
		out.println("});");
	} else {
		out.println("$().ready(function () {");
		out.println("	Swal.fire(");
		out.println("		'error',");
		out.println("		'회원탈퇴가 취소되었습니다.'");
		out.println("	).then(() => {");
		out.println("		history.back();");
		out.println("	})");
		out.println("});");
	}
	out.println("</script>");
%>