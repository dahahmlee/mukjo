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
    <title>내 소모임</title>
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

a:link {  color : black; text-decoration: none}
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
    margin-bottom : 10px;
   
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
    top: 50%;
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

</style>

</head>
<body>
    <nav id="header">
        <div class="headermake" style="width:100%; background-color: #fff;">
        <div id="headerWap">
            <h1 id="logoSec">
                <a href="#"><img src="images/logo.png" alt="logo"></a>
            </h1>
            <h3 > <%=welcome %> <a href="logoutok.do" id="logout" style="color : gray"> <br/><%=log %>	</a></h3>
            
            <ul>
                <li><b><a href="myPage.do">마이페이지</a></b></li>
                <li><b><a href="boss.do">소모임장페이지</a></b></li>
                 <li><b><a href="admin.do">관리자페이지</b></li></a>
				<li><b><a href="favorite.do">즐겨찾기</b></li></a>
                <li id="bell"><a href="#"><b><img src="images/bell.png"></a></b>1</li>

            </ul>
        </div> <!--headerWap-->
    </div>
   
   
      <!--locationSec -->
      <section id="locationSec">
        <div id = "locationwrap">
             <button class="allbtn"><a href="#" style="color : #de5f47">가입한 소모임</a></button>
             <button class="active"><a href="./main.do" >전체 소모임</a></button>
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
            <strong>내 소모임 <b>5</b></strong>

            <div class="search-wrap">           
                <input type="text" title="검색어 입력">
                <button type="button">검색</button>
            </div><!-- search-wrap -->

            
            <div class="modal">
                <div class="modal-content">
                    <a class="btn-close" href="#none">X</a>
                    <h2>소모임 새로 만들기</h2>
                    <p style="font-weight: bold;"> 소모임명
                        <input type="text" id="modal-search" name="tname" required
                         minlength="4" maxlength="20" size="10" style="width: 50% ; height : 30px; "/>
                         <button class="emailChk btn btn-primary" type="button" id="tnamecheckbtn" onclick="tnamechk(this.form)" value="">중복확인</button>
                    </p>
                     <div class="modal-make" style="margin-top: 100px;">
                   <a class="btn-guide" id="sbtn" href="#none" style="color : #fff; margin-right:10px; padding: 10px;">만들기</a>
                   <a class="btn-guide btn-exit" href="#none" style="color : #fff; padding: 10px;">취소</a>
                     </div>
                </div>
               
            </div>
        </section>


        <!-- 소모임 새로만들기 Modal -->
        <script>
            $('.modal-notice').click( function(){
                $('.modal').fadeIn()
            })
            $('.btn-close').click( function(){
                $('.modal').fadeOut()
            })
            $('.btn-exit').click( function(){
                $('.modal').fadeOut()
            })




            $("#tnamecheckbtn").click(function () {
             // 중복검사 

             const Toast = Swal.mixin({
             toast: true,
             position: 'center-center',
             showConfirmButton: false,
             timer: 2000,
             timerProgressBar: true,
             didOpen: (toast) => {
              toast.addEventListener('mouseenter', Swal.stopTimer)
              toast.addEventListener('mouseleave', Swal.resumeTimer)
            }
            })

            Toast.fire({
            //   icon: 'error', 
            //   title: '사용하실 수 없는 이메일입니다 잠시만 기다려주세요!'

            icon: 'success', 
            title: '사용하실 수 있는 소모임입니다. 잠시만 기다려주세요!'
             })
         });

         
        $("#sbtn").click(function () {
         // 모든 형식이 다 갖춰졌으면 데이터 받아서 버튼 클릭 후 confirm 실행

         Swal.fire({
         text: "소모임 만들기를 진행하시겠습니까?",
         icon: 'confirm',
         showCancelButton: true,
         confirmButtonColor: '#de5f47',
         cancelButtonColor: '#de5f47',
         confirmButtonText: '확인',
         cancelButtonText: '취소',
         reverseButtons: false, // 버튼 순서 거꾸로
      
         }).then((result) => {
         if (result.isConfirmed) {
         Swal.fire(
          '소모임 생성이 완료되었습니다.',
          'Welcome to Mukjo',
          'success'
        )  
        location.href="./main.do"; 
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
                        <tr>
                            <td><a href="#">1</td>
                            <td><a href="#">먹진남</a></td>
                            <td><a href="">손흥민</a></td>
                            <td><a href="#">13명</a></td>
                        </tr>

                        <tr>
                            <td><a href="#">2</a></td>
                            <td><a href="#">먹진남</a></td>
                            <td><a href="#">박지성</a></td>
                            <td><a href="#">20명</a></td>
                        </tr>         

                        <tr>
                            <td><a href="#">3</a></td>
                            <td><a href="#">먹진남</a></td>
                            <td><a href="#">박지성</a></td>
                            <td><a href="#">20명</a></td>
                        </tr>   
                        <tr>
                            <td><a href="#">4</a></td>
                            <td><a href="#">먹진남</a></td>
                            <td><a href="#">박지성</a></td>
                            <td><a href="#">20명</a></td>
                        </tr>   
                        <tr>
                            <td><a href="#">5</a></td>
                            <td><a href="#">먹진남</a></td>
                            <td><a href="#">박지성</a></td>
                            <td><a href="#">20명</a></td>
                        </tr>   
                    </tbody>
                </table>
            </div>

        </section><!--tblSec-->

        
        <section id="pagingSec">


            <div class="paginate_regular">
                <div class="board_pagetab">
                
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