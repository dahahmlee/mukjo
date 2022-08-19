<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.example.model1.FoodTO"%>
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

	String tseq = request.getParameter("tseq");
	
	ArrayList<FoodTO> lists = (ArrayList<FoodTO>)request.getAttribute("lists");
	
	StringBuilder sbHtml = new StringBuilder();
	StringBuilder mHtml = new StringBuilder();
	
	String name = "";
	String longitude = "";
	String latitude = "";
	
	mHtml.append( "var loc = [" );
	
	for(FoodTO to : lists) {
		String id = to.getId().replaceAll("[^0-9]", "");
		name = to.getName();
		String category = to.getCategory();
		longitude = to.getLongitude();
		latitude = to.getLatitude();
		String thumurl = to.getThumurl();
		
		sbHtml.append( "<div class='lists1'>" );
    	sbHtml.append( "<a href='./somoimboard_home.do?tseq=" + tseq + "&id=" + id + "&longitude=" + longitude + "&latitude=" + latitude + "'><img class='list1' style=\"background-image: url('" + thumurl + "');\">");
    	sbHtml.append( "<span class='write1'>"+name+"</span>" );
    	sbHtml.append( "<span class='write2'>"+category+"</span>" );
    	sbHtml.append( "<span class='write3'><i class='fa fa-star' style='font-size:20px;color:red'></i>    4.8점</span>" );
    	sbHtml.append( "</a>" );
    	sbHtml.append( "</div>" );
    	
    	mHtml.append( "{ Name: \""+name+"\", " );
    	mHtml.append( "Lat: \""+latitude+"\", " );
    	mHtml.append( "Lng: \""+longitude+"\" }," );
	}
	mHtml.deleteCharAt(mHtml.length() - 1);
	mHtml.append( "]" );
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>식당검색</title>
<style href="css/common.css"></style>
<!-- 나눔스퀘어 폰트 -->
<link href="https://hangeul.pstatic.net/hangeul_static/css/nanum-square.css" rel="stylesheet">
<!-- 부트스트랩 -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<!-- 지도 -->
<script type="text/javascript" src="https://openapi.map.naver.com/openapi/v3/maps.js?ncpClientId=f8b62z9xjz&amp;submodules=geocoder"></script>
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<style>
/** common **/

a:link {  color : black; text-decoration: none}
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


#btnSec .search-wrap{
    right: 0;
    font-size: 0; 
    margin-bottom : 8px;
    margin-left : 150px;
}

.search-wrap .input{
    width: 282px;
    height: 36px;
    box-sizing: border-box;
    -webkit-border-radius: 24px;
    -moz-border-radius: 24px;
    border-radius: 24px;
    border: 2px solid #5c3018;
    display: inline-block;
    overflow: hidden;
    vertical-align: top;
    position: relative;
    padding-left: 14px;
    padding-right: 42px;
    margin-left: 10px;
}

.search-wrap .input input{
    height: 32px;
    width: 100%;
    color: #000;
    font-size: 16px;
    box-sizing: border-box;
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
#tblWrap{
    display: flex;
    overflow: hidden;
    border-top: 1px solid;
    border-color: #ecf0f2;
    border-color: rgba(var(--place-color-border2), 1);
}

.scrollbar{
    height:450px;
    overflow: hidden;
    overflow-y: auto;
}


.scrollbar li{
    display: list-item;
    text-align: -webkit-match-parent;
    position: relative;
    margin-top: 20px;
    margin-left : 30px;
}

.scrollbar li a{
    overflow: hidden;
    flex: 1;
}

.list1{
    width: 150px; height: 150px;
    background-repeat: no-repeat; background-position: 50% 50%; background-size: cover;
    margin-right: 35px;
}
.lists1{
    position: relative;
    margin-top: 30px;
}

.scrollbar .write1{
    position: absolute;
    font-size: 1.3rem;
    font-weight: 700;
    letter-spacing: -1px;
    color : #0068c3;
    bottom: 105px;
}

.scrollbar .write1::before{
    width: 200px;
    position: absolute;
    right: -2px;
    bottom: 0;
    left: -2px;
    height: 11px;
    top: 47px;
    border-radius: 6px;
    background: rgba(43,152,235,.1);
    content: "";
}

.write2{
    color:#0068c3;
    margin-top : 55px;
    position: absolute;
    
}
.write3{
    position: absolute;
    top: 120px;
    color: #de5f47;
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
			<h3><%=welcome %><a href="logoutok.do" id="logout" style="color : gray"><br/><%=log %></a></h3>
	
			<ul>
				<li><b><a href="myPage.do">마이페이지</a></b></li>
				<li><b><a href="boss.do">소모임장페이지</a></b></li>
				<li><b><a href="admin.do">관리자페이지</a></b></li>
				<li><b><a href="favorite.do">즐겨찾기</a></b></li>
				<li id="bell"><a href="#"><b><img src="images/bell.png"></b></a>1</li>
			</ul>
		</div> <!--headerWap-->
	
		<!--locationSec -->
		<section id="locationSec">
			<div id = "locationwrap">
				<button class="active"><a href="somoimboard.do?tseq=" + <%=tseq %>>게시판</a></button>
				<button class="allbtn"><a href="somoimboard_search.do" style="color : #de5f47">식당검색</a></button>
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
		<section id ="btnSec" >
			<div class="search-wrap">  
				<form class="input" action="/somoimboard_search.do" method="post" name="sfrm">
					<input type="text" title="검색어 입력" name="search" placeholder="식당/지역 검색" />
					<button type="submit">검색</button>
				</form><!-- input -->
			</div><!-- search-wrap -->
		</section>
		<!-- 테이블 목록이 있는 섹션입니다 -->
		<div id="tblWrap" style= "display: flex; justify-content: space-around;">
			<div class="scrollwrap" style="width: 50%;">
				<div class="scrollbar" >
					<ul>
						<li>
						<%=sbHtml.toString() %>
						<!-- 
							<div class="lists1">
								<a href="./somoimboard_home.do"><img class="list1" style="background-image: url('https://search.pstatic.net/common/?autoRotate=true&type=w278_sharpen&src=https%3A%2F%2Fsearchad-phinf.pstatic.net%2FMjAyMjA0MThfMTYx%2FMDAxNjUwMjc2MTI4OTEz.Iwfc3HzhfZYcIfdtiWx7f4L1x9lOoGg1EUKGy2ZCxAwg.2S0g3cV4uNkldREs__6NEt5ChSUE2EOOV4EwCxJRtv8g.PNG%2F2355050-adba00da-0fad-4f6d-8d3d-9ade8109773c.png');">
									<span class="write1">경양가츠 강남점</span>
									<span class="write2">줄서서 먹는 돈까스맛집</span>
									<span class="write3"><i class="fa fa-star" style="font-size:20px;color:red"></i>    4.8점</span>
								</a>
							</div>
							<div class="lists1">
								<a href="./somoimboard_home.do"><img class="list1" style="background-image: url('https://search.pstatic.net/common/?autoRotate=true&type=w278_sharpen&src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20220427_237%2F165102764126107Ghf_JPEG%2F1.jpg');">
									<span class="write1">을지다락 강남</span>
									<span class="write2">깔끔한 분위기의 파스타</span>
									<span class="write3"><i class="fa fa-star" style="font-size:20px;color:red"></i>    4.9점</span>
								</a>
							</div>
							<div class="lists1">
								<a href="./somoimboard_home.do"><img class="list1" style="background-image: url('https://search.pstatic.net/common/?autoRotate=true&type=w278_sharpen&src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20161112_233%2F147894152004419V1R_PNG%2F177062583539881_0.png');">
									<span class="write1">장인닭갈비 강남점</span>
									<span class="write2">순수 모짜렐라 치즈를 사용한 닭갈비</span>
									<span class="write3"><i class="fa fa-star" style="font-size:20px;color:red"></i>    4.5점</span>
								</a>
							</div>
							 -->
						</li>
					</ul>
				</div><!--scrollbar-->
			</div><!-- scrollwrap -->
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
	let markers = [];
	let infoWindows = [];

	<%=mHtml.toString() %>
	var map = new naver.maps.Map('map', {
	    center: new naver.maps.LatLng(loc[0].Lat, loc[0].Lng),
	    zoom: 16
	});
	
	for(var i in loc) {
		var marker = new naver.maps.Marker({
	    	position: new naver.maps.LatLng(loc[i].Lat, loc[i].Lng),
	    	map: map
	    });

	    var infoWindow = new naver.maps.InfoWindow({
	    	content: '<div style=\"width:150px;text-align:center;padding:10px;\"><b>' + loc[i].Name + '</b></div>'
	    });
	}
    
	markers.push(marker);
	infoWindows.push(infoWindow);
	
	naver.maps.Event.addListener(map, 'idle', function() {
	    updateMarkers(map, markers);
	});

	function updateMarkers(map, markers) {
	    var mapBounds = map.getBounds();
	    var marker, position;

	    for (var i = 0 ; i < markers.length ; i++) {
	        marker = markers[i]
	        position = marker.getPosition();

	        if (mapBounds.hasLatLng(position)) {
	            showMarker(map, marker);
	        } else {
	            hideMarker(map, marker);
	        }
	    }
	}

	function showMarker(map, marker) {
	    if (marker.setMap()) return;
	    marker.setMap(map);
	}

	function hideMarker(map, marker) {
	    if (!marker.setMap()) return;
	    marker.setMap(null);
	}

	// 해당 마커의 인덱스를 seq라는 클로저 변수로 저장하는 이벤트 핸들러를 반환합니다.
	function getClickHandler(seq) {
	    return function(e) {
	        var marker = markers[seq],
	            infoWindow = infoWindows[seq];

	        if (infoWindow.getMap()) {
	            infoWindow.close();
	        } else {
	            infoWindow.open(map, marker);
	        }
	    }
	}

	for (var i=0 ; i<markers.length ; i++) {
	    naver.maps.Event.addListener(markers[i], 'click', getClickHandler(i));
	}
}
</script>
</html>