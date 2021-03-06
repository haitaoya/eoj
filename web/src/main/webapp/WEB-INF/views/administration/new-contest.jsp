<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="zh_CN" />
<!DOCTYPE html>
<html lang="zh_CN">
<head>
    <meta charset="UTF-8">
    <title>创建竞赛 | ${websiteName}</title>
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
    <link rel="stylesheet" type="text/css" href="/web/assets/css/administration/new-contest.css" />
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
                <h2 class="page-header"><i class="fa fa-file"></i> 创建竞赛</h2>
                <form id="contest-form" onSubmit="onSubmit(); return false;">
                    <div class="row-fluid">
                        <div class="span8">
                            <div class="alert alert-error hide"></div> <!-- .alert-error -->
                            <div class="control-group row-fluid">
                                <label for="contest-name">竞赛名称</label>
                                <input id="contest-name" class="span12" type="text" maxlength="128" />
                            </div> <!-- .control-group -->
                            <div class="control-group row-fluid">
                                <label for="contest-mode">竞赛模式 </label>
                                <input id="contest-mode" class="span12" type="text" value="ACM" disabled="disabled"/>
                            </div> <!-- .control-group -->
                            <div class="control-group row-fluid">
                                <label for="contest-starttime">开始时间</label>
                                <input id="contest-starttime" class="span12" type="datetime-local" value="<fmt:formatDate value="${currentTime}" pattern="yyyy-MM-dd'T'HH:mm:ss" type="both" dateStyle="default" timeStyle="default" />" step="1"/>
                            </div> <!-- .control-group -->
                            <div class="control-group row-fluid">
                                <label for="contest-endtime">结束时间</label>
                                <input id="contest-endtime" class="span12" type="datetime-local" value="<fmt:formatDate value="${currentTime}" pattern="yyyy-MM-dd'T'HH:mm:ss" type="both" dateStyle="default" timeStyle="default" />" step="1"/>
                            </div> <!-- .control-group -->
                            <div class="row-fluid">
                                <div class="span12">
                                    <label for="wmd-input">竞赛说明</label>    
                                    <div id="markdown-editor">
                                        <div class="wmd-panel">
                                            <div id="wmd-button-bar" class="wmd-button-bar"></div> <!-- #wmd-button-bar -->
                                            <textarea id="wmd-input" class="wmd-input"></textarea>
                                        </div> <!-- .wmd-panel -->
                                        <div id="wmd-preview" class="wmd-panel wmd-preview"></div> <!-- .wmd-preview -->
                                    </div> <!-- #markdown-editor -->
                                </div> <!-- .span12 -->
                            </div> <!-- .row-fluid -->
                        </div> <!-- .span8 -->
                        <div class="span4">
                            <div class="section">
                                <div class="header">
                                    <h5>创建竞赛</h5>
                                </div> <!-- .header -->
                                <div class="body">
                                    <div class="row-fluid">
                                        <div class="span8">
                                           	 公开竞赛?
                                        </div> <!--- .span8 -->
                                        <div class="span4 text-right">
                                            <input id="contest-is-public" type="checkbox" data-toggle="switch" checked="checked" disabled="disabled"/>
                                        </div> <!-- .span4 -->
                                    </div> <!-- .row-fluid -->
                                </div> <!-- .body -->
                                <div class="footer text-right">
                                    <button class="btn btn-primary" type="submit">发布</button>
                                </div> <!-- .footer -->
                            </div> <!-- .section -->
                            <div class="section">
                                <div class="header">
                                    <h5>竞赛试题ID</h5>
                                </div> <!-- .header -->
                                <div class="body">
                                    <input id="contest-problems" class="problemsinput" type="hidden" value="" />
                                </div> <!-- .body -->
                            </div> <!-- .section -->
                        </div> <!-- .span4 -->
                    </div> <!-- .row-fluid -->
                </form>
            </div> <!-- #content -->
        </div> <!-- #container -->
    </div> <!-- #wrapper -->
    <!-- Java Script -->
    <!-- Placed at the end of the document so the pages load faster -->
    <%@ include file="/WEB-INF/views/administration/include/footer-script.jsp" %>
    <script type="text/javascript">
        $(function() {
            $('.problemsinput').tagsInput();
            $('[data-toggle=switch]').wrap('<div class="switch" />').parent().bootstrapSwitch();
        });
    </script>
    <script type='text/javascript'>
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
        $('#test-cases').on('click', 'i.fa-edit', function() {
            var testCaseContainer = $(this).parent().parent().parent().parent().parent(),
                isBodyUnfolded      = $('.body', $(testCaseContainer)).is(':visible');

            if ( isBodyUnfolded ) {
                $('.body', $(testCaseContainer)).addClass('hide');
            } else {
                $('.body', $(testCaseContainer)).removeClass('hide');
            }
        });
    </script>
    <script type="text/javascript">
    $("#contest-starttime").change(function(){
        $("#contest-starttime").attr("value",$(this).val()); //赋值
    });
    $("#contest-endtime").change(function(){
        $("#contest-endtime").attr("value",$(this).val()); //赋值
    });
    </script>
    <script type="text/javascript">
        function onSubmit() {
            var contestName         = $('#contest-name').val(),
            	contestMode         = $('#contest-mode').val(),
                contestStartTime    = $('#contest-starttime').val().replace("T", " "),
                contestEndTime      = $('#contest-endtime').val().replace("T", " "),
                contestNotes         = $('#wmd-input').val(),
                contestProblems     = getcontestProblems();
            $('.alert-success', '#contest-form').addClass('hide');
            $('.alert-error', '#contest-form').addClass('hide');
            $('button[type=submit]', '#contest-form').attr('disabled', 'disabled');
            $('button[type=submit]', '#contest-form').html('请稍后...');

            return createcontest(contestName, contestMode, contestStartTime, contestEndTime, contestNotes, contestProblems);
        }
    </script>
    <script type="text/javascript">
        function getcontestProblems() {
            var contestProblems = $('#contest-problems').val();
            if ( contestProblems == '' ) {
            	contestProblems = [];
            } else {
            	contestProblems = contestProblems.split(',');
            }
            return JSON.stringify(contestProblems);
        }
    </script>
    <script type="text/javascript">
        function createcontest(contestName, contestMode, contestStartTime, contestEndTime, contestNotes, contestProblems) {
            var postData = {
                'contestName': contestName,
                'contestMode': contestMode,
                'contestStartTime': contestStartTime,
                'contestEndTime': contestEndTime,
                'contestNotes': contestNotes,
                'contestProblems': contestProblems
            };

            $.ajax({
                type: 'POST',
                url: '<c:url value="/administration/createContest.action" />',
                data: postData,
                dataType: 'JSON',
                success: function(result){
                    return processCreatecontestResult(result);
                }
            });
        }
    </script>
    <script type="text/javascript">
        function processCreatecontestResult(result) {
            if ( result['isSuccessful'] ) {
                var contestId = result['contestId'];
                window.location.href = '<c:url value="/administration/edit-contest/" />' + contestId;
            } else {
                var errorMessage  = '';

                if ( result['iscontestNameEmpty'] ) {
                    errorMessage += '请填写竞赛名称.<br>';
                } else if ( !result['iscontestNameLegal'] ) {
                    errorMessage += '竞赛名称的长度不得超过128个字符.<br>';
                }
                if ( !result['isTimeLegal'] ) {
                    errorMessage += '请填写正确的竞赛时间段.<br>';
                }
                if ( !result['isProblemIdLegal'] ) {
                    errorMessage += '请填写已存在的试题Id.<br>';
                }
                $('.alert-error', '#contest-form').html(errorMessage);
                $('.alert-error', '#contest-form').removeClass('hide');
            }
            $('button[type=submit]', '#contest-form').removeAttr('disabled');
            $('button[type=submit]', '#contest-form').html('发布');
        }
    </script>
</body>
</html>