<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<spring:eval expression="@propertyConfigurer.getProperty('url.cdn')" var="cdnUrl" />
<spring:eval expression="@propertyConfigurer.getProperty('build.version')" var="version" />
<!DOCTYPE html>
<html lang="zh_CN">
<head>
    <meta charset="UTF-8">
    <title>评测机 | ${websiteName}</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="${description}">
    <meta name="author" content="Haitao Wang">
    <!-- Icon -->
    <link href="/web/assets/img/favicon.ico" rel="shortcut icon" type="image/x-icon">
    <!-- StyleSheets -->
    <link rel="stylesheet" type="text/css" href="/web/assets/css/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="/web/assets/css/bootstrap-responsive.min.css" />
    <link rel="stylesheet" type="text/css" href="/web/assets/css/flat-ui.min.css" />
    <link rel="stylesheet" type="text/css" href="/web/assets/css/font-awesome.min.css" />
    <link rel="stylesheet" type="text/css" href="/web/assets/css/style.css" />
    <link rel="stylesheet" type="text/css" href="/web/assets/css/misc/about.css" />
    <style type="text/css">
        table th.key,
        table td.key {
            width: 20%;
        }

        table th.value,
        table td.value {
            width: 80%;
        }

        span.online {
            color: #f00;
        }
    </style>
    <!-- JavaScript -->
    <script type="text/javascript" src="/web/assets/js/jquery-1.11.1.min.js"></script>
    <script type="text/javascript" src="/web/assets/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="/web/assets/js/md5.min.js"></script>
</head>
<body>
    <!-- Header -->
    <%@ include file="/WEB-INF/views/include/header.jsp" %>
    <!-- Content -->
    <div id="content">
        <div id="ribbon"></div> <!-- #ribbon -->
        <div class="container">
            <div class="row-fluid">
            <div class="span2">
                    <div id="sidebar-nav">
                        <h5>评测机信息</h5>
                        <ul class="contents">
                            <li><a href="#compile-command">编译命令</a></li>
                            <li><a href="#judgers">评测机信息</a></li>
                        </ul>
                    </div> <!-- #sidebar-nav -->
                </div> <!-- .span2 -->
                <div class="span9">
                    <div id="main-content">
                        <div class="section">
                            <h3 id="browsers">编译命令</h3>
                            <table class="table table-striped">
                                <thead>
                                    <tr>
                                        <th class="key">语言</th>
                                        <th class="value">编译命令</th>
                                    </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="language" items="${languages}">
                                    <tr>
                                        <td>${language.languageName}</td>
                                        <td>${language.compileCommand}</td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div> <!-- .section -->
                        <div class="section">
                            <h3 id="judgers">评测机</h3>
                            <p id="no-judgers">暂无评测机</p>
                            <table id="judgers-list" class="table table-striped hide">
                                <thead>
                                    <tr>
                                        <th class="key">名称</th>
                                        <th class="value">状态描述</th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div> <!-- .section -->
                    </div> <!-- #main-content -->
                </div> <!-- .span10 -->
            </div> <!-- .row-fluid -->
        </div> <!-- .container -->
    </div> <!-- #content -->
    <!-- Footer -->
    <%@ include file="/WEB-INF/views/include/footer.jsp" %>
    <!-- Java Script -->
    <!-- Placed at the end of the document so the pages load faster -->
    <script type="text/javascript" src="/web/assets/js/site.js"></script>
    <script type="text/javascript">
        $(function() {
            $.ajax({
                type: 'GET',
                url: '<c:url value="/getJudgers.action" />',
                dataType: 'JSON',
                success: function(result){
                    if ( result['isSuccessful'] ) {
                        processResult(result['judgers']);

                        $('#no-judgers').addClass('hide');
                        $('#judgers-list').removeClass('hide');
                    }
                }
            });
        });
    </script>
    <script type="text/javascript">
        function processResult(judgers) {
            for ( var i = 0; i < judgers.length; ++ i ) {
                $('#judgers-list').append(
                    getJudgerContent(judgers[i]['username'], judgers[i]['description'])
                );
            }
        }
    </script>
    <script type="text/javascript">
        function getJudgerContent(username, description) {
            var judgerInfoTemplate = '<tr>' + 
                                     '    <td>%s</td>' +
                                     '    <td>%s</td>' +
                                     '</tr>';

            description = description.replace('[Online]', '<span class="online">工作中</span>');
            description = description.replace('[Offline]', '<span class="offline">已离线</span>');
            return judgerInfoTemplate.format(username, description);
        }
    </script>
    <script type="text/javascript"></script>
    <c:if test="${GoogleAnalyticsCode != ''}">
    ${googleAnalyticsCode}
    </c:if>
</body>
</html>