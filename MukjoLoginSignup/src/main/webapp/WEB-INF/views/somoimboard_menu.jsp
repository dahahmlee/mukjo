<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@page import="com.example.model1.BoardTO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.example.model1.BoardDAO"%>
<%@page import="com.example.model1.BoardListTO"%>
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
    <title>세부내용 MENU</title>
    <style href="css/common.css"></style>
    <!-- 나눔스퀘어 폰트 -->
    <link href="https://hangeul.pstatic.net/hangeul_static/css/nanum-square.css" rel="stylesheet">
    <!-- 부트스트랩 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">


<style>
/** common **/

a:link {  color: black; text-decoration: none}
    a:visited {color: black; text-decoration: none;}
    a:hover {color: #5c3018; text-decoration: none;}
    a:active {color: #de5f47; text-decoration: none;}


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

#headerWap h3{
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
 
  display: inline-block;
}



/* 버튼 섹션*/
#btnSec {
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
  font-size: 20px;
  display: inline-block;
  padding-left: 20px;
}



#locationSec{
    width: 100%;
    background-color: #f7f7fd;
    overflow: hidden;
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



/* 테이블 섹션 */

#itemBox{
    height: 380px;
    overflow-y: auto;
}

.mainmenu{
    border: 1px solid #fff;
    border-radius: 4px;
    margin-right: 20px;
    font-size: 12px;
    padding: 0 5px 0 5px;
    background: #de5f47;
    color: #ffffff;
}

#good td:nth-child(2n+1){
     width: 50%;
		}

#good td:nth-child(2n+0){
    width: 50%;
		}

/***** footer  *****/
footer{
    width: 100%;
    height: 163px;
    background-color: #d7d7d7;
    margin-top: 5%;
}

</style>

</head>
<body>
    <nav id="header">
        <div id="headerWap">
            <h1 id="logoSec">
                 <a href="main.do"><img src="images/logo.png" alt="logo"></a>
            </h1>
            <h3 > <%=welcome %> <a href="logoutok.do" id="logout" style="color : gray"> <br/><%=log %>	</a></h3>
            
            <ul>
                <li><b><a href="myPage.do">마이페이지</a></b></li>
                <li><b><a href="#">소모임장페이지</a></b></li>
                 <li><b><a href="admin.do">관리자페이지</b></li></a>
				<li><b><a href="favorite.do">즐겨찾기</b></li></a>
                <li id="bell"><a href="#"><b><img src="images/bell.png"></a></b>1</li>
            </ul>
        </div> <!--headerWap-->
   
   
      <!--locationSec -->
      <section id="locationSec">
        <div id = "locationwrap">
             <button class="active"><a href="./somoimboard.do" >게시판</a></button>
             <button class="allbtn"><a href="#" style="color : #de5f47">식당검색</a></button>
             <button class="allbtn"><a href="#">소모임 회원 목록</a></button>
             <button class="allbtn"><a href="#">소모임 탈퇴</a></button>
        </div>
      </section>
    </nav>  

    <!-- 전체 요소를 감싸는 div -->
    <div id="wrap">


        <!-- 게시판 이름이 있는 섹션입니다 -->
        <section id="titSec">
            <strong></strong>
        </section>
          
    

               <div class="tblmain" style= "display: flex; justify-content: space-around;">
                    <div style="width: 50%;">
                         <table border="1" style="width: 100%;    height: 20%;">  
                             <thead>
                               <td colspan="4"><a href="#">모리가츠</a></td>
                                  <tr id="tabBox">
                                    <th scope="col" class="th-title"><a href="./somoimboard_home.do" >홈</a></th>
                                    <th scope="col" class="th-date"><a href="./somoimboard_review.do">리뷰</a></th>
                                    <th scope="col" class="th-num"><a href="./somoimboard_menu.do" style="color : #de5f47">메뉴</a></th>
                                    <th scope="col" class="th-date"><a href="./somoimboard_picture.do">사진</a></th>
                                 
                                </tr> 
                            </thead>

                            
                         </table>
                         <div id="itemBox">
                            <table border="1" id="good">  
                               
                                
                                <tbody>
                                    <tr>
                                        <td ><a href="#"><img src='https://search.pstatic.net/common/?autoRotate=true&quality=95&type=f320_320&src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20200415_277%2F1586927108266gELTf_JPEG%2F4tmjr09h2qk8Wqi3nI7_Mxeo.jpg' class="_img" alt="사진" width="100%" height="auto" id="visitor_3"></a></td>
                                        <td><span class="mainmenu">대표</span><a href="#"><span>왕 돈까스 </br></br>10000원</span> </a></td>
                            
                                    </tr>

                                    <tr>
                                        <td ><a href="#"><img src='https://search.pstatic.net/common/?autoRotate=true&quality=95&type=f320_320&src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20200415_277%2F1586927108266gELTf_JPEG%2F4tmjr09h2qk8Wqi3nI7_Mxeo.jpg' class="_img" alt="사진" width="100%" height="auto" id="visitor_3"></a></td>
                                        <td><span class="mainmenu">대표</span><a href="#"><span>왕 돈까스 </br></br>10000원</span> </a></td>
                            
                                    </tr>

                                  

                                    <tr>
                                        <td><a href="#"><img src='https://search.pstatic.net/common/?autoRotate=true&quality=95&type=f320_320&src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20200415_277%2F1586927108266gELTf_JPEG%2F4tmjr09h2qk8Wqi3nI7_Mxeo.jpg' class="_img" alt="사진" width="100%" height="auto" id="visitor_3"></a></td>
                                        <td colspan="2"><span class="mainmenu">대표</span><a href="#">행운 정식 <span></br></br>11000원</span> </a></td>
                                    </tr>

                                    <tr>
                                        <td><a href="#"><img src='https://search.pstatic.net/common/?autoRotate=true&quality=95&type=f320_320&src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20200415_277%2F1586927108266gELTf_JPEG%2F4tmjr09h2qk8Wqi3nI7_Mxeo.jpg' class="_img" alt="사진" width="100%" height="auto" id="visitor_3"></a></td>
                                        <td colspan="2"><span class="mainmenu">대표</span><a href="#">행운 정식 <span></br></br>11000원</span> </a></td>
                                       
                                    </tr>

                                
                                   
                                    </tbody>
    
   
                                   </table>
                        </div>
                    </div>


                    <div class="maps" style="width: 50%;">  
                        <img src="images/mapsearch2.png">
                    </div> 



               
            </div><!-- tblmain -->
          
    
    </div>

    <!-- footer 
    <footer>

    </footer>
    -->

</body>
</html>