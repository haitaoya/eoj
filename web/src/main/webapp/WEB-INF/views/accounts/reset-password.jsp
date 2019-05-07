<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="zh_CN" />
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="zh_CN">
<head>
    <meta charset="UTF-8">
    <title>重置密码 | ${websiteName}</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- Icon -->
    <link href="/web/assets/img/favicon.ico" rel="shortcut icon" type="image/x-icon">
    <!-- StyleSheets -->
    <link rel="stylesheet" type="text/css" href="/web/assets/css/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="/web/assets/css/bootstrap-responsive.min.css" />
    <link rel="stylesheet" type="text/css" href="/web/assets/css/flat-ui.min.css" />
    <link rel="stylesheet" type="text/css" href="/web/assets/css/font-awesome.min.css" />
    <link rel="stylesheet" type="text/css" href="/web/assets/css/style.css" />
    <link rel="stylesheet" type="text/css" href="/web/assets/css/accounts/reset-password.css" />
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
        <div id="reset-password">
            <h2>重置密码</h2>
            <div class="alert alert-error hide"></div> <!-- .alert-error -->
            <div class="alert alert-success hide"></div> <!-- .alert-success -->
        <c:choose>
        <c:when test="${isTokenValid}">
            <form id="reset-password-form" method="POST" onSubmit="onSubmit(); return false;">
                <p class="row-fluid">
                    <label for="email">电子邮件地址</label>
                    <input id="email" name="email" class="span12" type="text" value="${email}" maxlength="64" disabled="disabled" />
                </p>
                <p class="row-fluid">
                    <label for="new-password">新密码</label>
                    <input id="new-password" name="new-password" class="span12" type="password" maxlength="16" />
                </p>
                <p class="row-fluid">
                    <label for="confirm-new-password">确认新密码</label>
                    <input id="confirm-new-password" name="confirm-new-password" class="span12" type="password" maxlength="16" />
                </p>
                <p>
                    <input id="csrf-token" type="hidden" value="${csrfToken}" />
                    <button class="btn btn-primary btn-block" type="submit">重置密码</button>
                </p>
            </form>
        </c:when> 
        <c:otherwise>
            <form id="reset-password-form" method="POST" onSubmit="onSubmit(); return false;">
                <p class="row-fluid">
                    <label for="username"> 用户名</label>
                    <input id="username" name="username" class="span12" type="text" maxlength="16" />
                </p>
                <p class="row-fluid">
                    <label for="email">电子邮件地址</label>
                    <input id="email" name="email" class="span12" type="text" maxlength="64" />
                </p>
                <p>
                    <input id="csrf-token" type="hidden" value="${csrfToken}" />
                    <button class="btn btn-primary btn-block" type="submit">发送验证邮件</button>
                </p>
            </form>
        </c:otherwise>
        </c:choose>
        </div> <!-- #reset-password -->
    </div> <!-- #content -->
    <!-- Footer -->
    <%@ include file="/WEB-INF/views/include/footer.jsp" %>
    <!-- JavaScript -->
    <!-- Placed at the end of the document so the pages load faster -->
    <script type="text/javascript" src="/web/assets/js/site.js"></script>
<c:choose>
<c:when test="${isTokenValid}">
    <script type="text/javascript">
        function onSubmit() {
            $('.alert-error').addClass('hide');
            $('button[type=submit]').attr('disabled', 'disabled');
            $('button[type=submit]').html('请稍后...');

            var email           = '${email}',
                token           = '${token}',
                newPassword     = $('#new-password').val()
                confirmPassword = $('#confirm-new-password').val(),
                csrfToken       = $('#csrf-token').val();

            return doResetPasswordAction(email, token, newPassword, confirmPassword, csrfToken);
        }
    </script>
    <script type="text/javascript">
        function doResetPasswordAction(email, token, newPassword, confirmPassword, csrfToken) {
            var postData = {
                'email': email,
                'token': token,
                'newPassword': newPassword,
                'confirmPassword': confirmPassword,
                'csrfToken': csrfToken
            };

            $.ajax({
                type: 'POST',
                url: '<c:url value="/accounts/resetPassword.action" />',
                data: postData,
                dataType: 'JSON',
                success: function(result){
                    return processResult(result);
                }
            });
        }
    </script>
    <script type="text/javascript">
        function processResult(result) {
            if ( result['isSuccessful'] ) {
                $('.alert-success').html('您的密码已被重置.');
                $('.alert-success').removeClass('hide');
                $('#reset-password-form').addClass('hide');
            } else {
                var errorMessage  = '';

                if ( !result['isCsrfTokenValid'] ) {
                    errorMessage += '无效的CSRF Token.<br>';
                }
                if ( !result['isEmailValidationValid'] ) {
                    errorMessage += '重置密码的Token似乎是无效的.<br>';
                }
                if ( result['isNewPasswordEmpty'] ) {
                    errorMessage += '请填写新的密码.<br>';
                } else if ( !result['isNewPasswordLegal'] ) {
                    errorMessage += '新密码的长度应该在6-16个字符之间.<br>';
                }
                if ( !result['isConfirmPasswordMatched'] ) {
                    errorMessage += '新密码和确认密码不匹配.<br>';
                }
                $('.alert-error').html(errorMessage);
                $('.alert-error').removeClass('hide');
            }

            $('button[type=submit]').html('重置密码');
            $('button[type=submit]').removeAttr('disabled');
        }
    </script>
</c:when>
<c:otherwise>
    <c:if test="${not empty token}">
    <script type="text/javascript">
        $(function() {
            $('.alert-error').html('重置密码的Token似乎是无效的.');
            $('.alert-error').removeClass('hide');
            $('#reset-password-form').addClass('hide');
        });
    </script>
    </c:if>
    <script type="text/javascript">
        function onSubmit() {
            $('.alert-error').addClass('hide');
            $('button[type=submit]').attr('disabled', 'disabled');
            $('button[type=submit]').html('请稍后...');
            
            var username    = $('#username').val(),
                email       = $('#email').val(),
                csrfToken   = $('#csrf-token').val();

            return doResetPasswordAction(username, email, csrfToken);
        }
    </script>
    <script type="text/javascript">
        function doResetPasswordAction(username, email, csrfToken) {
            var postData = {
                'username': username,
                'email': email,
                'csrfToken': csrfToken
            };

            $.ajax({
                type: 'POST',
                url: '<c:url value="/accounts/forgotPassword.action" />',
                data: postData,
                dataType: 'JSON',
                success: function(result){
                    return processResult(result);
                }
            });
        }
    </script>
    <script type="text/javascript">
        function processResult(result) {
            if ( result['isSuccessful'] ) {
                $('.alert-success').html('一封包含重置密码说明的邮件已发送至您的邮箱.>');
                $('.alert-success').removeClass('hide');
                $('#reset-password-form').addClass('hide');
            } else {
                var errorMessage  = '';

                if ( !result['isCsrfTokenValid'] ) {
                    errorMessage += '无效的CSRF Token.<br>';
                } else if ( !result['isUserExists'] ) {
                    errorMessage += '用户名或电子邮件地址不正确.<br>';
                }
                $('.alert-error').html(errorMessage);
                $('.alert-error').removeClass('hide');
            }

            $('button[type=submit]').html('发送验证邮件');
            $('button[type=submit]').removeAttr('disabled');
        }
    </script>
</c:otherwise>
</c:choose>
    <c:if test="${GoogleAnalyticsCode != ''}">
    ${googleAnalyticsCode}
    </c:if>
</body>
</html>