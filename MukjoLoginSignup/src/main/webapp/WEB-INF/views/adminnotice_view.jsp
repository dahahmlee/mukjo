<%@page import="com.example.model1.BoardTO"%>
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

   int cpage = (Integer)request.getAttribute("cpage");
   BoardTO to = (BoardTO)request.getAttribute("to");   
   
   String bseq=to.getBseq();
   String subject=to.getSubject();
   String writer=to.getWriter();
   String wdate=to.getWdate();
   String hit=to.getHit();
   String content=to.getContent();
   String filename=to.getFilename();
   
   StringBuilder sbHtml=new StringBuilder();
   if (filename!=null) {
     // 이미지 크기 조정 여기서 하기 width: 500px;
      sbHtml.append("<img style='width: 500px;' src='../../upload/"+filename+"'/><br />");
      
   }
   sbHtml.append("<div>");
   sbHtml.append("<p style='font-size:15px; color:black; word-break: break-all; '>");
   sbHtml.append(content);
   sbHtml.append("</p>");
   sbHtml.append("</div>");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Notice</title>

<!-- 나눔스퀘어 폰트 -->
<link
   href="https://hangeul.pstatic.net/hangeul_static/css/nanum-square.css"
   rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.js"></script>
<script  src="http://code.jquery.com/jquery-latest.min.js"></script>
<style>
body, ul, li, h1, h2, h3 {
   margin: 0;
   padding: 0;
}

p {
   width:980px;
   font-size: 1rem;
   color: black;
   font-family: 'Noto Sans KR', sans-serif;
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
   width: 1000px;
   
   margin: auto;
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

.contents_sub {
   width: 1000px;
   margin: 0;
}

.contents_sub table {
   width: 100%;
   border-collapse: collapse;
}

.contents_sub table img {
   padding-top: 2px;
}

.board_view {
   border-top: 0px solid #464646;
}

.board_view table {
    border-collapse: collapse;
}

.board_view th {
   height: 25px;
   text-align: center;
   padding: 8px;
   border-bottom: 1px solid #dadada;
   color: #464646;
   font-weight: 600;
   background-color: #f2f2f2;
}

.board_view td {
   font-family: 'NanumSquareBold';
   height: 25px;
   text-align: left;
   padding: 8px;
   border-bottom: 1px solid #dadada;
   color: black;
}

.board_view_input {
   border: 1px solid #d1d1d1;
}

.board_view_input {
   height: 20px;
   width: 500px;
}

.board_editor_area {
   width: 100%;
   height: 200px;
}

.btn_area {
   overflow: hidden;
   margin: 10px 0;
}

.align_left {
   float: left;
}

.align_right {
   float: right;
}

.btn_write {
   display: inline-block;
   background: #5c3018;
   border: 1px solid #404144;
   padding: 6px 17px 7px 17px;
}

.btn_list {
   display: inline-block;
   background: #5c3018;
   border: 1px solid #404144;
   padding: 6px 17px 7px 17px;
}

.board {
   width: 100%;
}

.board th {
   height: 41px;
   border-bottom: 1px solid #dadada;
   background-color: #f9f9fb;
   color: #464646;
   font-weight: 600;
   word-wrap: break-word;
   border-top: 1px solid #464646;
   word-break: break-all;
}

.board td {
   height: 30px;
   border-bottom: 1px solid #dadada;
   color: #797979;
   text-align: center;
   padding: 5px;
   word-wrap: break-word;
   word-break: break-all;
}

.board td.left {
   text-align: center;
}

.board td.category {
   font-weight: bold;
}

table {
   border-collapse: collapse;
   border-spacing: 0;
}

textarea {
   width: 100%;
   height: 120px;
   border: 1px solid #cecece;
   font-weight: 600;
}

.board_view_input {
   border: 1px solid #d1d1d1;
   font-weight: 600;
}

.btn_txt01 {
   color: white;
   font-weight: 600;
}

.btn_txt02 {
   color: white;
   font-weight: 600;
}

.align_center {
   margin-top: 20px;
}

.btn_list {
   display: inline-block;
   background: #5c3018;
   border: 1px solid #404144;
   padding: 6px 17px 7px 17px;
}

.img_size {
   width: 1000px;
   height: 400px;
   overflow: auto;
}
</style>

</head>
<body>
   <nav id="header">
      <div id="headerWap">
         <h1 id="logoSec">
            <a href="main.do"><img src="images/logo.png" alt="logo"></a>
         </h1>
         <h3><%=welcome%><a href="logoutok.do" id="logout"
               style="color: gray"> <br /><%=log%>
            </a>
         </h3>

         <ul>
            <li><b><a href="myPage.do">마이페이지</a></b></li>
            <li><b><a href="#" style="color: black;">소모임장페이지</a></b></li>
            <li><b><a href="admin.do" style="color: #de5f47">관리자페이지</a></b></li>
            <li><b><a href="favorite.do">즐겨찾기</a></b></li>
            <li id="bell"><a href="#"><b><img src="images/bell.png"></a></b>1</li>

         </ul>
      </div>
      <!--headerWap-->

      <!--locationSec -->
      <section id="locationSec">
         <div id="locationwrap">
            <button class="allbtn">
               <a href="admin.do">리뷰&게시물 수</a>
            </button>
            <button class="active">
               <a href="adminmemberlists.do">전체 회원 목록</a>
            </button>
            <button class="active">
               <a href="adminteam.do">소모임 목록</a>
            </button>
            <button class="active">
               <a href="adminnotice.do" style="color: #de5f47">공지사항</a>
            </button>
         </div>
      </section>
   </nav>

   <!-- 전체 요소를 감싸는 div -->
   <div id="wrap">
      <div class="con_txt">
         <div class="contents_sub">
            <!--게시판-->
            <div class="board_view">
               <table>
                  <tr>
                     <th width="10%">제목</th>
                     <td width="30%"><%=subject %></td>
                     <th width="10%">등록일</th>
                     <td width="20%"><%=wdate %></td>         
                  </tr>
                  <tr>
                     <th>글쓴이</th>
                     <td><%=writer %></td>
                     <th>조회수</th>
                     <td><%=hit %></td>
                  </tr>   
                  <tr>
                     <td colspan="4" height="100" valign="top"
                        style="padding: 10px; line-height: 150% overflow: auto;">
                        <div class="img_size">
                        <%=sbHtml.toString() %>
                        </div>
                     </td>
                  </tr>
               </table>
            </div>

            <div class="btn_area">
               <div class="align_left">
                  <input type="button" value="목록" class="btn_list btn_txt02"
                     style="cursor: pointer;" onclick="location.href='adminnotice.do?cpage=<%=cpage %>&bseq=<%=bseq %>'" />
               </div>
               
               <div class="align_right">
                  <input type="button" value="수정" class="btn_list btn_txt02"   style="cursor: pointer;"
                  onclick="location.href='adminnotice_modify.do?cpage=<%=cpage %>&bseq=<%=bseq %>'" /> 
                     
                  <input type="button" value="삭제" class="btn_list btn_txt02" style="cursor: pointer;" 
                  onclick="location.href='adminnotice_delete.do?cpage=<%=cpage %>&bseq=<%=bseq %>'"/>
                     
                  <input type="button" value="글 쓰기" class="btn_write btn_txt01" style="cursor: pointer;"
                  onclick="location.href='adminnotice_write.do?cpage=<%=cpage %>&bseq=<%=bseq %>'" />
               </div>
            </div>
            <!--//게시판-->
         </div>
      </div>
   </div>
</body>

</html>