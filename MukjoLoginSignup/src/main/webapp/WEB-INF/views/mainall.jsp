<%@page import="com.example.model1.PageMainTeamTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.example.model1.TeamTO"%>
<%@ page import="java.util.ArrayList"%>
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
	
	PageMainTeamTO pageMainTeamTO = (PageMainTeamTO)request.getAttribute("pageMainTeamTO");

	int cpage = pageMainTeamTO.getCpage();
	int recordPerPage = pageMainTeamTO.getRecordPerPage();
	int totalRecord = pageMainTeamTO.getTotalRecord();
	int totalPage = pageMainTeamTO.getTotalPage();
	int blockPerPage = pageMainTeamTO.getBlockPerPage();
	int startBlock = pageMainTeamTO.getStartBlock();
	int endBlock = pageMainTeamTO.getEndBlock();
	
	ArrayList<TeamTO> memberLists = pageMainTeamTO.getMainTeamLists();

	int num = 1;
	
	StringBuilder sbHtml = new StringBuilder();

	for (int j = 0 ; j < memberLists.size() ; j = j+20) {
		num = (pageMainTeamTO.getCpage() - 1) * 20+1;
		for (int i = j ; i < j+20 ; i++) {
			
			if (i < memberLists.size()) {
				String tseq = memberLists.get(i).getTseq();
				String tname = memberLists.get(i).getTname();
				String tleader = memberLists.get(i).getName();
				String memcount = memberLists.get(i).getMemcount();
				
				sbHtml.append( "<tr>" );
				sbHtml.append( "<td>" + num + "</td>" );
				sbHtml.append( "<td><a href='./mainjoin.do?tseq=" + tseq + "' />" + tname + "</td>" );
				sbHtml.append( "<td><a href='./mainjoin.do?tseq=" + tseq + "' />" + tleader + "</td>" );
				sbHtml.append( "<td>" + memcount + "명</td>" );
				sbHtml.append( "</tr>" );
				num+=1;
			}
		}
	}
%>
    
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>전체소모임</title>
<style href="css/common.css"></style>
<!-- 나눔스퀘어 폰트 -->
<link href="https://hangeul.pstatic.net/hangeul_static/css/nanum-square.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.js"></script>
<script  src="http://code.jquery.com/jquery-latest.min.js"></script>
<style>
/** common **/

body,ul ,li, h1,h2,h3{
	margin: 0;
	padding: 0;
}

input{
	writing-mode: horizontal-tb !important;
	text-rendering: auto;
	color: fieldtext;
	letter-spacing: normal;
	word-spacing: normal;
	line-height: normal;
	text-transform: none;
	text-indent: 0px;
	text-shadow: none;
	display: inline-block;
	text-align: start;
	appearance: auto;
	-webkit-rtl-ordering: logical;
	cursor: text;
	border: none;
	outline: none;
}

ul{
	list-style:none;
}

a:link {color : black; text-decoration: none}
a:visited {color: black; text-decoration: none;}
a:hover {color: #5c3018; text-decoration: none;}
a:active {color: #de5f47; text-decoration: none;}

img{
	width: 100%;
}

table{
	text-align: center;
}

:root {
	--button-color: #ffffff;
	--button-bg-color: #5c3018;
	--button-hover-bg-color: #5c3018;
}

button {
	-webkit-appearance: none;
	-moz-appearance: none;
	appearance: none;
	background: var(--button-bg-color);
	color: var(--button-color);
	margin: 0;
	padding: 0.5rem 1rem;
	font-family: 'Noto Sans KR', sans-serif;
	font-size: 1rem;
	font-weight: 400;
	text-align: center;
	text-decoration: none;
	text-transform : none;
	border: none;
	border-radius: 4px;
	display: inline-block;
	width: auto;
	box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
	cursor: pointer;
	transition: 0.5s;
}

button:active,
button:hover,
button:focus {
	background: var(--button-hover-bg-color);
	outline: 0;
}
button:disabled {
	opacity: 0.5;
}

/** nav **/
nav{
	position: sticky;
	top : 0;
}

#header{
	border-bottom: #c7bebe 1px solid;
	z-index: 1;
}

#headerWap h3 {
	font-size: 15px;
	justify-content: left;
	position: absolute;
	margin-left: 120px;
}

#header ul{
	display: flex;
	font-family: 'NanumSquareBold';
}

#header ul li{
	margin-left: 73px;
}

#header ul li b{
	line-height: 41.5px;
}

#logoSec{
	width: 8%;
}

#logout{
	color: grey;
	width: 10%;
	text-decoration: underline;
	margin-right: 17%;
}

#bell{
	width: 5%;
	display:flex;
	align-items: center;
	color: red;
}

#headerWap{
	width:1280px;
	margin: auto;
	display: flex;
	justify-content: space-between;
	height: 98px;
	align-items : center;
	background-color: white;
}

#headerWap h3 {
	font-size: 15px;
	justify-content: left;
	position: absolute;
	margin-left: 120px;
}

/***** warp  *****/
#wrap{
	width: 1280px; 
	margin : auto;
}


/* 타이틀 섹션 */
#titSec strong{
	font-family: 'NanumSquareExtraBold';
	font-size: 35px;
	padding: 30px 0 30px 0;
	display: inline-block;
}



/* 버튼 섹션*/
#btnSec {
	border-bottom: 2px solid #5c3018; 
	display: inline-flex;
	justify-content: space-between;
	width: 100%;
}

#btnSec button{
	margin-left: 10px;
	margin-bottom: 5px;
}

#btnSec strong{
	font-family: 'NanumSquareExtraBold';
	font-size: 25px;
	display: inline-block;
	padding-left: 50px;
}

#btnSec .search-wrap{
	margin-left : 50%;
}

#locationSec{
	width: 100%;
	background-color: #f7f7fd;
}

#locationSec button{
	font-weight: 500;
	background: none;
	cursor: default;
	outline: none;
	box-shadow: none;
}

#locationwrap{
	width: 1280px;
	margin: 0 auto;
	height: 55px;
	padding-top: 13px;
}

#locationwrap button{
	font-family: 'NanumSquareBold';
}

.allbtn{
	color : #333;
	position : relative;
}
/*
.allbtn:before{
    position: absolute;
    left: 0;
    top : 0;
    margin : auto 0;
    width: 1px;
    height: 18px;
    background-color: #000;
    content: "";
    margin-top: 8%;
}
*/

.active{
	color: #de5f47;
}

a{
	text-decoration: none;
}

*{
	box-sizing: border-box;
}

/* Modal */ 
.modal{
	position: fixed;
	background-color: rgba(0, 0, 0, 0.4);
	top : 0;
	left : 0;
	height: 100vh;
	width: 100%;
	display: none;
}

.modal-content{
	background-color: #fff;
	width: 500px;
	border-radius: 10px;
	position: absolute;
	top: 45%;
	left : 50%;
	transform: translate( -50%, -50%);
	padding: 30px;
	box-shadow: 0 0 15px rgba(0, 0, 0, 0.15);
	text-align: center;
	height: 300px;
}

.btn-close{
	position: absolute;
	top : 15px;
	right: 15px;
}

.btn-guide{
	background-color: #de5f47;
	color: #fff;
	border-radius: 5px;
	font-size: 14px;
	padding : 7px;
}

.btn-guide a{
	color : #fff
}
#modal-search{
	border : 1px solid black;
}


/* 테이블 섹션 */
#tblSec table{
	width: 100%;
	border-collapse: collapse;
}

#tblSec table td{
	height: 45px;
	border-bottom : 1px solid #c7bebe;
}

#tblWrap{
	padding-top: 30px;
}

/***** pagingSec  *****/
#pagingSec ul{
	display: flex;
}


#pagingSec{
	display: flex;
	justify-content: center;
	margin-top: 30px;
	line-height: 2.5;
}

#btnSec .search-wrap{
	align-items: center;
	width: 282px;
	height: 36px;
	box-sizing: border-box;
	-webkit-border-radius: 24px;
	-moz-border-radius: 24px;
	border-radius: 24px;
	border: 2px solid #5c3018;
	display: inline-block;
	overflow: hidden;
	position: relative;
}

#pagingSec .search-wrap #search{
	height: 37.6px;
	margin-right: 4px;
}

.search-wrap input{
	height: 32px;
	width: 80%;
	color: #000;
	font-size: 16px;
	box-sizing: border-box;
	margin-left:5px;
}

/* width : 30, height : 45 */
.search-wrap button{
	width: 30px;
	height: 25px;
	right: 5%;
	top: 10%;
	text-indent: -9999px;
	overflow: hidden;
	background: url( ./images/search2.png) no-repeat ;
	position: absolute;
	background-size: 38px 25px;
}

#pagingSec ul li{
	width: 42px;
	height: 42px;
	text-align: center;
	line-height: 42px;
	margin-right: 10px;
	border: 1px solid #c4c4c4;
	border-radius: 10%;
}


#pagingSec .active{
	color:white;
	background-color: #de5f47;
}

	.board_pagetab { text-align: center; display: inline-flex; position:relative;}
	.board_pagetab a { text-decoration: none; font: 12px verdana; color: #000; padding: 0 3px 0 3px; }
	/* .board_pagetab ul a:hover  { background-color:black; } */
	.on a { font-weight: bold; }

/***** footer  *****/
footer{
	width: 100%;
	height: 163px;
	background-color: #d7d7d7;
	margin-top: 5%;
}

.board-table th  {
   padding-bottom: 10px;
   border-bottom: 1px solid black;
}
</style>
</head>

<body>
	<nav id="header">
		<div class="headermake" style="width:100%; background-color: #fff;">
			<div id="headerWap">
				<h1 id="logoSec">
					<a href="./main.do"><img src="images/logo.png" alt="logo"></a>
				</h1>
				<h3 ><%=welcome %><a href="logoutok.do" id="logout" style="color : gray"><br/><%=log %></a></h3>

				<ul>
					<li><b><a href="myPage.do">마이페이지</a></b></li>
					<li><b><a href="#">소모임장페이지</a></b></li>
 					<li><b><a href="admin.do">관리자페이지</b></li></a>
					<li><b><a href="favorite.do">즐겨찾기</b></li></a>
					<li id="bell"><a href="#"><b><img src="images/bell.png"></a></b>1</li>
				</ul>
			</div> <!--headerWap-->
		</div>

		<!--locationSec -->
		<section id="locationSec">
			<div id = "locationwrap">
				<button class="allbtn"><a href="./main.do">가입한 소모임</a></button>
				<button class="active"><a href="./mainall.do" style="color : #de5f47">전체 소모임</a></button>
			</div>
		</section>
	</nav>

	<!-- 전체 요소를 감싸는 div -->
	<div id="wrap">
		<!-- 게시판 이름이 있는 섹션입니다 -->
		<section id="titSec">
			<strong></strong>
		</section>

		<section id ="btnSec" >
			<strong>전체 <b>(<%=totalRecord - 1 %>)</b></strong>

			<div class="search-wrap">           
				<input type="text" title="검색어 입력" value="">
				<button type="button">검색</button>
			</div><!-- search-wrap -->

			<button id="newsomoim">소모임 새로 만들기</button>
		</section>
		<!-- 소모임 새로만들기 -->
		<script type="text/javascript">
		$("#newsomoim").click(function () {
			Swal.fire({
				title: '소모임 새로 만들기',
				html: '생성하고자하는 소모임 이름을 입력해주세요<br />(띄어쓰기 포함 최대 12자까지 가능)',
				input: 'text',
				showCancelButton: true,
				confirmButtonColor: '#3085d6',
				cancelButtonColor: '#d33',
				confirmButtonText: '생성',
				cancelButtonText: '취소',
				reverseButtons: false, // 버튼 순서 거꾸로    
			}).then((result) => {
				if (result.isConfirmed) {
					if(result.value.trim() != ''){
						if(result.value.length < 13) {
							var tnamechk = result.value;
							var seq = <%=loginedMemberSeq %>;
							$.ajax({
								type: 'get',
					        	url: 'checktname.do',
					        	data: { 'tname': tnamechk, 'seq': seq },
					        	success: function(item) {
					        		console.log($.trim(item));
					        		if($.trim(item) == 'true') {
					        			Swal.fire({
					        				title: '소모임 생성 실패',
					        				html: '생성하고자하는 소모임 이름이 존재합니다.<br />다른 이름으로 시도해주세요.',
					        				icon: 'error',
					        			})
					        		} else {
					        			Swal.fire({
					        				title: '소모임 생성 성공',
					        				html: '생성하신 소모임의 소모임장이 되셨습니다.',
					        				icon: 'success',
					        			}).then(() => {
					        				location.href='./main.do';
					        			})
					        		}
					        	},
					        	error: function(data) {}
							})
						} else {
							alert('소모임 이름은 띄어쓰기 포함 최대 12자까지 가능합니다.');
							return false;
						}
					} else {
						alert('공백은 사용 불가능');
					}
				}
			}) 
		});
		</script>

		<!-- 테이블 목록이 있는 섹션입니다 -->
		<section id="tblSec">
			<div id="tblWrap">
				<table class="board-table">
					<thead>
						<tr>
							<th scope="col" class="th-num"><a>번호</a></th>
							<th scope="col" class="th-title"><a>소모임 이름</a></th>
							<th scope="col" class="th-date"><a>소모임장</a></th>
							<th scope="col" class="th-date"><a>멤버수</a></th>
						</tr>
					</thead>
					<tbody>
						<%=sbHtml.toString() %>
						<!-- <tr>
							<td><a href="#">1</td>
							<td><a href="./mainjoinsomoim.do">먹진남</a></td>
							<td><a href="./mainjoinsomoim.do">손흥민</a></td>
							<td><a href="#">13명</a></td>
						</tr> -->
					</tbody>
				</table>
			</div>
		</section><!--tblSec-->

		<section id="pagingSec">
			<div class="paginate_regular">
				<div class="board_pagetab">
					<!-- <span class="off"><a href="#">&lt;&lt;</a>&nbsp;&nbsp;</span>
					<span class="off"><a href="#">&lt;</a>&nbsp;&nbsp;</span>
					<ul>
						<li class="active"><a href="#">1</a></li>
						<li><a href="#">2</a></li>
						<li><a href="#">3</a></li>
						<li><a href="#">4</a></li>
						<li><a href="#">5</a></li>
					</ul>
					<span class="off">&nbsp;&nbsp;<a href="#">&gt;</a></span>
					<span class="off">&nbsp;&nbsp;<a href="#">&gt;&gt;</a></span> -->
<%	
	if (startBlock==1) { //<<
		out.println("<span><a>&lt;&lt;</a>&nbsp;&nbsp;</span>");
	} else {
		out.println("<span><a href='mainall.do?cpage="+(startBlock-blockPerPage)+"'>&lt;&lt;</a>&nbsp;&nbsp;</span>");
	}

	if (cpage==1) { //<
		out.println("<span><a>&lt;</a>&nbsp;&nbsp;</span>");
	} else {
		out.println("<span><a href='mainall.do?cpage="+(cpage-1)+"'>&lt;</a>&nbsp;&nbsp;</span>");
	}
	
	out.println("<ul>");
	for (int i=startBlock;i<=endBlock;i++) {
		if (cpage==i) {
			out.println("<li class='active'><a>"+i+"</a></li>");
		} else {
			out.println("<li><a href='mainall.do?cpage="+i+"'>"+i+"</a></span>");
		}
	}
	
	out.println("</ul>");
	
	if (cpage==totalPage) { //>
		out.println("<span>&nbsp;&nbsp;<a>&gt;</a></span>");
	} else {
		out.println("<span>&nbsp;&nbsp;<a href='mainall.do?cpage="+(cpage+1)+"'>&gt;</a></span>");
	}
	
	if (endBlock==totalPage) { //>>
		out.println("<span>&nbsp;&nbsp;<a>&gt;&gt;</a></span>");
	} else {
		out.println("<span>&nbsp;&nbsp;<a href='mainall.do?cpage="+(startBlock+blockPerPage)+"'>&gt;&gt;</a></span>");
	}
%>
				</div><!-- board_pagetab -->
			</div><!-- paginate_regular -->
		</section>
	</div>
	<!-- footer 
	<footer>
	</footer>
	-->
</body>
</html>