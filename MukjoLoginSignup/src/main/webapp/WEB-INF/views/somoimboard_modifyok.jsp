<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.js"></script>
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<%
	int flag = (int)request.getAttribute("flag");
	String tseq = (String)request.getAttribute("tseq");
	String bseq = (String)request.getAttribute("bseq");
	String cpage = (String)request.getAttribute("cpage");
	
	System.out.println("ok tseq : " + tseq);

	out.println("<script type='text/javascript'>");
	out.println("$().ready(function () {");
	
	if(flag == 1) {
		out.println("	Swal.fire({");
		out.println("		title: '글수정 성공',");
		out.println("		text: '글 수정이 완료되었습니다.',");
		out.println("		icon: 'success',");
		out.println("		confirmButtonColor: '#3085d6',");
		out.println("		confirmButtonText: '확인',");
		out.println("		reverseButtons: false,");
		out.println("	}).then((result) => {");
		out.println("		if (result.isConfirmed) {");
		out.println("		location.href='../../../../main/board/view?tseq="+tseq+"&bseq="+bseq+"&cpage="+cpage+"'");
		out.println("		}");
		out.println("	})");
	} else {
		out.println("	Swal.fire({");
		out.println("		title: '글수정 실패',");
		out.println("		text: '글 작성에 실패했습니다.',");
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