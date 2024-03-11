<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"         uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"      uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@ taglib prefix="spring"    uri="http://www.springframework.org/tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>게시판 게시글 상세보기</title>
	<!-- css 양식 가져오기 -->
    <link type="text/css" rel="stylesheet" href="<c:url value='/css/egovframework/styles.css'/>"/>
    <script type="text/javascript" src="<c:url value='/cmmn/validator.do'/>"></script>
    <validator:javascript formName="sampleVO" staticJavascript="false" xhtml="true" cdata="false"/>
</head>
<body>
		<!-- 네비게이션 바 -->
		<div>
		<jsp:include page="navbar.jsp"></jsp:include>
		</div>
		<div id="page-content-wrapper">

		<div class="container-fluid">
		<div id="UND_DV"></div>
			
			<!-- Board_view.jsp 코드 시작 -->
			<form:form commandName="sampleVO" id="detailForm" name="detailForm">
			<table class="table"
				style="text-align: left; border: 1px solid #dddddd">
				<colgroup>
					<col width="10%" />
					<col width="*" />
				</colgroup>
				<!-- 게시글 작성자 -->
				<tr>
					<td>작성자</td>
					<td colspan="3"><c:out value="${sampleVO.writer}"/></td>
				</tr>

				<!-- 게시글 제목 -->
				<tr>
					<td>제목</td>
					<td colspan="3"><c:out value="${sampleVO.title}"/></td>
				</tr>
				<!-- 게시글 내용 -->
				<tr>
					<td>내용</td>
					<td colspan="5" height="100">
					<br /><c:out value="${sampleVO.contents}"/></td>
				</tr>
				
				<!-- 하단 메뉴(버튼) -->
				<tr>
					<td colspan="4" align="center">
						<button type="button" id="editBtn" class="ViewButton">수 정</button>
						<button type="button" class="List" onclick="location.href='../board/boardList.do';">목 록</button>
						<button type="button" id="delBtn" class="ViewButton" onclick="removeCheck();">삭 제</button>
					</td>
				</tr>
			</table>
			</form:form>
		</div>
	</div>
<script>
	var num = "${sampleVO.num}";
	
	$('#editBtn').on("click", (e) => {
	    password = prompt("게시글 수정을 위한 비밀번호를 입력하세요.");
	    if (password != null) {
	        $.ajax({
	            anyne:true,
	            type: 'post',
	            url: 'http://localhost:8080/test/board/checkPassword.do',
	            dataType: 'text',
	            data: {
	                "num" : num,
	                "password" : password
	            },
	            success: function(data) {
	                let url = '../board/edit?lst=${param.num}'
	                if (data === 0) {    //비밀번호 불일치
	                    console.log("check의 값은 : " + data);
	                    alert("비밀번호 불일치!"); 
	                } else {    //비밀번호 일치
	                    console.log("check의 값은 : " + data);
	                    alert("비밀번호 일치! 게시글 수정 페이지로 이동합니다.");
	                    location.replace(url);
	                }
	            },
	            error: function(data, textStatus) {
	                console.log('전체 데이터:', data);
	                console.log('check의 값은 : ' + data.check);
	                console.log('error');
	            }
	        })
	    }
	});

    
    $('#delBtn').on("click", (e) => {
        password = prompt("게시글 삭제를 위한 비밀번호를 입력하세요.");
        if (password != null) {
            $.ajax({
                type: 'post',
                url: 'http://localhost:8080/test/board/checkPassword.do',
                dataType: 'text',
                data: {
                    lst: lst,
                    ttl: ttl,
                    cntns: cntns,
                    pwd: password
                },
                success: function(data, textStatus) {
                	var responseData = JSON.parse(data); // JSON 문자열을 객체로 변환
                	let url = '../board/delete?num=${param.num}'
                    if (responseData.check === 0) {    //비밀번호 불일치
                        console.log("check의 값은 : " + responseData.check);
                        alert("비밀번호 불일치!"); 
                    } else {    //비밀번호 일치
                    	console.log("check의 값은 : " + responseData.check);
                    	if (confirm("정말 삭제하시겠습니까?") == true) {    //비밀번호 일치 시 게시글 삭제 여부 확인
                    		location.replace(url);
                            } else {
                                return;
                        }                        
                    }
                },
                error: function(data, textStatus) {
                	console.log('전체 데이터:', data);
                    console.log('check의 값은 : ' + data.check);
                    console.log('error');
                }
            })
        }
    });
</script>
</body>
</html>