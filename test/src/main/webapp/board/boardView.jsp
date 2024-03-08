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
    <link type="text/css" rel="stylesheet" href="<c:url value='../css/styles.css'/>"/>
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
			<table class="table"
				style="text-align: left; border: 1px solid #dddddd">
				<colgroup>
					<col width="10%" />
					<col width="*" />
				</colgroup>

				<!-- 게시글 제목 -->
				<tr>
					<td>제목</td>
					<td colspan="3">${ dto.ttl }</td>
				</tr>
				<!-- 첨부파일 -->
				<tr>
					<td>첨부파일</td>
					<td>
						<c:if test="${ not empty dto.file_nm }">
						<a href="../board/download?filename=${ dto.file_nm }&idx=${ dto.lst }">${ dto.file_nm }</a>
						</c:if>
					</td>
				</tr>
				<!-- 게시글 내용 -->
				<tr>
					<td>내용</td>
					<td colspan="5" height="100">
					<br />${ dto.cntns }</td>
				</tr>
				
				<!-- 하단 메뉴(버튼) -->
				<tr>
					<td colspan="4" align="center">
						<button type="button" id="editBtn" class="ViewButton">수 정</button>
						<button type="button" class="List" onclick="location.href='../board/list';">목 록</button>
						<button type="button" id="delBtn" class="ViewButton" onclick="removeCheck();">삭 제</button>
					</td>
				</tr>
			</table>

			<form name="commentForm" id="commentForm" method="post"
				action="../board/CommWrite.do">
				<table class="table table-striped"
					style="text-align: center; border: 1px solid #dddddd; width: 100%;">
					<%-- 홀,짝 행 구분 --%>
					<thead>
						<tr>
							<th colspan="3"
								style="background-color: #eeeeeee; text-align: center;">댓글</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td style="text-align: left;"></td>
							<td style="text-align: right;">
							<a
								href="javascript:setEditMode('');"
								class="btn">수정</a> <a
								href="../board/CommEdit.do?action=delete&commNum="
								class="btn">삭제</a></td>
						</tr>
					</tbody>
				</table>
			</form>
		</div>
	</div>
<script>
    var ttl = "${dto.ttl}";
    var cntns = "${dto.cntns}";
    
    $('#editBtn').on("click", (e) => {
        password = prompt("게시글 수정을 위한 비밀번호를 입력하세요.");
        if (password != null) {
            $.ajax({
                type: 'post',
                url: 'http://localhost:8080/Nado/board/password',
                dataType: 'text',
                data: {
                    lst: ${param.lst},
                    ttl: ttl,
                    cntns: cntns,
                    pwd: password
                },
                success: function(data, textStatus) {
                	var responseData = JSON.parse(data); // JSON 문자열을 객체로 변환
                	let url = '../board/edit?lst=${param.lst}'
                    if (responseData.check === 0) {    //비밀번호 불일치
                        console.log("check의 값은 : " + responseData.check);
                        alert("비밀번호 불일치!"); 
                    } else {    //비밀번호 일치
                        console.log("check의 값은 : " + responseData.check);
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
                url: 'http://localhost:8080/Nado/board/password',
                dataType: 'text',
                data: {
                    lst: ${param.lst},
                    ttl: ttl,
                    cntns: cntns,
                    pwd: password
                },
                success: function(data, textStatus) {
                	var responseData = JSON.parse(data); // JSON 문자열을 객체로 변환
                	let url = '../board/delete?lst=${param.lst}'
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