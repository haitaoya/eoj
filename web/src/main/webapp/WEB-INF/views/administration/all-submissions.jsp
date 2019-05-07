<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="zh_CN" />
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html lang="zh_CN">
<head>
    <meta charset="UTF-8">
    <title>提交记录 | ${websiteName}</title>
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
    <link rel="stylesheet" type="text/css" href="/web/assets/css/administration/all-submissions.css" />
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
        <%@ include file="/WEB-INF/views/administration/include/sidebar.jsp" %>
        <div id="container">
            <!-- Header -->
            <%@ include file="/WEB-INF/views/administration/include/header.jsp" %>
            <!-- Content -->
            <div id="content">
                <h2 class="page-header"><i class="fa fa-code"></i> 提交记录</h2>
                <div class="alert alert-error hide"></div> <!-- .alert-error -->
                <div id="filters" class="row-fluid">
                    <div class="span6">
                        <select id="actions">
                            <option value="delete">删除</option>
                            <option value="restart">重新评测</option>
                        </select>
                        <button class="btn btn-danger">应用</button>
                    </div> <!-- .span6 -->
                    <div class="span6">
                        <form class="row-fluid text-right" action="<c:url value="/administration/all-submissions" />">
                            <div class="span5">
                                <div class="control-group">
                                    <input id="problem-id" name="problemId" class="span12" value="<c:if test="${problemId != 0}">${problemId}</c:if>" placeholder="试题ID" type="text" />
                                </div> <!-- .control-group -->
                            </div> <!-- .span5 -->
                            <div class="span5">
                                <div class="control-group">
                                    <input id="username" name="username" class="span12" value="${username}" placeholder="用户名" type="text" />
                                </div> <!-- .control-group -->
                            </div> <!-- .span5 -->
                            <div class="span2">
                                <button class="btn btn-primary">筛选</button>
                            </div> <!-- .span2 -->
                        </form> <!-- .row-fluid -->
                    </div> <!-- .span6 -->
                </div> <!-- .row-fluid -->
                <table class="table table-striped">
                    <thead>
                        <tr>
                            <th class="check-box">
                                <label class="checkbox" for="all-submissions">
                                    <input id="all-submissions" type="checkbox" data-toggle="checkbox">
                                </label>
                            </th>
                            <th class="flag">运行结果</th>
                            <th class="score">分数</th>
                            <th class="time">时间</th>
                            <th class="memory">内存</th>
                            <th class="name">标题</th>
                            <th class="user">用户名</th>
                            <th class="language">语言</th>
                            <th class="submit-time">提交时间</th>
                            <th class="execute-time">评测时间</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="submission" items="${submissions}">
                        <tr data-value="${submission.submissionId}">
                            <td class="check-box">
                                <label class="checkbox" for="submission-${submission.submissionId}">
                                    <input id="submission-${submission.submissionId}" type="checkbox" value="${submission.submissionId}" data-toggle="checkbox" />
                                </label>
                            </td>
                            <td class="flag flag-${submission.judgeResult.judgeResultSlug}"><a href="<c:url value="/administration/edit-submission/${submission.submissionId}" />">${submission.judgeResult.judgeResultName}</a></td>
                            <td class="score">${submission.judgeScore}</td>
                            <td class="time">${submission.usedTime} ms</td>
                            <td class="memory">${submission.usedMemory} K</td>
                            <td class="name"><a href="<c:url value="/administration/edit-problem/${submission.problem.problemId}" />">P${submission.problem.problemId} ${submission.problem.problemName}</a></td>
                            <td class="user"><a href="<c:url value="/administration/edit-user/${submission.user.uid}" />">${submission.user.username}</a></td>
                            <td class="language">${submission.language.languageName}</td>
                            <td class="submit-time">
                                <fmt:formatDate value="${submission.submitTime}" type="both" dateStyle="default" timeStyle="default" />
                            </td>
                            <td class="execute-time">
                                <fmt:formatDate value="${submission.executeTime}" type="both" dateStyle="default" timeStyle="default" />
                            </td>
                        </tr>
                        </c:forEach>
                    </tbody>
                </table>
                <div id="pagination" class="pagination pagination-centered">
                    <c:set var="lowerBound" value="${currentPage - 5 > 0 ? currentPage - 5 : 1}" />
                    <c:set var="upperBound" value="${currentPage + 5 < totalPages ? currentPage + 5 : totalPages}" />
                    <c:set var="baseUrl" value="/administration/all-submissions?problemId=${problemId}&username=${username}" />
                    <ul>
                        <li class="previous <c:if test="${currentPage <= 1}">disabled</c:if>">
                        <a href="
                        <c:choose>
                            <c:when test="${currentPage <= 1}">javascript:void(0);</c:when>
                            <c:otherwise><c:url value="${baseUrl}&page=${currentPage - 1}" /></c:otherwise>
                        </c:choose>
                        ">&lt;</a>
                        </li>
                        <c:forEach begin="${lowerBound}" end="${upperBound}" var="pageNumber">
                        <li <c:if test="${pageNumber == currentPage}">class="active"</c:if>><a href="<c:url value="${baseUrl}&page=${pageNumber}" />">${pageNumber}</a></li>
                        </c:forEach>
                        <li class="next <c:if test="${currentPage >= totalPages}">disabled</c:if>">
                        <a href="
                        <c:choose>
                            <c:when test="${currentPage >= totalPages}">javascript:void(0);</c:when>
                            <c:otherwise><c:url value="${baseUrl}&page=${currentPage + 1}" /></c:otherwise>
                        </c:choose>
                        ">&gt;</a>
                        </li>
                    </ul>
                </div> <!-- #pagination-->
            </div> <!-- #content -->
        </div> <!-- #container -->
    </div> <!-- #wrapper -->
    <!-- Java Script -->
    <!-- Placed at the end of the document so the pages load faster -->
    <%@ include file="/WEB-INF/views/administration/include/footer-script.jsp" %>
    <script type="text/javascript">
        $('label[for=all-submissions]').click(function() {
            // Fix the bug for Checkbox in FlatUI 
            var isChecked = false;
            setTimeout(function() {
                isChecked = $('label[for=all-submissions]').hasClass('checked');
                
                if ( isChecked ) {
                    $('label.checkbox').addClass('checked');
                } else {
                    $('label.checkbox').removeClass('checked');
                }
            }, 100);
        });
    </script>
    <script type="text/javascript">
        $('button.btn-danger', '#filters').click(function() {
            if ( !confirm('你确定要继续吗?') ) {
                return;
            }
            $('.alert-error').addClass('hide');
            $('button.btn-danger', '#filters').attr('disabled', 'disabled');
            $('button.btn-danger', '#filters').html('请稍后...');

            var submissions = [],
                action      = $('#actions').val();

            $('label.checkbox', 'table tbody').each(function() {
                if ( $(this).hasClass('checked') ) {
                    var submissionId = $('input[type=checkbox]', $(this)).val();
                    submissions.push(submissionId);
                }
            });

            if ( action == 'delete' ) {
                return doDeleteSubmissionsAction(submissions);
            } else if ( action == 'restart' ) {
                return doRestartSubmissionsAction(submissions);
            }
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
                        var deletedSubmissions = result['deletedSubmissions'];
                        $('.alert').html('删除成功.');
                        $('.alert').removeClass('hide');
                        for ( var i = 0; i < deletedSubmissions.length; ++ i ) {
                            $('tr[data-value=%s]'.format(deletedSubmissions[i])).remove();
                        }
                    } else {
                        $('.alert').html('在删除评测记录的过程中发生了一些错误.');
                        $('.alert').removeClass('hide');
                    }
                    $('button.btn-danger', '#filters').removeAttr('disabled');
                    $('button.btn-danger', '#filters').html('应用');
                },
                error:function(errorThrown){
                	 $('.alert').html('在删除评测记录的过程中发生了一些错误.(无法删除竞赛中提交的记录)');
                     $('.alert').removeClass('hide');
                     $('button.btn-danger', '#filters').removeAttr('disabled');
                     $('button.btn-danger', '#filters').html('应用');
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
                        for ( var i = 0; i < submissions.length; ++ i ) {
                            var submission  = $('tr[data-value=%s]'.format(submissions[i])),
                                judgeResult = $('td.flag', $(submission)); 

                            $(judgeResult).removeClass();
                            $(judgeResult).addClass('flag flag-PD');
                            $('a', $(judgeResult)).html('Pending');
                        }
                    } else {
                        $('.alert').html('在重新评测的过程中发生了一些错误.');
                        $('.alert').removeClass('hide');
                    }
                    $('button.btn-danger', '#filters').removeAttr('disabled');
                    $('button.btn-danger', '#filters').html('应用');
                    setTimeout(function(){
                    	window.location.reload();//刷新当前页面.
                    },10000);
                }
            });
        }
    </script>
</body>
</html>