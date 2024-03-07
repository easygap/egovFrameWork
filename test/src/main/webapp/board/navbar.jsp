<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
    <!-- BootStrap css 사용 -->
	<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css"
	rel="stylesheet"
	integrity="sha384-4bw+/aepP/YC94hEpVNVgiZdgIC5+VKNBQNGCHeKRQN+PtmoHDEXuppvnDJzQIu9"
	crossorigin="anonymous">
        <title>navigation bar</title>
    <!-- css 양식 가져오기 -->
    <link href="../css/egovframework/styles.css" rel="stylesheet" />

    </head>

    <body id="navbar">

    <div class="d-flex" id="wrapper">

        <!-- Page Content -->
        <div id="page-content-wrapper">
            <nav class="navbar navbar-expand-lg navbar-light bg-light bg-primary border-bottom" style="background-color: #112D4E !important;">
                <div class="collapse navbar-collapse" id="navbarSupportedContent">
                    <ul class="navbar-nav">
                        <li class="nav-item active">
                            <a href="/test/board/main.jsp">
                                <img src="../images/egovframework/logo.png" style="width:10em" alt="로고">
                            </a>
                        </li>
                        <li class="nav-item active">
                            <!-- 커뮤니티 -->
                            <a href="/test/board/boardList.do">
                            	<img src="../images/egovframework/Community.png" alt="로고" style="margin-left:5em; width:6em;">
                            </a>
                        </li>
                    </ul>
                </div>
            </nav>

        </div>

    </div>
    
    <!-- Jquery 사용 -->
	<script src="https://code.jquery.com/jquery-3.7.1.min.js" integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=" crossorigin="anonymous"></script>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
        <meta name="description" content="" />
        <meta name="author" content="" />
	<!-- BootStrap javascript 사용 -->
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js"
		integrity="sha384-HwwvtgBNo3bZJJLYd8oVXjrBZt8cqVSpeBNS5n7C8IVInixGAoxmnlMuBnhbgrkm"
		crossorigin="anonymous"></script>
    </body>
</html>