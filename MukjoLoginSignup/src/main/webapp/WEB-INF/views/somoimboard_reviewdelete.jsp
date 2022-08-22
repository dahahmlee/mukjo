<%@page import="com.example.model1.ReviewTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.js"></script>
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<%
	int flag = (int)request.getAttribute("flag");
	String tseq = request.getParameter("tseq");
	String id = request.getParameter("id");
	String longitude = request.getParameter("longitude");
	String latitude = request.getParameter("latitude");


	out.println("<script type='text/javascript'>");
	out.println("$().ready(function () {");
	
	if(flag == 1) {
		out.println("	Swal.fire({");
		out.println("		title: '리뷰삭제 성공',");
		out.println("		text: '리뷰 삭제가 완료되었습니다.',");
		out.println("		icon: 'success',");
		out.println("		confirmButtonColor: '#3085d6',");
		out.println("		confirmButtonText: '확인',");
		out.println("		reverseButtons: false,");
		out.println("	}).then((result) => {");
		out.println("		if (result.isConfirmed) {");
		out.println("		location.href='../../../../main/search/review?tseq="+tseq+"&id="+id+"&latitude="+latitude+"&longitude="+longitude+"'");
		out.println("		}");
		out.println("	})");
	} else {
		out.println("	Swal.fire({");
		out.println("		title: '리뷰삭제 실패',");
		out.println("		text: '리뷰 삭제에 실패했습니다.',");
		out.println("		icon: 'error',");
		out.println("		confirmButtonColor: '#3085d6',");
		out.println("		confirmButtonText: '확인',");
		out.println("		reverseButtons: false,");
		out.println("	}).then((result) => {");
		out.println("		if (result.isConfirmed) {");
		out.println("			history.back();");
		out.println("		}");
		out.println("	})");
	}
	out.println("})");
	out.println("</script>");
%>