<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="zh_CN">
<head>
    <meta charset="UTF-8">
    <title>试题编辑 - ${problem.problemName} | ${websiteName}</title>
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
    <link rel="stylesheet" type="text/css" href="/web/assets/css/administration/new-problem.css" />
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
                <h2 class="page-header"><i class="fa fa-file"></i> 试题编辑</h2>
                <form id="problem-form" onSubmit="onSubmit(); return false;">
                    <div class="row-fluid">
                        <div class="span8">
                            <div class="alert alert-error hide"></div> <!-- .alert-error -->
                            <div class="alert alert-success hide">编辑成功 <a href="<c:url value="/p/" />${problem.problemId}">查看试题</a></div> <!-- .alert-success -->    
                            <div class="control-group row-fluid">
                                <label for="problem-name">标题</label>
                                <input id="problem-name" class="span12" type="text" maxlength="128" value="${problem.problemName}" />
                                <input id="problem-id" type="hidden" value="${problem.problemId}" />
                            </div> <!-- .control-group -->
                            <div class="control-group row-fluid">
                                <label for="time-limit">时间限制 (ms)</label>
                                <input id="time-limit" class="span12" type="text" maxlength="8" value="${problem.timeLimit}" />
                            </div> <!-- .control-group -->
                            <div class="control-group row-fluid">
                                <label for="memory-limit">内存限制 (KB)</label>
                                <input id="memory-limit" class="span12" type="text" maxlength="8" value="${problem.memoryLimit}" />
                            </div> <!-- .control-group -->
                            <div class="row-fluid">
                                <div class="span12">
                                    <label for="wmd-input">试题描述</label>    
                                    <div id="markdown-editor">
                                        <div class="wmd-panel">
                                            <div id="wmd-button-bar" class="wmd-button-bar"></div> <!-- #wmd-button-bar -->
                                            <textarea id="wmd-input" class="wmd-input">${problem.description}</textarea>
                                        </div> <!-- .wmd-panel -->
                                        <div id="wmd-preview" class="wmd-panel wmd-preview"></div> <!-- .wmd-preview -->
                                    </div> <!-- #markdown-editor -->
                                </div> <!-- .span12 -->
                            </div> <!-- .row-fluid -->
                            <div class="control-group row-fluid">
                                <label for="hint">提示</label>
                                <textarea id="hint" class="span12">${problem.hint}</textarea>
                            </div> <!-- .control-group -->
                            <h4>输入/输出</h4>
                            <div class="control-group row-fluid">
                                <label for="input-format">输入格式</label>
                                <textarea id="input-format" class="span12">${problem.inputFormat}</textarea>
                            </div> <!-- .control-group -->
                            <div class="control-group row-fluid">
                                <label for="output-format">输出格式</label>
                                <textarea id="output-format" class="span12">${problem.outputFormat}</textarea>
                            </div> <!-- .control-group -->
                            <div class="control-group row-fluid">
                                <label for="input-sample">样例输入</label>
                                <textarea id="input-sample" class="span12">${problem.sampleInput}</textarea>
                            </div> <!-- .control-group -->
                            <div class="control-group row-fluid">
                                <label for="output-sample">样例输出</label>
                                <textarea id="output-sample" class="span12">${problem.sampleOutput}</textarea>
                            </div> <!-- .control-group -->
                            <div class="row-fluid">
                                <div class="span6">
                                    <h4>测试用例</h4>
                                </div> <!-- .span6 -->
                                <div class="span6 text-right">
                                    <a id="new-test-case" title="新测试用例" href="javascript:void(0);">
                                        <i class="fa fa-plus-circle"></i>
                                    </a>
                                </div> <!-- .span6 -->
                            </div> <!-- .row-fluid -->
                            <div class="row-fluid">
                                <div class="span12">
                                    <div id="test-cases">
                                        <p id="no-test-cases">暂无测试用例.</p>
                                        <ul>
                                        <c:forEach var="checkpoint" items="${checkpoints}">
                                            <li class="test-case">
                                                <div class="header">
                                                    <h5>测试用例 #${checkpoint.checkpointId}</h5>
                                                    <ul class="inline">
                                                        <li><a href="javascript:void(0);"><i class="fa fa-edit"></i></a></li>
                                                        <li><a href="javascript:void(0);"><i class="fa fa-trash"></i></a></li>
                                                    </ul>
                                                </div> <!-- .header -->
                                                <div class="body">
                                                    <div class="row-fluid">
                                                        <div class="span4">
                                                            <label>标准输入</label>
                                                        </div> <!-- .span4 -->
                                                        <div class="span8">
                                                            <textarea class="standard-input span12">${checkpoint.input}</textarea>
                                                        </div> <!-- .span8 -->
                                                    </div> <!-- .row-fluid -->
                                                    <div class="row-fluid">
                                                        <div class="span4">
                                                            <label>标准输出</label>
                                                        </div> <!-- .span4 -->
                                                        <div class="span8">
                                                            <textarea class="standard-output span12">${checkpoint.output}</textarea>
                                                        </div> <!-- .span8 -->
                                                    </div> <!-- .row-fluid -->
                                                </div> <!-- .body -->
                                            </li> <!-- .test-case -->
                                        </c:forEach>
                                        </ul>
                                    </div> <!-- #test-cases -->
                                </div> <!-- .span12 -->
                            </div> <!-- .row-fluid -->
                        </div> <!-- .span8 -->
                        <div class="span4">
                            <div class="section">
                                <div class="header">
                                    <h5>试题编辑</h5>
                                </div> <!-- .header -->
                                <div class="body">
                                    <div class="row-fluid">
                                        <div class="span8">
                                        	   公开试题?
                                        </div> <!--- .span8 -->
                                        <div class="span4 text-right">
                                            <input id="problem-is-public" type="checkbox" data-toggle="switch" <c:if test="${problem.isPublic()}">checked="checked"</c:if> />
                                        </div> <!-- .span4 -->
                                    </div> <!-- .row-fluid -->
                                    <div class="row-fluid">
                                        <div class="span8">
                                            精确匹配测试用例
                                        </div> <!--- .span8 -->
                                        <div class="span4 text-right">
                                            <input id="problem-is-exactly-match" type="checkbox" data-toggle="switch" />
                                        </div> <!-- .span4 -->
                                    </div> <!-- .row-fluid -->
                                </div> <!-- .body -->
                                <div class="footer text-right">
                                    <button class="btn btn-primary" type="submit">发布更新</button>
                                </div> <!-- .footer -->
                            </div> <!-- .section -->
                            <div class="section">
                                <div class="header">
                                    <h5>试题分类</h5>
                                </div> <!-- .header -->
                                <div class="body">
                                    <c:forEach var="entry" items="${problemCategories}">
                                    <ul class="parent-categories">                                        
                                        <li>
                                            <label class="checkbox parent-category" for="${entry.key.problemCategorySlug}">
                                                <input id="${entry.key.problemCategorySlug}" type="checkbox" data-toggle="checkbox"> ${entry.key.problemCategoryName}
                                            </label>
                                            <ul class="sub-categories">
                                            <c:forEach var="problemCategory" items="${entry.value}">
                                                <li>
                                                    <label class="checkbox child-category" for="${problemCategory.problemCategorySlug}">
                                                        <input id="${problemCategory.problemCategorySlug}" type="checkbox" data-toggle="checkbox"> ${problemCategory.problemCategoryName}
                                                    </label>
                                                </li>
                                            </c:forEach>
                                            </ul>
                                        </li>
                                    </ul>
                                </c:forEach>
                                </div> <!-- .body -->
                            </div> <!-- .section -->
                            <div class="section">
                                <div class="header">
                                    <h5>试题标签</h5>
                                </div> <!-- .header -->
                                <div class="body">
                                    <input id="problem-tags" class="tagsinput" type="hidden" value="<c:forEach var="problemTag" items="${problemTags}">${problemTag.problemTagName},</c:forEach>" />
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
        <c:if test="${fn:length(checkpoints) != 0}">
            $('#no-test-cases').addClass('hide');
        </c:if>

        <c:forEach var="problemCategory" items="${selectedProblemCategories}">
            $('#${problemCategory.problemCategorySlug}').parent().addClass('checked');
        </c:forEach>

            $('.tagsinput').tagsInput();
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
        $('#new-test-case').click(function() {
            var testCaseId = $('li.test-case', '#test-cases').length; 
            
            $('#no-test-cases').addClass('hide');
            $('#test-cases > ul').append(getTestCaseContainer(testCaseId));
        });
    </script>
    <script type="text/javascript">
        function getTestCaseContainer(testCaseId, standardInput, standardOutput) {
            var containerTemplate = '<li class="test-case">' +
                                    '    <div class="header">' +
                                    '        <h5>测试用例 #%s</h5>' +
                                    '        <ul class="inline">' +
                                    '            <li><a href="javascript:void(0);"><i class="fa fa-edit"></i></a></li>' +
                                    '            <li><a href="javascript:void(0);"><i class="fa fa-trash"></i></a></li>' +
                                    '        </ul>' +
                                    '    </div> <!-- .header -->' +
                                    '    <div class="body">' +
                                    '        <div class="row-fluid">' +
                                    '            <div class="span4">' +
                                    '                <label>标准输入</label>' +
                                    '            </div> <!-- .span4 -->' +
                                    '            <div class="span8">' +
                                    '                <textarea class="standard-input span12">%s</textarea>' + 
                                    '            </div> <!-- .span8 -->' +
                                    '        </div> <!-- .row-fluid -->' +
                                    '        <div class="row-fluid">' +
                                    '            <div class="span4">' +
                                    '                <label>标准输出</label>' +
                                    '            </div> <!-- .span4 -->' +
                                    '            <div class="span8">' +
                                    '                <textarea class="standard-output span12">%s</textarea>' + 
                                    '            </div> <!-- .span8 -->' +
                                    '        </div> <!-- .row-fluid -->' +
                                    '    </div> <!-- .body -->' +
                                    '</li> <!-- .test-case -->';

            return containerTemplate.format(testCaseId, 
                typeof(standardInput) == 'undefined' ? '' : standardInput, 
                typeof(standardOutput) == 'undefined' ? '' : standardOutput);
        }
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
        $('#test-cases').on('click', 'i.fa-trash', function() {
            var testCaseContainer = $(this).parent().parent().parent().parent().parent(),
                testCases         = $('li.test-case', '#test-cases').length,
                testCaseName      = '测试用例 #%s';

            $(testCaseContainer).remove();
            $('li.test-case', '#test-cases').each(function(index) {
                $('h5', this).html(testCaseName.format(index));
            });

            if ( testCases == 1 ) {
                $('#no-test-cases').removeClass('hide');
            }
        });
    </script>
    <script type="text/javascript">
        $('label.checkbox.parent-category').click(function() {
            var currentControl = $(this);
            // Fix the bug for Checkbox in FlatUI 
            setTimeout(function() {
                var isChecked = $(currentControl).hasClass('checked');

                if ( !isChecked ) {
                    $('label.checkbox.child-category', $(currentControl).parent()).removeClass('checked');
                }
            }, 50);
        });
    </script>
    <script type="text/javascript">
        $('label.checkbox.child-category').click(function() {
            var currentControl = $(this);
            // Fix the bug for Checkbox in FlatUI 
            setTimeout(function() {
                var isChecked = $(currentControl).hasClass('checked');

                if ( isChecked ) {
                    $('label.checkbox.parent-category', $(currentControl).parent().parent().parent()).addClass('checked');
                }
            }, 50);
        });
    </script>
    <script type="text/javascript">
        function onSubmit() {
            var problemId           = $('#problem-id').val(),
                problemName         = $('#problem-name').val(),
                timeLimit           = $('#time-limit').val(),
                memoryLimit         = $('#memory-limit').val(),
                description         = $('#wmd-input').val(),
                hint                = $('#hint').val(),
                inputFormat         = $('#input-format').val(),
                outputFormat        = $('#output-format').val(),
                inputSample         = $('#input-sample').val(),
                outputSample        = $('#output-sample').val(),
                testCases           = getTestCases(),
                problemCategories   = getProblemCategories(),
                problemTags         = getProblemTags(),
                isPublic            = $('#problem-is-public').parent().hasClass('switch-on'),
                isExactlyMatch      = $('#problem-is-exactly-match').parent().hasClass('switch-on');

            $('.alert-success', '#problem-form').addClass('hide');
            $('.alert-error', '#problem-form').addClass('hide');
            $('button[type=submit]', '#problem-form').attr('disabled', 'disabled');
            $('button[type=submit]', '#problem-form').html('请稍后');

            return editProblem(problemId, problemName, timeLimit, memoryLimit, description, 
                    hint, inputFormat, outputFormat, inputSample, outputSample, testCases, 
                    problemCategories, problemTags, isPublic, isExactlyMatch);
        }
    </script>
    <script type="text/javascript">
        function getTestCases() {
            var testCases   = [];

            $('li.test-case').each(function() {
                var input   = $('.standard-input', $(this)).val(),
                    output  = $('.standard-output', $(this)).val();

                testCases.push({
                    'input': input,
                    'output': output
                });
            });
            return JSON.stringify(testCases);
        }
    </script>
    <script type="text/javascript">
        function getProblemCategories() {
            var problemCategories = [];

            $('label.checked', '.parent-categories').each(function() {
                problemCategories.push($(this).attr('for'));
            });
            return JSON.stringify(problemCategories);
        }
    </script>
    <script type="text/javascript">
        function getProblemTags() {
            var problemTags = $('#problem-tags').val();

            if ( problemTags == '' ) {
                problemTags = [];
            } else {
                problemTags = problemTags.split(',');
            }
            return JSON.stringify(problemTags);
        }
    </script>
    <script type="text/javascript">
        function editProblem(problemId, problemName, timeLimit, memoryLimit, description, hint, inputFormat, outputFormat, 
                    inputSample, outputSample, testCases, problemCategories, problemTags, isPublic, isExactlyMatch) {
            var postData = {
                'problemId': problemId,
                'problemName': problemName,
                'timeLimit': timeLimit,
                'memoryLimit': memoryLimit,
                'description': description,
                'hint': hint,
                'inputFormat': inputFormat,
                'outputFormat': outputFormat,
                'inputSample': inputSample,
                'outputSample': outputSample,
                'testCases': testCases,
                'problemCategories': problemCategories,
                'problemTags': problemTags,
                'isPublic': isPublic,
                'isExactlyMatch': isExactlyMatch
            };

            $.ajax({
                type: 'POST',
                url: '<c:url value="/administration/editProblem.action" />',
                data: postData,
                dataType: 'JSON',
                success: function(result){
                    return processEditProblemResult(result);
                }
            });
        }
    </script>
    <script type="text/javascript">
        function processEditProblemResult(result) {
            if ( result['isSuccessful'] ) {
                $('.alert-error').addClass('hide');
                $('.alert-success').removeClass('hide');
            } else {
                var errorMessage  = '';

                if ( !result['isProblemExists'] ) {
                    errorMessage += '试题不存在<br>';
                } 
                if ( result['isProblemNameEmpty'] ) {
                    errorMessage += '请填写试题名称.<br>';
                } else if ( !result['isProblemNameLegal'] ) {
                    errorMessage += '试题名称的长度不得超过128个字符.<br>';
                }
                if ( !result['isTimeLimitLegal'] ) {
                    errorMessage += '时间限制必须是大于0的整数.<br>';
                } 
                if ( !result['isMemoryLimitLegal'] ) {
                    errorMessage += '内存限制必须是大于0的整数.<br>';
                } 
                if ( result['isDescriptionEmpty'] ) {
                    errorMessage += '请填写试题描述.<br>';
                }
                if ( result['isInputFormatEmpty'] ) {
                    errorMessage += '请填写输入格式.<br>';
                } 
                if ( result['isOutputFormatEmpty'] ) {
                    errorMessage += ' 请填写输出格式.<br>';
                } 
                if ( result['isInputSampleEmpty'] ) {
                    errorMessage += '请填写输入样例.br>';
                } 
                if ( result['isOutputSampleEmpty'] ) {
                    errorMessage += '请填写输出样例.<br>';
                } 

                $('.alert-error', '#problem-form').html(errorMessage);
                $('.alert-error', '#problem-form').removeClass('hide');
            }
            $('button[type=submit]', '#problem-form').removeAttr('disabled');
            $('button[type=submit]', '#problem-form').html('发布更新');
        }
    </script>
</body>
</html>