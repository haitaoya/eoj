<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="zh_CN" />
<!DOCTYPE html>
<html lang="zh_CN">
<head>
    <meta charset="UTF-8">
    <title>编辑评测记录 #${submission.submissionId} | ${websiteName}</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- Icon -->
    <link href="/web/assets/img/favicon.ico" rel="shortcut icon" type="image/x-icon">
    <!-- StyleSheets -->
    <link rel="stylesheet" type="text/css" href="/web/assets/css/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="/web/assets/css/bootstrap-responsive.min.css" />
    <link rel="stylesheet" type="text/css" href="/web/assets/css/flat-ui.min.css" />
    <link rel="stylesheet" type="text/css" href="/web/assets/css/font-awesome.min.css" />
    <link rel="stylesheet" type="text/css" href="/web/assets/css/administration/style.css" />
    <link rel="stylesheet" type="text/css" href="/web/assets/css/administration/edit-submission.css" />
    <link rel="stylesheet" type="text/css" href="/web/assets/css/highlight.min.css" />
    <!-- JavaScript -->
    <script type="text/javascript" src="/web/assets/js/jquery-1.11.1.min.js"></script>
    <script type="text/javascript" src="/web/assets/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="/web/assets/js/md5.min.js"></script>
    <script type="text/javascript" src="/web/assets/js/pace.min.js"></script>
</head>
<body>
    <div id="wrapper">
        <!-- Sidebar -->
        <%@ include file="/WEB-INF/views/administration/include/sidebar.jsp" %>
        <div id="container">
            <!-- Header -->
            <%@ include file="/WEB-INF/views/administration/include/header.jsp" %>
            <!-- Content -->
            <div id="content">
                <h2 class="page-header"><i class="fa fa-edit"></i> 编辑评测记录</h2>
                <div class="section">
                    <h4>概况</h4>
                    <div class="description">
                        <table class="table">
                            <tr>
                                <td>评测结果</td>
                                <td id="judge-result" class="flag-${submission.judgeResult.judgeResultSlug}">${submission.judgeResult.judgeResultName}</td>
                            </tr>
                            <tr>
                                <td>试题</td>
                                <td id="problem-summery"><a href="<c:url value="/administration/edit-problem/${submission.problem.problemId}" />">P${submission.problem.problemId} ${submission.problem.problemName}</a></td>
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
                                <td>提交者</td>
                                <td id="submit-user"><a href="<c:url value="/administration/edit-user/${submission.user.uid}" />">${submission.user.username}</a></td>
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
                    <h4>代码</h4>
                    <div class="description">
                        <pre><code>${submission.code.replace("<", "&lt;").replace(">", "&gt;")}</code></pre>
                    </div> <!-- .description -->
                </div> <!-- .section -->
                <div class="section">
                    <h4>评测结果</h4>
                    <div id="judge-log" class="description markdown">${submission.judgeLog}</div> <!-- .description -->
                </div> <!-- .section -->
                <div class="section">
                    <button class="btn btn-warning">重新评测</button>                    
                    <button class="btn btn-danger">删除评测记录</button>                    
                </div> <!-- .section -->
            </div> <!-- #content -->
        </div> <!-- #container -->
    </div> <!-- #wrapper -->
    <!-- Java Script -->
    <!-- Placed at the end of the document so the pages load faster -->
    <%@ include file="/WEB-INF/views/administration/include/footer-script.jsp" %>
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
    <script type="text/javascript">
        $.getScript('/web/assets/js/highlight.min.js', function() {
            $('code').each(function(i, block) {
                hljs.highlightBlock(block);
            });
        });
    </script>
    <script type="text/javascript">
        $('button.btn-warning').click(function() {
            if ( !confirm('你确定要继续吗?') ) {
                return;
            }
            $('.alert-error').addClass('hide');
            $('button.btn-warning').attr('disabled', 'disabled');
            $('button.btn-warning').html('请稍后...');

            var submissions = [${submission.submissionId}];
            return doRestartSubmissionsAction(submissions);
        });
    </script>
    <script type="text/javascript">
        $('button.btn-danger').click(function() {
            if ( !confirm('你确定要继续吗?') ) {
                return;
            }
            $('.alert-error').addClass('hide');
            $('button.btn-danger').attr('disabled', 'disabled');
            $('button.btn-danger').html('请稍后...');

            var submissions = [${submission.submissionId}];
            return doDeleteSubmissionsAction(submissions);
        });
    </script>
    <script type="text/javascript">
        function doDeleteSubmissionsAction(submissions) {
            var postData = {
                'submissions': JSON.stringify(submissions)
            };

            $.ajax({
                type: 'POST',
                url: '<c:url value="/administration/deleteSubmissions.action" />',
                data: postData,
                dataType: 'JSON',
                success: function(result){
                    if ( result['isSuccessful'] ) {
                        for ( var i = 0; i < submissions.length; ++ i ) {
                            window.location.href = '<c:url value="/administration/all-submissions" />';
                        }
                    } else {
                        alert('在删除评测记录时发生了一些错误.');
                    }
                    $('button.btn-danger').removeAttr('disabled');
                    $('button.btn-danger').html('删除评测记录');
                }
            });
        }
    </script>
    <script type="text/javascript">
        function doRestartSubmissionsAction(submissions) {
            var postData = {
                'submissions': JSON.stringify(submissions)
            };

            $.ajax({
                type: 'POST',
                url: '<c:url value="/administration/restartSubmissions.action" />',
                data: postData,
                dataType: 'JSON',
                success: function(result){
                    if ( result['isSuccessful'] ) {
                    	setTimeout(function(){
                    		window.location.reload();//刷新当前页面.
                    		},10000)
                    } else {
                        alert('在重新评测时发生了一些错误.');
                    }
                    $('button.btn-danger').removeAttr('disabled');
                    $('button.btn-danger').html('重新评测');
                }
            });
        }
    </script>
    <c:if test="${submission.judgeResult.judgeResultName == 'Pending'}">
    <script type="text/javascript">
        $.getScript('/web/assets/js/date-zh_CN.min.js', function() {
            var currentJudgeResult = 'Pending',
                getterInterval     = setInterval(function() {
                    getRealTimeJudgeResult();
                    currentJudgeResult = $('#judge-result').html();

                    if ( currentJudgeResult != 'Pending' ) {
                        clearInterval(getterInterval);
                    }
                }, 10000);
        });
    </script>
    <script type="text/javascript">
        $(function() {
            var subscriptionUrl = '<c:url value="/submission/getRealTimeJudgeResult.action?submissionId=${submission.submissionId}&csrfToken=${csrfToken}" />',
                source          = new EventSource(subscriptionUrl),
                lastMessage     = '';

            source.onmessage    = function(e) {
                var message     = e['data'];

                if ( message == lastMessage ) {
                    return;
                }
                lastMessage     = message;

                if ( message == 'Established' ) {
                    $('#judge-log').append('<p>Connected to Server.</p>');
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
</body>
</html>