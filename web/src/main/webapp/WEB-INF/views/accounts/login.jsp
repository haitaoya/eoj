<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>登录 | ${websiteName}</title>
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
    <link rel="stylesheet" type="text/css" href="/web/assets/css/accounts/login.css" />
    <!-- JavaScript -->
    <script type="text/javascript" src="/web/assets/js/jquery-1.11.1.min.js"></script>
    <script type="text/javascript" src="/web/assets/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="/web/assets/js/flat-ui.min.js"></script>
    <!-- md5加密 -->
    <script type="text/javascript" src="/web/assets/js/md5.min.js"></script>
</head>
<body>
    <!-- Header -->
    <%@ include file="/WEB-INF/views/include/header.jsp" %>
    <!-- Content -->
    <div id="content">
        <div id="login">
            <h2>登录 Easy OJ</h2>
            <div class="alert alert-error hide"></div>
            <c:if test="${isLogout}">
            <div class="alert alert-success">您已退出登录</div>
            </c:if>
            <!--  return false; 目的是中止submit的动作 -->
            <form id="login-form" method="POST" onsubmit="onSubmit(); return false;">
                <p class="row-fluid">
                    <label for="username">用户名或邮箱地址</label>
                    <input id="username" name="username" class="span12" type="text" maxlength="32" />
                </p>
                <p class="row-fluid">
                    <label for="password">
                        	密码
                    </label>
                    <input id="password" name="password" class="span12" type="password" maxlength="16" />
                </p>
<!--                  <p>
 					样式 参考 view-source:http://www.runoob.com/manual/Flat-UI/
                    <label class="checkbox" for="remember-me">
                        <input id="remember-me" type="checkbox"  /> 下次自动登录
                        
                    </label>
                    <span class="pull-right">
                          
                        </span>
                </p> -->
                <br/>
                <p>
                    <button class="btn btn-primary btn-block" type="submit">登录</button>
                </p>
            </form> <!-- #login-form -->
        </div> <!-- #login -->
        <p class="text-center">
	忘记密码？
            <a href="<c:url value="/accounts/reset-password" />" style="color:#08c">找回密码</a>
             &nbsp; &nbsp; &nbsp; &nbsp;
	没有账号？ 
            <a href="<c:url value="/accounts/register" />" style="color:#08c">注册帐号</a>
        </p>
    </div> <!-- #content -->
    <!-- Footer -->
    <%@ include file="/WEB-INF/views/include/footer.jsp" %>
    <!-- JavaScript -->
    <!-- Placed at the end of the document so the pages load faster -->
    <script type="text/javascript" src="/web/assets/js/site.js"></script>
    <script type="text/javascript">
        function onSubmit() {
            $('.alert-success').addClass('hide');
            $('.alert-error').addClass('hide');
            $('button[type=submit]').attr('disabled', 'disabled');
            $('button[type=submit]').html('登录中');
            
            var username   = $('#username').val(),
                password   = md5($('#password').val()),
                rememberMe = $('input#remember-me').is(':checked');
            
            $('#password').val(password);
            return doLoginAction(username, password, rememberMe);
        };
    </script>
    <script type="text/javascript">
        function doLoginAction(username, password, rememberMe) {
            var postData = {
                'username': username,
                'password': password,
                'rememberMe': rememberMe
            };
            
            $.ajax({
                type: 'POST',
                url: '<c:url value="/accounts/login.action" />',
                data: postData,
                dataType: 'JSON',
                success: function(result){
                    return processLoginResult(result);
                }
            });
        }
    </script>
    <script type="text/javascript">
    	/* 分析返回的结果 */
        function processLoginResult(result) {
            if ( result['isSuccessful'] ) {
            	/* 返回上一级 或者 主页 */
                var forwardUrl = '${forwardUrl}' || '<c:url value="/" />';
                window.location.href = forwardUrl;
            } else {
                var errorMessage = '';
                if ( !result['isAccountValid'] ) {
                    errorMessage = '用户名或密码错误，请重新输入';
                } else if ( !result['isAllowedToAccess'] ) {
                    errorMessage = '您无权限登录，请联系管理员';
                }
                $('#password').val('');
                $('.alert-error').html(errorMessage);
                $('.alert-error').removeClass('hide');
            }

            $('button[type=submit]').html('登录');
            $('button[type=submit]').removeAttr('disabled');
        }
    </script>
    <c:if test="${GoogleAnalyticsCode != ''}">
    ${googleAnalyticsCode}
    </c:if>
</body>
</html>