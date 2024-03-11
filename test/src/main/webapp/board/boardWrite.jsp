<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"         uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"      uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@ taglib prefix="spring"    uri="http://www.springframework.org/tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>게시판 글쓰기</title>
	<!-- css 양식 가져오기 -->
    <link type="text/css" rel="stylesheet" href="<c:url value='../css/styles.css'/>"/>
    <script type="text/javascript" src="<c:url value='/cmmn/validator.do'/>"></script>
    <validator:javascript formName="sampleVO" staticJavascript="false" xhtml="true" cdata="false"/>
<script>
function validateForm() {
    var form = document.getElementById("form"); // 폼 요소 가져오기

    var nmCheck = /^[a-zA-Z0-9가-힣]{1,30}$/;
    var ttlCheck = /^[a-zA-Z0-9가-힣!@#$%^&*()\s]{1,30}$/;
    var cntnsCheck = /^[a-zA-Z0-9가-힣!@#$%^&*()\s\n]{1,1000}$/;
    var pwdCheck = /^(?=.*[!@#$%^&*()])[a-zA-Z0-9가-힣!@#$%^&*()]{1,30}$/;

    // 폼 요소가 정상적으로 가져와졌는지 확인
    if (!form) {
        console.error("폼 요소를 찾을 수 없습니다.");
        return false;
    }

    var name = form.elements["writer"].value; // 폼 필드 값 가져오기
    var title = form.elements["title"].value;
    var content = form.elements["contents"].value; // 수정된 부분: "cntns"에서 "contents"로 변경
    var password = form.elements["password"].value;

    if (!nmCheck.test(name)) {
        alert("닉네임은 띄어쓰기 & 특수문자 제외, 1~30자 까지 입력 가능합니다.");
    } else if (!ttlCheck.test(title)) {
        alert("제목은 1~30자 까지 입력 가능합니다.");
    } else if (!cntnsCheck.test(content)) {
        alert("내용은 1~1000자 까지 입력 가능합니다.");
    } else if (!pwdCheck.test(password)) {
        alert("비밀번호는 특수문자를 반드시 포함한 1~20자 이어야 합니다.");
    } else {
        form.action = "<c:url value='/board/boardWrite.do'/>";
        form.submit();
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

					<div class="mb-3">
    					<label for="writer" style="display: inline-block;"><spring:message code="title.sample.writer" /></label>
    					<form:input path="writer" type="text" style="width:400px; display: inline-block;" maxlength="10" class="form-control" name="nm" id="writer" placeholder="10자 이하로 입력."/><form:errors path="writer" />
    					<label for="title" style="display: inline-block;"><spring:message code="title.sample.title" /></label>
    					<form:input path="title" type="text" style="width:1100px; display: inline-block;" maxlength="30" class="form-control" name="ttl" id="title" placeholder="30자 이하로 입력."/><form:errors path="title" />
					</div>

					<div class="mb-3">
					    <label for="content"><spring:message code="title.sample.contents" /></label>
					    <form:textarea path="contents" rows="11" cssClass="form-control" maxlength="1000" id="content" placeholder="내용을 1000자 이하로 입력"/><form:errors path="contents" />
					</div>
					
					<div class="mb-3">
							<label for="password"><spring:message code="title.sample.password" /></label> <form:input path="password" type="password"
							style="width:300px;" class="form-control" name="pwd" id="password"
							maxlength="20" placeholder="특수문자를 포함한 20자 이하로 입력."/><form:errors path="password" />
					</div>
					
					<div class="mybtn">
						<input
							type="button" onclick="location.href='../board/list';"
							class="List" value="취 소"/>
						<input type="button" class="write" onclick="validateForm();"
							value="등 록"/>
					</div>
				</form:form>
			</div>
		</div>
</body>
</html>