<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<spring:eval expression="@propertyConfigurer.getProperty('url.cdn')" var="cdnUrl" />
<spring:eval expression="@propertyConfigurer.getProperty('build.version')" var="version" />
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>提交记录 | ${websiteName}</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="author" content="Haitao Wang">
    <!-- Icon -->
    <link href="/web/assets/img/favicon.ico" rel="shortcut icon" type="image/x-icon">
    <!-- StyleSheets -->
    <link rel="stylesheet" type="text/css" href="/web/assets/css/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="/web/assets/css/bootstrap-responsive.min.css" />
    <link rel="stylesheet" type="text/css" href="/web/assets/css/flat-ui.min.css" />
    <link rel="stylesheet" type="text/css" href="/web/assets/css/font-awesome.min.css" />
    <link rel="stylesheet" type="text/css" href="/web/assets/css/style.css" />
    <link rel="stylesheet" type="text/css" href="/web/assets/css/submissions/submissions.css" />
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
        <form id="filter"  action="<c:url value="/submission" />">
            <div class="row-fluid">
            <div class="span5">
            	<h4 style="margin:10px 0">最近提交记录 </h4>
            </div>
                <div class="span3">
                    <div class="form-group">
                        <input name="username" type="text" value="${param.username}" placeholder="用户名" class="form-control span12">
                    </div> <!-- .form-group -->
                </div> <!-- .span3 -->
                <div class="span3">
                    <div class="form-group">
                        <input name="problemId" type="text" value="${param.problemId}" placeholder="试题号" class="form-control span12">
                    </div> <!-- .form-group -->
                </div> <!-- .span3 -->
                <div class="span1">
                    <button class="btn btn-primary btn-block" type="submit">搜索</button>
                </div> <!-- .span1 -->
            </div> <!-- .row-fluid -->
        </form> <!-- #filter -->
        <div id="main-content">
            <div class="row-fluid">
                <div id="submission" class="span12">
                    <table class="table table-striped">
                        <thead>
                            <tr>
                                <th class="flag">运行结果</th>
                                <th class="score">分数</th>
                                <th class="time">时间</th>
                                <th class="memory">内存</th>
                                <th class="name">试题 </th>
                                <th class="user">用户名 </th>
                                <th class="language">语言</th>
                                <th class="submit-time">提交时间</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="submission" items="${submissions}">
                            <tr data-value="${submission.submissionId}">
                                <td class="flag-${submission.judgeResult.judgeResultSlug}"><a href="<c:url value="/submission/${submission.submissionId}" />">${submission.judgeResult.judgeResultName}</a></td>
                                <td class="score">${submission.judgeScore}</td>
                                <td class="time">${submission.usedTime} ms</td>
                                <td class="memory">${submission.usedMemory} K</td>
                                <td class="name"><a href="<c:url value="/p/${submission.problem.problemId}" />">P${submission.problem.problemId} ${submission.problem.problemName}</a></td>
                                <td class="user"><a href="<c:url value="/accounts/user/${submission.user.uid}" />">${submission.user.username}</a></td>
                                <td class="language">${submission.language.languageName}</td>
                                <td class="submit-time">
                                    <fmt:formatDate value="${submission.submitTime}" type="both" dateStyle="default" timeStyle="default" />
                                </td>
                            </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                    <div id="more-submissions">
                        <p class="availble">加载更多</p>
                        <img src="/web/assets/img/loading.gif" alt="Loading" class="hide" />
                    </div>
                </div> <!-- #submission -->
            </div> <!-- .row-fluid -->
        </div> <!-- #main-content -->
    </div> <!-- #content -->
    <!-- Footer -->
    <%@ include file="/WEB-INF/views/include/footer.jsp" %>
    <!-- Java Script -->
    <!-- Placed at the end of the document so the pages load faster -->
    <script type="text/javascript" src="/web/assets/js/site.js"></script>
    <script type="text/javascript" src="/web/assets/js/date-zh_CN.min.js"></script>
    <script type="text/javascript">
        setInterval(function() {
            var firstSubmissionRecord = $('tr:first-child', '#submission tbody'),
                firstSubmissionId     = parseInt($(firstSubmissionRecord).attr('data-value'));
            
            getLatestSubmissions(firstSubmissionId + 1);
        }, 10000);
    </script>
    <script type="text/javascript">
        function getLatestSubmissions(startIndex) {
            var pageRequests = {
                'problemId': '${param.problemId}',
                'username': '${param.username}',
                'startIndex': startIndex
            };

            $.ajax({
                type: 'GET',
                url: '<c:url value="/submission/getLatestSubmissions.action" />',
                data: pageRequests,
                dataType: 'JSON',
                success: function(result){
                    if ( result['isSuccessful'] ) {
                        displayLatestSubmissionRecords(result['submissions']);
                    }
                }
            });
        }
    </script>
    <script type="text/javascript">
        function displayLatestSubmissionRecords(submissions) {
            for ( var i = 0; i < submissions.length; ++ i ) {
                $('table > tbody', '#submission').prepend(
                    getSubmissionContent(submissions[i]['submissionId'], submissions[i]['judgeResult'], 
                                         submissions[i]['judgeScore'], submissions[i]['usedTime'], 
                                         submissions[i]['usedMemory'], submissions[i]['problem'], 
                                         submissions[i]['user'], submissions[i]['language'], submissions[i]['submitTime'])
                );
            }
        }
    </script>
    <script type="text/javascript">
        function setLoadingStatus(isLoading) {
            if ( isLoading ) {
                $('p', '#more-submissions').addClass('hide');
                $('img', '#more-submissions').removeClass('hide');
            } else {
                $('img', '#more-submissions').addClass('hide');
                $('p', '#more-submissions').removeClass('hide');
            }
        }
    </script>
    <script type="text/javascript">
        $('#more-submissions').click(function(event) {
            var isLoading            = $('img', this).is(':visible'),
                hasNextRecord        = $('p', this).hasClass('availble'),
                lastSubmissionRecord = $('tr:last-child', '#submission tbody'),
                lastSubmissionId     = parseInt($(lastSubmissionRecord).attr('data-value'));

            if ( isNaN(lastSubmissionId) ) {
                lastSubmissionId = 0;
            }
            if ( !isLoading && hasNextRecord ) {
                setLoadingStatus(true);
                return getMoreHistorySubmissions(lastSubmissionId - 1);
            }
        });
    </script>
    <script type="text/javascript">
        function getMoreHistorySubmissions(startIndex) {
            var pageRequests = {
                'problemId': '${param.problemId}',
                'username': '${param.username}',
                'startIndex': startIndex
            };

            $.ajax({
                type: 'GET',
                url: '<c:url value="/submission/getSubmissions.action" />',
                data: pageRequests,
                dataType: 'JSON',
                success: function(result){
                    return processHistorySubmissionsResult(result);
                }
            });
        }
    </script>
    <script type="text/javascript">
        function processHistorySubmissionsResult(result) {
            if ( result['isSuccessful'] ) {
                displayHistorySubmissionRecords(result['submissions']);
            } else {
                $('p', '#more-submissions').removeClass('availble');
                $('p', '#more-submissions').html('已加载全部');
                $('#more-submissions').css('cursor', 'default');
            }
            setLoadingStatus(false);
        }
    </script>
    <script type="text/javascript">
        function displayHistorySubmissionRecords(submissions) {
            for ( var i = 0; i < submissions.length; ++ i ) {
                $('table > tbody', '#submission').append(
                    getSubmissionContent(submissions[i]['submissionId'], submissions[i]['judgeResult'], 
                                         submissions[i]['judgeScore'], submissions[i]['usedTime'], 
                                         submissions[i]['usedMemory'], submissions[i]['problem'], 
                                         submissions[i]['user'], submissions[i]['language'], submissions[i]['submitTime'])
                );
            }
        }
    </script>
    <script type="text/javascript">
        function getSubmissionContent(submissionId, judgeResult, judgeScore, usedTime, usedMemory, problem, user, language, submitTime) {
            var submissionTemplate = '<tr data-value="%s">' +
                                     '    <td class="flag-%s"><a href="<c:url value="/submission/%s" />">%s</a></td>' +
                                     '    <td class="score">%s</td>' +
                                     '    <td class="time">%s ms</td>' +
                                     '    <td class="memory">%s K</td>' +
                                     '    <td class="name"><a href="<c:url value="/p/%s" />">P%s %s</a></td>' +
                                     '    <td class="user"><a href="<c:url value="/accounts/user/%s" />">%s</a></td>' +
                                     '    <td class="language">%s</td>' +
                                     '    <td class="submit-time">%s</td>' +
                                     '</tr>';

            return submissionTemplate.format(submissionId, judgeResult['judgeResultSlug'], submissionId, 
                                             judgeResult['judgeResultName'], judgeScore, usedTime, usedMemory, 
                                             problem['problemId'], problem['problemId'], problem['problemName'],
                                             user['uid'], user['username'], language['languageName'], getFormatedDateString(submitTime, 'zh_CN'));
        }
    </script>
    <c:if test="${GoogleAnalyticsCode != ''}">
    ${googleAnalyticsCode}
    </c:if>
</body>
</html>