<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="zh_CN" />
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="zh_CN">
<head>
    <meta charset="UTF-8">
    <title>用户信息: ${user.username} | ${websiteName}</title>
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
    <link rel="stylesheet" type="text/css" href="/web/assets/css/accounts/user.css" />
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
            <div id="sidebar" class="span12">
                <div id="vcard" class="section">
                  <h2> <img src="/web/assets/img/user-plus.png" alt="avatar"> ${user.username}</h2>
                </div> <!-- #vcard -->
            <c:if test="${not empty socialLinks && fn:length(socialLinks) > 0}">
                <div id="social-links" class="section">
                    <ul class="inline">
                    <c:if test="${not empty socialLinks['Weibo']}">
                        <li><a href="http://weibo.com/${socialLinks['Weibo']}" target="_blank" class="weibo" title="Weibo"><i class="fa fa-weibo"></i></a></li>
                    </c:if>
                    <c:if test="${not empty socialLinks['GitHub']}">
                        <li><a href="https://github.com/${socialLinks['GitHub']}" target="_blank" class="github" title="GitHub"><i class="fa fa-github"></i></a></li>
                    </c:if>
                    <c:if test="${not empty socialLinks['StackOverflow']}">
                        <li><a href="http://stackoverflow.com/users/${socialLinks['StackOverflow']}" target="_blank" class="stackoverflow" title="StackOverflow"><i class="fa fa-stack-overflow"></i></a></li>
                    </c:if>
                    </ul>
                </div> <!-- #social-links -->
            </c:if>
                <div id="vcard-details" class="section">
                    <ul>
                    <c:if test="${not empty location}">
                        <li><span class="icon"><i class="fa fa-map-marker"></i></span> ${location}</li>
                    </c:if>
                        <li><span class="icon"><i class="fa fa-envelope-o"></i></span> ${user.email}</li>
                    <c:if test="${not empty website}">
                        <li><span class="icon"><i class="fa fa-link"></i></span> <a href="${website}" target="_blank">${website}</a></li>
                    </c:if>
                        <li><span class="icon"><i class="fa fa-users"></i></span> ${user.userGroup.userGroupName}</li>
                        <li>
                            <span class="icon"><i class="fa fa-clock-o"></i></span> 
                          	  注册于
                            <fmt:parseDate pattern="yyyy-MM-dd HH:mm:ss" value="${registerTime}" var="parsedDateTime" />
                            <fmt:formatDate value="${parsedDateTime}" type="date" dateStyle="long" />
                        </li>
                    </ul>
                </div> <!-- vcard-details -->
                <div id="vcard-stats">
                    <div class="row-fluid">
                    	<div class="span4">
                            <h3>${submissionStats.get("totalSubmission")}</h3>
                             	提交
                        </div> <!-- .span4 -->
                        <div class="span4">
                            <h3>${submissionStats.get("acceptedSubmission")}</h3>
                        		    解决
                        </div> <!-- .span4 -->
                        <div class="span4">
                         <h3><c:choose>
                             <c:when test="${submissionStats.get('totalSubmission') == 0}">0%</c:when>
                             <c:otherwise>
                                 <fmt:formatNumber type="number"  maxFractionDigits="0" value="${submissionStats.get('acceptedSubmission') * 100 / submissionStats.get('totalSubmission')}" />%
                             </c:otherwise>
                         </c:choose></h3>
                         	正确率
                        </div><!-- .span4 -->
                    </div> <!-- .row-fluid -->
                </div> <!-- #vcard-stats -->
            </div> <!-- .span4 -->
            </div>
            <div class="row-fluid">
            <div id="main-content" class="span12">
            <c:if test="${not empty aboutMe}">
                <div class="section">
                    <div class="header">
                        <h3>个人简介</h3>
                    </div> <!-- .header -->
                    <div class="body markdown">${aboutMe}</div> <!-- .body -->
                </div> <!-- .section -->
            </c:if>
               
            </div> <!-- .span8 -->
        </div> <!-- .row-fluid -->
    </div> <!-- #content -->
    <!-- Footer -->
    <%@ include file="/WEB-INF/views/include/footer.jsp" %>
    <!-- JavaScript -->
    <!-- Placed at the end of the document so the pages load faster -->
    <script type="text/javascript" src="/web/assets/js/site.js"></script>
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
    <c:if test="${GoogleAnalyticsCode != ''}">
    ${googleAnalyticsCode}
    </c:if>
</body>
</html>