<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!-- SweetAlert창 바꾸기-->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.css">
<link href="https://fonts.googleapis.com/css?family=Sunflower:500" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.js"></script>
<script src="https://code.jquery.com/jquery-latest.min.js"></script>
<style>
body,ul ,li, h1,h2,h3{
    margin: 0;
    padding: 0;
    font-family: 'Sunflower' !important;
}

button {
	font-family: 'Sunflower' !important;
}
</style>
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
	     out.println ( "window.location.href = 'https://mukjo.herokuapp.com/welcome'");
	     out.println ( "</script>");
	}

	String seq=(String)request.getAttribute("seq");
	String tseq=(String)request.getAttribute("tseq");
	String name=(String)request.getAttribute("name");
	
	out.println("<script type='text/javascript'>");
	out.println("$().ready(function () {");
	out.println("	Swal.fire({");
	out.println("		title: '권한 위임 확인',");
	out.println("		text: '"+name.toString()+"님에게 소모임장 권한을 위임하시겠습니까?',");
	out.println("		icon: 'warning',");
	out.println("		showCancelButton: true,");
	out.println("		confirmButtonColor: '#3085d6',");
	out.println("		cancelButtonColor: '#d33',");
	out.println("		confirmButtonText: '확인',");
	out.println("		cancelButtonText: '취소',");
	out.println("		reverseButtons: false,");
	out.println("	}).then((result) => {");
	out.println("		if (result.isConfirmed) {");
	out.println("			location.href='../../../adgroups/members/chgleader/success?seq="+seq.toString()+"&tseq="+tseq.toString()+"';");
	out.println("		} else {");
	out.println("			history.back();");
	out.println("		}");
	out.println("	})");
	out.println("})");
	out.println("</script>");
%>