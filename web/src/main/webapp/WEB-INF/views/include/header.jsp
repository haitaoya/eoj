<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<div id="header" class="container">
	<div class="row-fluid">
		<div id="logo" class="span6">
			<a href="<c:url value="/" />"> <img src="/web/assets/img/logo.png"
				alt="Logo" />
			</a>
		</div>
		<!-- #logo -->
		<div id="nav" class="span6">
			<ul class="inline">
				<li><a href="<c:url value="/p" />">试题</a></li>
				<li><a href="<c:url value="/contest" />">竞赛&作业</a></li>
				<li><a href="<c:url value="/rankList" />">排名</a></li>
				<li><a href="<c:url value="/submission" />">提交</a></li>
				<c:choose>
					<c:when test="${isLogin}">
						<li>|&nbsp;&nbsp;&nbsp;
						<img src="/web/assets/img/user.png" alt="avatar">
						<a href="<c:url value="/accounts/user/${myProfile.uid}" />">${myProfile.username}</a></li>
							<li><a href="<c:url value="/accounts/dashboard" />">个人中心</a></li>
							<li><a href="<c:url value="/accounts/login?logout=true" />">注销</a></li>
					</c:when>
					<c:otherwise>
							<li>|&nbsp;&nbsp;&nbsp;<a href="<c:url value="/accounts/login?forward=" />${requestScope['javax.servlet.forward.request_uri']}">登录</a></li>
							<li><a href="<c:url value="/accounts/register?forward=" />${requestScope['javax.servlet.forward.request_uri']}">注册</a></li>
					</c:otherwise>
				</c:choose>

			</ul>
		</div>
		<!-- #nav -->
	</div>
	<!-- .container -->
</div>
