<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh_CN">
<head>
    <meta charset="UTF-8">
    <title>编程语言设置 | ${websiteName}</title>
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
    <link rel="stylesheet" type="text/css" href="/web/assets/css/administration/language-settings.css" />
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
                <h2 class="page-header"><i class="fa fa-code"></i> 编程语言设置</h2>
                <form id="language-form" onSubmit="onSubmit(); return false;">
                    <div class="alert alert-warning">
                        <button type="button" class="close" data-dismiss="alert">×</button>
                        <h6>请谨慎小心!</h6>
                        <p>请不要随意修改以下配置</p>
                    </div> <!-- .alert-warning -->
                    <div class="alert alert-error hide"></div> <!-- .alert-error -->
                    <div class="alert alert-success hide"></div> <!-- .alert-success -->
                    <p>
                        <a id="new-language" href="javascript:void(0);">
                            <i class="fa fa-plus-circle"></i> 
                           新语言
                        </a>
                    </p>
                    <p id="no-languages" class="<c:if test="${languages.size() != 0}">hide</c:if>">暂无可用的编程语言.</p>
                    <ul id="languages">
                    <c:forEach items="${languages}" var="language">
                        <li class="language">
                            <div class="header">
                                <h5>${language.languageName}</h5>
                                <ul class="inline">
                                    <li><a href="javascript:void(0);"><i class="fa fa-edit"></i></a></li>
                                    <li><a href="javascript:void(0);"><i class="fa fa-trash"></i></a></li>
                                </ul>
                            </div> <!-- .header -->
                            <div class="body hide">
                                <div class="row-fluid">
                                    <div class="span4">
                                        <label>
                                           	 MIME类型
                                            <a href="https://codemirror.net/mode/" target="_blank">(这是什么?)</a>
                                        </label>
                                    </div> <!-- .span4 -->
                                    <div class="span8">
                                        <div class="control-group">
                                            <input class="language-slug span8" type="text" value="${language.languageSlug}" maxlength="16" />
                                        </div> <!-- .control-group -->
                                    </div> <!-- .span8 -->
                                </div> <!-- .row-fluid -->
                                <div class="row-fluid">
                                    <div class="span4">
                                        <label>语言名称</label>
                                    </div> <!-- .span4 -->
                                    <div class="span8">
                                        <div class="control-group">
                                            <input class="language-id span8" type="hidden" value="${language.languageId}" />
                                            <input class="language-name span8" type="text" value="${language.languageName}" maxlength="16" />
                                        </div> <!-- .control-group -->
                                    </div> <!-- .span8 -->
                                </div> <!-- .row-fluid -->
                                <div class="row-fluid">
                                    <div class="span4">
                                        <label>编译命令</label>
                                    </div> <!-- .span4 -->
                                    <div class="span8">
                                        <div class="control-group">
                                            <input class="compile-command span8" type="text" value="${language.compileCommand}" maxlength="128" />
                                        </div> <!-- .control-group -->
                                    </div> <!-- .span8 -->
                                </div> <!-- .row-fluid -->
                                <div class="row-fluid">
                                    <div class="span4">
                                        <label>运行命令</label>
                                    </div> <!-- .span4 -->
                                    <div class="span8">
                                        <div class="control-group">
                                            <input class="run-command span8" type="text" value="${language.runCommand}" maxlength="128" />
                                        </div> <!-- .control-group -->
                                    </div> <!-- .span8 -->
                                </div> <!-- .row-fluid -->
                            </div> <!-- .body -->
                        </li>
                    </c:forEach>
                    </ul>
                    <div class="row-fluid">
                        <button class="btn btn-primary" type="submit">保存修改</button>
                    </div> <!-- .row-fluid -->
                </form> <!-- #language-form -->
            </div> <!-- #content -->
        </div> <!-- #container -->
    </div> <!-- #wrapper -->
    <!-- Java Script -->
    <!-- Placed at the end of the document so the pages load faster -->
    <%@ include file="/WEB-INF/views/administration/include/footer-script.jsp" %>
    <script type="text/javascript">
        $('#languages').on('click', 'i.fa-edit', function() {
            var languageContainer = $(this).parent().parent().parent().parent().parent(),
                isBodyUnfolded    = $('.body', $(languageContainer)).is(':visible');

            if ( isBodyUnfolded ) {
                $('.body', $(languageContainer)).addClass('hide');
            } else {
                $('.body', $(languageContainer)).removeClass('hide');
            }
        });
    </script>
    <script type="text/javascript">
        $('#languages').on('click', 'i.fa-trash', function() {
            var languageContainer = $(this).parent().parent().parent().parent().parent(),
                languages         = $('li.language', '#languages').length;
            
            $(languageContainer).remove();

            if ( languages == 1 ) {
                $('#no-languages').removeClass('hide');
            }
        });
    </script>
    <script type="text/javascript">
        $('#languages').on('change', 'input.language-name', function() {
            var languageContainer = $(this).parent().parent().parent().parent().parent(),
                languageName      = $(this).val();
            
            $('h5', $(languageContainer)).html(languageName);
        });
    </script>
    <script type="text/javascript">
        function onSubmit() {
            $('.alert-success').addClass('hide');
            $('.alert-error').addClass('hide');
            $('button[type=submit]').attr('disabled', 'disabled');
            $('button[type=submit]').html('请稍后...');

            return updateLanguageSettings();
        }
    </script>
    <script type="text/javascript">
        function updateLanguageSettings(languages) {
            var postData = {
                'languages': getLanguages()
            }

            $.ajax({
                type: 'POST',
                url: '<c:url value="/administration/updateLanguageSettings.action" />',
                data: postData,
                dataType: 'JSON',
                success: function(result){
                    return processResult(result);
                }
            });
        }
    </script>
    <script type="text/javascript">
        function getLanguages() {
            var languages = [];
            
            $('.language').each(function() {
                var languageId     = $('.language-id', $(this)).val() || 0,
                    languageSlug   = $('.language-slug', $(this)).val(),
                    languageName   = $('.language-name', $(this)).val(),
                    compileCommand = $('.compile-command', $(this)).val(),
                    runCommand     = $('.run-command', $(this)).val(),
                    language       = {
                        'languageId': languageId,
                        'languageSlug': languageSlug,
                        'languageName': languageName,
                        'compileCommand': compileCommand,
                        'runCommand': runCommand
                    };
                languages.push(language);
            });
            return JSON.stringify(languages);
        }
    </script>
    <script type="text/javascript">
        function processResult(result) {
            if ( result['isSuccessful'] ) {
                var message  = '<p>设置已保存.</p>';

                if ( result['languageCreated'].length != 0 ) {
                    var totalLanguages = result['languageCreated'].length;
                    
                    message += '<p style="padding-left: 15px;">下列语言已经创建: ';
                    for ( var i = 0; i < totalLanguages; ++ i ) {
                        var languageId   = result['languageCreated'][i]['languageId'],
                            languageSlug = result['languageCreated'][i]['languageSlug'],
                            languageName = result['languageCreated'][i]['languageName'];

                        message += languageName + ( i != totalLanguages - 1 ? ', ' : '' );
                        setLanguageId(languageSlug, languageId);
                    }
                    message += '</p>';
                }
                if ( result['languageUpdated'].length != 0 ) {
                    var totalLanguages = result['languageUpdated'].length;

                    message += '<p style="padding-left: 15px;">下列语言已经更新:';
                    for ( var i = 0; i < totalLanguages; ++ i ) {
                        message += result['languageUpdated'][i]['languageName'] + ( i != totalLanguages - 1 ? ', ' : '' );
                    }
                    message += '</p>';
                }
                if ( result['languageDeleted'].length != 0 ) {
                    var totalLanguages = result['languageDeleted'].length;

                    message += '<p style="padding-left: 15px;">下列语言已经删除: ';
                    for ( var i = 0; i < totalLanguages; ++ i ) {
                        message += result['languageDeleted'][i]['languageName'] + ( i != totalLanguages - 1 ? ', ' : '' );
                    }
                    message += '</p>';
                }
                $('.alert-success').html(message);
                $('.alert-success').removeClass('hide');
            } else {
                var message  = '';

                for ( var languageName in result ) {
                    var languageResult = result[languageName];

                    if ( typeof(languageResult) != 'object' ) {
                        continue;
                    }
                    if ( !languageResult['isSuccessful'] ) {
                        message += '<p>';
                        message += '<strong>' + languageName + ' 语言</strong><br>';
                        if ( 'isLanguageSlugEmpty' in languageResult && languageResult['isLanguageSlugEmpty'] ) {
                            message += '请填写MIME类型.<br>';
                        } else if ( 'isLanguageSlugLegal' in languageResult && !languageResult['isLanguageSlugLegal'] ) {
                            message += 'MIME类型的长度不得超过16个字符.<br>';
                        } else if ( 'isLanguageSlugExists' in languageResult && languageResult['isLanguageSlugExists'] ) {
                            message += 'MIME类型已被其他语言已经占用.<br>';
                        }
                        if ( 'isLanguageNameEmpty' in languageResult && languageResult['isLanguageNameEmpty'] ) {
                            message += '请填写语言名称.<br>';
                        } else if ( 'isLanguageNameLegal' in languageResult && !languageResult['isLanguageNameLegal'] ) {
                            message += '语言名称的长度不得超过16个字符.<br>';
                        }
                        if ( 'isCompileCommandEmpty' in languageResult && languageResult['isCompileCommandEmpty'] ) {
                            message += '请填写编译命令.<br>';
                        } else if ( 'isCompileCommandLegal' in languageResult && !languageResult['isCompileCommandLegal'] ) {
                            message += '编译命令似乎是无效的.<br>';
                        }
                        if ( 'isRunCommandEmpty' in languageResult && languageResult['isRunCommandEmpty'] ) {
                            message += '请填写运行命令.<br>';
                        } else if ( 'isRunCommandLegal' in languageResult && !languageResult['isRunCommandLegal'] ) {
                            message += '运行命令似乎是无效的.<br>';
                        }
                        if ( 'isLangaugeInUse' in languageResult && languageResult['isLangaugeInUse'] ) {
                            message += '该语言无法被删除.<br>';
                        }
                        message += '</p>';
                    }
                }
                $('.alert-error').html(message);
                $('.alert-error').removeClass('hide');
            }

            $('button[type=submit]').html('保存修改');
            $('button[type=submit]').removeAttr('disabled');
            $('html, body').animate({ scrollTop: 0 }, 100);
        }
    </script>
    <script type="text/javascript">
        function setLanguageId(languageSlug, languageId) {
            var languageSlugInput = null;
            $('.language-slug', '#languages').each(function() {
                if ( $(this).val() == languageSlug ) {
                    languageSlugInput = $(this);
                }
            });

            var languageContainer = $(languageSlugInput).parent().parent().parent().parent(),
                languageIdInput   = $('.language-id', $(languageContainer));

            $(languageIdInput).val(languageId);
        }
    </script>
    <script type="text/javascript">
        $('#new-language').click(function() {
            $('#languages').append(
                '<li class="language">' + 
                '    <div class="header">' + 
                '        <h5></h5>' + 
                '        <ul class="inline">' + 
                '            <li><a href="javascript:void(0);"><i class="fa fa-edit"></i></a></li>' + 
                '            <li><a href="javascript:void(0);"><i class="fa fa-trash"></i></a></li>' + 
                '        </ul>' + 
                '    </div> <!-- .header -->' +
                '    <div class="body">' + 
                '        <div class="row-fluid">' +
                '            <div class="span4">' +
                '                <label>' +
                '                   MIME类型' +
                '                    <a href="https://codemirror.net/mode/" target="_blank">(这是什么?)</a>' +
                '                </label>' +
                '            </div> <!-- .span4 -->' +
                '            <div class="span8">' +
                '                <div class="control-group">' +
                '                    <input class="language-slug span8" type="text" maxlength="16" />' +
                '                </div> <!-- .control-group -->' +
                '            </div> <!-- .span8 -->' +
                '        </div> <!-- .row-fluid -->' +
                '        <div class="row-fluid">' +
                '            <div class="span4">' +
                '                <label>语言名称</label>' +
                '            </div> <!-- .span4 -->' +
                '            <div class="span8">' +
                '                <div class="control-group">' +
                '                    <input class="language-id span8" type="hidden" value="0" />' +
                '                    <input class="language-name span8" type="text" maxlength="16" />' +
                '                </div> <!-- .control-group -->' +
                '            </div> <!-- .span8 -->' +
                '        </div> <!-- .row-fluid -->' +
                '        <div class="row-fluid">' +
                '            <div class="span4">' +
                '                <label>编译命令</label>' +
                '            </div> <!-- .span4 -->' +
                '            <div class="span8">' +
                '                <div class="control-group">' +
                '                    <input class="compile-command span8" type="text" maxlength="128" />' +
                '                </div> <!-- .control-group -->' +
                '            </div> <!-- .span8 -->' +
                '        </div> <!-- .row-fluid -->' +
                '        <div class="row-fluid">' +
                '            <div class="span4">' +
                '                <label>运行命令</label>' +
                '            </div> <!-- .span4 -->' +
                '            <div class="span8">' +
                '                <div class="control-group">' +
                '                    <input class="run-command span8" type="text" maxlength="128" />' +
                '                </div> <!-- .control-group -->' +
                '            </div> <!-- .span8 -->' +
                '        </div> <!-- .row-fluid -->' +
                '    </div> <!-- .body -->' +
                '</li>'
            );
        });
    </script>
</body>
</html>