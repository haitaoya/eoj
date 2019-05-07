<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title><spring:message code="eoj.accounts.register.title" text="Create Account" /> | ${websiteName}</title>
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
    <link rel="stylesheet" type="text/css" href="/web/assets/css/accounts/register.css" />
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
        <div id="register">
            <h2>注册 Easy OJ 用户</h2>
            <div class="alert alert-error hide"></div>
        <c:choose>
        <c:when test="${!isAllowRegister}">
            <div class="alert alert-warning">
                <h5>目前关闭注册</h5>
                <p>在线注册已关闭. 需要注册用户， 请联系管理员.</p>
            </div> <!-- .alert -->
        </c:when>
        <c:otherwise>
        <!--  return false; 目的是中止submit的动作 -->
            <form id="register-form" method="POST" onsubmit="onSubmit(); return false;">
                <p class="row-fluid">
                    <label for="username">用户名</label>
                    <input id="username" name="username" class="span12" type="text" maxlength="16" />
                </p>
                <p class="row-fluid">
                    <label for="email">邮箱地址</label>
                    <input id="email" name="email" class="span12" type="text" maxlength="64" />
                </p>
                <p class="row-fluid">
                    <label for="password">密码</label>
                    <input id="password" name="password" class="span12" type="password" maxlength="16" />
                </p>
                <p class="row-fluid">
                    <label for="language-preference">常用语言</label>
                    <select id="language-preference" class="span12">
                    <c:forEach var="language" items="${languages}">
                        <option value="${language.languageSlug}">${language.languageName}</option>
                    </c:forEach>
                    </select>
                </p>
                <br/>
                <p>
                    <input id="csrf-token" type="hidden" value="${csrfToken}" />
                    <button class="btn btn-primary btn-block" type="submit">注册用户</button>
                </p>
            </form> <!-- #register-form -->
        </c:otherwise>
        </c:choose>
        <p class="text-center">
            已有账号？
            <a href="<c:url value="/accounts/login" />" style="color:#08c"> 点击登录</a>
        </p>
        </div> <!-- #register -->
    </div> <!-- #content -->
    <!-- Footer -->
    <%@ include file="/WEB-INF/views/include/footer.jsp" %>
    <!-- JavaScript -->
    <!-- Placed at the end of the document so the pages load faster -->
    <script type="text/javascript" src="/web/assets/js/site.js"></script>
    <c:if test="${isAllowRegister}">
    <script type="text/javascript">
        function onSubmit() {
            $('.alert-error').addClass('hide');
            $('button[type=submit]').attr('disabled', 'disabled');
            $('button[type=submit]').html('请稍后...');
            
            var username            = $('#username').val(),
                password            = $('#password').val(),
                email               = $('#email').val(),
                languagePreference  = $('#language-preference').val(),
                csrfToken           = $('#csrf-token').val();
            
            return doRegisterAction(username, password, email, languagePreference, csrfToken);
        };
    </script>
    <script type="text/javascript">
        function doRegisterAction(username, password, email, languagePreference, csrfToken) {
            var postData = {
                'username': username,
                'password': password,
                'email': email,
                'languagePreference': languagePreference,
                'csrfToken': csrfToken
            };

            $.ajax({
                type: 'POST',
                url: '<c:url value="/accounts/register.action" />',
                data: postData,
                dataType: 'JSON',
                success: function(result){
                    return processRegisterResult(result);
                }
            });
        }
    </script>
    <script type="text/javascript">
        function processRegisterResult(result) {
            if ( result['isSuccessful'] ) {
                var forwardUrl = '${forwardUrl}' || '<c:url value="/" />';
                window.location.href = forwardUrl;
            } else {
                var errorMessage  = '';

                if ( !result['isCsrfTokenValid'] ) {
                    errorMessage += '无效的token<br>';
                }
                if ( result['isUsernameEmpty'] ) {
                    errorMessage += '请填写用户名.<br>';
                } else if ( !result['isUsernameLegal'] ) {
                    var username = $('#username').val();

                    if ( username.length < 6 || username.length > 16 ) {
                        errorMessage += '用户名的长度必须在6-16个字符之间.<br>';
                    } else if ( !username[0].match(/[a-z]/i) ) {
                        errorMessage += '用户名必须以字母(a-z)开头.<br>';
                    } else {
                        errorMessage += '用户名必须只包含字母(a-z), 数字和下划线(_).<br>';
                    }
                } else if ( result['isUsernameExists'] ) {
                    errorMessage += '用户名已被他人占用.<br>';
                }
                if ( result['isPasswordEmpty'] ) {
                    errorMessage += '请填写密码.<br>';
                } else if ( !result['isPasswordLegal'] ) {
                    errorMessage += '密码的长度必须在6-16个字符之间.<br>';
                }
                if ( result['isEmailEmpty'] ) {
                    errorMessage += '请填写电子邮件地址.<br>';
                } else if ( !result['isEmailLegal'] ) {
                    errorMessage += '电子邮件地址似乎是无效的.<br>';
                } else if ( result['isEmailExists'] ) {
                    errorMessage += '电子邮件地址已被他人占用.<br>';
                }
                if ( !result['isLanguageLegal'] ) {
                    errorMessage += '请选择语言偏好.<br>';
                }

                $('.alert-error').html(errorMessage);
                $('.alert-error').removeClass('hide');
            }

            $('button[type=submit]').html('注册用户');
            $('button[type=submit]').removeAttr('disabled');
            /* 美观 滚动条到顶端 主要是 html 第二个是所用时间  */
            $('html, body').animate({ scrollTop: 0 }, 100);
        }
    </script>
    </c:if>
    <c:if test="${GoogleAnalyticsCode != ''}">
    ${googleAnalyticsCode}
    </c:if>
</body>
</html>