<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh_CN">
<head>
    <meta charset="UTF-8">
    <title>网站信息设置 | ${websiteName}</title>
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
    <link rel="stylesheet" type="text/css" href="/web/assets/css/administration/general-settings.css" />
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
                <h2 class="page-header"><i class="fa fa-cog"></i>网站信息设置</h2>
                <form id="option-form" onSubmit="onSubmit(); return false;">
                    <div class="alert alert-error hide"></div> <!-- .alert-error -->
                    <div class="alert alert-success hide">设置已保存.</div> <!-- .alert-success -->
                    <div class="control-group row-fluid">
                        <label for="website-name">网站名称</label>
                        <input id="website-name" class="span12" type="text" value="${options['websiteName']}" />
                    </div> <!-- .control-group -->
                    <div class="control-group row-fluid">
                        <label for="website-description">网站描述</label>
                        <input id="website-description" class="span12" type="text" value="${options['description']}" />
                    </div> <!-- .control-group -->
                    <div class="control-group row-fluid">
                        <label for="copyright">版权信息</label>
                        <input id="copyright" class="span12" type="text" value="${options['copyright'].replace("\"", "\'")}" /> <!-- " -->
                    </div> <!-- .control-group -->
                    <div class="control-group switch-container row-fluid">
                        <div class="span8">
                            <label for="allow-register">允许用户注册</label>
                        </div> <!-- .span8 -->
                        <div class="span4">
                            <input id="allow-register" type="checkbox" data-toggle="switch" <c:if test="${options['allowUserRegister'] != 0}">checked</c:if> />
                        </div> <!-- .span4 -->
                    </div> <!-- .control-group -->
                    <div class="control-group row-fluid hide">
                        <label for="icp-number">ICP 备案号 (仅限中国用户)</label>
                        <input id="icp-number" class="span12" type="text" value="${options['icpNumber']}" />
                    </div> <!-- .control-group -->
                    <div class="control-group row-fluid hide">
                        <label for="police-icp-number">公安机关备案号 (仅限中国用户)</label>
                        <input id="police-icp-number" class="span12" type="text" value="${options['policeIcpNumber']}" />
                    </div> <!-- .control-group -->
                    <div class="control-group row-fluid hide">
                        <label for="google-analytics-code">
                            Google Analytics 代码
                            (<a href="https://www.google.com/analytics" target="_blank">了解更多</a>)
                        </label>
                        <textarea id="google-analytics-code" class="span12" rows="5">${options['googleAnalyticsCode']}</textarea>
                    </div> <!-- .control-group -->
                    <div class="control-group row-fluid">
                        <label for="offensive-words">敏感词及表达式</label>
                        <input id="offensive-words" class="tagsinput" type="hidden" value="" />
                    </div> <!-- .control-group -->
                    <div class="row-fluid">
                        <button class="btn btn-primary" type="submit">保存修改</button>
                    </div> <!-- .row-fluid -->
                </form> <!-- #option-form -->
            </div> <!-- #content -->
        </div> <!-- #container -->
    </div> <!-- #wrapper -->
    <!-- Java Script -->
    <!-- Placed at the end of the document so the pages load faster -->
    <%@ include file="/WEB-INF/views/administration/include/footer-script.jsp" %>
    <script type="text/javascript">
        $(function() {
            var offensiveWordsList  = JSON.parse('${options['offensiveWords']}'),
                offensiveWordsValue = '';
            for ( var i = 0; i < offensiveWordsList.length; ++ i ) {
                offensiveWordsValue += offensiveWordsList[i] + ',';
            }
            
            $('#offensive-words').val(offensiveWordsValue);
            $('.tagsinput').tagsInput();
            $("[data-toggle='switch']").wrap('<div class="switch" />').parent().bootstrapSwitch();
        });
    </script>
    <script type="text/javascript">
        function onSubmit() {
            $('.alert-success').addClass('hide');
            $('.alert-error').addClass('hide');
            $('button[type=submit]').attr('disabled', 'disabled');
            $('button[type=submit]').html('请稍后...');

            var websiteName         = $('#website-name').val(),
                websiteDescription  = $('#website-description').val(),
                copyright           = $('#copyright').val(),
                allowUserRegister   = $('#allow-register').is(':checked'),
                icpNumber           = $('#icp-number').val(),
                policeIcpNumber     = $('#police-icp-number').val(),
                googleAnalyticsCode = $('#google-analytics-code').val(),
                offensiveWords      = $('#offensive-words').val();

            return doUpdateGeneralSettingsAction(websiteName, websiteDescription, copyright, allowUserRegister, icpNumber, policeIcpNumber, googleAnalyticsCode, offensiveWords);
        }
    </script>
    <script type="text/javascript">
        function doUpdateGeneralSettingsAction(websiteName, websiteDescription, copyright, allowUserRegister, icpNumber, policeIcpNumber, googleAnalyticsCode, offensiveWords) {
            var postData = {
                'websiteName': websiteName, 
                'websiteDescription': websiteDescription, 
                'copyright': copyright, 
                'allowUserRegister': allowUserRegister, 
                'policeIcpNumber': policeIcpNumber, 
                'icpNumber': icpNumber, 
                'googleAnalyticsCode': googleAnalyticsCode, 
                'offensiveWords': offensiveWords
            };

            $.ajax({
                type: 'POST',
                url: '<c:url value="/administration/updateGeneralSettings.action" />',
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
                $('.alert-success').removeClass('hide');
            } else {
                var errorMessage  = '';

                if ( result['isWebsiteNameEmpty'] ) {
                    errorMessage += '请填写网站名称.<br>';
                } else if ( !result['isWebisteNameLegal'] ) {
                    errorMessage += '网站名称的长度不得超过32个字符.<br>';
                }
                if ( result['isDescriptionEmpty'] ) {
                    errorMessage += '请填写网站描述.<br>';
                } else if ( !result['isDescriptionLegal'] ) {
                    errorMessage += ' 网站描述的长度不得超过128个字符.<br>';
                }
                if ( result['isCopyrightEmpty'] ) {
                    errorMessage += '请填写版权信息.<br>';
                } else if ( !result['isCopyrightLegal'] ) {
                    errorMessage += '版权信息的长度不得超过128个字符.<br>';
                }
                if ( !result['isIcpNumberLegal'] ) {
                    errorMessage += 'ICP备案号似乎是无效的.<br>';
                } 
                if ( !result['isPoliceIcpNumberLegal'] ) {
                    errorMessage += '公安机关备案号似乎是无效的.<br>';
                } 
                if ( !result['isAnalyticsCodeLegal'] ) {
                    errorMessage += 'Google Analytics代码似乎是无效的.<br>';
                }
                $('.alert-error').html(errorMessage);
                $('.alert-error').removeClass('hide');
            }

            $('button[type=submit]').html('保存修改');
            $('button[type=submit]').removeAttr('disabled');
            $('html, body').animate({ scrollTop: 0 }, 100);
        }
    </script>
</body>
</html>