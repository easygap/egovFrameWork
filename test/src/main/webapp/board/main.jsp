<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
  /**
  * Description : 메인페이지
  * 작성일 : 2024.03.05
  * 작성자 : ljs
  */
%>
<!DOCTYPE html>
<html>
<!-- 네비게이션 바 -->
<div>
		<jsp:include page="navbar.jsp"></jsp:include>
<div id="mainDiv">	
	<a href="/test/board/main.jsp"> <img src="../images/egovframework/logo.png"
		id="logo2Img" alt="nadoIMG">
	</a>
</div>
<div id="btnDiv">
		<a href="/test/board/boardList.do">
			<button type="button" class="mainBtn">커뮤니티</button>
		</a>
</div>
</div>
</html>