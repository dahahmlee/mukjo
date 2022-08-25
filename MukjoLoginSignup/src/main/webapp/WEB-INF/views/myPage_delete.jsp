<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!-- SweetAlert창 바꾸기-->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.js"></script>
<script src="https://code.jquery.com/jquery-latest.min.js"></script>
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

	String bseq=(String)request.getAttribute("bseq");
	
	out.println("<script type='text/javascript'>");
	out.println("$().ready(function () {");
	out.println("	Swal.fire({");
	out.println("		title: '삭제 확인',");
	out.println("		text: '이 글을 삭제하시겠습니까?',");
	out.println("		icon: 'warning',");
	out.println("		showCancelButton: true,");
	out.println("		confirmButtonColor: '#3085d6',");
	out.println("		cancelButtonColor: '#d33',");
	out.println("		confirmButtonText: '확인',");
	out.println("		cancelButtonText: '취소',");
	out.println("		reverseButtons: false,");
	out.println("	}).then((result) => {");
	out.println("		if (result.isConfirmed) {");
	out.println("			location.href='./del/success?bseq="+bseq.toString()+"';");
	out.println("		} else {");
	out.println("			history.back();");
	out.println("		}");
	out.println("	})");
	out.println("})");
	out.println("</script>");
%>