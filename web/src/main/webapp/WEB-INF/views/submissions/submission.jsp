<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>提交记录 \#${submission.submissionId} | ${websiteName}</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="author" content="Haitao Wang">
    <link href="/web/assets/img/favicon.ico" rel="shortcut icon" type="image/x-icon">
    <!-- StyleSheets -->
    <link rel="stylesheet" type="text/css" href="/web/assets/css/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="/web/assets/css/bootstrap-responsive.min.css" />
    <link rel="stylesheet" type="text/css" href="/web/assets/css/flat-ui.min.css" />
    <link rel="stylesheet" type="text/css" href="/web/assets/css/font-awesome.min.css" />
    <link rel="stylesheet" type="text/css" href="/web/assets/css/style.css" />
    <link rel="stylesheet" type="text/css" href="/web/assets/css/submissions/submission.css" />
    <link rel="stylesheet" type="text/css" href="/web/assets/css/highlight.min.css" />
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
            <div id="main-content" class="span12">
                <div class="submission">
                    <div class="body">
                        <div class="section">
                        	<h1 style="text-align:center">P${submission.problem.problemId}： ${submission.problem.problemName}</h1>
                        </div>
                        <div class="section">
                            <div class="description">
                                <table class="table">
                                    <tr>
                                        <td>评测结果</td>
                                        <td id="judge-result" class="flag-${submission.judgeResult.judgeResultSlug}">${submission.judgeResult.judgeResultName}</td>
                                    </tr>
                                    <tr>
                                        <td>试题</td>
                                        <td id="problem-summery"><a href="<c:url value="/p/${submission.problem.problemId}" />">P${submission.problem.problemId} ${submission.problem.problemName}</a></td>
                                    </tr>
                                    <tr>
                                        <td>提交时间</td>
                                        <td id="submit-time"><fmt:formatDate value="${submission.submitTime}" type="both" dateStyle="default" timeStyle="default"/></td>
                                    </tr>
                                    <tr>
                                        <td>语言</td>
                                        <td id="language-name">${submission.language.languageName}</td>
                                    </tr>
                                    <tr>
                                        <td>评测机</td>
                                        <td id="judger-name">Default Judger</td>
                                    </tr>
                                    <tr>
                                        <td>所用时间</td>
                                        <td id="used-time">${submission.usedTime} ms</td>
                                    </tr>
                                    <tr>
                                        <td>所用内存</td>
                                        <td id="used-memory">${submission.usedMemory} K</td>
                                    </tr>
                                    <tr>
                                        <td>评测时间</td>
                                        <td id="execute-time"><fmt:formatDate value="${submission.executeTime}" type="both" dateStyle="default" timeStyle="default"/></td>
                                    </tr>
                                </table>
                            </div> <!-- .description -->
                        </div> <!-- .section -->
                        <div class="section">
                            <h4>评测记录</h4>
                            <div id="judge-log" class="description markdown">${submission.judgeLog}</div> <!-- .description -->
                        </div> <!-- .section -->
                        <c:if test="${submission.user == myProfile or myProfile.userGroup.userGroupSlug == 'administrators'}">
                        <div class="section">
                            <h4>提交代码</h4>
                            <div class="description">
                                <pre><code>${submission.code.replace("<", "&lt;").replace(">", "&gt;")}</code></pre>
                            </div> <!-- .description -->
                        </div> <!-- .section -->
                        </c:if>
                    </div> <!-- .body -->
                </div> <!-- .submission -->
            </div> <!-- #main-content -->
        </div> <!-- .row-fluid -->
    </div> <!-- #content -->
    <!-- Footer -->
    <%@ include file="/WEB-INF/views/include/footer.jsp" %>
    <!-- Java Script -->
    <!-- Placed at the end of the document so the pages load faster -->
    <script type="text/javascript" src="/web/assets/js/site.js"></script>
    <script type="text/javascript">
        $.getScript('/web/assets/js/markdown.min.js', function() {
            converter = Markdown.getSanitizingConverter();

            $('.markdown').each(function() {
                var plainContent    = $(this).text(),
                //replace(/\\\n/g, '\\n') 转换成makedown语法
                    markdownContent = converter.makeHtml(plainContent);
                
                $(this).html(markdownContent);
            });
        });
    </script>
    <!--   setInterval()： 间隔指定的毫秒数不停地执行指定的代码，定时器
		clearInterval()： 用于停止 setInterval() 方法执行的函数代码 -->
    <c:if test="${submission.judgeResult.judgeResultName == 'Pending'}">
    <script type="text/javascript">
        $.getScript('/web/assets/js/date-zh_CN.min.js', function() {
            var currentJudgeResult = false,
                getterInterval     = setInterval(function() {
                    getRealTimeJudgeResult();
                    currentJudgeResult = $('#judge-result').is('.flag-PD');
                    if (!currentJudgeResult) {
                        clearInterval(getterInterval);
                    }
                }, 10000);
        });
    </script>
    <!-- 异步输出 实时评测结果 -->
    <script type="text/javascript">
        $(function() {
            var subscriptionUrl = '<c:url value="/submission/getRealTimeJudgeResult.action?submissionId=${submission.submissionId}&csrfToken=${csrfToken}" />',
                source          = new EventSource(subscriptionUrl),
                lastMessage     = '';
             source.onmessage = function(e) {
                var message     = e['data'];
                if ( message == lastMessage ) {
                    return;
                }
                lastMessage     = message;

                if ( message == 'Established' ) {
                    $('#judge-log').append('<p>正在评测....</p>');
                    return;
                }
                var mapMessage  = JSON.parse(message),
                    judgeResult = mapMessage['judgeResult'],
                    judgeLog    = mapMessage['message'];
                     
                $('#judge-result').html(judgeResult);
                $('#judge-log').append(converter.makeHtml(judgeLog));
            }
        });
    </script>
    <script type="text/javascript">
        function getRealTimeJudgeResult() {
            var pageRequests = {
                'submissionId': ${submission.submissionId}
            };
            $.ajax({
                type: 'GET',
                url: '<c:url value="/submission/getSubmission.action" />',
                data: pageRequests,
                dataType: 'JSON',
                success: function(result){
                    if ( result['isSuccessful'] ) {
                        if ( result['submission']['judgeResult']['judgeResultSlug'] != 'PD' ) {
                            $('#judge-result').removeClass();
                            $('#judge-result').addClass("flag-" + result['submission']['judgeResult']['judgeResultSlug'])
                            $('#judge-result').html(result['submission']['judgeResult']['judgeResultName']);
                            $('#used-time').html(result['submission']['usedTime'] + " ms");
                            $('#used-memory').html(result['submission']['usedMemory'] + " KB");
                            $('#execute-time').html(getFormatedDateString(result['submission']['executeTime'], 'zh_CN'));
                            $('#judge-log').html(converter.makeHtml(result['submission']['judgeLog'].replace(/\\\n/g, '\\n')));
                        }
                    }
                }
            });
        }
    </script>
    <script type="text/javascript">
        function getFormatedDateString(dateTime, locale) {
            var dateObject = new Date(dateTime),
                dateString = dateObject.toString();

            if ( locale == 'en_US' ) {
                dateString = dateObject.toString('MMM d, yyyy h:mm:ss tt');
            } else if ( locale == 'zh_CN' ) {
                dateString = dateObject.toString('yyyy-M-dd HH:mm:ss');
            }

            return dateString;
        }
    </script>
    </c:if>
    <script type="text/javascript">
        $.getScript('/web/assets/js/highlight.min.js', function() {
            $('pre code').each(function(i, block) {
                hljs.highlightBlock(block);
            });
        });
    </script>
    <c:if test="${GoogleAnalyticsCode != ''}">
    ${googleAnalyticsCode}
    </c:if>
</body>
</html>