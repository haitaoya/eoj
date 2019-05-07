<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>试题列表| ${websiteName}</title>
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
    <link rel="stylesheet" type="text/css" href="/web/assets/css/problems/problems.css" />
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
        <div  class="row-fluid">
     	 <div id="sidebar" class="span12">
                <div id="search-widget" class="widget span12">
                	<div id="locator" class="span6">
         		   <ul class="inline">
          		      <li><h4 style="margin:10px 0">定位题号: </h4></li>
            		    <c:forEach var="locatorID" begin="${startIndexOfProblems}" end="${startIndexOfProblems + totalProblems}" step="${numberOfProblemsPerPage}">
             		   <li><a href="<c:url value="/p?start=${locatorID}" />">P${locatorID}</a></li>
              		  </c:forEach>
           		 </ul>
       		 </div> <!-- #locator -->
                    <form id="search-form" action="<c:url value="/p" />" class="span6">
                        <div class="control-group span5">
                            <input id="keyword" name="keyword"  class="span12" type="text" placeholder="试题关键字" value="${param.keyword}" />
                        </div>
                        &nbsp;
                   		 <select id="category" name="category"  class="span5">
                   		 	  <option value="" disabled selected>试题分类</option>
                   		 	  	<!-- 一级目录 遍历 -->
	                  			  <c:forEach var="entry" items="${problemCategories}">
	                  			  	 <c:if test="${param.category == entry.key.problemCategorySlug}">
										<option value="${entry.key.problemCategorySlug}" selected>${entry.key.problemCategoryName}</option>
									 </c:if>
									 <!-- 二级目录 遍历 -->
									 <c:forEach var="problemCategory" items="${entry.value}">
	                          		  <c:if test="${param.category == problemCategory.problemCategorySlug}">
										<option value="${problemCategory.problemCategorySlug}" selected>${problemCategory.problemCategoryName}</option>
									 </c:if>
									  <c:if test="${param.category != problemCategory.problemCategorySlug}">
									  	<option value="${problemCategory.problemCategorySlug}">${problemCategory.problemCategoryName}</option>
									  </c:if>
	                        		</c:forEach>
								 <c:if test="${param.category != entry.key.problemCategorySlug}">
                     			   <option value="${entry.key.problemCategorySlug}">${entry.key.problemCategoryName}</option>
                  			 	 </c:if>
                  			  </c:forEach>
                  		  </select>
                        <button class="btn btn-primary btn-block pull-right span2" type="submit">查询</button>
                    </form> <!-- #search-form -->
                </div> <!-- #search-widget -->
            </div> <!-- #sidebar -->
            </div>
            <div id="main-content" class="row-fluid">
            <div id="problems" class="span12">
                <table class="table table-striped">
                    <thead>
                        <tr>
                        <c:if test="${isLogin}">
                            <th class="flag">状态</th>
                        </c:if>
                            <th class="name">标题</th>
                            <th class="tag">标签</th>
                            <th class="submission">提交</th>
                            <th class="ac-rate">AC%</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="problem" items="${problems}">
                        <tr data-value="${problem.problemId}">
                        <c:if test="${isLogin}">
                            <c:choose>
                                <c:when test="${submissionOfProblems[problem.problemId] == null}"><td></td></c:when>
                                <c:otherwise>
                                    <td class="flag-${submissionOfProblems[problem.problemId].judgeResult.judgeResultSlug}">
                                        <a href="<c:url value="/submission/${submissionOfProblems[problem.problemId].submissionId}" />">
                                            ${submissionOfProblems[problem.problemId].judgeResult.judgeResultSlug}
                                        </a>
                                    </td>
                                </c:otherwise>
                            </c:choose>
                        </c:if>
                            <td class="name"><a href="<c:url value="/p/${problem.problemId}" />">P${problem.problemId} ${problem.problemName}</a></td>
                            <td class="tag">
                            <c:choose>
                                <c:when test="${problemTagRelationships[problem.problemId] == null}"></c:when>
                                <c:otherwise>
                                <c:forEach var="problemTag" items="${problemTagRelationships[problem.problemId]}" varStatus="loop">
                                    <a href="<c:url value="/p?tag=${problemTag.problemTagSlug}" />">
                                        ${problemTag.problemTagName}
                                    </a><c:if test="${!loop.last}">, </c:if>
                                </c:forEach>
                                </c:otherwise>
                            </c:choose>
                            </td>
                            <td>${problem.totalSubmission}</td>
                            <td>
                            <c:choose>
                                <c:when test="${problem.totalSubmission == 0}">0%</c:when>
                                <c:otherwise>
                                	<!-- 求百分率 -->
                                    <fmt:formatNumber type="number"  maxFractionDigits="0" value="${problem.acceptedSubmission * 100 / problem.totalSubmission}" />%
                                </c:otherwise>
                            </c:choose>
                            </td>
                        </tr>
                        </c:forEach>
                    </tbody>
                </table>
                <div id="more-problems">
                    <p class="availble">加载更多</p>
                    <img src="/web/assets/img/loading.gif" alt="Loading" class="hide" />
                </div>
            </div> <!-- #problems -->
            
        </div> <!-- #main-content -->
    </div> <!-- #content -->
    <!-- Footer -->
    <%@ include file="/WEB-INF/views/include/footer.jsp" %>
    <!-- Java Script -->
    <!-- Placed at the end of the document so the pages load faster -->
    <script type="text/javascript" src="/web/assets/js/site.js"></script>
    <script type="text/javascript">
        $(function() {
            var numberOfProblems = $('tr', '#problems tbody').length;

            if ( numberOfProblems == 0 ) {
                return processProblemsResult(false);
            } 
        });
    </script>
    <script type="text/javascript">
        function setLoadingStatus(isLoading) {
            if ( isLoading ) {
                $('p', '#').addClass('hide');
                $('img', '#').removeClass('hide');
            } else {
                $('img', '#').addClass('hide');
                $('p', '#').removeClass('hide');
            }
        }
    </script>
    <script type="text/javascript">
        $('#more-problems').click(function(event) {
            var isLoading         = $('img', this).is(':visible'),
                hasNextRecord     = $('p', this).hasClass('availble'),
                lastProblemRecord = $('tr:last-child', '#problems tbody'),
                lastProblemId     = parseInt($(lastProblemRecord).attr('data-value'));

            if ( !isLoading && hasNextRecord ) {
                setLoadingStatus(true);
                return getMoreProblems(lastProblemId + 1);
            }
        });
    </script>
    <script type="text/javascript">
        function getMoreProblems(startIndex) {
            var pageRequests = {
                'startIndex': startIndex,
                'keyword': '${param.keyword}',
                'category': '${param.category}',
                'tag': '${param.tag}'
            };

            $.ajax({
                type: 'GET',
                url: '<c:url value="/p/getProblems.action" />',
                data: pageRequests,
                dataType: 'JSON',
                success: function(result){
                    return processProblemsResult(result);
                }
            });
        }
    </script>
    <script type="text/javascript">
        function processProblemsResult(result) {
            if ( result['isSuccessful'] ) {
                displayProblemsRecords(result['problems'], result['submissionOfProblems'], result['problemTagRelationships']);
            } else {
            	console.log("false");
                $('p', '#more-problems').removeClass('availble');
                $('p', '#more-problems').html('已加载全部试题');
                $('#more-problems').css('cursor', 'default');
            }
            setLoadingStatus(false);
        }
    </script>
    <script type="text/javascript">
        function displayProblemsRecords(problems, submissionOfProblems,problemTagRelationships) {
            for ( var i = 0; i < problems.length; ++ i ) {
                $('table > tbody', '#problems').append(
                		/* 时有时无的参数放在末尾，不影响其他参数传值 */
                    getProblemContent(problems[i]['problemId'], problems[i]['problemName'], 
                                      problems[i]['totalSubmission'], problems[i]['acceptedSubmission'], problemTagRelationships,submissionOfProblems)
                );
            }
        }
    </script>
    <script type="text/javascript">
    <c:choose>
    <c:when test="${isLogin}">
        function getProblemContent(problemId, problemName, totalSubmission, acceptedSubmission, problemTagRelationships,submissionOfProblems) {
            var problemTemplate = '<tr data-value="%s">' +
                                  '    %s' +
                                  '    <td class="name"><a href="<c:url value="/p/%s" />">P%s %s</a></td>' +
                                  '	   %s' +
                                  '    <td>%s</td>' +
                                  '    <td>%s%</td>' +
                                  '</tr>';

            return problemTemplate.format(problemId, getSubmissionOfProblemHtml(problemId, submissionOfProblems[problemId]),
                        problemId, problemId, problemName,getTagsOfProblemHtml(problemId,problemTagRelationships[problemId]),totalSubmission, getAcRate(acceptedSubmission, totalSubmission));
        }
    </c:when>
    <c:otherwise>
        function getProblemContent(problemId, problemName, totalSubmission, acceptedSubmission,problemTagRelationships) {
            var problemTemplate = '<tr data-value="%s">' +
                                  '    <td class="name"><a href="<c:url value="/p/%s" />">P%s %s</a></td>' +
                                  '	   %s'  +
                                  '    <td>%s</td>' +
                                  '    <td>%s%</td>' +
                                  '</tr>';
            return problemTemplate.format(problemId, problemId, problemId, problemName, getTagsOfProblemHtml(problemId,problemTagRelationships[problemId]),
                        totalSubmission, getAcRate(acceptedSubmission, totalSubmission));
        }
    </c:otherwise>
    </c:choose>
    </script>
    <script type="text/javascript">
        function getSubmissionOfProblemHtml(problemId, submissionOfProblem) {
            if ( typeof(submissionOfProblem) == 'undefined' ) {
                return '<td></td>';
            }

            var submissionId        = submissionOfProblem['submissionId'],
                judgeResultSlug     = submissionOfProblem['judgeResult']['judgeResultSlug'],
                submissionTemplate  = '<td class="flag-%s">' +
                                      '    <a href="<c:url value="/submission/%s" />">%s</a>' +
                                      '</td>';

            return submissionTemplate.format(judgeResultSlug, submissionId, judgeResultSlug);
        }
        </script>
        <script type="text/javascript">
        function getTagsOfProblemHtml(problemId, ListTagsOfProblem) {
            if ( typeof(ListTagsOfProblem) == 'undefined' ) {
                return '<td></td>';
            }
            var tagTemplate = '<td>';
			for(var i=0 ; i<ListTagsOfProblem.length; i++){
				var problemTagSlug = ListTagsOfProblem[i]['problemTagSlug'],
					problemTagName = ListTagsOfProblem[i]['problemTagName'];
				tagTemplate += '<a href="<c:url value="/p?tag=%s" />">%s</a>'; 
				 if(i!=ListTagsOfProblem.length-1)
					 tagTemplate += ',';
				 else
					 tagTemplate += '</td>';
			}
            return tagTemplate.format(problemTagSlug, problemTagName);
        }
    </script>
    <script type="text/javascript">
        function getAcRate(acceptedSubmission, totalSubmission) {
            if ( totalSubmission == 0 ) {
                return 0;
            }
            return Math.round(acceptedSubmission / totalSubmission) * 100;
        }
    </script>
    <c:if test="${GoogleAnalyticsCode != ''}">
    ${googleAnalyticsCode}
    </c:if>
</body>
</html>