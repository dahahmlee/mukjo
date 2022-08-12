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
    <title>세부내용 리뷰</title>
    <style href="css/common.css"></style>
    <!-- 나눔스퀘어 폰트 -->
    <link href="https://hangeul.pstatic.net/hangeul_static/css/nanum-square.css" rel="stylesheet">
    <!-- 부트스트랩 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    <!-- 제이쿼리 -->
    <script src="http://code.jquery.com/jquery-latest.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/raty/3.1.1/jquery.raty.min.js" integrity="sha512-Isj3SyFm+B8u/cErwzYj2iEgBorGyWqdFVb934Y+jajNg9kiYQQc9pbmiIgq/bDcar9ijmw4W+bd72UK/tzcsA==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>


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
    table-layout: fixed;
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




.cmttable tr{
	border-bottom: 2px solid #c4b2b2;
	border-top: 2px solid #aa9d9d;
	border-right: none;
	border-left: none;
}

.cmttable td{
	vertical-align: top;
	border-right: none;
	border-left: none;
    padding: 10px 0;
}

.nick{
    padding-left: 10px;
	width: 80px;
    color:blue;
}

.tablewrap table td:nth-last-child(2) { /*뒤에서 (n)번째에 해당색을 집어넣으려고 할 때 */
    width:440px;
}

.tablewrap table td:nth-last-child(3){
    color : #de5f47;
    width: 80px;
}

.tablewrap table tr{
    border-bottom: 2px solid #c4b2b2;
	border-top: 2px solid #aa9d9d;
	border-right: none;
	border-left: none;
}

.btn_list2 {
	display: inline-block;
	background: #f3f3f3;
	border: 1px solid;
    border-color: #ccc #c6c6c6 #c3c3c3 #ccc;
	padding: 6px 17px 7px 17px;
}

.btn_txt03 {
	color: #000;
	font-weight: 600;
}




        
.btn_list {
	display: inline-block;
	background: #5c3018;
	border: 1px solid #404144;
	padding: 6px 17px 7px 17px;
}

.btn_txt02 {
   color: white;
   font-weight: 600;
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
                                    <th scope="col" class="th-date"><a href="./somoimboard_review.do" style="color : #de5f47">리뷰</a></th>
                                    <th scope="col" class="th-num"><a href="./somoimboard_menu.do" >메뉴</a></th>
                                    <th scope="col" class="th-date"><a href="./somoimboard_picture.do" >사진</a></th>
                                 
                                </tr> 
                            </thead>

                            
                         </table>


                         <div id="itemBox">

                            <div class="cmttable" style="clear: both; margin-bottom: 8px; overflow: hidden; _height: 1%;
				                                        background: #fff; margin-top:20px; display: table; border-collapse: separate;">
				<div class="tablewrap" style="display : table-cell;">
				<table width="100%" cellpadding="0" cellspacing="0" style="table-layout : fixed; text-align: start;  border-collapse: collapse;">
					<tbody>
						<tr>
							<td class="nick"><span><i class="fa fa-star" style="font-size:20px;color:#de5f47"></i>
                            3.5점</td>
                            <td>김영규</td>
							<td class="comment">맛있음 굿굿</td>
							<td class="data"><a href="#">X</a></td>
						
						</tr>

						<tr>
							<td class="nick"><span><i class="fa fa-star" style="font-size:20px;color:#de5f47"></i>
                            3.5점</td>
                            <td>김영규</td>
							<td class="comment">예전에 가봤는데 별로였음</td>
							<td class="data" ><a href="#">X</a></td>
						</tr>

                        <tr>
							<td class="nick"><span><i class="fa fa-star" style="font-size:20px;color:#de5f47"></i>
                            3.5점</td>
                            <td>김영규</td>
							<td class="comment">예전에 가봤는데 별로였음</td>
							<td class="data" ><a href="#">X</a></td>
						</tr>

                        <tr>
							<td class="nick"><span><i class="fa fa-star" style="font-size:20px;color:#de5f47"></i>
                            3.5점</td>
                            <td>김영규</td>
							<td class="comment">예전에 가봤는데 별로였음</td>
							<td class="data" ><a href="#">X</a></td>
						</tr>

                        <tr>
							<td class="nick"><span><i class="fa fa-star" style="font-size:20px;color:#de5f47"></i>
                            3.5점</td>
                            <td>김영규</td>
							<td class="comment">예전에 가봤는데 별로였음qdddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddㅇㅇㅇ</td>
							<td class="data" ><a href="#">X</a></td>
						</tr>


					</tbody>

				</table>
				</div>
			</div><!-- cmttable -->



                            <div class="cmteditor" style="padding: 12px 16px 20px;background: #fcfcfc;border: 1px solid #ddd;
				                                        border-bottom-color: #ccc; border-radius: 8px; box-shadow: 0 1px 3px -1px rgb(0 0 0 / 10%);">
				<label for="editorlabel" style="cursor: pointer; position: relative; margin-bottom: 10px;"> 
               
					<strong style="padding-left:5px;font-size:16px;line-height:1.5;">리뷰 쓰기
                        <div id="star" style="width : 130px; display:flex;">

                        </div>
                            <script type="text/javascript">
                                $(function() {
                                    $('div#star').raty({
                                        score: 3
                                        ,path : "/images/"
                                        ,width : 130
                                        ,click: function(score, evt) {
                                            $("#starRating").val(score);
                                            $("#displayStarRating").html(score);
                                        }
                                    });
                                });
                            </script></span>
                       </strong>
				</label>

				<form style="display: block;
				position: relative;
				clear: both;">
				<div class="textcmt" style="display: flex; margin-top: 10px;">
					<textarea style="background: rgb(255, 255, 255); overflow: hidden; min-height: 4em; resize: none;
					height: 49px;width: 85%; margin-left: 3px;"></textarea>

				<input type="button" value="등록" class="btn_list2 btn_txt03"
				style="cursor: pointer; margin-left:40px ;" onclick="location.href='#'" />
				</div>

				</form>



				</div> <!-- cmteditor -->
                         
                        </div><!-- itembox -->
                    </div><!-- width50%용 div -->


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