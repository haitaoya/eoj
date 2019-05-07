<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="zh_CN">
<head>
    <meta charset="UTF-8">
    <title>${contest.contestName} | ${websiteName}</title>
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
    <link rel="stylesheet" type="text/css" href="/web/assets/css/contests/contest.css" />
    <!-- JavaScript -->
    <script type="text/javascript" src="/web/assets/js/jquery-1.11.1.min.js"></script>
    <script type="text/javascript" src="/web/assets/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="/web/assets/js/md5.min.js"></script>
</head>
<body>
    <!-- Header -->
    <%@ include file="/WEB-INF/views/include/header.jsp" %>
    <!-- Content -->
    <c:choose>
        <c:when test="${currentTime.before(contest.startTime)}">
            <c:set var="contestStatus" value="等待开始" />
        </c:when>
        <c:when test="${currentTime.after(contest.endTime)}">
            <c:set var="contestStatus" value="已结束" />
        </c:when>
        <c:when test="${currentTime.after(contest.startTime) and currentTime.before(contest.endTime)}">
            <c:set var="contestStatus" value="进行中" />
        </c:when>
    </c:choose>
    <div id="content" class="container">
        <div class="row-fluid">
            <div id="main-content" class="span8">
                <div class="contest">
                    <div class="header">
                        <span class="pull-right">
                        <c:if test="${isLogin}">
                        <c:choose>
                            <c:when test="${isAttended}">已参加</c:when>
                            <c:otherwise>未参加</c:otherwise>
                        </c:choose>
                        </c:if>
                        </span>
                        <span class="name">${contest.contestName}</span>
                    </div> <!-- .header -->
                    <div class="body">
                        <div class="section">
                            <h4>说明</h4>
                            <c:choose>
                                <c:when test="${contest.contestNotes == ''}"><p>暂无说明</p></c:when>
                                <c:otherwise><div class="markdown">${contest.contestNotes}</div> <!-- .markdown --></c:otherwise>
                            </c:choose>
                        </div> <!-- .section -->
                    <c:if test="${currentTime.after(contest.startTime) and isAttended or currentTime.after(contest.endTime)}">
                        <div class="section">
                            <h4>试题列表</h4>
                            <table id="problems" class="table table-striped">
                            <c:if test="${isLogin}">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>标题</th>
                                        <th>状态</th>
                                    </tr>
                                </thead>
                            </c:if>
                                <tbody>
                                <c:forEach var="problem" items="${problems}" varStatus="id">
                                    <tr>
                                    	<!-- 试题的字母编号 -->
                                    	<td>&#${id.count+64};</td>
                                        <td>
                                            <a href="<c:url value="/contest/${contest.contestId}/p/${problem.problemId}/${id.count+64}" />">${problem.problemName}</a>
                                        </td>
                                        <c:if test="${isLogin}">
                                    <c:set var="submission" value="${submissions[problem.problemId]}" />
                                    <c:choose>
                                    <c:when test="${submission != null}">
                                        <td class="flag-${submission.submission.judgeResult.judgeResultSlug}"><a href="<c:url value="/submission/${submission.submission.submissionId}" />">${submission.submission.judgeResult.judgeResultName}</a></td>
                                    </c:when>
                                    <c:otherwise>
                                        <td>未提交</td>
                                    </c:otherwise>
                                    </c:choose>
                                    </c:if>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div> <!-- .section -->
                    </c:if>
                    </div> <!-- .body -->
                </div> <!-- .contest -->
            </div> <!-- #main-content -->
            <div id="sidebar" class="span4">
                <div class="section">
                    <h5>基本信息</h5>
                    <div id="basic-info">
                        <div class="row-fluid">
                            <div class="span5">状态</div> <!-- .span5 -->
                            <div class="span7 ${contestStatus}">${contestStatus}</div> <!-- .span7 -->
                        </div> <!-- .row-fluid -->
                        <div class="row-fluid">
                            <div class="span5">开始时间</div> <!-- .span5 -->
                            <div class="span7"><fmt:formatDate value="${contest.startTime}" pattern="yyyy-MM-dd HH:mm:ss" /></div> <!-- .span7 -->
                        </div> <!-- .row-fluid -->
                        <div class="row-fluid">
                            <div class="span5">结束时间</div> <!-- .span5 -->
                            <div class="span7"><fmt:formatDate value="${contest.endTime}" pattern="yyyy-MM-dd HH:mm:ss" /></div> <!-- .span7 -->
                        </div> <!-- .row-fluid -->
                        <div class="row-fluid">
                            <div class="span5">类型</div> <!-- .span5 -->
                            <div class="span7">${contest.contestMode}</div> <!-- .span7 -->
                        </div> <!-- .row-fluid -->
                        <div class="row-fluid">
                            <div class="span5">题数</div> <!-- .span5 -->
                            <div class="span7">${problems.size()}</div> <!-- .span7 -->
                        </div> <!-- .row-fluid -->
                        <div class="row-fluid">
                            <div class="span5">参赛人数</div> <!-- .span5 -->
                            <div id="number-of-contestants" class="span7">${numberOfContestants}</div> <!-- .span7 -->
                        </div> <!-- .row-fluid -->
                    </div> <!-- #basic-info -->
                </div> <!-- .section -->
                <div class="section">
                    <h5>操作</h5>
                    <ul>
                    <c:if test="${not isAttended and contestStatus != 'Done'}">
                        <li><a id="attend-contest-button" href="javascript:attendContest();">参加竞赛</a></li>
                    </c:if>
                    <c:if test="${contestStatus != 'Ready'}">
                        <li><a href="<c:url value="/contest/${contest.contestId}/leaderboard" />">排行榜</a></li>
                    </c:if>
                    <c:if test="${isAttended and contestStatus == 'Ready'}">
                        <li>已参加</li>
                        <li>目前无可行操作，等待竞赛开始</li>
                    </c:if>
                    </ul>
                </div> <!-- .section -->
            </div> <!-- #sidebar -->
        </div> <!-- .row-fluid -->
    </div> <!-- #content -->
    <!-- Footer -->
    <%@ include file="/WEB-INF/views/include/footer.jsp" %>
    <!-- Java Script -->
    <!-- Placed at the end of the document so the pages load faster -->
    <script type="text/javascript" src="/web/assets/js/site.js"></script>
    <script type="text/x-mathjax-config">
        MathJax.Hub.Config({
            tex2jax: {inlineMath: [['$','$'], ['\\(','\\)']]}
        });
    </script>
    <script type="text/javascript" async src="https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.2/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>
    <script type="text/javascript">
        $.getScript('/web/assets/js/markdown.min.js', function() {
            converter = Markdown.getSanitizingConverter();

            $('.markdown').each(function() {
                var plainContent    = $(this).text(),
                    markdownContent = converter.makeHtml(plainContent.replace(/\\\n/g, '\\n'));
                
                $(this).html(markdownContent);
            });
        });
    </script>
<c:if test="${not isAttended and contestStatus != 'Done'}">
<c:choose>
    <c:when test="${isLogin}">
    <script type="text/javascript">
        function attendContest() {
            var postData = {
                'csrfToken': '${csrfToken}'
            };

            $.ajax({                
                type: 'POST',
                url: '<c:url value="/contest/${contest.contestId}/attend.action" />',
                data: postData, 
                dataType: 'JSON',
                success: function(result) {
                    if ( result['isSuccessful'] ) {
                        $('#attend-contest-button').removeAttr('href');
                        setContestAttended();
                    } else {
                        if ( !result['isCsrfTokenValid'] ) {
                            alert('无效的token，请刷新后重试');
                        } else if ( !result['isContestExists'] ) {
                            alert('竞赛不存在');
                        } else if ( !result['isContestReady'] ) {
                            alert('竞赛已开始或已结束');
                        } else if ( !result['isUserLogin'] ) {
                            alert('未登录');
                        } else if ( result['isAttendedContest'] ) {
                            alert('您已参加该竞赛');
                            setContestAttended();
                        }
                    }
                }
            });
        }
    </script>
    <script type="text/javascript">
        function setContestAttended() {
            var numberOfContestants = parseInt($('#number-of-contestants').html());

            $('.pull-right', '.contest .header').html('参加竞赛');
            $('#number-of-contestants').html(numberOfContestants + 1);
            $('#attend-contest-button').html('您已参加该竞赛');
            setTimeout(function(){
                $('#attend-contest-button').remove();
            }, 1500);
        }
    </script>
    </c:when>
    <c:otherwise>
    <script type="text/javascript">
        function attendContest() {
            window.location.href = '<c:url value="/accounts/login?forward=" />${requestScope['javax.servlet.forward.request_uri']}';
        }
    </script>
    </c:otherwise>
    </c:choose>
    </c:if>
    <c:if test="${GoogleAnalyticsCode != ''}">
    ${googleAnalyticsCode}
    </c:if>
</body>
</html>