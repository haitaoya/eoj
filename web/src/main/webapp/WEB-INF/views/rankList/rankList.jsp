<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="zh_CN">
<head>
    <meta charset="UTF-8">
    <title>排行榜 | ${websiteName}</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- Icon -->
    <link href="/web/assets/img/favicon.ico" rel="shortcut icon" type="image/x-icon">
    <!-- StyleSheets -->
    <link rel="stylesheet" type="text/css" href="/web/assets/css/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="/web/assets/css/bootstrap-responsive.min.css" />
    <link rel="stylesheet" type="text/css" href="/web/assets/css/flat-ui.min.css" />
    <link rel="stylesheet" type="text/css" href="/web/assets/css/font-awesome.min.css" />
    <link rel="stylesheet" type="text/css" href="/web/assets/css/style.css" />
    <link rel="stylesheet" type="text/css" href="/web/assets/css/rankList/rankList.css" />
    <!-- JavaScript -->
    <script type="text/javascript" src="/web/assets/js/jquery-1.11.1.min.js"></script>
    <script type="text/javascript" src="/web/assets/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="/web/assets/js/flat-ui.min.js"></script>
    <script type="text/javascript" src="/web/assets/js/md5.min.js"></script>
    <script type="text/javascript" src="/web/assets/js/pace.min.js"></script>
</head>
<body>
    <div id="wrapper">
        <!-- Sidebar -->
        <%@ include file="/WEB-INF/views/include/header.jsp" %>
        <!-- Content -->
        <div id="content" class="container">
            <div  id="filter" >
            	<div class="row-fluid">
            		<div class="span8">
            			<h4 style="margin:10px 0">排行榜 </h4>
           	 		</div>
           	 		<div class="span4">
           	 		<div id="rankscope" class="span2 black"><a href="<c:url value="/rankList?scope=" />">总榜</a></div>
            		<div id="rankscopey" class="span2 black"><a href="<c:url value="/rankList?scope=y" />">年榜</a></div>
					<div id="rankscopem" class="span2 black"><a href="<c:url value="/rankList?scope=m" />">月榜</a></div>
					<div id="rankscopew" class="span2 black"><a href="<c:url value="/rankList?scope=w" />">周榜</a></div>
					<div id="rankscoped" class="span2 black"><a href="<c:url value="/rankList?scope=d" />">日榜</a></div>
           	 		</div>
            	</div>
            </div> <!-- .row-fluid -->
                <table class="table table-striped">
                    <thead>
                        <tr>
                            <th class="rank">排名 </th>
                            <th class="username">用户名</th>
                            <th class="uid">ID</th>
                            <th class="acceptNum">解决</th>
                            <th class="submissionNum">提交</th>
                            <th class="AC">AC率</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="user" items="${ranklist}" varStatus="rank">
                        <tr data-value="${user.uid}">
                            <td class="rank">
                                ${rank.count}
                            </td>
                            <td class="username">
                                <a href="<c:url value="/accounts/user/${user.uid}" />">${user.username}</a>
                            </td>
                            <td class="uid">
                            	 <a href="<c:url value="/accounts/user/${user.uid}" />">${user.uid}</a>
                            </td>
                            <td class="acceptNum">${user.acceptNum}</td>
                            <td class="submissionNum">${user.submissionNum}</td>
                            <td class="AC">
                            	<c:choose>
                                <c:when test="${user.submissionNum == 0}">0%</c:when>
                                <c:otherwise>
                                	<!-- 求百分率 -->
                                    <fmt:formatNumber type="number"  maxFractionDigits="0" value="${user.acceptNum * 100 / user.submissionNum}" />%
                                </c:otherwise>
                            	</c:choose>
                            </td>
                        </tr>
                        </c:forEach>
                    </tbody>
                </table>
                <div id="pagination" class="pagination pagination-centered">
                    <c:set var="lowerBound" value="${currentPage - 5 > 0 ? currentPage - 5 : 1}" />
                    <c:set var="upperBound" value="${currentPage + 5 < totalPages ? currentPage + 5 : totalPages}" />
                    <c:set var="baseUrl" value="/rankList?" />
                    <ul>
                        <li class="previous <c:if test="${currentPage <= 1}">disabled</c:if>">
                        <a href="
                        <c:choose>
                            <c:when test="${currentPage <= 1}">javascript:void(0);</c:when>
                            <c:otherwise><c:url value="${baseUrl}page=${currentPage - 1}&scope=${param.scope}" /></c:otherwise>
                        </c:choose>
                        ">&lt;</a>
                        </li>
                        <c:forEach begin="${lowerBound}" end="${upperBound}" var="pageNumber">
                        <li <c:if test="${pageNumber == currentPage}">class="active"</c:if>><a href="<c:url value="${baseUrl}page=${pageNumber}&scope=${param.scope}" />">${pageNumber}</a></li>
                        </c:forEach>
                        <li class="next <c:if test="${currentPage >= totalPages}">disabled</c:if>">
                        <a href="
                        <c:choose>
                            <c:when test="${currentPage >= totalPages}">javascript:void(0);</c:when>
                            <c:otherwise><c:url value="${baseUrl}page=${currentPage + 1}&scope=${param.scope}" /></c:otherwise>
                        </c:choose>
                        ">&gt;</a>
                        </li>
                    </ul>
                </div> <!-- #pagination-->
        </div>  <!-- #content -->
    </div> <!-- #wrapper -->
    <!-- Java Script -->
    <!-- Placed at the end of the document so the pages load faster -->
    <%@ include file="/WEB-INF/views/administration/include/footer-script.jsp" %>
    <script type="text/javascript">
    	$(function(){
    		$('#rankscope${param.scope}').removeClass("black").addClass("red");
    	});
    </script>
</body>
</html>