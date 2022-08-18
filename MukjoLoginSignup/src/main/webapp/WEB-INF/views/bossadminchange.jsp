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
	String tseq = (String)request.getAttribute("tseq");
	
	out.println("<script type='text/javascript'>");
	if(flag == 1) {
		out.println("$().ready(function () {");
		out.println("	Swal.fire({");
		out.println("		title: '소모임 이름 변경 성공',");
		out.println("		text: '성공적으로 변경했습니다.',");
		out.println("		icon: 'success',");
		out.println("	}).then(() => {");
		out.println("		location.href='./bossadmin.do?tseq="+tseq+"'");
		out.println("	})");
		out.println("});");
	} else {
		out.println("$().ready(function () {");
		out.println("	Swal.fire(");
		out.println("		'error',");
		out.println("		'중복확인을 해주세요.'");
		out.println("	).then(() => {");
		out.println("		history.back();");
		out.println("	})");
		out.println("});");
	}
	out.println("</script>");
%>