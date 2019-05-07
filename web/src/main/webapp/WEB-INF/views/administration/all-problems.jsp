<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="zh_CN" />
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html lang="zh_CN">
<head>
    <meta charset="UTF-8">
    <title>所有试题 | ${websiteName}</title>
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
    <link rel="stylesheet" type="text/css" href="/web/assets/css/administration/all-problems.css" />
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
                <h2 class="page-header"><i class="fa fa-question-circle"></i>所有试题</h2>
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
                        <form action="<c:url value="/administration/all-problems" />" method="GET" class="row-fluid">
                            <div class="span5">
                                <div class="control-group">
                                    <input id="keyword" name="keyword" class="span12" type="text" placeholder="关键字" value="${keyword}" />
                                </div> <!-- .control-group -->
                            </div> <!-- .span5 -->
                            <div class="span5">
                                <select name="problemCategory" id="problem-category">
                                    <option value="">所有分类</option>
                                <c:forEach var="problemCategory" items="${problemCategories}">
                                    <option value="${problemCategory.problemCategorySlug}" <c:if test="${problemCategory.problemCategorySlug == selectedProblemCategory}">selected</c:if> >${problemCategory.problemCategoryName}</option>
                                </c:forEach>
                                </select>
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
                                <label class="checkbox" for="all-problems">
                                    <input id="all-problems" type="checkbox" data-toggle="checkbox">
                                </label>
                            </th>
                            <th class="problem-id">#</th>
                            <th class="problem-is-public">公开/私有</th>
                            <th class="problem-name">标题</th>
                            <th class="problem-categories">分类</th>
                            <th class="problem-tags">标签</th>
                            <th class="total-submission">提交数</th>
                            <th class="accepted-submission">通过数</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="problem" items="${problems}">
                        <tr data-value="${problem.problemId}">
                            <td class="check-box">
                                <label class="checkbox" for="problem-${problem.problemId}">
                                    <input id="problem-${problem.problemId}" type="checkbox" value="${problem.problemId}" data-toggle="checkbox" />
                                </label>
                            </td>
                            <td class="problem-id">
                                <a href="<c:url value="/administration/edit-problem/${problem.problemId}" />">${problem.problemId}</a>
                            </td>
                            <td class="problem-is-public">
                            <c:choose>
                                <c:when test="${problem.isPublic()}">公开</c:when>
                                <c:otherwise>私有</c:otherwise>
                            </c:choose>
                            </td>
                            <td class="problem-name"><a href="<c:url value="/administration/edit-problem/${problem.problemId}" />">${problem.problemName}</a></td>
                            <td class="problem-categories">
                            <c:choose>
                                <c:when test="${problemCategoryRelationships[problem.problemId] == null}"></c:when>
                                <c:otherwise>
                                <c:forEach var="problemCategory" items="${problemCategoryRelationships[problem.problemId]}" varStatus="loop">
                                    <a href="<c:url value="/administration/all-problems?problemCategory=${problemCategory.problemCategorySlug}" />">
                                        ${problemCategory.problemCategoryName}
                                    </a><c:if test="${!loop.last}">, </c:if>
                                </c:forEach>
                                </c:otherwise>
                            </c:choose>
                            </td>
                            <td class="problem-tags">
                            <c:choose>
                                <c:when test="${problemTagRelationships[problem.problemId] == null}"></c:when>
                                <c:otherwise>
                                <c:forEach var="problemTag" items="${problemTagRelationships[problem.problemId]}" varStatus="loop">
                                    <a href="<c:url value="/administration/all-problems?problemTag=${problemTag.problemTagSlug}" />">
                                        ${problemTag.problemTagName}
                                    </a><c:if test="${!loop.last}">, </c:if>
                                </c:forEach>
                                </c:otherwise>
                            </c:choose>
                            </td>
                            <td class="total-submission">${problem.totalSubmission}</td>
                            <td class="accepted-submission">${problem.acceptedSubmission}</td>
                        </tr>
                        </c:forEach>
                    </tbody>
                </table>
                <div id="pagination" class="pagination pagination-centered">
                    <c:set var="lowerBound" value="${currentPage - 5 > 0 ? currentPage - 5 : 1}" />
                    <c:set var="upperBound" value="${currentPage + 5 < totalPages ? currentPage + 5 : totalPages}" />
                    <c:set var="baseUrl" value="/administration/all-problems?keyword=${keyword}&problemCategory=${selectedProblemCategory}" />
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
        $('label[for=all-problems]').click(function() {
            // Fix the bug for Checkbox in FlatUI 
            var isChecked = false;
            setTimeout(function() {
                isChecked = $('label[for=all-problems]').hasClass('checked');
                
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

            var problems    = [],
                action      = $('#actions').val();

            $('label.checkbox', 'table tbody').each(function() {
                if ( $(this).hasClass('checked') ) {
                    var problemId = $('input[type=checkbox]', $(this)).val();
                    problems.push(problemId);
                }
            });

            if ( action == 'delete' ) {
                return doDeleteProblemsAction(problems);
            }
        });
    </script>
    <script type="text/javascript">
        function doDeleteProblemsAction(problems) {
            var postData = {
                'problems': JSON.stringify(problems)
            };

            $.ajax({
                type: 'POST',
                url: '<c:url value="/administration/deleteProblems.action" />',
                data: postData,
                dataType: 'JSON',
                success: function(result){
                    if ( result['isSuccessful'] ) {
                        for ( var i = 0; i < problems.length; ++ i ) {
                            $('tr[data-value=%s]'.format(problems[i])).remove();
                        }
                    } else {
                        $('.alert').html('在删除试题的过程中发生了一些错误.');
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