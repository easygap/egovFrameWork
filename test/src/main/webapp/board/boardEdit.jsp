<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"         uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"      uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@ taglib prefix="spring"    uri="http://www.springframework.org/tags"%>
<%
  /**
  * Description : 게시글 수정
  * 작성일 : 2024.03.12
  * 작성자 : ljs
  */
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><spring:message code="title.sample" /></title>
<link type="text/css" rel="stylesheet" href="<c:url value='/css/egovframework/styles.css'/>"/>
<script type="text/javascript" src="<c:url value='/cmmn/validator.do'/>"></script>
<validator:javascript formName="sampleVO" staticJavascript="false" xhtml="true" cdata="false"/>
<script>
function validateForm() {
    var form = document.getElementById("form"); // 폼 요소 가져오기

    var ttlCheck = /^[a-zA-Z0-9가-힣!@#$%^&*()\s]{1,30}$/;
    var cntnsCheck = /^[a-zA-Z0-9가-힣!@#$%^&*()\s\n]{1,1000}$/;
    var pwdCheck = /^(?=.*[!@#$%^&*()])[a-zA-Z0-9가-힣!@#$%^&*()]{1,30}$/;

    // 폼 요소가 정상적으로 가져와졌는지 확인
    if (!form) {
        console.error("폼 요소를 찾을 수 없습니다.");
        return false;
    }

    var title = form.elements["title"].value;    //폼 필드값 가져오기
    var content = form.elements["contents"].value;
    var password = form.elements["password"].value;

    if (!ttlCheck.test(title)) {
        alert("제목은 1~30자 까지 입력 가능합니다.");
    } else if (!cntnsCheck.test(content)) {
        alert("내용은 1~1000자 까지 입력 가능합니다.");
    } else if (!pwdCheck.test(password)) {
        alert("비밀번호는 특수문자를 반드시 포함한 1~20자 이어야 합니다.");
    } else {
        var num = document.getElementById("num").value;
        var url = "/test/board/boardEdit.do?num=" + num;
        form.action = url;
        form.submit(); // 폼 제출
    }

}

</script>
</head>
<body>
	<!-- 네비게이션 바 -->
	<div>
			<jsp:include page="navbar.jsp"></jsp:include>
	</div>
			<div id="page-content-wrapper">

			<div class="container-fluid">
				<div id="UND_DV"></div>
		<form:form commandName="sampleVO" name="writeFrm" id="form" onsubmit="return validateForm(this);">
		<table class="table" border="1" width="90%">
			<tr>
				<td>작성자</td>
				<td colspan="3"><c:out value="${sampleVO.writer}"/></td>
			</tr>
			<tr>
				<td>제목</td>
				<td><form:input path="title" type="text" style="width:1100px; display: inline-block;" maxlength="30" class="form-control" name="ttl" id="title" placeholder="30자 이하로 입력."
					value="${sampleVO.title}" /><form:errors path="title" /></td>
			</tr>
			<tr>
				<td>내용</td>
				<td><form:textarea path="contents" rows="11" cssClass="form-control" maxlength="1000" id="contents" placeholder="내용을 1000자 이하로 입력"/>
				<form:errors path="contents" />
				</td>
			</tr>
			<tr>
				<td>비밀번호</td>
				<td><form:input path="password" type="password" style="width:300px;" class="form-control" name="pwd" id="password" maxlength="20" placeholder="특수문자를 포함한 20자 이하로 입력." value="0000"/><form:errors path="password" /></td>
			</tr>
			<tr>
				<td colspan="2" align="center">
				<button type="button" class="ViewButton"
						onclick="location.href='../board/boardList.do';">목 록</button>
					<button type="submit" class="ViewButton">수 정</button>
				</td>
			</tr>
		</table>
	</form:form>
	</div>
	</div>
</body>
</html>