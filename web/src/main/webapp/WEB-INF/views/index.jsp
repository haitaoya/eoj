<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>首页 | ${websiteName}</title>
    <meta name="author" content="Haitao Wang">
    <!-- Icon -->
    <link href="/web/assets/img/favicon.ico" rel="shortcut icon" type="image/x-icon">
    <!-- StyleSheets -->
    <link rel="stylesheet" type="text/css" href="/web/assets/css/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="/web/assets/css/bootstrap-responsive.min.css" />
    <link rel="stylesheet" type="text/css" href="/web/assets/css/font-awesome.min.css" />
    <link rel="stylesheet" type="text/css" href="/web/assets/css/style.css" />
    <link rel="stylesheet" type="text/css" href="/web/assets/css/misc/homepage.css" />
    <!-- JavaScript -->
    <script type="text/javascript" src="/web/assets/js/jquery-1.11.1.min.js"></script>
    <script type="text/javascript" src="/web/assets/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="/web/assets/js/bootstrap-table.min.js"></script>
    <script type="text/javascript" src="/web/assets/js/bootstrap-table-zh-CN.min.js"></script>
    <script type="text/javascript" src="/web/assets/js/md5.min.js"></script>
        <!--[if lte IE 9]>
        <script type="text/javascript" src="${cdnUrl}/js/jquery.placeholder.min.js"></script>
    <![endif]-->
    <!--[if lte IE 7]>
        <link rel="stylesheet" type="text/css" href="${cdnUrl}/css/font-awesome-ie7.min.css" />
    <![endif]-->
    <!--[if lte IE 6]>
        <script type="text/javascript"> 
            window.location.href='<c:url value="/not-supported" />';
        </script>
    <![endif]-->
</head>
<body>
    <!-- Header -->
    <%@ include file="/WEB-INF/views/include/header.jsp" %>
    <!-- Content -->
    <div id="content" class="container">
        <div class="row-fluid container">
          <div id="welcome" class="span12">
            </div> <!-- #welcome -->
        </div> <!-- .row-fluid container -->
        
        <div class="row-fluid container">
          <div id="sidebar" class="span12">
                <div id="bulletin-board" class="widget">
                    <h4>公告板</h4>
                <c:choose>
                <c:when test="${bulletinBoardMessages != null and bulletinBoardMessages.size() > 0}">
                    <ul id="bulletin-board-messages">
                    <c:forEach var="bulletinBoardMessage" items="${bulletinBoardMessages}">
                        <li>
                            <a href="javascript:void(0);">
                                <span class="message-create-time">[<fmt:formatDate value="${bulletinBoardMessage.messageCreateTime}" type="date" dateStyle="short" />]</span>
                                <span class="message-title">${bulletinBoardMessage.messageTitle}</span>
                                <p class="message-body hide">${bulletinBoardMessage.messageBody}</p>
                            </a>
                        </li>
                    </c:forEach>
                    </ul>
                </c:when>
                <c:otherwise>
                    <p>暂无通知</p>
                </c:otherwise>
                </c:choose>
                </div> <!-- #kanban -->
            </div> <!-- #sidebar -->
        </div> <!-- .row-fluid -->
	 
    </div> <!-- #content -->
	 <!-- 公告详情 -->
    <div id="bulletin-board-message-modal" class="modal hide fade">
        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            <h5 class="message-title"></h5>
        </div> <!-- .modal-header -->
        <div class="modal-body">
            <div class="message-body"></div> <!-- .message-body -->
        </div> <!-- .modal-body -->
    </div> <!-- #bulletin-board-message-modal -->


    
    <!-- Footer -->
    <%@ include file="/WEB-INF/views/include/footer.jsp" %>
    <!-- Java Script -->
    <script type="text/javascript" src="/web/assets/js/site.js"></script>
    
    <script type="text/javascript">
    	<!-- 公告详情 -->
        $('li', '#bulletin-board-messages').click(function() {
            var messageTitle = $('.message-title', this).html(),
                messageBody  = $('.message-body', this).html();
			console.log(messageBody);
            $('.message-title', '#bulletin-board-message-modal').html(messageTitle);
            $('.message-body', '#bulletin-board-message-modal').html(messageBody.replace('\n', '<br><br>'));
            $('#bulletin-board-message-modal').modal();
        });

    </script>
</body>
</html>