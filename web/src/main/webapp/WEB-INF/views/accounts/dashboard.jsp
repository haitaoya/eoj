<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="zh_CN" />
<!DOCTYPE html>
<html lang="zh_CN">
<head>
    <meta charset="UTF-8">
    <title>个人中心 | ${websiteName}</title>
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
    <link rel="stylesheet" type="text/css" href="/web/assets/css/accounts/dashboard.css" />
    <!-- JavaScript -->
    <script type="text/javascript" src="/web/assets/js/jquery-1.11.1.min.js"></script>
    <script type="text/javascript" src="/web/assets/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="/web/assets/js/md5.min.js"></script>
    <!--[if lte IE 9]>
        <script type="text/javascript" src="/web/assets/js/jquery.placeholder.min.js"></script>
    <![endif]-->
    <!--[if lte IE 7]>
        <link rel="stylesheet" type="text/css" href="/web/assets/css/font-awesome-ie7.min.css" />
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
        <div id="sub-nav">
            <ul class="nav nav-tabs">
                <li class="active"><a href="#tab-statistics" data-toggle="tab">统计</a></li>
                <li><a href="#tab-accounts" data-toggle="tab">账户管理</a></li>
            <c:if test="${myProfile.userGroup.userGroupSlug == 'administrators'}">
                <li><a href="<c:url value="/administration" />">系统管理</a></li>
            </c:if>
            </ul>
        </div> <!-- #sub-nav -->
        <div id="main-content" class="tab-content">
            <div class="tab-pane active" id="tab-statistics">
                <div class="section">
                    <div class="header">
                        <div class="row-fluid">
                            <div class="span8">
                                <h4>提交统计</h4>
                            </div> <!-- .span8 -->
                            <div class="span4">
                                <select id="submission-period">
                                    <option value="7">最近一周</option>
                                    <option value="30">最近一个月</option>
                                    <option value="365">最近一年</option>
                                </select>
                            </div> <!-- .span4 -->
                        </div> <!-- .row-fluid -->
                    </div> <!-- .header -->
                    <div class="body">
                        <div id="submissions-calendar"></div> <!-- #submissions-calendar -->
                    </div> <!-- .body -->
                </div> <!-- .section -->
                <div class="section">
                    <div class="header">
                        <h4>我的提交</h4>
                    </div> <!-- .header -->
                    <div class="body">
                        <table id="submissions" class="table table-striped">
                            <thead>
                                <tr>
                                    <th class="flag">状态</th>
                                    <th class="name">标题</th>
                                    <th class="submission">提交</th>
                                    <th class="ac-rate">AC%</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="submission" items="${submissions}">
                                <tr>
                                    <td class="flag-${submission.value.judgeResult.judgeResultSlug}">
                                        <a href="<c:url value="/submission/${submission.value.submissionId}" />">
                                            ${submission.value.judgeResult.judgeResultSlug}
                                        </a>
                                    </td>
                                    <td class="name"><a href="<c:url value="/p/${submission.key}" />">P${submission.key} ${submission.value.problem.problemName}</a></td>
                                    <td>${submission.value.problem.totalSubmission}</td>
                                    <td>
                                    <c:choose>
                                        <c:when test="${submission.value.problem.totalSubmission == 0}">0%</c:when>
                                        <c:otherwise>
                                            <fmt:formatNumber type="number"  maxFractionDigits="0" value="${submission.value.problem.acceptedSubmission * 100 / submission.value.problem.totalSubmission}" />%
                                        </c:otherwise>
                                    </c:choose>
                                    </td>
                                </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div> <!-- .body -->
                </div> <!-- .section -->
            </div> <!-- #tab-statistics -->
            <div class="tab-pane" id="tab-accounts">
                <form id="password-form" class="section" method="POST" onSubmit="onChangePasswordSubmit(); return false;">
                    <h4>修改密码</h4>
                    <div class="row-fluid">
                        <div class="alert alert-error hide"></div>
                        <div class="alert alert-success hide">您的密码已更改</div>
                    </div> <!-- .row-fluid -->
                    <div class="row-fluid">
                        <div class="span4">
                            <label for="old-password">旧密码</label>
                        </div> <!-- .span4 -->
                        <div class="span8">
                            <div class="control-group">
                                <input id="old-password" class="span8" type="password" maxlength="16" />
                            </div> <!-- .control-group -->
                        </div> <!-- .span8 -->
                    </div> <!-- .row-fluid -->
                    <div class="row-fluid">
                        <div class="span4">
                            <label for="new-password">新密码</label>
                        </div> <!-- .span4 -->
                        <div class="span8">
                            <div class="control-group">
                                <input id="new-password" class="span8" type="password" maxlength="16" />
                            </div> <!-- .control-group -->
                        </div> <!-- .span8 -->
                    </div> <!-- .row-fluid -->
                    <div class="row-fluid">
                        <div class="span4">
                            <label for="confirm-new-password">确认新密码</label>
                        </div> <!-- .span4 -->
                        <div class="span8">
                            <div class="control-group">
                                <input id="confirm-new-password" class="span8" type="password" maxlength="16" />
                            </div> <!-- .control-group -->
                        </div> <!-- .span8 -->
                    </div> <!-- .row-fluid -->
                    <div class="row-fluid">
                        <div class="span12">
                            <button class="btn btn-primary btn-block" type="submit">修改密码</button>
                        </div> <!-- .span12 -->
                    </div> <!-- .row-fluid -->
                </form> <!-- #password-form -->
                <form id="profile-form" class="section" method="POST" onSubmit="onChangeProfileSubmit(); return false;">
                    <h4>个人资料</h4>
                    <div class="row-fluid">
                        <div class="alert alert-error hide"></div>
                        <div class="alert alert-success hide">您的个人信息已更改</div>
                    </div> <!-- .row-fluid -->
                    <div class="row-fluid">
                        <div class="span4">
                            <label for="email">Email地址</label>
                        </div> <!-- .span4 -->
                        <div class="span8">
                            <div class="control-group">
                                <input id="email" class="span8" type="text" value="${user.email}" maxlength="64" placeholder="you@example.com" />
                            </div> <!-- .control-group -->
                        </div> <!-- .span8 -->
                    </div> <!-- .row-fluid -->
                    <div class="row-fluid">
                        <div class="span4">
                            <label for="location">学校</label>
                        </div> <!-- .span4 -->
                        <div class="span8">
                            <div class="control-group">
                                <input id="location" class="span8" type="text" value="${location}" maxlength="128" placeholder="学校名称" />
                            </div> <!-- .control-group -->
                        </div> <!-- .span8 -->
                    </div> <!-- .row-fluid -->
                    <div class="row-fluid">
                        <div class="span4">
                            <label for="website">个人网址</label>
                        </div> <!-- .span4 -->
                        <div class="span8">
                            <div class="control-group">
                                <input id="website" class="span8" type="text" value="${website}" maxlength="64" placeholder="https://blog.csdn.net/w_wonder" />
                            </div> <!-- .control-group -->
                        </div> <!-- .span8 -->
                    </div> <!-- .row-fluid -->
                    <div class="row-fluid">
                        <div class="span12">
                            <label for="social-links">
                          		      社交网站
                                <a id="new-social-link" title="添加社交网站" href="javascript:void(0);">
                                    <i class="fa fa-plus-circle"></i>
                                </a>
                            </label>
                            <div id="social-links">
                                <p id="no-social-links">暂无社交网站信息.</p>
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
                                    <textarea id="wmd-input" class="wmd-input" placeholder="介绍一下自己吧~">${aboutMe}</textarea>
                                </div> <!-- .wmd-panel -->
                                <div id="wmd-preview" class="wmd-panel wmd-preview"></div> <!-- .wmd-preview -->
                            </div> <!-- #markdown-editor -->
                        </div> <!-- .span12 -->
                    </div> <!-- .row-fluid -->
                    <div class="row-fluid">
                        <div class="span12">
                            <button class="btn btn-primary btn-block" type="submit">更新个人信息</button>
                        </div> <!-- .span12 -->
                    </div> <!-- .row-fluid -->
                </form> <!-- #profile-form -->
            </div> <!-- #tab-accounts -->
        </div> <!-- #main-content -->
    </div> <!-- #content -->
    <!-- Footer -->
    <%@ include file="/WEB-INF/views/include/footer.jsp" %>
    <!-- JavaScript -->
    <!-- Placed at the end of the document so the pages load faster -->
    <script type="text/javascript" src="/web/assets/js/site.js"></script>
    <script type="text/javascript">
        $.getScript('/web/assets/js/highcharts.min.js', function() {
            return getSubmissionsOfUsers(7);
        });
    </script>
    <script type="text/javascript">
        $('#submission-period').change(function() {
            var period = $(this).val();
            return getSubmissionsOfUsers(period);
        });
    </script>
    <script type="text/javascript">
        function getSubmissionsOfUsers(period) {
            var pageRequests = {
                'period': period
            };

            $.ajax({
                type: 'GET',
                url: '<c:url value="/accounts/getNumberOfSubmissionsOfUsers.action" />',
                data: pageRequests,
                dataType: 'JSON',
                success: function(result){
                    return processSubmissionOfUsers(result['acceptedSubmissions'], result['totalSubmissions']);
                }
            });
        }
    </script>
    <script type="text/javascript">
        function processSubmissionOfUsers(acceptedSubmissionsMap, totalSubmissionsMap) {
            var categories          = [],
                totalSubmissions    = [],
                acceptedSubmissions = [];
            
            $.each(totalSubmissionsMap, function(key, value){
                categories.push(key);
                totalSubmissions.push(value);
            });
            $.each(acceptedSubmissionsMap, function(key, value){
                acceptedSubmissions.push(value);
            });
            displaySubmissionsOfUsers(categories, acceptedSubmissions, totalSubmissions);
        }
    </script>
    <script type="text/javascript">
        function displaySubmissionsOfUsers(categories, acceptedSubmissions, totalSubmissions) {
            Highcharts.setOptions({
                colors: ['#34495e', '#e74c3c']
            });

            $('#submissions-calendar').highcharts({
                chart: {
                    backgroundColor: null,
                },
                title: {
                    text: null
                },
                xAxis: {
                    categories: categories
                },
                yAxis: {
                    allowDecimals: false,
                    title: {
                        text: '提交次数'
                    }
                },
                tooltip: {
                    shared: true,
                    crosshairs: true
                },
                series: [
                    {
                        name: '全部提交',
                        lineWidth: 4,
                        marker: {
                            radius: 4
                        },
                        data: totalSubmissions
                    },
                    {
                        name: '通过提交',
                        data: acceptedSubmissions
                    }
                ]
            });
        }
    </script>
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
        function onChangePasswordSubmit() {
            $('.alert-success', '#password-form').addClass('hide');
            $('.alert-error', '#password-form').addClass('hide');
            $('button[type=submit]', '#password-form').attr('disabled', 'disabled');
            $('button[type=submit]', '#password-form').html('请稍后...');

            var oldPassword     = $('#old-password').val(),
                newPassword     = $('#new-password').val(),
                confirmPassword = $('#confirm-new-password').val();

            return doChangePasswordAction(oldPassword, newPassword, confirmPassword);
        }
    </script>
    <script type="text/javascript">
        function doChangePasswordAction(oldPassword, newPassword, confirmPassword) {
            var postData = {
                'oldPassword': oldPassword,
                'newPassword': newPassword,
                'confirmPassword': confirmPassword
            };
            
            $.ajax({
                type: 'POST',
                url: '<c:url value="/accounts/changePassword.action" />',
                data: postData,
                dataType: 'JSON',
                success: function(result){
                    return processChangePasswordResult(result);
                }
            });
        }
    </script>
    <script type="text/javascript">
        function processChangePasswordResult(result) {
            if ( result['isSuccessful'] ) {
                $('.alert-success', '#password-form').removeClass('hide');
            } else {
                var errorMessage  = '';

                if ( !result['isOldPasswordCorrect'] ) {
                    errorMessage += '旧密码不正确<br>';
                }
                if ( result['isNewPasswordEmpty'] ) {
                    errorMessage += '请填写新的密码<br>';
                }
                if ( !result['isNewPasswordLegal'] ) {
                    errorMessage += '新密码的长度应该在6-16个字符之间.<br>';
                }
                if ( !result['isConfirmPasswordMatched'] ) {
                    errorMessage += '新密码和确认密码不匹配<br>';
                }
                $('.alert-error', '#password-form').html(errorMessage);
                $('.alert-error', '#password-form').removeClass('hide');
            }
            $('button[type=submit]', '#password-form').html('修改密码');
            $('button[type=submit]', '#password-form').removeAttr('disabled');
        }
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
        function onChangeProfileSubmit() {
            $('.alert-success', '#profile-form').addClass('hide');
            $('.alert-error', '#profile-form').addClass('hide');
            $('button[type=submit]', '#profile-form').attr('disabled', 'disabled');
            $('button[type=submit]', '#profile-form').html('请稍后...');

            var email       = $('#email').val(),
                location    = $('#location').val(),
                website     = $('#website').val(),
                socialLinks = getSocialLinks(),
                aboutMe     = $('#wmd-input').val();

            return doUpdateProfileAction(email, location, website, socialLinks, aboutMe);
        }
    </script>
    <script type="text/javascript">
        function doUpdateProfileAction(email, location, website, socialLinks, aboutMe) {
            var postData = {
                'email': email,
                'location': location,
                'website': website,
                'socialLinks': socialLinks,
                'aboutMe': aboutMe
            };

            $.ajax({
                type: 'POST',
                url: '<c:url value="/accounts/updateProfile.action" />',
                data: postData,
                dataType: 'JSON',
                success: function(result){
                    return processUpdateProfileResult(result);
                }
            });
        }
    </script>
    <script type="text/javascript">
        function processUpdateProfileResult(result) {
            if ( result['isSuccessful'] ) {
                $('.alert-success', '#profile-form').removeClass('hide');
            } else {
                var errorMessage  = '';

                if ( result['isEmailEmpty'] ) {
                    errorMessage += '请填写电子邮件地址.<br>';
                } else if ( !result['isEmailLegal'] ) {
                    errorMessage += 'Email邮件地址是无效的.<br>';
                } else if ( result['isEmailExists'] ) {
                    errorMessage += '电子邮件地址已被他人占用.<br>';
                }
                if ( !result['isLocationLegal'] ) {
                    errorMessage += '学校名称长度不得超过128个字符<br>';
                }
                if ( !result['isWebsiteLegal'] ) {
                    errorMessage += '个人主页的链接是无效的.<br>';
                }
                if ( !result['isAboutMeLegal'] ) {
                    errorMessage += '个人信息不得超过256个字符.<br>';
                }
                $('.alert-error', '#profile-form').html(errorMessage);
                $('.alert-error', '#profile-form').removeClass('hide');
            }
            $('button[type=submit]', '#profile-form').html('更新个人资料');
            $('button[type=submit]', '#profile-form').removeAttr('disabled');
        }
    </script>
    <c:if test="${GoogleAnalyticsCode != ''}">
    ${googleAnalyticsCode}
    </c:if>
</body>
</html>