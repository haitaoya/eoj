<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="zh_CN">
<head>
    <meta charset="UTF-8">
    <title>${contest.contestName} 排行榜 | ${websiteName}</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="${description}">
    <meta name="author" content="Haitao Wang">
    <!-- Icon -->
    <link href="/web/assets/img/favicon.ico" rel="shortcut icon" type="image/x-icon">
    <!-- StyleSheets -->
    <link rel="stylesheet" type="text/css" href="/web/assets/css/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="/web/assets/css/bootstrap-responsive.min.css" />
    <link rel="stylesheet" type="text/css" href="/web/assets/css/flat-ui.min.css" />
    <link rel="stylesheet" type="text/css" href="/web/assets/css/font-awesome.min.css" />
    <link rel="stylesheet" type="text/css" href="/web/assets/css/style.css" />
    <link rel="stylesheet" type="text/css" href="/web/assets/css/contests/leaderboard.css" />
    <!-- JavaScript -->
    <script type="text/javascript" src="/web/assets/js/jquery-1.11.1.min.js"></script>
    <script type="text/javascript" src="/web/assets/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="/web/assets/js/md5.min.js"></script>
</head>
<body>
    <!-- Header -->
    <%@ include file="/WEB-INF/views/include/header.jsp" %>
    <!-- Content -->
    <div id="content" class="container">
        <div class="row-fluid">
            <div class="span12">
                <div class="leaderboard">
                    <div class="header">
                        ${contest.contestName} 排行榜
                    </div> <!-- .header -->
                    <div class="body">
                        <table class="table table-striped">
                            <thead>
                               <th class="rank">排名</th>
                                <th class="contestant">参赛者</th>
                                <th class="score">通过数</th>
                                <th class="time">用时</th>
                            <c:forEach var="problem" items="${problems}" varStatus="id">
                                <th class="submission problem-${problem.problemId}"><a href="<c:url value="/contest/${contest.contestId}/p/${problem.problemId}/${id.count+64}" />" target="_blank">&#${id.count+64};</a></th>
                            </c:forEach>
                            </thead>
                            <tbody>
                            <c:forEach var="contestant" items="${contestants}">
                                <tr>
                                    <td class="rank">${contestant.rank}</td>
                                    <td class="contestant"><a href="<c:url value="/accounts/user/${contestant.contestant.uid}" />" target="_blank">${contestant.contestant.username}</a></td>
                                    <!-- 通过数 --><td class="score">${contestant.score}</td>
                                    <!-- 用时 --><td class="time"><fmt:formatNumber pattern="00" value="${(contestant.time-contestant.time % 3600 ) / 3600}" />:<fmt:formatNumber pattern="00" value="${(contestant.time - contestant.time % 60) / 60 % 60}" />:<fmt:formatNumber pattern="00" value="${contestant.time % 60}" /></td>
                                <c:forEach var="problem" items="${problems}">
                                	<c:set var="submission" value="${submissions[contestant.contestant.uid][problem.problemId]}" />
                                    <c:set var="wrongNum" value="${wrongsubmissions[contestant.contestant.uid][problem.problemId]}" />
                                	<c:set var="color" value="" />
                                    <c:choose>
                                    <c:when test="${submission == null}">
                                    	<c:choose>
                                    		<c:when test="${wrongNum == null}">
                                    		</c:when>
                                    		<c:otherwise>
                                    			 <c:set var="color" value="style='background-color:#ff0700'" />
                                  		  </c:otherwise>
                                    	</c:choose>
                                    </c:when>
                                    <c:otherwise>
                                      <c:set var="color" value="style='background-color:#33f967'" />
                                    </c:otherwise>
                                    </c:choose>
                                    
                                    <td class="submission problem-${problem.problemId}" ${color}">
                                    <c:choose>
                                    <c:when test="${submission == null}">
                                    	<c:choose>
                                    		<c:when test="${wrongNum == null}">
                                    					-
                                    		</c:when>
                                    		<c:otherwise>
                                    			${wrongNum}
                                  		  </c:otherwise>
                                    	</c:choose>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="<c:url value="/submission/${submission.submissionId}" />" target="_blank"><fmt:formatNumber pattern="00" value="${(submission.usedTime - submission.usedTime % 3600) / 3600}" />:<fmt:formatNumber pattern="00" value="${(submission.usedTime - submission.usedTime % 60 ) / 60 % 60}" />:<fmt:formatNumber pattern="00" value="${submission.usedTime % 60}" /></a>
                                      <c:choose>
                                   		 <c:when test="${wrongNum == null}"></c:when>
                                    	 <c:otherwise>
                                    			(${wrongNum}) 
                                  		  </c:otherwise>
                                    	</c:choose>
                                    </c:otherwise>
                                    </c:choose>
                                   
                                    </td>
                                </c:forEach>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div> <!-- .body -->
                </div> <!-- .leaderboard -->
            </div> <!-- .span12 -->
        </div> <!-- .row-fluid -->
    </div> <!-- #content -->
    <!-- Footer -->
    <%@ include file="/WEB-INF/views/include/footer.jsp" %>
    <!-- Java Script -->
    <!-- Placed at the end of the document so the pages load faster -->
    <script type="text/javascript" src="/web/assets/js/site.js"></script>
    <script type="text/javascript">
        $(window).scroll(function() {
            var offset = $('table').offset().top - $('thead').outerHeight() - $(window).scrollTop();

            if ( offset <= 0 ) {
                $('thead').css('position', 'fixed');
            <c:forEach var="problem" items="${problems}">
                $('th.problem-${problem.problemId}').width($('td.problem-${problem.problemId}').width());
            </c:forEach>
            } else {
                $('thead').css('position', 'relative');
            }
        });
    </script>
    <c:if test="${GoogleAnalyticsCode != ''}">
    ${googleAnalyticsCode}
    </c:if>
</body>
</html>
