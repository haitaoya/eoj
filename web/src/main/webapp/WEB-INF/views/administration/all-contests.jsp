<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="zh_CN" />
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html lang="zh_CN">
<head>
    <meta charset="UTF-8">
    <title>所有竞赛 | ${websiteName}</title>
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
    <link rel="stylesheet" type="text/css" href="/web/assets/css/administration/all-contests.css" />
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
                <h2 class="page-header"><i class="fa fa-question-circle"></i>所有竞赛</h2>
                <div class="alert alert-error hide"></div> <!-- .alert-error -->
                <div id="filters" class="row-fluid">
                    <div class="span4">
                        <div class="row-fluid">
                            <div class="span8">
                                <select id="actions">
                                    <option value="delete">删除</option>
                                </select>
                            </div> <!-- .span8 -->
                            <div class="span4">
                                <button class="btn btn-danger span12">应用</button>
                            </div> <!-- .span4 -->
                        </div> <!-- .row-fluid -->
                    </div> <!-- .span4 -->
                    <div class="span8 text-right">
                        <form action="<c:url value="/administration/all-contests" />" method="GET" class="row-fluid">
                            <div class="span5">
                                <div class="control-group">
                                    <input id="keyword" name="keyword" class="span12" type="text" placeholder="关键字" value="${keyword}" />
                                </div> <!-- .control-group -->
                            </div> <!-- .span5 -->
                            <div class="span5">
                            </div> <!-- .span5 -->
                            <div class="span2">
                                <button class="btn btn-primary span12">筛选</button>
                            </div> <!-- .span2 -->
                        </form> <!-- .row-fluid -->
                    </div> <!-- .span8 -->
                </div> <!-- .row-fluid -->
                <table class="table table-striped">
                    <thead>
                        <tr>
                            <th class="check-box">
                                <label class="checkbox" for="all-contests">
                                    <input id="all-contests" type="checkbox" data-toggle="checkbox">
                                </label>
                            </th>
                            <th class="contest-id">#</th>
                            <th class="contest-name">竞赛名称</th>
                            <th class="contest-model">模式</th>
                            <th class="contest-starttime">开始时间</th>
                            <th class="contest-endtime">结束时间</th>
                            <th class="contest-status">状态</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="contest" items="${contests}">
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
                        <tr data-value="${contest.contestId}">
                            <td class="check-box">
                                <label class="checkbox" for="contest-${contest.contestId}">
                                    <input id="contest-${contest.contestId}" type="checkbox" value="${contest.contestId}" data-toggle="checkbox" />
                                </label>
                            </td>
                            <td class="contest-id">
                                <a href="<c:url value="/administration/edit-contest/${contest.contestId}" />">${contest.contestId}</a>
                            </td>
                            <td class="contest-name">
                             <a href="<c:url value="/administration/edit-contest/${contest.contestId}" />">${contest.contestName}</a>
                            </td>
                            <td class="contest-model">${contest.contestMode}</td>
                            <td class="contest-starttime">
                            <fmt:formatDate value="${contest.startTime}" type="both" dateStyle="default" timeStyle="default" />
                            </td>
                            <td class="contest-endtime">
                            <fmt:formatDate value="${contest.endTime}" type="both" dateStyle="default" timeStyle="default" />
                            </td>
                            <td class="contest-status">${contestStatus}</td>
                        </tr>
                        </c:forEach>
                    </tbody>
                </table>
                <div id="pagination" class="pagination pagination-centered">
                    <c:set var="lowerBound" value="${currentPage - 5 > 0 ? currentPage - 5 : 1}" />
                    <c:set var="upperBound" value="${currentPage + 5 < totalPages ? currentPage + 5 : totalPages}" />
                    <c:set var="baseUrl" value="/administration/all-contests?keyword=${keyword}" />
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
        $('label[for=all-contests]').click(function() {
            // Fix the bug for Checkbox in FlatUI 
            var isChecked = false;
            setTimeout(function() {
                isChecked = $('label[for=all-contests]').hasClass('checked');
                
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
            if ( !confirm('确定继续操作吗？') ) {
                return;
            }
            $('.alert-error').addClass('hide');
            $('button.btn-danger', '#filters').attr('disabled', 'disabled');
            $('button.btn-danger', '#filters').html('请稍后...');

            var contests    = [],
                action      = $('#actions').val();

            $('label.checkbox', 'table tbody').each(function() {
                if ( $(this).hasClass('checked') ) {
                    var contestId = $('input[type=checkbox]', $(this)).val();
                    contests.push(contestId);
                }
            });

            if ( action == 'delete' ) {
                return doDeletecontestsAction(contests);
            }
        });
    </script>
    <script type="text/javascript">
        function doDeletecontestsAction(contests) {
            var postData = {
                'contests': JSON.stringify(contests)
            };
            $.ajax({
                type: 'POST',
                url: '<c:url value="/administration/deleteContests.action" />',
                data: postData,
                dataType: 'JSON',
                success: function(result){
                    if ( result['isSuccessful'] ) {
                        for ( var i = 0; i < contests.length; ++ i ) {
                            $('tr[data-value=%s]'.format(contests[i])).remove();
                        }
                    } else {
                        $('.alert').html('在删除竞赛的过程中发生了一些错误.(该竞赛存在参赛者或者存在提交记录无法删除)');
                        $('.alert').removeClass('hide');
                    }
                    $('button.btn-danger', '#filters').removeAttr('disabled');
                    $('button.btn-danger', '#filters').html('应用');
                }
            });
        }
    </script>
</body>
</html>