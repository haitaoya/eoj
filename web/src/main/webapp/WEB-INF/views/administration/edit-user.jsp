<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh_CN">
<head>
    <meta charset="UTF-8">
    <title>编辑用户: ${user.username} | ${websiteName}</title>
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
    <link rel="stylesheet" type="text/css" href="/web/assets/css/administration/style.css" />
    <link rel="stylesheet" type="text/css" href="/web/assets/css/administration/edit-user.css" />
    <!-- JavaScript -->
    <script type="text/javascript" src="/web/assets/js/jquery-1.11.1.min.js"></script>
    <script type="text/javascript" src="/web/assets/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="/web/assets/js/flat-ui.min.js"></script>
    <script type="text/javascript" src="/web/assets/js/md5.min.js"></script>
    <script type="text/javascript" src="/web/assets/js/pace.min.js"></script>
    <!--[if lte IE 9]>
        <script type="text/javascript" src="/web/assets/js/jquery.placeholder.min.js"></script>
    <![endif]-->
    <!--[if lte IE 7]>
        <script type="text/javascript"> 
            window.location.href='<c:url value="/not-supported" />';
        </script>
    <![endif]-->
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
                <h2 class="page-header"><i class="fa fa-user"></i> 编辑用户信息</h2>
                <form id="profile-form" onSubmit="onSubmit(); return false;">
                    <div class="alert alert-error hide"></div> <!-- .alert-error -->
                    <div class="alert alert-success hide">个人资料已保存.</div> <!-- .alert-success -->
                    <div class="control-group row-fluid">
                        <label for="username">用户名</label>
                        <input id="username" class="span12" type="text" value="${user.username}" disabled="disabled" />
                    </div> <!-- .control-group -->
                    <div class="control-group row-fluid">
                        <label for="password">密码</label>
                        <input id="password" class="span12" type="password" maxlength="16" />
                    </div> <!-- .control-group -->
                    <div class="control-group row-fluid">
                        <label for="email">email地址</label>
                        <input id="email" class="span12" type="text" maxlength="64" value="${user.email}" />
                    </div> <!-- .control-group -->
                    <div class="control-group row-fluid">
                        <label for="user-group">用户组</label>
                        <select id="user-group" name="userGroup">
                        <c:forEach var="userGroup" items="${userGroups}">
                            <option value="${userGroup.userGroupSlug}" <c:if test="${userGroup.userGroupSlug == user.userGroup.userGroupSlug}">selected</c:if> >${userGroup.userGroupName}</option>
                        </c:forEach>
                        </select>
                    </div> <!-- .control-group -->
                    <div class="control-group row-fluid">
                        <label for="prefer-language">语言偏好</label>
                        <select id="prefer-language" name="preferLanguage">
                        <c:forEach var="language" items="${languages}">
                            <option value="${language.languageSlug}" <c:if test="${language.languageId == user.preferLanguage.languageId}">selected</c:if> >${language.languageName}</option>
                        </c:forEach>
                        </select>
                    </div> <!-- .control-group -->
                    <div class="control-group row-fluid">
                        <label for="location">学校</label>
                        <input id="location" class="span12" type="text" value="${location}" maxlength="128" />
                    </div> <!-- .control-group -->
                    <div class="control-group row-fluid">
                        <label for="website">个人网站</label>
                        <input id="website" class="span12" type="text" value="${website}" maxlength="64" />
                    </div> <!-- .control-group -->
                    <div class="row-fluid">
                        <div class="span12">
                            <label for="social-links">
                                	社交网站
                                <a id="new-social-link" title="添加社交网站" href="javascript:void(0);">
                                    <i class="fa fa-plus-circle"></i>
                                </a>
                            </label>
                            <div id="social-links">
                                <p id="no-social-links">无社交网站</p>
                                <ul></ul>
                            </div> <!-- #social-links -->
                        </div> <!-- .span12 -->
                    </div> <!-- .row-fluid -->
                    <div class="row-fluid">
                        <div class="span12">
                            <label for="wmd-input">个人简介</label>    
                            <div id="markdown-editor">
                                <div class="wmd-panel">
                                    <div id="wmd-button-bar" class="wmd-button-bar"></div> <!-- #wmd-button-bar -->
                                    <textarea id="wmd-input" class="wmd-input">${aboutMe}</textarea>
                                </div> <!-- .wmd-panel -->
                                <div id="wmd-preview" class="wmd-panel wmd-preview"></div> <!-- .wmd-preview -->
                            </div> <!-- #markdown-editor -->
                        </div> <!-- .span12 -->
                    </div> <!-- .row-fluid -->
                    <div class="row-fluid">
                        <div class="span12">
                            <button class="btn btn-primary" type="submit">更新用户信息</button>&nbsp;
                            <button class="btn btn-danger" onclick="return false;">删除用户</button>
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
        $.getScript('/web/assets/js/markdown.min.js', function() {
            converter = Markdown.getSanitizingConverter();
            editor    = new Markdown.Editor(converter);
            editor.run();

            $('.markdown').each(function() {
                var plainContent    = $(this).text(),
                    markdownContent = converter.makeHtml(plainContent.replace(/\\\n/g, '\\n'));
                
                $(this).html(markdownContent);
            });
        });
    </script>
    <script type="text/javascript">
        socialServices      = {
            'Weibo'         : 'http://weibo.com/',
            'GitHub'        : 'https://github.com/',
            'StackOverflow' : 'http://stackoverflow.com/users/'
        };
    </script>
    <script type="text/javascript">
        $(function() {
            var mySocialLinks   = {
                'Weibo'         : '${socialLinks['Weibo']}',
                'GitHub'        : '${socialLinks['GitHub']}',
                'StackOverflow' : '${socialLinks['StackOverflow']}'
            };

            for ( var serviceName in mySocialLinks ) {
                var serviceBaseUrl  = socialServices[serviceName],
                    serviceUsername = mySocialLinks[serviceName],
                    serviceUrl      = serviceBaseUrl + serviceUsername;

                if ( typeof(serviceUsername) != 'undefined' && serviceUsername != '' ) {
                    $('#no-social-links').addClass('hide');
                    $('#social-links > ul').append(getSocialLinkContainer(serviceName, serviceUrl));
                }
            }
        });
    </script>
    <script type="text/javascript">
        $('#new-social-link').click(function() {
            var serviceName = 'Weibo', 
                serviceUrl  = socialServices['Weibo'];
            
            $('#no-social-links').addClass('hide');
            $('#social-links > ul').append(getSocialLinkContainer(serviceName, serviceUrl));
        });
    </script>
    <script type="text/javascript">
        function getSocialLinkContainer(serviceName, serviceUrl) {
            var containerTemplate = '<li class="social-link">' +
                                    '    <div class="header">' +
                                    '        <h5>%s</h5>' +
                                    '        <ul class="inline">' +
                                    '            <li><a href="javascript:void(0);"><i class="fa fa-edit"></i></a></li>' +
                                    '            <li><a href="javascript:void(0);"><i class="fa fa-trash"></i></a></li>' +
                                    '        </ul>' +
                                    '    </div> <!-- .header -->' +
                                    '    <div class="body hide">' +
                                    '        <div class="row-fluid">' +
                                    '            <div class="span4">' +
                                    '                <label>网站类型</label>' +
                                    '            </div> <!-- .span4 -->' +
                                    '            <div class="span8">' +
                                    '                <div class="control-group">' +
                                    '                    <select class="service">' + getSocialLinkOptions(serviceName) + '</select>' +
                                    '                </div> <!-- .control-group -->' +
                                    '            </div> <!-- .span8 -->' +
                                    '        </div> <!-- .row-fluid -->' +
                                    '        <div class="row-fluid">' +
                                    '            <div class="span4">' +
                                    '                <label>URL</label>' +
                                    '            </div> <!-- .span4 -->' +
                                    '            <div class="span8">' +
                                    '                <div class="control-group">' +
                                    '                    <input class="url span8" type="text" maxlength="128" value="%s" />' +
                                    '                </div> <!-- .control-group -->' +
                                    '            </div> <!-- .span8 -->' +
                                    '        </div> <!-- .row-fluid -->' +
                                    '    </div> <!-- .body -->' +
                                    '</li> <!-- .social-link -->';

            return containerTemplate.format(serviceName, serviceUrl);
        }
    </script>
    <script type="text/javascript">
        function getSocialLinkOptions(selectedServiceName) {
            var socialLinkOptions       = '',
                optionTemplate          = '<option value="%s">%s</option>',
                selectedOptionTemplate  = '<option value="%s" selected>%s</option>';

            for ( var serviceName in socialServices ) {
                if ( serviceName == selectedServiceName ) {
                    socialLinkOptions  += selectedOptionTemplate.format(serviceName, serviceName);
                } else {
                    socialLinkOptions  += optionTemplate.format(serviceName, serviceName);
                }
            }
            return socialLinkOptions;
        }
    </script>
    <script type="text/javascript">
        $('#social-links').on('click', 'i.fa-edit', function() {
            var socialLinkContainer = $(this).parent().parent().parent().parent().parent(),
                isBodyUnfolded      = $('.body', $(socialLinkContainer)).is(':visible');

            if ( isBodyUnfolded ) {
                $('.body', $(socialLinkContainer)).addClass('hide');
            } else {
                $('.body', $(socialLinkContainer)).removeClass('hide');
            }
        });
    </script>
    <script type="text/javascript">
        $('#social-links').on('click', 'i.fa-trash', function() {
            var socialLinkContainer = $(this).parent().parent().parent().parent().parent(),
                socialLinks         = $('li.social-link', '#social-links').length;
            
            $(socialLinkContainer).remove();

            if ( socialLinks == 1 ) {
                $('#no-social-links').removeClass('hide');
            }
        });
    </script>
    <script type="text/javascript">
        $('#social-links').on('change', 'select.service', function() {
            var socialLinkContainer = $(this).parent().parent().parent().parent().parent(),
                serviceName         = $(this).val(),
                serviceBaseUrl      = socialServices[serviceName];
            
            $('h5', $(socialLinkContainer)).html(serviceName);
            $('input.url', $(socialLinkContainer)).val(serviceBaseUrl);
        });
    </script>
    <script type="text/javascript">
        function getSocialLinks() {
            var socialLinks = {};

            $('.social-link').each(function() {
                var serviceName     = $('select.service', $(this)).val(),
                    serviceUrl      = $('input.url', $(this)).val(),
                    serviceBaseUrl  = socialServices[serviceName],
                    serviceUsername = serviceUrl.substr(serviceBaseUrl.length);

                if ( serviceUrl.indexOf(serviceBaseUrl) != -1 && serviceUsername != '' ) {
                    socialLinks[serviceName] = serviceUsername;
                }
            });
            return JSON.stringify(socialLinks);
        }
    </script>
    <script type="text/javascript">
        function getSocialLinks() {
            var socialLinks = {};

            $('.social-link').each(function() {
                var serviceName     = $('select.service', $(this)).val(),
                    serviceUrl      = $('input.url', $(this)).val(),
                    serviceBaseUrl  = socialServices[serviceName],
                    serviceUsername = serviceUrl.substr(serviceBaseUrl.length);

                if ( serviceUrl.indexOf(serviceBaseUrl) != -1 && serviceUsername != '' ) {
                    socialLinks[serviceName] = serviceUsername;
                }
            });
            return JSON.stringify(socialLinks);
        }
    </script>
    <script type="text/javascript">
        function onSubmit() {
            $('.alert-success', '#profile-form').addClass('hide');
            $('.alert-error', '#profile-form').addClass('hide');
            $('button[type=submit]', '#profile-form').attr('disabled', 'disabled');
            $('button[type=submit]', '#profile-form').html('请稍后...');

            var uid             = '${user.uid}',
                password        = $('#password').val(),
                email           = $('#email').val(),
                userGroup       = $('#user-group').val(),
                preferLanguage  = $('#prefer-language').val(),
                location        = $('#location').val(),
                website         = $('#website').val(),
                socialLinks     = getSocialLinks(),
                aboutMe         = $('#wmd-input').val();
            
            return doEditUserAction(uid, password, email, userGroup, preferLanguage, location, website, socialLinks, aboutMe);
        }
    </script>
    <script type="text/javascript">
        function doEditUserAction(uid, password, email, userGroup, preferLanguage, location, website, socialLinks, aboutMe) {
            var postData = {
                'uid': uid,
                'password': password,
                'email': email,
                'userGroup': userGroup,
                'preferLanguage': preferLanguage,
                'location': location,
                'website': website,
                'socialLinks': socialLinks,
                'aboutMe': aboutMe
            };
            
            $.ajax({
                type: 'POST',
                url: '<c:url value="/administration/editUser.action" />',
                data: postData,
                dataType: 'JSON',
                success: function(result){
                    return processEditUserResult(result);
                }
            });
        }
    </script>
    <script type="text/javascript">
        function processEditUserResult(result) {
            if ( result['isSuccessful'] ) {
                $('.alert-success').removeClass('hide');
            } else {
                var errorMessage  = '';
                
                if ( !result['isUserExists'] ) {
                    errorMessage  = '用户不存在<br>';
                }
                if ( !result['isPasswordEmpty'] && !result['isPasswordLegal'] ) {
                    errorMessage += '密码的长度应该在6-16个字符之间.<br>';
                }
                if ( result['isEmailEmpty'] ) {
                    errorMessage += '请填写电子邮件地址.<br>';
                } else if ( !result['isEmailLegal'] ) {
                    errorMessage += '电子邮件地址似乎是无效的.<br>';
                } else if ( result['isEmailExists'] ) {
                    errorMessage += ' 电子邮件地址已被他人占用.<br>';
                }
                if ( !result['isUserGroupLegal'] ) {
                    errorMessage += '用户组不存在.<br>';
                }
                if ( !result['isPreferLanguageLegal'] ) {
                    errorMessage += '编程语言不存在.<br>';
                }
                if ( !result['isLocationLegal'] ) {
                    errorMessage += '学校名称的长度不得超过128个字符.<br>';
                }
                if ( !result['isWebsiteLegal'] ) {
                    errorMessage += '个人主页的链接似乎是无效的.<br>';
                }
                if ( !result['isAboutMeLegal'] ) {
                    errorMessage += '关于我的描述不得超过256个字符.<br>';
                }
                $('.alert-error').html(errorMessage);
                $('.alert-error').removeClass('hide');
            }
            $('button[type=submit]').html('更新用户信息');
            $('button[type=submit]').removeAttr('disabled');
            $('html, body').animate({ scrollTop: 0 }, 100);
        }
    </script>
    <script type="text/javascript">
        $('button.btn-danger').click(function() {
            if ( !confirm('你确定要继续吗?') ) {
                return;
            }
            $('.alert-error').addClass('hide');
            $('button.btn-danger').attr('disabled', 'disabled');
            $('button.btn-danger').html('请稍后...');
            var users = [${user.uid}];
            return doDeleteUsersAction(users);
        });
    </script>
    <script type="text/javascript">
        function doDeleteUsersAction(users) {
            var postData = {
                'users': JSON.stringify(users)
            };

            $.ajax({
                type: 'POST',
                url: '<c:url value="/administration/deleteUsers.action" />',
                data: postData,
                dataType: 'JSON',
                success: function(result){
                    if ( result['isSuccessful'] ) {
                        window.location.href = '<c:url value="/administration/all-users" />';
                    } else {
                        $('.alert').html('删除用户的过程中出现了一些问题');
                        $('.alert').removeClass('hide');
                    }
                    $('button.btn-danger').removeAttr('disabled');
                    $('button.btn-danger').html('删除用户');
                }
            });
        }
    </script>
</body>
</html>