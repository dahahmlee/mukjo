
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

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
    
    %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Main</title>
<style href="css/common.css"></style>
<!-- 나눔스퀘어 폰트 -->
<link
	href="https://hangeul.pstatic.net/hangeul_static/css/nanum-square.css"
	rel="stylesheet">


<style>
/** common **/
body, ul, li, h1, h2, h3 {
	margin: 0;
	padding: 0;
}

input {
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

ul {
	list-style: none;
}

a:link {
	text-decoration: none
}

a:visited {
	color: black;
	text-decoration: none;
}

a:hover {
	color: #5c3018;
	text-decoration: none;
}

a:active {
	color: #de5f47;
	text-decoration: none;
}

img {
	width: 100%;
}

table {
	text-align: center;
}

:root { -
	-button-color: #ffffff; -
	-button-bg-color: #5c3018; -
	-button-hover-bg-color: #5c3018;
}

button {
	-webkit-appearance: none;
	-moz-appearance: none;
	appearance: none;
	background: var(- -button-bg-color);
	color: var(- -button-color);
	margin: 0;
	padding: 0.5rem 1rem;
	font-family: 'Noto Sans KR', sans-serif;
	font-size: 1rem;
	font-weight: 400;
	text-align: center;
	text-decoration: none;
	text-transform: none;
	border: none;
	border-radius: 4px;
	display: inline-block;
	width: auto;
	box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px
		rgba(0, 0, 0, 0.06);
	cursor: pointer;
	transition: 0.5s;
}

button:active, button:hover, button:focus {
	background: var(- -button-hover-bg-color);
	outline: 0;
}

button:disabled {
	opacity: 0.5;
}

/** nav **/
nav {
	position: sticky;
	top: 0;
}

#header {
	border-bottom: #c7bebe 1px solid;
	z-index: 1;
}

#header ul {
	display: flex;
	font-family: 'NanumSquareBold';
}

#header ul li {
	margin-left: 73px;
}

#header ul li b {
	line-height: 41.5px;
}

#logoSec {
	width: 8%;
}

#logout {
	color: grey;
	width: 10%;
	text-decoration: underline;
	margin-right: 17%;
}

#bell {
	width: 5%;
	display: flex;
	align-items: center;
	color: red;
}

#headerWap {
	width: 1280px;
	margin: auto;
	display: flex;
	justify-content: space-between;
	height: 98px;
	align-items: center;
	background-color: white;
}

#headerWap h3 {
	font-size: 15px;
	justify-content: left;
	position: absolute;
	margin-left: 120px;
}

/***** warp  *****/
#wrap {
	width: 100%;
	margin-top : 5px;
	padding-top: 10px;
	padding-bottom: 10px;
	display: flex;
	/* border: 1px dotted black; */
	justify-content: center;
}

/* 타이틀 섹션 */
#titSec strong {
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

#btnSec button {
	margin-left: 10px;
	margin-bottom: 5px;
}

#btnSec strong {
	font-family: 'NanumSquareExtraBold';
	font-size: 25px;
	display: inline-block;
	padding-left: 50px;
}

#btnSec .search-wrap {
	margin-left: 50%;
}

#locationSec {
	width: 100%;
	background-color: #f7f7fd;
}

#locationSec button {
	font-weight: 500;
	background: none;
	cursor: default;
	outline: none;
	box-shadow: none;
}

#locationwrap {
	width: 1280px;
	margin: 0 auto;
	height: 55px;
	padding-top: 13px;
}

#locationwrap button {
	font-family: 'NanumSquareBold';
}

.allbtn {
	color: #333;
	position: relative;
}

.active {
	color: #de5f47;
}

/* 테이블 섹션 */
#tblSec table {
	width: 100%;
	border-collapse: collapse;
}

#tblSec table td {
	height: 45px;
	border-bottom: 1px solid #c7bebe;
}

#tblWrap {
	padding-top: 30px;
}

/***** pagingSec  *****/
#pagingSec ul {
	display: flex;
}

#pagingSec {
	display: flex;
	justify-content: center;
	margin-top: 30px;
	line-height: 2.5;
}

#btnSec .search-wrap {
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

#pagingSec .search-wrap #search {
	height: 37.6px;
	margin-right: 4px;
}

.search-wrap input {
	height: 32px;
	width: 80%;
	color: #000;
	font-size: 16px;
	box-sizing: border-box;
	margin-left: 5px;
}

/* width : 30, height : 45 */
.search-wrap button {
	width: 30px;
	height: 25px;
	right: 5%;
	top: 10%;
	text-indent: -9999px;
	overflow: hidden;
	background: url( ./images/search2.png) no-repeat;
	position: absolute;
	background-size: 38px 25px;
}

#pagingSec ul li {
	width: 42px;
	height: 42px;
	text-align: center;
	line-height: 42px;
	margin-right: 10px;
	border: 1px solid #c4c4c4;
	border-radius: 10%;
}

#pagingSec .active {
	color: white;
	background-color: #de5f47;
}

.board_pagetab {
	text-align: center;
	display: inline-flex;
	position: relative;
}

.board_pagetab a {
	text-decoration: none;
	font: 12px verdana;
	color: #000;
	padding: 0 3px 0 3px;
}
/* .board_pagetab ul a:hover  { background-color:black; } */
.on a {
	font-weight: bold;
}

/***** footer  *****/
footer {
	width: 100%;
	height: 163px;
	background-color: #d7d7d7;
	margin-top: 5%;
}

.user_id {
	margin-top: 20px;
	width: 500px;
	display: flex;
}

.user_id h4 {
	margin-bottom: 10px;
}

.user_id input {
	width: 80%;
	height: 40px;
	border-radius: 0px;
	margin-top: 10px;
	padding: 0px 20px;
	border: 1px solid lightgray;
	outline: none;
}

.user_birth {
	margin-top: 20px;
	width: 500px;
	display: flex;
}

.user_birth h4 {
	margin-bottom: 10px;
}

.user_birth input {
	width: 370px;
	height: 40px;
	border-radius: 0px;
	margin-top: 10px;
	padding: 0px 20px;
	border: 1px solid lightgray;
	outline: none;
}

.user_phone {
	margin-top: 20px;
	width: 500px;
	display: flex;
}

.user_phone h4 {
	margin-bottom: 10px;
}

.user_phone input {
	width: 350px;
	height: 40px;
	border-radius: 0px;
	margin-top: 10px;
	padding: 0px 20px;
	border: 1px solid lightgray;
	outline: none;
}

.user_pwd1 {
	margin-top: 20px;
	width: 500px;
	display: flex;
}

.user_pwd1 h4 {
	margin-bottom: 10px;
}

.user_pwd1 input {
	width: 370px;
	height: 40px;
	border-radius: 0px;
	margin-top: 10px;
	padding: 0px 20px;
	border: 1px solid lightgray;
	outline: none;
}

.user_pwd2 {
	margin-top: 20px;
	width: 500px;
	display: flex;
}

.user_pwd2 h4 {
	margin-bottom: 10px;
}

.user_pwd2 input {
	width: 325px;
	height: 40px;
	border-radius: 0px;
	margin-top: 10px;
	padding: 0px 20px;
	border: 1px solid lightgray;
	outline: none;
}

.submit {
	margin-top: 20px;
	width: 350px;
	text-align: right;
	justify-cotent: center;
}

.submit input:active {
	font-size: 15px;
	font-weight: 500;
	box-shadow: none;
}

.submit input:hover {
	cursor: pointer;
}

.submit input {
	width: 100px;
	height: 35px;
	border: 0;
	outline: none;
	background-color: #f1b654;
	color: #5c3018;
	font-size: 1em;
	font-weight: 600;
	text-align: center;
	letter-spacing: 2px;
	box-shadow: 1px 2px 2px black;
	transition-duration: 0.5s;
}



.form_modify h4 {
	font-size: 0.9em;
}

.form_modify h2 {
	color: #5c3018;
}

.chkbox1 {
	padding-top: 20px;
	padding-bottom: 0px;
	
}

.chkbox1 input {
	cursor: pointer;
}
</style>
<script type="text/javascript">
    window.onload = function() {
       document.querySelector('#mpBtn1').onclick = function() {
          if( document.mpfrm.userbirth.value.trim() == "" ) {
             alert( '생년월일을 입력해주세요.' );
             return false;
          }
          
          if( document.mpfrm.user_phone.value.trim() == "" ) {
             alert( '핸드폰 번호를 입력해주세요.' );
             return false;            
          }
          
          if( document.mpfrm.user_pwd1.value.trim() == "" ) {
              alert( '비밀번호를 입력해주세요.' );
              return false;            
           }
          
          if( document.mpfrm.user_pwd2.value.trim() == "" ) {
              alert( '비밀번호를 재확인해주세요.' );
              return false;            
           }
          
          document.mpfrm.submit();
       };
       
       
    };
 </script>
<link
	href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap"
	rel="stylesheet">
<script src="https://kit.fontawesome.com/53a8c415f1.js"
	crossorigin="anonymous"></script>
</head>
<body>
	<nav id="header">
		<div id="headerWap">
			<h1 id="logoSec">
				<a href="main.do"><img src="images/logo.png" alt="logo"></a>
			</h1>
			<h3><%=welcome %><a href="logoutok.do" id="logout"
					style="color: gray"><br /><%=log %></a>
			</h3>
			<ul>
				<li><b><a href="#" style="color : #de5f47;">마이페이지</a></b></li>
				<li><b><a href="#">소모임장페이지</a></b></li>
				<li><b><a href="admin.do">관리자페이지</b></li>
				</a>
				<li><b><a href="favorite.do">즐겨찾기</b></li>
				</a>
				<li id="bell"><a href="#"><b><img src="images/bell.png"></a></b>1</li>

			</ul>
		</div>
		<!--headerWap-->


		<!--locationSec -->
		<section id="locationSec">
			<div id="locationwrap">
				<button class="allbtn">
					<a href="myPage.do">내가 쓴 글 보기</a>
				</button>
				<button class="active">
					<a href="#" style="color: #de5f47;">내 정보 수정</a>
				</button>
			</div>
		</section>
	</nav>

	<!-- 전체 요소를 감싸는 div -->
	<div id="wrap">
		<form action="" method="post" name="mpfrm" class="form_modify">
				<h2>내 정보수정</h2>
				<hr />
				<div class="user_id">
					<h4>계정</h4>
					&nbsp;&nbsp; <input type="text" readonly name="usermail" id="" placeholder="young@naver.com">
				</div>

				<div class="user_birth">
					<h4>생년월일</h4>
					&nbsp;&nbsp; <input type="text" name="userbirth" id="" maxlength="6">
				</div>

				<div class="user_phone">
					<h4>핸드폰 번호</h4>
					&nbsp;&nbsp;
					 <input type="text" name="user_phone" id=""	maxlength="11">
				</div>

				<div class="user_pwd1">
					<h4>비밀번호</h4>
					&nbsp;&nbsp; <input type="password" name="user_pwd1" id="" maxlength="20">
				</div>

				<div class="user_pwd2">
					<h4>비밀번호 확인</h4>
					&nbsp;&nbsp;&nbsp;&nbsp; <input type="password" name="user_pwd2"
						id="" maxlength="20">
				</div>
				
				<div class="chkbox1">
					<input type="checkbox" name="chkbox1" id=""> 이메일 수신에 동의합니다.(선택)
				</div>
				
				<div class="submit">
                    <input type="button" id="mpBtn1" value="수정" >
                    &nbsp;&nbsp;&nbsp;
                    <input type="button" id="mpBtn2" value="취소" location.href="'myPage.do'">
                </div>
			


		</form>
	</div>

	<!-- footer 
    <footer>

    </footer>
    -->

</body>

</html>
