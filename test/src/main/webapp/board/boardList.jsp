<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
  /**
  * Description : 게시글 리스트
  * 작성일 : 2024.03.06
  * 작성자 : ljs
  */
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title><spring:message code="title.sample" /></title>
    <link type="text/css" rel="stylesheet" href="<c:url value='/css/egovframework/styles.css'/>"/>
    <script type="text/javaScript" language="javascript" defer="defer">
    
    	/* 글 상세보기 화면 function */
    	function fn_egov_select(bbrdLst) {
    		document.listForm.selectedId.value = bbrdLst;
    		console.log(bbrdLst);
    		document.listForm.action = "<c:url value='/board/boardView.do'/>";
           	document.listForm.submit();
    	}
    
        /* 글 등록 화면 function */
        function fn_egov_addView() {
           	document.listForm.action = "<c:url value='/boardWrite.do'/>";
           	document.listForm.submit();
        }
        
        /* pagination 페이지 링크 function */
        function fn_egov_link_page(pageNo){
        	document.listForm.pageIndex.value = pageNo;
        	document.listForm.action = "<c:url value='/board/boardList.do'/>";
           	document.listForm.submit();
        }

    </script>
</head>

<body>
	<!-- 네비게이션 바 -->
	<div>
			<jsp:include page="navbar.jsp"></jsp:include>
	</div>
			<div id="UND_DV"></div>
    <form:form commandName="searchVO" id="listForm" name="listForm" method="post">
        <input type="hidden" name="selectedId" />
        <div id="content_pop">
        	
        	<!-- List -->
        	<div id="table">
        		<table width="100%" border="0" cellpadding="0" cellspacing="0" summary="카테고리ID, 케테고리명, 사용여부, Description, 등록자 표시하는 테이블">
        			<caption style="visibility:hidden">카테고리ID, 케테고리명, 사용여부, Description, 등록자 표시하는 테이블</caption>
        			<colgroup>
        				<col width="40"/>
        				<col width="120"/>
        				<col width="*"/>
        				<col width="120"/>
        				<col width="50"/>
        			</colgroup>
        			<tr>
        				<th align="right">No</th>
        				<th align="right"><spring:message code="title.sample.writer" /></th>
        				<th align="center"><spring:message code="title.sample.title" /></th>
        				<th align="right"><spring:message code="title.sample.date" /></th>
        				<th align="center"><spring:message code="title.sample.view" /></th>
        			</tr>
        			<c:forEach var="result" items="${resultList}" varStatus="status">
        				<c:if test="${result.bbrdYn == null}">
            			<tr>
            				<td align="left" class="listtd"><c:out value="${paginationInfo.totalRecordCount+1 - ((searchVO.pageIndex-1) * searchVO.pageSize + status.count)}"/></td>
            				<td align="left" class="listtd"><c:out value="${result.bbrdWrter}"/>&nbsp;</td>
            				<td align="left" class="listtd"><a href="javascript:fn_egov_select('<c:out value="${result.bbrdLst}"/>')"><c:out value="${result.bbrdTtl}"/></a></td>
            				<td align="left" class="listtd"><c:out value="${result.bbrdWrDate}"/>&nbsp;</td>
            				<td align="center" class="listtd"><c:out value="${result.bbrdVew}"/>&nbsp;</td>
            			</tr>
            			</c:if>
        			</c:forEach>
        		</table>
        	</div>
        	<div align="right" class="goWr">
        		<button type="button" class="write" onclick="location.href='/test/board/boardWrite.do';">글 쓰 기</button>
        	</div>
        	<!-- /List -->
        	<div id="paging" align="center">
        		<ui:pagination paginationInfo = "${paginationInfo}" type="image" jsFunction="fn_egov_link_page" />
        		<form:hidden path="pageIndex" />
        	</div>
        	
        	<!-- // 타이틀 -->
			<div id="search">
			    <table align="center">
			        <tr>
			            <td>
			                <label for="searchCondition" style="visibility:hidden;"><spring:message code="search.choose" /></label>
			                <form:select path="searchCondition" cssClass="use">
			                    <form:option value="2" label="제목" />
			                    <form:option value="1" label="내용" />
			                    <form:option value="0" label="글쓴이" />
			                </form:select>
			            </td>
			            <td>
			                <label for="searchKeyword" style="visibility:hidden;display:none;"><spring:message code="search.keyword" /></label>
			                <form:input path="searchKeyword" cssClass="txt"/>
			            </td>
			            <td>
			                <button type="submit" class="searchB"><spring:message code="button.search" /></button>
			            </td>
			        </tr>
			    </table>
			</div>
        	
        </div>
    </form:form>
</body>
</html>
