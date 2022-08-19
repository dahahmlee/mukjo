<%@page import="com.example.model1.NoticeTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@page import="com.example.model1.MapDAO3"%>
<%@page import="java.util.ArrayList"%>
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
    
   String tseq=request.getParameter("tseq");
   String id=request.getParameter("id");
   String latitude=request.getParameter("latitude");
   String longitude=request.getParameter("longitude");
   String rname = (String)request.getAttribute("rname");
   
   ArrayList<String> pic=(ArrayList<String>)request.getAttribute("pic");

   StringBuilder sb = new StringBuilder();
   String pos=""; //사진 위치
   for( int i = 0 ; i < pic.size(); i++ ) {
       if (i==0) {
          pos="0px; left: 0.5px";
       } else if (i==1) {
          pos="0px;left: 305px";
       } else if (i==2) {
          pos="237px; left: 0.5px";
       } else if (i==3) {
          pos="236px; left: 304.5px";
       } else {
          pos="475px; left: 0.5px";
       }
        
         sb.append("<div data-grid-groupkey='0' class='_21zjL' style='position: absolute; top:"+pos+";'>");
         sb.append("<a href='"+pic.get(i)+"' target='_self' role='button' class='place_thumb'>");
         sb.append("<img src='"+pic.get(i)+"' alt='사진' width='100%' height='auto'>");
         sb.append("</a></div>>");
      }
   
   ArrayList<NoticeTO> noticeList=(ArrayList<NoticeTO>)request.getAttribute("noticeList");
   String noticeCount=(String)request.getAttribute("noticeCount").toString();
   
   StringBuilder sbh=new StringBuilder();
   for (int i=0; i<noticeList.size(); i++) {
      String words=noticeList.get(i).getWords();
      String ndate=noticeList.get(i).getNdate();
      
      sbh.append("<p>"+words);
      sbh.append("<span>"+ndate+"</span>");
      sbh.append("</p>");
   }
    %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>세부내용 사진</title>
    <style href="css/common.css"></style>
    <!-- 나눔스퀘어 폰트 -->
    <link href="https://hangeul.pstatic.net/hangeul_static/css/nanum-square.css" rel="stylesheet">
    <!-- 부트스트랩 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
	
	<!-- Bootstrap (for modal) -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
	
<!-- 지도 -->
<script type="text/javascript" src="https://openapi.map.naver.com/openapi/v3/maps.js?ncpClientId=f8b62z9xjz&amp;submodules=geocoder"></script>
<script src="http://code.jquery.com/jquery-latest.min.js"></script>

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
    padding-bottom: 5px;
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
    z-index: 1050;
}

#header ul{
    display: flex;
    font-family: 'NanumSquareBold';
}

#header ul li{
    margin-left: 65px;
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
    width: 60px;
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
    font-weight: bold;
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

#tabBox th{
    width : 23%;
}

.tblmain table th{
    background-color: #f7f7fd;
}

._21zjL{
   width : 48% !important;
   padding: 2px;
    box-sizing: border-box;
    transition: all .3s cubic-bezier(0.65, 0.05, 0.36, 1);
}

.place_thumb {
    overflow: hidden;
    border-radius: 5px;
}

#itemBox img, svg {
    display: inline-block;
    vertical-align: top;
}



/***** footer  *****/
footer{
    width: 100%;
    height: 163px;
    background-color: #d7d7d7;
    margin-top: 5%;
}

.tblmain table td {
   border: 1px solid black;
}

.tblmain table th {
   border: 1px solid black;
   border-bottom: none;
}

.tblmain table tr {
   border: 1px solid black;
}

.modal-dialog {
    position: fixed;
    margin: auto;
    width: 320px;
    height: 100%;
    right: 0px;
}

.modal-content {
   border: 1px solid black;
    height: 100%;
}

#noticelogo {
   width: 25%;
}

.modal-body span {
   float: right;
   margin-right: 15px;
}

._21zjL img{
   width:290px;
   height:230px;
}

.iw_inner {
	margin: 5px;
	padding: 1px 5px;
	border-radius: 30px;
	background-color: rgba(4, 117, 244, 0.9);
}

.checkbox {
	float: right;
	
}

#star {
	width: 40px;
	margin-top: 10px;
	
}

input[type="checkbox"]+label {
    display: flex;
    width: 28px;
    height: 28px;
    background: url('./images/staroff2.png') no-repeat 0 0px / contain;
}

input[type='checkbox']:checked+label {
    background: url('./images/star-on.png') no-repeat 0 1px / contain;
}

input[type="checkbox"] {
    display: none;
}
</style>

</head>
<body>
    <nav id="header">
        <div class="headermake" style="width:100%; background-color: #fff;">
        <div id="headerWap">
            <h1 id="logoSec">
                <a href="main.do"><img src="images/logo.png" alt="logo"></a>
            </h1>
            <h3><%=welcome %><a href="logoutok.do" id="logout" style="color : gray"><br/><%=log %></a></h3>
            <ul>
                <li><b><a href="myPage.do">마이페이지</a></b></li>
                <li><b><a href="boss.do">소모임장페이지</a></b></li>
                <li><b><a href="admin.do">관리자페이지</b></li></a>
                <li><b><a href="favorite.do">즐겨찾기</b></li></a>
                <li id="bell" style="margin-left: 20px;">
                	<button type="button" id="modalBtn" class="btn" data-bs-toggle="modal" data-bs-target="#exampleModal">
						<img src="images/bell.png">
					</button><%=noticeCount %>
				</li>
            </ul>
          </div>
        </div> <!--headerWap-->
        
        <!-- Modal -->
  <div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-scrollable">
      <div class="modal-content">
        <div class="modal-header">
          <h4 class="modal-title" id="exampleModalLabel"><b>알림</b></h4>
          <span id="noticelogo"><img src="images/logo.png"></span>
        </div>

        <div class="modal-body">
          <%=sbh %>
        <!-- 
          <p>[맥크리] 소모임 가입 승인이 완료되었습니다.
             <span>2022.07.13</span>
          </p>
          <hr />
          <p>[맥크리] 소모임 가입 승인이 완료되었습니다.
             <span>2022.07.13</span>
          </p>
          <hr />
          <p>[맥크리] 소모임 가입 승인이 완료되었습니다.
             <span>2022.07.13</span>
          </p>
          -->
          <hr />
        </div>

        <div class="modal-footer">
          <button type="button" class="btn btn-outline-primary" data-bs-dismiss="modal"><a href="noticedeleteok.do"><b>읽음</b></button>
          <button type="button" class="btn btn-outline-danger" data-bs-dismiss="modal"><a href=""><b>닫기</b></button>
        </div>
      </div>
    </div>
  </div>
   
   
       <!--locationSec -->
      <section id="locationSec">
        <div id = "locationwrap">
             <button class="active"><a href="./somoimboard.do?tseq=<%=tseq %>">게시판</a></button>
             <button class="allbtn"><a href="./somoimboard_search.do?tseq=<%=tseq %>" style="color : #de5f47">식당검색</a></button>
             <button class="allbtn"><a href="./somoimboard_memberlist.do?tseq=<%=tseq %>">소모임 회원 목록</a></button>
             <button class="allbtn" id="bsbtn"><a href="./somoimboard_memberexit.do?tseq=<%=tseq %>">소모임 탈퇴</a></button>
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
                               <td colspan="4" class="homesub"><a href="#" style=" font-weight:bold; margin-left: 40px;"><%= rname %></a>
                                      <div class="checkbox">
                                         <input type="checkbox" id="favCheck" onclick="'location.href='">
										 <label for="favCheck" style="margin-right: 10px;"></label>
									  </div>
                                  <tr id="tabBox">
                                   <th scope="col" class="th-title"><a href="./somoimboard_home.do?tseq=<%=tseq%>&id=<%=id %>&latitude=<%=latitude %>&longitude=<%=longitude %>" >홈</a></th>
                                    <th scope="col" class="th-date"><a href="./somoimboard_review.do?tseq=<%=tseq%>&id=<%=id %>&latitude=<%=latitude %>&longitude=<%=longitude %>">리뷰</a></th>
                                    <th scope="col" class="th-num"><a href="./somoimboard_menu.do?tseq=<%=tseq%>&id=<%=id %>&latitude=<%=latitude %>&longitude=<%=longitude %>" >메뉴</a></th>
                                    <th scope="col" class="th-date"><a href="./somoimboard_picture.do?tseq=<%=tseq%>&id=<%=id %>&latitude=<%=latitude %>&longitude=<%=longitude %>" style="color : #de5f47">사진</a></th>
                                 
                                </tr> 
                            </thead>

                         </table>

                         <div id="itemBox">
                            <div style="position:relative; height: 700px;">
                        <%=sb %>
                        <!--  
                                <div data-grid-groupkey="0" class="_21zjL" style="position: absolute; top: 0px; left: 0.5px;">
                                 <a href="#" target="_self" role="button" class="place_thumb">
                                <img src="https://search.pstatic.net/common/?autoRotate=true&amp;type=w560_sharpen&amp;src=https%3A%2F%2Fnaverbooking-phinf.pstatic.net%2F20220804_213%2F1659540983719DJg8F_JPEG%2Fimage.jpg" alt="사진" width="100%" height="auto" id="visitor_1">
                                </a></div>

                                <div data-grid-groupkey="0" class="_21zjL" style="position: absolute;top: 0px;left: 305px;"><a href="#" target="_self" role="button" class="place_thumb">
                                    <a href="#" target="_self" role="button" class="place_thumb">
                                        <img src="https://search.pstatic.net/common/?autoRotate=true&amp;type=w560_sharpen&amp;src=https%3A%2F%2Fpup-review-phinf.pstatic.net%2FMjAyMjA3MThfMTYz%2FMDAxNjU4MTEyOTk2MjM2.MmauqWDCrGySBjOCxY2s0AEoXZxZ_IsHmWlaNeBxNF4g.SxrxN9sVrEP2JPfmI6D--NJBQBsOcHFHwt5rz_Ph0UYg.JPEG%2Fupload_f5ec1fef7fa58bdd110ed6d26b41e92f.jpeg" alt="사진" width="100%" height="auto" id="visitor_2">
                                </a></div>

                                <div data-grid-groupkey="0" class="_21zjL" style="position: absolute; top: 400px; left: 0.5px;">
                                    <a href="#" target="_self" role="button" class="place_thumb">
                                        <img src="https://search.pstatic.net/common/?autoRotate=true&amp;type=w560_sharpen&amp;src=https%3A%2F%2Fpup-review-phinf.pstatic.net%2FMjAyMjA3MTZfMTAg%2FMDAxNjU3OTQwOTM4ODgz.APMvsfeWqrb2rLbNpDVndeqhDzm3c71EF9zGQdjOe2gg.dhs_wRvHG9EJM85Z6pWCDbJelraMAj5ksCu5xE1X1mkg.JPEG%2Fupload_9a54a039c73e5778a672266e414a40a4.jpg" alt="사진" width="100%" height="auto" id="visitor_3">
                                </a></div>

                                <div data-grid-groupkey="0" class="_21zjL" style="position: absolute; top: 399px; left: 304.5px;">
                                    <a href="#" target="_self" role="button" class="place_thumb">
                                        <img src="https://search.pstatic.net/common/?autoRotate=true&amp;type=w560_sharpen&amp;src=https%3A%2F%2Fpup-review-phinf.pstatic.net%2FMjAyMjA3MTZfMjky%2FMDAxNjU3OTQwOTQ2MzAz.CbFRiNhFY6Of53-HriV0KUCQSjXkGRMnAgrbPr0WxLIg.YBClQ2o1jqXSaP29AfKy0M84o5Vl80hdWu-1PXS80cAg.JPEG%2Fupload_0e54458f9b0b7476b62c6756187a6659.jpg" alt="사진" width="100%" height="auto" id="visitor_4">
                                </a></div>

                                <div data-grid-groupkey="0" class="_21zjL" style="position: absolute; top: 702px; left: 0.5px;">
                                    <a href="#" target="_self" role="button" class="place_thumb">
                                        <img src="https://search.pstatic.net/common/?autoRotate=true&amp;type=w560_sharpen&amp;src=http%3A%2F%2Fblogfiles.naver.net%2FMjAxODA2MDlfMjA1%2FMDAxNTI4NTE3MjEyOTUz.1fi7JXtpQbfn4uFnbyxk6iYmqbvokfGhpW2xFkRePWQg.OQ5-ctlZxZX3tFvXs5GHLAvsAEEOlW6AteF0eF7T2wUg.JPEG.lja1918%2FIMG_5291.jpg" alt="사진" width="100%" height="auto" id="ugc_6">
                                </a></div>

                                <div data-grid-groupkey="0" class="_21zjL" style="position: absolute;top: 629px;left: 304.5px;">
                                    <a href="#" target="_self" role="button" class="place_thumb">
                                        <img src="https://search.pstatic.net/common/?autoRotate=true&amp;type=w560_sharpen&amp;src=http%3A%2F%2Fblogfiles.naver.net%2FMjAxODA4MTBfMjQ3%2FMDAxNTMzOTA1MDc4Nzg3.8Eq42gZEOWTS9KCSK1JqIN13jk0hrEz6NRh68N63cl8g.c-wLtjkewJMVZmyCOs8g7lms44z8TrOXBB_fPoGWa9wg.PNG.myhearts16%2F%25B9%25D9%25B3%25AA%25B3%25AA_%25B5%25B7%25B1%25EE%25BD%25BA.png" alt="사진" width="100%" height="auto" id="ugc_5">
                                </a></div>

                                <div data-grid-groupkey="0" class="_21zjL" style="position: absolute; top: 702px; left: 0.5px;">
                                    <a href="#" target="_self" role="button" class="place_thumb">
                                        <img src="https://search.pstatic.net/common/?autoRotate=true&amp;type=w560_sharpen&amp;src=https%3A%2F%2Fpup-review-phinf.pstatic.net%2FMjAyMjA2MjZfMTQ5%2FMDAxNjU2MjMyODIyODM1.awSLcPSKytTWlwUVUinYBnFLgIQPvJ8aiH1u63IWuPYg.h19X9otJ-gAmOSLOn-X6YBGFQ9tIuAnJWo_3BQRcm6Qg.JPEG%2Fupload_f2be1cbdd31be6720171848764e2b57e.jpeg" alt="사진" width="100%" height="auto" id="visitor_8">
                                </a></div>

                                <div data-grid-groupkey="0" class="_21zjL" style="position: absolute; top: 702px; left: 304.5px;">
                                    <a href="#" target="_self" role="button" class="place_thumb">
                                        <img src="https://search.pstatic.net/common/?autoRotate=true&amp;type=w560_sharpen&amp;src=https%3A%2F%2Fpup-review-phinf.pstatic.net%2FMjAyMjA2MTJfMjMw%2FMDAxNjU1MDA0MDE4MjU5.uo8OiDA5yNyvZm3cCxkOHeKwE3Pi9a5FiQTe2KCxYwkg.0FdwNRd8eItzKLZgM8fC_MWNI4zZoh0mqcDmYKqREdAg.JPEG%2Fupload_f9d97d76ff7198b32bcda3b238d6bee0.jpeg" alt="사진" width="100%" height="auto" id="visitor_9">
                                </a></div>

                                <div data-grid-groupkey="0" class="_21zjL" style="position: absolute; top: 1003px; left: 0.5px;">
                                    <a href="#" target="_self" role="button" class="place_thumb">
                                        <img src="https://search.pstatic.net/common/?autoRotate=true&amp;type=w560_sharpen&amp;src=https%3A%2F%2Fpup-review-phinf.pstatic.net%2FMjAyMjA2MDhfMjI3%2FMDAxNjU0Njg2MzUwNjUx.y0nmgchjC9z9dcP0bkqT4Tjt6yD2RbSF8s9ED6iPsbAg.IMljEST0deoG6dtvgQ97nw1IAVFYKooAMqaCeLLB8H4g.JPEG%2Fupload_73d9371a150e5ea954a09badba30f3cf.jpeg" alt="사진" width="100%" height="auto" id="visitor_10">
                                </a></div>

                                <div data-grid-groupkey="0" class="_21zjL" style="position: absolute; top: 1104px; left: 304.5px;">
                                    <a href="#" target="_self" role="button" class="place_thumb">
                                        <img src="https://search.pstatic.net/common/?autoRotate=true&amp;type=w560_sharpen&amp;src=http%3A%2F%2Fblogfiles.naver.net%2FMjAxODA4MTJfNDgg%2FMDAxNTM0MDU3NzQ4Mjcw.kDb410rkRvYywZN5ISV0plpPm_PcJ281I7IAxGYflygg.lUtNlZqhTT-zvqIbJSKATMKWIdtIOPEN8BeL2YIiyFUg.JPEG.wldnjsshfkd3%2F1534057746523.jpg" alt="사진" width="100%" height="auto" id="ugc_12">
                                </a></div>
                        -->

                           </div><!-- 사진 relative용-->
                        </div><!-- itemBox-->
                    </div><!-- width 50%용-->
                    <div class="maps" style="width:50%;">
				<div id="map" style="width:100%;height:450px;"></div>
			</div>
		</div><!-- tblWrap -->
	</div>
<!-- footer 
<footer>

</footer>
 -->
</body>
<script type="text/javascript">
$(function() {
	initMap();
})

function initMap() {
	var map = new naver.maps.Map('map', {
	    center: new naver.maps.LatLng(<%=latitude %>, <%=longitude %>),
	    zoom: 17
	});
	
	var marker = new naver.maps.Marker({
	   	position: new naver.maps.LatLng(<%=latitude %>, <%=longitude %>),
	   	map: map
	});
	
	var infoWindow = new naver.maps.InfoWindow({
    	content: '<div class=\"iw_inner\"><div class=\"div_font\"style=\"font-size:13px;font-weight:600;text-align:center;padding:10px;color:#ffffff;\"><b><%= rname%></b></div></div>',
	    	borderWidth: 0,
	    	disableAnchor: true,
	    	backgroundColor: 'transparent'
    });
	
	infoWindow.open(map, marker);
}
</script>
</html>