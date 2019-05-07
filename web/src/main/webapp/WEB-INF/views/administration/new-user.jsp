<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<spring:eval expression="@propertyConfigurer.getProperty('url.cdn')" var="cdnUrl" />
<spring:eval expression="@propertyConfigurer.getProperty('build.version')" var="version" />
<!DOCTYPE html>
<html lang="zh_CN">
<head>
    <meta charset="UTF-8">
    <title>创建用户 | ${websiteName}</title>
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
    <link rel="stylesheet" type="text/css" href="/web/assets/css/administration/new-user.css" />
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
                <h2 class="page-header"><i class="fa fa-user"></i> 创建用户</h2>
                <form id="profile-form" onSubmit="onSubmit(); return false;">
                    <div class="alert alert-error hide"></div> <!-- .alert-error -->
                    <div class="alert alert-success hide">创建成功</div> <!-- .alert-success -->
                    <div class="control-group row-fluid">
                        <label for="username">用户名</label>
                        <input id="username" class="span12" type="text" maxlength="16" />
                    </div> <!-- .control-group -->
                    <div class="control-group row-fluid">
                        <label for="password">密码</label>
                        <input id="password" class="span12" type="password" maxlength="16" />
                    </div> <!-- .control-group -->
                    <div class="control-group row-fluid">
                        <label for="email">email地址</label>
                        <input id="email" class="span12" type="text" maxlength="64" />
                    </div> <!-- .control-group -->
                    <div class="control-group row-fluid">
                        <label for="user-group">用户组</label>
                        <select id="user-group" name="userGroup">
                        <c:forEach var="userGroup" items="${userGroups}">
                            <option value="${userGroup.userGroupSlug}">${userGroup.userGroupName}</option>
                        </c:forEach>
                        </select>
                    </div> <!-- .control-group -->
                    <div class="control-group row-fluid">
                        <label for="prefer-language">语言偏好</label>
                        <select id="prefer-language" name="preferLanguage">
                        <c:forEach var="language" items="${languages}">
                            <option value="${language.languageSlug}">${language.languageName}</option>
                        </c:forEach>
                        </select>
                    </div> <!-- .control-group -->
                    <div class="row-fluid">
                        <div class="span12">
                            <button class="btn btn-primary" type="submit">创建用户</button>
                        </div> <!-- .span12 -->
                    </div> <!-- .row-fluid -->
                </form> <!-- #profile-form -->
            </div> <!-- #content -->    
        </div> <!-- #container -->
    </div> <!-- #wrapper -->
    <!-- Java Script -->
    <!-- Placed at the end of the document so the pages load faster -->
    <%@ include file="/WEB-INF/views/administration/include/footer-script.jsp" %>
    <script type="text/javascript">
        function onSubmit() {
            var username        = $('#username').val(),
                password        = $('#password').val(),
                email           = $('#email').val(),
                userGroup       = $('#user-group').val(),
                preferLanguage  = $('#prefer-language').val();
            
            $('.alert-success', '#profile-form').addClass('hide');
            $('.alert-error', '#profile-form').addClass('hide');
            $('button[type=submit]', '#profile-form').attr('disabled', 'disabled');
            $('button[type=submit]', '#profile-form').html('请稍后...');

            return doCreateUserAction(username, password, email, userGroup, preferLanguage);
        }
    </script>
    <script type="text/javascript">
        function doCreateUserAction(username, password, email, userGroup, preferLanguage) {
            var postData = {
                'username': username,
                'password': password,
                'email': email,
                'userGroup': userGroup,
                'preferLanguage': preferLanguage
            };
            
            $.ajax({
                type: 'POST',
                url: '<c:url value="/administration/newUser.action" />',
                data: postData,
                dataType: 'JSON',
                success: function(result){
                    return processCreateUserResult(result);
                }
            });
        }
    </script>
    <script type="text/javascript">
        function processCreateUserResult(result) {
            if ( result['isSuccessful'] ) {
                $('input').val('');
                $('.alert-success', '#profile-form').removeClass('hide');
            } else {
                var errorMessage  = '';

                if ( result['isUsernameEmpty'] ) {
                    errorMessage += '用户名不能为空<br>';
                } else if ( !result['isUsernameLegal'] ) {
                    var username = $('#username').val();

                    if ( username.length < 6 || username.length > 16 ) {
                        errorMessage += '用户名的长度必须在6-16个字符之间.<br>';
                    } else if ( !username[0].match(/[a-z]/i) ) {
                        errorMessage += '用户名必须以字母(a-z)开头." /><br>';
                    } else {
                        errorMessage += '用户名必须只包含字母(a-z), 数字和下划线(_).<br>';
                    }
                } else if ( result['isUsernameExists'] ) {
                    errorMessage += '用户名已存在<br>';
                }
                if ( result['isPasswordEmpty'] ) {
                    errorMessage += '密码不能为空<br>';
                } else if ( !result['isPasswordLegal'] ) {
                    errorMessage += '密码的长度必须在6-16个字符之间.<br>';
                }
                if ( result['isEmailEmpty'] ) {
                    errorMessage += 'email地址不能为空<br>';
                } else if ( !result['isEmailLegal'] ) {
                    errorMessage += '请填写有效邮箱<br>';
                } else if ( result['isEmailExists'] ) {
                    errorMessage += '邮箱已被使用<br>';
                }
                if ( !result['isUserGroupLegal'] ) {
                    errorMessage += '用户组不能为空<br>';
                }
                if ( !result['isLanguageLegal'] ) {
                    errorMessage += '语言偏好不能为空<br>';
                }
                $('.alert-error', '#profile-form').html(errorMessage);
                $('.alert-error', '#profile-form').removeClass('hide');
            }
            $('button[type=submit]', '#profile-form').removeAttr('disabled');
            $('button[type=submit]', '#profile-form').html('创建用户');
        }
    </script>
</body>
</html>