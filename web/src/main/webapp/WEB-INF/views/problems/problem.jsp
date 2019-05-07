<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>P${problem.problemId} ${problem.problemName} | ${websiteName}</title>
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
    <link rel="stylesheet" type="text/css" href="/web/assets/css/codemirror.min.css" />
    <link rel="stylesheet" type="text/css" href="/web/assets/css/style.css" />
    <link rel="stylesheet" type="text/css" href="/web/assets/css/problems/problem.css" />
    <link rel="stylesheet" type="text/css" href="/web/assets/css/highlight.min.css" />
    <!-- JavaScript -->
    <script type="text/javascript" src="/web/assets/js/jquery-1.11.1.min.js"></script>
    <script type="text/javascript" src="/web/assets/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="/web/assets/js/md5.min.js"></script>
</head>
<body>
    <!-- Header -->
    <%@ include file="/WEB-INF/views/include/header.jsp" %>
    <!-- Content -->
    <div id="content" class="container">
        <div class="row-fluid">
            <div id="main-content" class="span12">
                <div class="problem">
                    <div class="body">
                        <div class="section">
			               <c:if test="${isContest}">
			                 <a href="<c:url value="/contest/${contest.contestId}" />"><i class="fa fa-arrow-left"></i> 试题列表</a>
			                <h1 style="text-align:center">&#${problemIdInContest};： ${problem.problemName}</h1>
			               </c:if> 
			               <c:if test="${not isContest}">
			                 <h1 style="text-align:center">P${problem.problemId}： ${problem.problemName}</h1>
			               </c:if>
                            
                            <h4 style="text-align:center"> 时间限制： ${problem.timeLimit} ms &nbsp;&nbsp; 内存限制：${problem.memoryLimit} KB </h4>
                            <h4 style="text-align:center"> 提交：${problem.totalSubmission}&nbsp;&nbsp;解决： ${problem.acceptedSubmission}
                           		 <c:if test="${isLogin}">
                       		 		<c:if test="${latestSubmission[problem.problemId] != null}">
                           	 			&nbsp;&nbsp;状态：${latestSubmission[problem.problemId].judgeResult.judgeResultName}
                       		 		</c:if>
                    			</c:if>
                    		</h4>
                            <h4>题目描述</h4>
                            <div class="description markdown">${problem.description}</div> <!-- .description -->
                        </div> <!-- .section -->
                        <div class="section">
                            <h5>输入</h5>
                            <div class="description">${problem.inputFormat}</div> <!-- .description -->
                            <h5>输出</h5>
                            <div class="description">${problem.outputFormat}</div> <!-- .description -->
                        </div> <!-- .section -->
                        <div id="io-sample" class="section">
                            <h5>样例输入</h5>
                            <div class="description"><pre>${problem.sampleInput}</pre></div> <!-- .description -->
                            <h5>样例输出</h5>
                            <div class="description"><pre>${problem.sampleOutput}</pre></div> <!-- .description -->
                        </div> <!-- .section -->
                        <!-- 提示 -->
                        <c:if test="${problem.hint != null and problem.hint != ''}">
                        <div class="section">
                            <h4>提示</h4>
                            <div class="description markdown">${problem.hint.replace("<", "&lt;").replace(">", "&gt;")}</div> <!-- .description -->
                        </div> <!-- .section -->
                        </c:if>
                        <form id="code-editor" onsubmit="onSubmit(); return false;" method="POST">
                            <textarea name="codemirror-editor" id="codemirror-editor"><c:if test="${isContest and codeSnippet != null}">${codeSnippet['code']}</c:if></textarea>
                            <div class="row-fluid">
                                <div class="span4">
                                    <select id="languages">
                                    <c:forEach var="language" items="${languages}">
                                        <option value="${language.languageSlug}">${language.languageName}</option>
                                    </c:forEach>
                                    </select>
                                </div> <!-- .span4 -->
                                <div id="submission-error" class="offset1 span3"></div> <!-- #submission-error -->
                                <div id="submission-action" class="span4">
                                    <input type="hidden" id="csrf-token" value="${csrfToken}" />
                                    <button type="submit" class="btn btn-primary">提交</button>
                                    <button id="close-submission" class="btn">取消</button>
                                </div> <!-- #submission-action -->
                            </div> <!-- .row-fluid -->
                        </form> <!-- #code-editor-->
                        <!-- 遮罩 -->
                        <div id="mask" class="hide"></div> <!-- #mask -->
                        <div class="section" style="text-align:left">
				             <c:choose>
				               	  <c:when test="${isContest}">
				                    <c:choose>
				                        <c:when test="${currentTime.after(contest.endTime)}">
				                        	<button disabled="disabled" class="btn btn-primary">无法提交</button>
				                        	<div class="alert alert-error span6 pull-right">比赛已结束</div>
				                        </c:when>
				                        <c:otherwise>
				                        <button id="submit-solution" class="btn btn-primary">提交代码</button>
				                        </c:otherwise>
				                    </c:choose>
				                </c:when>
				                <c:otherwise>
				                	<button id="submit-solution" class="btn btn-primary">提交代码</button>
				                </c:otherwise>
				            </c:choose>
                        	<div class="alert alert-error hide span6 pull-right">(#`O′)未登录，登陆后可提交</div>
                        </div> <!-- .section -->
                    </div> <!-- .body -->
                </div> <!-- .problem -->
            </div> <!-- #main-content -->
            </div><!-- .row-fluid -->
           <div class="row-fluid">
        </div> <!-- .row-fluid -->
    </div> <!-- #content -->
    <!-- Footer -->
    <%@ include file="/WEB-INF/views/include/footer.jsp" %>
    <!-- Java Script -->
    <!-- Placed at the end of the document so the pages load faster -->
    <script type="text/javascript" src="/web/assets/js/site.js"></script>
    <!-- 实现公式识别 -->
    <script type="text/x-mathjax-config">
        MathJax.Hub.Config({
            tex2jax: {inlineMath: [['$','$'], ['\\(','\\)']]}
        });
    </script>
    <script type="text/javascript" async src="https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.2/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>
    <script type="text/javascript">
        $.getScript('/web/assets/js/markdown.min.js', function() {
            converter = Markdown.getSanitizingConverter();

            $('.markdown').each(function() {
                var plainContent    = $(this).text(),
                    markdownContent = converter.makeHtml(plainContent/* .replace(/\\\n/g, '\\n') */);
                
                $(this).html(markdownContent);
            });
        });
    </script>
    <script type="text/javascript">
        $.getScript('/web/assets/js/codemirror.min.js', function() {
           $.when(
                $.getScript('/web/assets/mode/clike.min.js'),
                $.getScript('/web/assets/mode/go.min.js'),
                $.getScript('/web/assets/mode/pascal.min.js'),
                $.getScript('/web/assets/mode/perl.min.js'),
                $.getScript('/web/assets/mode/php.min.js'),
                $.getScript('/web/assets/mode/python.min.js'),
                $.getScript('/web/assets/mode/ruby.min.js'),
                $.Deferred(function(deferred) {
                    $(deferred.resolve);
                })
            ).done(function() {
                window.codeMirrorEditor = CodeMirror.fromTextArea(document.getElementById('codemirror-editor'), {
                    mode: $('select#languages').val(),
                    tabMode: 'indent',
                    theme: 'neat',
                    tabSize: 4,
                    indentUnit: 4,
                    lineNumbers: true,
                    lineWrapping: true
                });
            }); 
        });
    </script>
    <script type="text/javascript">
        $.getScript('/web/assets/js/highlight.min.js', function() {
            $('code').each(function(i, block) {
                hljs.highlightBlock(block);
            });
        });
    </script>
    <script type="text/javascript">
        $(function() {
            var preferLanguage = '${myProfile.preferLanguage.languageSlug}';
            $('select#languages').val(preferLanguage);
         <c:if test="${isContest and codeSnippet != null}">
            $('select#languages').val('${codeSnippet['language']}');
        </c:if>
        });
    </script>
    <script type="text/javascript">
        $('select#languages').change(function() {
            window.codeMirrorEditor.setOption('mode', $(this).val());
        });
    </script>
    <script type="text/javascript">
        $('#submit-solution').click(function() {
        	$("#myAlert").alert();
        	var login = '${isLogin}';
        	if(login=='true'){
        		 $('#mask').removeClass('hide');
                 $('#code-editor').addClass('fade');
                 /* 美观 滚动条到顶端 主要是 html 第二个是所用时间  */
                 $('html, body').animate({ scrollTop: 0 }, 500);
        	}else{
        		$('.alert-error').removeClass('hide');
        	}
        });
    </script>
    <script type="text/javascript">
        $('#close-submission').click(function(e) {
        	e.preventDefault();
            $('#code-editor').removeClass('fade');
            $('#mask').addClass('hide');
        });
    </script>
    <script type="text/javascript">
        function onSubmit() {
            var problemId   = ${problem.problemId},
                language    = $('select#languages').val(),
                code        = window.codeMirrorEditor.getValue(),
                csrfToken   = $('#csrf-token').val();

            $('button[type=submit]', '#code-editor').attr('disabled', 'disabled');
            $('button[type=submit]', '#code-editor').html('请稍后...');

            return createSubmissionAction(problemId, language, code, csrfToken);
        }
    </script>
<c:choose>
<c:when test="${isContest}">
    <script type="text/javascript">
        function createSubmissionAction(problemId, languageSlug, code, csrfToken) {
            var postData = {
                'problemId': problemId,
                'languageSlug': languageSlug,
                'code': code,
                'csrfToken': csrfToken
            };
 
            $.ajax({
                type: 'POST',
                url: '<c:url value="/contest/${contest.contestId}/createSubmission.action" />',
                data: postData,
                dataType: 'JSON',
                success: function(result) {
                	if ( result['isSuccessful'] ) {
                        var submissionId = result['submissionId'];
                        window.location.href = '<c:url value="/submission/" />' + submissionId;
                    } else {
                        var errorMessage = '';

                        if ( !result['isCsrfTokenValid'] ) {
                            errorMessage = '无效的token请刷新后重试';
                        } else if ( !result['isUserLogined'] ) {
                            errorMessage = '未登录，请登录后重试';
                        } else if ( !result['isProblemExists'] ) {
                            errorMessage = '题目不存在';
                        } else if ( !result['isLanguageExists'] ) {
                            errorMessage = '语言不存在';
                        } else if ( result['isCodeEmpty'] ) {
                            errorMessage = '代码不能为空';
                        }
                        $('#submission-error').html(errorMessage);
                    }

                    $('button[type=submit]', '#code-editor').removeAttr('disabled');
                    $('button[type=submit]', '#code-editor').html('请稍后...');
                	
                	
                }
            });
        }
    </script>
</c:when>
<c:otherwise>
    <script type="text/javascript">
        function createSubmissionAction(problemId, languageSlug, code, csrfToken) {
            var postData = {
                'problemId': problemId,
                'languageSlug': languageSlug,
                'code': code,
                'csrfToken': csrfToken
            };
            $.ajax({
                type: 'POST',
                url: '<c:url value="/p/createSubmission.action" />',
                data: postData,
                dataType: 'JSON',
                success: function(result) {
                    if ( result['isSuccessful'] ) {
                        var submissionId = result['submissionId'];
                        window.location.href = '<c:url value="/submission/" />' + submissionId;
                    } else {
                        var errorMessage = '';

                        if ( !result['isCsrfTokenValid'] ) {
                            errorMessage = '无效的token请刷新后重试';
                        } else if ( !result['isUserLogined'] ) {
                            errorMessage = '未登录，请登录后重试';
                        } else if ( !result['isProblemExists'] ) {
                            errorMessage = '题目不存在';
                        } else if ( !result['isLanguageExists'] ) {
                            errorMessage = '语言不存在';
                        } else if ( result['isCodeEmpty'] ) {
                            errorMessage = '代码不能为空';
                        }
                        $('#submission-error').html(errorMessage);
                    }

                    $('button[type=submit]', '#code-editor').removeAttr('disabled');
                    $('button[type=submit]', '#code-editor').html('请稍后...');
                }
            });
        }
    </script>
</c:otherwise>
</c:choose>
    <c:if test="${GoogleAnalyticsCode != ''}">
    ${googleAnalyticsCode}
    </c:if>
</body>
</html>