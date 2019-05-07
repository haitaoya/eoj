<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="zh_CN">
<head>
    <meta charset="UTF-8">
    <title>竞赛列表 | ${websiteName}</title>
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
    <link rel="stylesheet" type="text/css" href="/web/assets/css/contests/contests.css" />
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
         <form id="search-form" action="<c:url value="/contest" />">
             <div class="row-fluid">
             <div class="span8">
             	<h4 style="margin:10px 0">竞赛列表 </h4>
             </div>
                 <div class="control-group span3" style="margin-bottom: 0;">
                     <input name="keyword" class="span12" type="text" placeholder="关键字" />
                 </div>
                 <div class="span1">
                 	<button class="btn btn-primary btn-block" type="submit">查询</button>
                 </div>
             </div><!-- .row-fluid -->
         </form> <!-- #search-form -->
        <div id="main-content" class="row-fluid">
            <div id="contests" class="span12">
                <table class="table">
                <thead>
                	<tr>
                    	<th>竞赛名称</th>
                    	<th>竞赛模式</th>
                    	<th>开始时间</th>
                    	<th>结束时间</th>
                    	<th>状态</th>
                    </tr>
                 </thead>
                   <tbody>
                <c:forEach var="contest" items="${contests}">
                    <c:choose>
                        <c:when test="${currentTime.before(contest.startTime)}">
                        	<c:set var="contestStatusSlug" value="Ready" />
                            <c:set var="contestStatus" value="等待开始" />
                        </c:when>
                        <c:when test="${currentTime.after(contest.endTime)}">
                        	<c:set var="contestStatusSlug" value="Done" />
                            <c:set var="contestStatus" value="已结束" />
                        </c:when>
                        <c:when test="${currentTime.after(contest.startTime) and currentTime.before(contest.endTime)}">
                        	<c:set var="contestStatusSlug" value="Live" />
                            <c:set var="contestStatus" value="进行中" />
                        </c:when>
                    </c:choose>
                    <tr data-value="${contest.contestId}" class="contest ${contestStatusSlug}">
                        <td>
                            <a href="<c:url value="/contest/${contest.contestId}" />">${contest.contestName}</a>
                           <%--  <ul class="inline">
                                <li>${contest.contestMode}</li>
                                <li>开始时间: <fmt:formatDate value="${contest.startTime}" type="both" dateStyle="default" timeStyle="default" /></li>
                                <li>结束时间: <fmt:formatDate value="${contest.endTime}" type="both" dateStyle="default" timeStyle="default" /></li>
                            </ul> --%>
                        </td>
                        <td>${contest.contestMode}</td>
                        <td><fmt:formatDate value="${contest.startTime}" type="both" dateStyle="default" timeStyle="default" /></td>
                        <td><fmt:formatDate value="${contest.endTime}" type="both" dateStyle="default" timeStyle="default" /></td>
                        <td class="status">${contestStatus}</td>
                    </tr>
                </c:forEach>
                </tbody>
                </table> <!-- .table -->
                <div id="more-contests">
                    <p class="availble">加载更多</p>
                    <img src="/web/assets/img/loading.gif" alt="Loading" class="hide" />
                </div>
            </div> <!-- #contests -->
        </div> <!-- #main-content -->
    </div> <!-- #content -->
    <!-- Footer -->
    <%@ include file="/WEB-INF/views/include/footer.jsp" %>
    <!-- Java Script -->
    <!-- Placed at the end of the document so the pages load faster -->
    <script type="text/javascript" src="/web/assets/js/site.js"></script>
    <script type="text/javascript" src="/web/assets/js/date-zh_CN.min.js"></script>
    <script type="text/javascript">
        function setLoadingStatus(isLoading) {
            if ( isLoading ) {
                $('p', '#more-contests').addClass('hide');
                $('img', '#more-contests').removeClass('hide');
            } else {
                $('img', '#more-contests').addClass('hide');
                $('p', '#more-contests').removeClass('hide');
            }
        }
    </script>
    <script type="text/javascript">
        $('#more-contests').click(function() {
            var isLoading         = $('img', this).is(':visible'),
                hasNextRecord     = $('p', this).hasClass('availble'),
                numberOfContests  = $('tr.contest').length;

            if ( !isLoading && hasNextRecord ) {
                setLoadingStatus(true);
                return getMoreContests(numberOfContests);
            }
        });
    </script>
    <script type="text/javascript">
        function getMoreContests(startIndex) {
            var pageRequests = {
                'keyword': '${param.keyword}',
                'startIndex': startIndex
            };

            $.ajax({
                type: 'GET',
                url: '<c:url value="/contest/getContests.action" />',
                data: pageRequests,
                dataType: 'JSON',
                success: function(result){
                    return processContestsResult(result);
                }
            });
        }
    </script>
    <script type="text/javascript">
        function processContestsResult(result) {
            if ( result['isSuccessful'] ) {
                displayContests(result['contests']);
            } else {
                $('p', '#more-contests').removeClass('availble');
                $('p', '#more-contests').html('已加载全部竞赛');
                $('#more-contests').css('cursor', 'default');
            }
            setLoadingStatus(false);
        }
    </script>
    <script type="text/javascript">
        function displayContests(contests) {
            for ( var i = 0; i < contests.length; ++ i ) {
                var contestStatus    = 'Done',contestStatusSlug = '已结束',
                    currentTime      = new Date(),
                    contestStartTime = new Date(contests[i]['startTime']),
                    contestEndTime   = new Date(contests[i]['endTime']);
                
                if ( currentTime < contestStartTime ) {
                    contestStatus = 'Ready';
                    contestStatusSlug = '等待开始';
                } else if ( currentTime >= contestStartTime && currentTime <= contestEndTime ) {
                    contestStatus = 'Live';
                    contestStatusSlug = '进行中';
                }
                $('#contests tbody').append('<tr data-value="%s" class="contest %s">'.format(contests[i]['contestId'],contestStatus) + 
                    '    <td><a href="<c:url value="/contest/" />%s">%s</a></td>'.format(contests[i]['contestId'], contests[i]['contestName']) + 
                    '      <td>%s</td>'.format(contests[i]['contestMode']) +
                    '      <td>%s</td>'.format(getFormatedDateString(contests[i]['startTime'], 'zh_CN')) + 
                    '      <td>%s</td>'.format(getFormatedDateString(contests[i]['endTime'], 'zh_CN')) + 
                    '    <td class="status">%s</td>'.format(contestStatusSlug) +  
                    '</tr>');
            }
        }
    </script>
    <c:if test="${GoogleAnalyticsCode != ''}">
    ${googleAnalyticsCode}
    </c:if>
</body>
</html>