<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="com.example.model1.BoardTO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.example.model1.BoardListTO"%>
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
	
	BoardListTO boardListTO = (BoardListTO)request.getAttribute("boardListTO");
	int cpage = boardListTO.getCpage();
	int recordPerPage = boardListTO.getRecordPerPage();
	int totalRecord = boardListTO.getTotalRecord();
	int totalPage = boardListTO.getTotalPage();
	int blockPerPage = boardListTO.getBlockPerPage();
	int startBlock = boardListTO.getStartBlock();
	int endBlock = boardListTO.getEndBlock();
	ArrayList<BoardTO> boardLists = boardListTO.getBoardLists();
	
	StringBuilder sb = new StringBuilder();
	
	for (int j=0; j<boardLists.size(); j=j+20) {
		for (int i=j; i<j+20; i++) {
			
			if (i>=boardLists.size()) {

			} else {
				String bseq=boardLists.get(i).getBseq();
				String subject=boardLists.get(i).getSubject();
				String writer=boardLists.get(i).getWriter();
				String wdate=boardLists.get(i).getWdate();
				String hit=boardLists.get(i).getHit();
				
				sb.append("<tr>");
				sb.append("<td>공지</td>");
				sb.append("<td><a href='adminnotice_view.do?cpage="+cpage+"&bseq="+bseq+"'>"+subject+"</td>");
				sb.append("<td>"+writer+"</td>");
				sb.append("<td>"+wdate+"</td>");
				sb.append("<td>"+hit+"</td>");
				sb.append("</tr>");
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
    <title>Main</title>
   
    <!-- 나눔스퀘어 폰트 -->
    <link href="https://hangeul.pstatic.net/hangeul_static/css/nanum-square.css" rel="stylesheet">

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

a:link {  text-decoration: none}
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
    color : grey;
    width:10%;
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
    width: 1000px; 
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

.active{
    color: #de5f47;
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


#btn_write {
	float: right;
	padding: 10px;
}



/***** footer  *****/
footer{
    width: 100%;
    height: 163px;
    background-color: #d7d7d7;
    margin-top: 5%;
}

.board-table td  {
   width: 1200px;
}

.th-title {
   width: 2600px;
}

</style>

</head>
<body>
    <nav id="header">
        <div id="headerWap">
            <h1 id="logoSec">
                <a href="main.do"><img src="images/logo.png" alt="logo"></a>
            </h1>
            <h3><%=welcome %><a href="logoutok.do" id="logout" style="color : gray"><br/><%=log %></a></h3>
            <ul>
                <li><b><a href="myPage.do">마이페이지</a></b></li>
                <li><b><a href="#">소모임장페이지</a></b></li>
                <li><b><a href="admin.do" style="color: #de5f47">관리자페이지</b></li></a>
                <li><b><a href="favorite.do">즐겨찾기</b></li></a>
                <li id="bell"><a href="#"><b><img src="images/bell.png"></a></b>1</li>

            </ul>
        </div> <!--headerWap-->
   
   
      <!--locationSec -->
      <section id="locationSec">
        <div id = "locationwrap">
             <button class="allbtn"><a href="admin.do">리뷰&게시물 수</a></button>
             <button class="active"><a href="adminmemberlists.do">전체 회원 목록</a></button>
             <button class="active"><a href="adminteam.do">소모임 목록</a></button>
             <button class="active"><a href="adminnotice.do" style="color: #de5f47">공지사항</a></button>
        </div>
      </section>
    </nav>  

    <!-- 전체 요소를 감싸는 div -->
    <div id="wrap">
   		<section id="tblSec">
   		<div id="btn_write">
			<button type="submit" onclick="location.href='http://localhost:8080/adminnotice_write.do?cpage=<%=cpage %>'">글쓰기</button>
		</div>
            <div id="tblWrap">
                <table class="board-table">
                    <thead>
                        <tr>
                            <th scope="col" class="th-num">분류</th>
                            <th scope="col" class="th-title">제목</th>
                            <th scope="col" class="th-id">글쓴이</th>
                            <th scope="col" class="th-date">등록일</th>
                            <th scope="col" class="th-hit">조회수</th>
                        </tr>
                    </thead>
                    <tbody>
<%=sb %>
                    <!--  
                        <tr>
                            <td>공지</td>
                            <td><a href="#">Muckjo에서 프론트엔드 개발자 모십니다!</a></td>
                            <td>관리자</a></td>
                            <td>2022-06-02</a></td>
                            <td>101</a></td>
                        </tr>

                        <tr>
                            <td>공지</td>
                            <td><a href="#">7월 리뷰 이벤트 안내</a></td>
                            <td>관리자</a></td>
                            <td>2022-06-24</a></td>
                            <td>205</a></td>
                        </tr>         

                        <tr>
                            <td>공지</td>
                            <td><a href="#">회원가입 시 준수사항</a></td>
                            <td>관리자</a></td>
                            <td>2022-07-05</a></td>
                            <td>300</a></td>
                        </tr>   
					-->
                    </tbody>
                </table>
            </div>

        </section>
		<!--tblSec-->
		

        <!-- 페이징 처리 -->
        <section id="pagingSec">
            <div class="paginate_regular">
                <div class="board_pagetab">
                <!--  
                    <span class="off"><a href="#">&lt;&lt;</a>&nbsp;&nbsp;</span>
                    <span class="off"><a href="#">&lt;</a>&nbsp;&nbsp;</span>
                <ul>
                    <li class="active"><a href="#">1</a></li>
                    <li><a href="#">2</a></li>
                    <li><a href="#">3</a></li>
                    <li><a href="#">4</a></li>
                    <li><a href="#">5</a></li>
                </ul>
                    <span class="off">&nbsp;&nbsp;<a href="#">&gt;</a></span>
                    <span class="off">&nbsp;&nbsp;<a href="#">&gt;&gt;</a></span>
                -->
        <%	
	if (startBlock==1) { //<<
		out.println("<span><a>&lt;&lt;</a>&nbsp;&nbsp;</span>");
	} else {
		out.println("<span><a href='adminnotice.do?cpage="+(startBlock-blockPerPage)+"'>&lt;&lt;</a>&nbsp;&nbsp;</span>");
	}

	if (cpage==1) { //<
		out.println("<span><a>&lt;</a>&nbsp;&nbsp;</span>");
	} else {
		out.println("<span><a href='adminnotice.do?cpage="+(cpage-1)+"'>&lt;</a>&nbsp;&nbsp;</span>");
	}
	
	out.println("<ul>");
	for (int i=startBlock;i<=endBlock;i++) {
		if (cpage==i) {
			out.println("<li class='active'><a>"+i+"</a></li>");
		} else {
			out.println("<li><a href='adminnotice.do?cpage="+i+"'>"+i+"</a></span>");
		}
	}
	
	out.println("</ul>");
	
	if (cpage==totalPage) { //>
		out.println("<span>&nbsp;&nbsp;<a>&gt;</a></span>");
	} else {
		out.println("<span>&nbsp;&nbsp;<a href='adminnotice.do?cpage="+(cpage+1)+"'>&gt;</a></span>");
	}
	
	if (endBlock==totalPage) { //>>
		out.println("<span>&nbsp;&nbsp;<a>&gt;&gt;</a></span>");
	} else {
		out.println("<span>&nbsp;&nbsp;<a href='adminnotice.do?cpage="+(startBlock+blockPerPage)+"'>&gt;&gt;</a></span>");
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