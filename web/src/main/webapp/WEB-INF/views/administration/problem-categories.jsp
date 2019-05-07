<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="zh_CN">
<head>
    <meta charset="UTF-8">
    <title>试题分类 | ${websiteName}</title>
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
    <link rel="stylesheet" type="text/css" href="/web/assets/css/administration/problem-categories.css" />
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
                <h2 class="page-header"><i class="fa fa-th-list"></i> 试题分类</h2>
                <div class="row-fluid">
                    <div class="span4">
                        <h4>添加试题分类</h4>
                        <form id="new-category-form" onSubmit="onSubmit(); return false;">
                            <div class="alert alert-error hide"></div> <!-- .alert-error -->
                            <div class="control-group row-fluid">
                                <label for="category-name">名称</label>
                                <input id="category-name" class="span12" type="text" maxlength="32" />
                                <p>这将是它在站点上显示的名字.</p>
                            </div> <!-- .control-group -->
                            <div class="control-group row-fluid">
                                <label for="category-slug">别名</label>
                                <input id="category-slug" class="span12" type="text" maxlength="32" />
                                <p>\"别名\"是在URL中使用的别称, 它可以令URL更美观. 通常使用小写, 只能包含字母, 数字和连字符(-).</p>
                            </div> <!-- .control-group -->
                            <div class="row-fluid">
                                <label for="category-parent">父节点</label>
                                <select id="category-parent">
                                    <option value="">无</option>
                                <c:forEach items="${problemCategories}" var="problemCategory">
                                    <option value="${problemCategory.problemCategorySlug}">${problemCategory.problemCategoryName}</option>
                                </c:forEach>
                                </select>
                                <p>分类目录和标签不同, 它可以有层级关系. 您可以有一个\"背包\"分类目录, 在这个目录下可以有叫做\"01背包\"和\"完全背包\"的子目录.</p>
                            </div> <!-- .row-fluid -->
                            <div class="row-fluid">
                                <button class="btn btn-primary" type="submit">添加试题分类</button>
                            </div> <!-- .row-fluid -->
                        </form> <!-- #new-category-form -->
                    </div> <!-- .span4 -->
                    <div class="span8">
                        <div id="filters" class="row-fluid">
                            <div class="span12">
                                <select id="actions">
                                    <option value="delete">删除</option>
                                </select>
                                <button class="btn btn-danger">应用</button>
                            </div> <!-- .span12 -->
                        </div> <!-- .row-fluid -->
                        <table id="problem-categories" class="table table-striped">
                            <thead>
                                <tr>
                                    <th class="check-box">
                                        <label class="checkbox all-problem-categories" for="all-problem-categories-thead">
                                            <input id="all-problem-categories-thead" type="checkbox" data-toggle="checkbox">
                                        </label>
                                    </th>
                                    <th>名称</th>
                                    <th>别名</th>
                                </tr>
                            </thead>
                            <tbody>
                            <c:forEach items="${problemCategories}" var="problemCategory">
                                <tr  data-value="${problemCategory.problemCategoryId}">
                                    <td class="check-box">
                                        <label class="checkbox" for="problem-category-${problemCategory.problemCategorySlug}">
                                            <input id="problem-category-${problemCategory.problemCategorySlug}" type="checkbox" value="problem-category-${problemCategory.problemCategorySlug}" data-toggle="checkbox" />
                                        </label>
                                    </td>
                                    <td>
                                        <span class="problem-category-name">${problemCategory.problemCategoryName}</span>
                                        <input type="hidden" class="parent-category" value="${problemCategory.parentProblemCategoryId}" />
                                        <ul class="actions inline">
                                            <li><a href="javascript:void(0);" class="action-edit">编辑</a></li>
                                        <c:if test="${problemCategory.problemCategorySlug != 'uncategorized'}">
                                            <li><a href="javascript:void(0);" class="action-delete">删除</a></li>
                                        </c:if>
                                        </ul>
                                    </td>
                                    <td><span class="problem-category-slug">${problemCategory.problemCategorySlug}</span></td>
                                </tr>
                            </c:forEach>
                            </tbody>
                            <tfoot>
                                <tr>
                                    <th class="check-box">
                                        <label class="checkbox all-problem-categories" for="all-problem-categories-tfoot">
                                            <input id="all-problem-categories-tfoot" type="checkbox" data-toggle="checkbox">
                                        </label>
                                    </th>
                                    <th>名称</th>
                                    <th> 别名</th>
                                </tr>
                            </tfoot>
                        </table>
                    </div> <!-- .span8 -->
                </div> <!-- .row-fluid -->
            </div> <!-- #content -->
        </div> <!-- #container -->
    </div> <!-- #wrapper -->
    <!-- Java Script -->
    <!-- Placed at the end of the document so the pages load faster -->
    <%@ include file="/WEB-INF/views/administration/include/footer-script.jsp" %>
    <script type="text/javascript">
        // Global Variable for Problem Categories Store
        // Key: ID for the ProblemCategory
        // Value: the ProblemCategory object
        problemCategoriesOptions = {
            "0": {
                "problemCategorySlug": "none",
                "problemCategoryName": "无"
            }
        <c:forEach items="${problemCategories}" var="problemCategory">
            , "${problemCategory.problemCategoryId}": {
                "problemCategorySlug": "${problemCategory.problemCategorySlug}",
                "problemCategoryName": "${problemCategory.problemCategoryName}"
            }
        </c:forEach>
        };
    </script>
    <script type="text/javascript">
        $('label.all-problem-categories').click(function() {
            // Fix the bug for Checkbox in FlatUI 
            var isChecked = false,
                trigger   = $(this);
            setTimeout(function() {
                isChecked = $(trigger).hasClass('checked');
                
                if ( isChecked ) {
                    $('label.checkbox').addClass('checked');
                } else {
                    $('label.checkbox').removeClass('checked');
                }
            }, 100);
        });
    </script>
    <script type="text/javascript">
        $('tr', '#problem-categories').hover(function() {
            $('ul.actions', $(this)).css('visibility', 'visible');
        }, function() {
            $('ul.actions', $(this)).css('visibility', 'hidden');
        });
    </script>
    <script type="text/javascript">
        $('.action-edit').click(function() {
            var currentRowSet           = $(this).parent().parent().parent().parent(),
                problemCategoryId       = $(currentRowSet).attr('data-value'),
                problemCategoryName     = $('.problem-category-name', $(currentRowSet)).html(),
                problemCategorySlug     = $('.problem-category-slug', $(currentRowSet)).html(),
                parentProblemCategoryId = $('.parent-category', $(currentRowSet)).val();

            $('.edit-fieldset').remove();
            $('tr.hide', '#problem-categories').removeClass('hide');
            $(currentRowSet).addClass('hide');

            $(currentRowSet).after(getEditFieldset(problemCategoryId, problemCategoryName, problemCategorySlug));
            $('#category-parent-edit').append(getParentProblemCategoriesOptions());
            $('#category-parent-edit option[value=%s]'.format(problemCategorySlug), '.edit-fieldset').remove();
            $('#category-parent-edit', '.edit-fieldset').val(getProblemCategorySlugUsingId(parentProblemCategoryId));

            if ( problemCategorySlug == 'uncategorized' ) {
                $('#category-slug-edit', '.edit-fieldset').attr('disabled', 'disabled');
                $('#category-parent-edit', '.edit-fieldset').attr('disabled', 'disabled');
            }
        });
    </script>
    <script type="text/javascript">
        function getProblemCategorySlugUsingId(problemCategoryId) {
            for (var key in problemCategoriesOptions) {
                var problemCategory = problemCategoriesOptions[key];

                if ( key == problemCategoryId &&
                     problemCategoriesOptions.hasOwnProperty(key) ) {
                    return problemCategory['problemCategorySlug'];
                }
            }
            return 'none';
        }
    </script>
    <script type="text/javascript">
        function getEditFieldset(problemCategoryId, problemCategoryName, problemCategorySlug) {
            var tpl =  '<tr class="edit-fieldset" data-value="%s">' +
                       '    <td colspan="3">' +
                       '        <div class="control-group row-fluid">' +
                       '            <label for="category-name-edit">名称</label>' +
                       '            <input id="category-name-edit" class="span12" type="text" value="%s" maxlength="32" />' +
                       '            <p id="category-name-error-message" class="hide"></p>' +
                       '        </div> <!-- .control-group -->' +
                       '        <div class="control-group row-fluid">' +
                       '            <label for="category-slug-edit">别名</label>' +
                       '            <input id="category-slug-edit" class="span12" type="text"  value="%s" maxlength="32" />' +
                       '            <p id="category-slug-error-message" class="hide"></p>' +
                       '        </div> <!-- .control-group -->' +
                       '        <div class="row-fluid">' +
                       '            <label for="category-parent-edit">父节点</label>' +
                       '            <select id="category-parent-edit">' +
                       '            </select>' +
                       '            <p id="category-parent-error-message" class="hide"></p>' +
                       '        </div> <!-- .row-fluid -->' +
                       '        <div id="edit-fieldset-controls" class="row-fluid">' +
                       '            <button class="btn btn-cancel">取消</button>' +
                       '            <button class="btn btn-primary pull-right" type="submit">更新分类目录</button>' +
                       '        </div> <!-- .row-fluid -->' +
                       '    </td>' +
                       '</tr>';
            return tpl.format(problemCategoryId, problemCategoryName, problemCategorySlug);
        }
    </script>
    <script type="text/javascript">
        $('button.btn-danger', '#filters').click(function() {
            if ( !confirm('你确定要继续吗?') ) {
                return;
            }
            $('.alert-error').addClass('hide');
            $('button.btn-danger', '#filters').attr('disabled', 'disabled');
            $('button.btn-danger', '#filters').html('请稍后...');

            var problemCategories   = [],
                action              = $('#actions').val();

            $('label.checkbox', 'table tbody').each(function() {
                if ( $(this).hasClass('checked') ) {
                    var problemCategoryId = $(this).parent().parent().attr('data-value');
                    problemCategories.push(problemCategoryId);
                }
            });

            if ( action == 'delete' ) {
                return doDeleteProblemCategoriesAction(problemCategories);
            }
        });
    </script>
    <script type="text/javascript">
        $('#problem-categories').on('click', '.edit-fieldset .btn-cancel', function() {
            $('.edit-fieldset').remove();
            $('tr.hide', '#problem-categories').removeClass('hide');
        });
    </script>
    <script type="text/javascript">
        $('#problem-categories').on('click', '.edit-fieldset .btn-primary', function() {
            var problemCategoryId       = $(this).parent().parent().parent().attr('data-value'),
                problemCategorySlug     = $('#category-slug-edit', $(this).parent().parent()).val(),
                problemCategoryName     = $('#category-name-edit', $(this).parent().parent()).val(),
                parentProblemCategory   = $('#category-parent-edit', $(this).parent().parent()).val();

            $('#category-name-edit, #category-slug-edit').removeClass('error');
            $('#category-name-error-message, #category-slug-error-message').addClass('hide');
            $('.edit-fieldset .btn-primary', '#problem-categories').attr('disabled', 'disabled');
            $('.edit-fieldset .btn-primary', '#problem-categories').html('请稍后...');

            return doEditProblemCategoryAction(problemCategoryId, problemCategorySlug, 
                    problemCategoryName, parentProblemCategory);
        });
    </script>
    <script type="text/javascript">
        function doEditProblemCategoryAction(problemCategoryId, problemCategorySlug, 
            problemCategoryName, parentProblemCategory) {
            var postData = {
                'problemCategoryId': problemCategoryId,
                'problemCategorySlug': problemCategorySlug,
                'problemCategoryName': problemCategoryName,
                'parentProblemCategory': parentProblemCategory
            };

            $.ajax({
                type: 'POST',
                url: '<c:url value="/administration/editProblemCategory.action" />',
                data: postData,
                dataType: 'JSON',
                success: function(result){
                    return processEditProblemCategoryResult(result);
                }
            });
        }
    </script>
    <script type="text/javascript">
        function processEditProblemCategoryResult(result) {
            if ( result['isSuccessful'] ) {
                // Update Information in List
                var problemCategoryItem         = $('.hide', '#problem-categories'),
                    problemCategoryEditor       = $('.edit-fieldset', '#problem-categories'),
                    problemCategoryName         = $('#category-name-edit', $(problemCategoryEditor)).val(),
                    problemCategorySlug         = $('#category-slug-edit', $(problemCategoryEditor)).val(),
                    parentProblemCategorySlug   = $('#category-parent-edit', $(problemCategoryEditor)).val(),
                    parentProblemCategoryId     = getProblemCategoryIdUsingSlug(parentProblemCategorySlug);

                $('.problem-category-name', $(problemCategoryItem)).html(problemCategoryName);
                $('.problem-category-slug', $(problemCategoryItem)).html(problemCategorySlug);
                $('.parent-category', $(problemCategoryItem)).html(parentProblemCategoryId);

                $('.edit-fieldset').remove();
                $('.hide', '#problem-categories').removeClass('hide');
            } else {
                if ( !result['isProblemCategoryEditable']  || !result['isProblemCategoryExists'] ||
                      result['isProblemCategoryNameEmpty'] || !result['isProblemCategoryNameLegal'] ) {
                    if ( !result['isProblemCategoryEditable'] ) {
                        $('#category-name-error-message').html('您无法编辑该项目');
                    } else if ( !result['isProblemCategoryExists'] ) {
                        $('#category-name-error-message').html('该分类目录不存在.');
                    } else if ( result['isProblemCategoryNameEmpty'] ) {
                        $('#category-name-error-message').html('请填写分类目录名称.');
                    } else if ( !result['isProblemCategoryNameLegal'] ) {
                        $('#category-name-error-message').html('分类目录的名称不得超过32个字符.');
                    }

                    $('#category-name-error-message').removeClass('hide');
                    $('#category-name-edit').addClass('error');
                }

                if ( result['isProblemCategorySlugEmpty'] || !result['isProblemCategorySlugLegal'] ||
                     result['isProblemCategorySlugExists'] ) {
                    if ( result['isProblemCategorySlugEmpty'] ) {
                        $('#category-slug-error-message').html('请填写分类目录别名.');
                    } else if ( !result['isProblemCategorySlugLegal'] ) {
                        $('#category-slug-error-message').html('分类目录别名不得超过32个字符.');
                    } else if ( result['isProblemCategorySlugExists'] ) {
                        $('#category-slug-error-message').html('分类目录别名已被占用.');
                    }

                    $('#category-slug-error-message').removeClass('hide');
                    $('#category-slug-edit').addClass('error');
                }
            }
            $('.edit-fieldset .btn-primary', '#problem-categories').removeAttr('disabled');
            $('.edit-fieldset .btn-primary', '#problem-categories').html('更新分类目录');
        }
    </script>
    <script type="text/javascript">
        function getProblemCategoryIdUsingSlug(problemCategorySlug) {
            for (var key in problemCategoriesOptions) {
                var problemCategory = problemCategoriesOptions[key];

                if ( problemCategoriesOptions.hasOwnProperty(key) &&
                        problemCategory['problemCategorySlug'] == problemCategorySlug) {
                    return key;
                }
            }
            return 0;
        }
    </script>
    <script type="text/javascript">
        $('.action-delete').click(function() {
            var currentRowSet           = $(this).parent().parent().parent().parent(),
                problemCategoryId       = $(currentRowSet).attr('data-value'),
                problemCategories       = [];

            problemCategories.push(problemCategoryId);
            return doDeleteProblemCategoriesAction(problemCategories);
        });
    </script>
    <script type="text/javascript">
        function doDeleteProblemCategoriesAction(problemCategories) {
            var postData = {
                'problemCategories': JSON.stringify(problemCategories)
            };

            $.ajax({
                type: 'POST',
                url: '<c:url value="/administration/deleteProblemCategories.action" />',
                data: postData,
                dataType: 'JSON',
                success: function(result){
                    if ( result['isSuccessful'] ) {
                        processDeleteProblemCategoryResult(result['deletedProblemCategories']);
                    }
                    $('button.btn-danger', '#filters').html('应用');
                    $('button.btn-danger', '#filters').removeAttr('disabled');
                }
            });
        }
    </script>
    <script type="text/javascript">
        function processDeleteProblemCategoryResult(deletedProblemCategories) {
            for ( var i = 0; i < deletedProblemCategories.length; ++ i ) {
                var problemCategoryId = deletedProblemCategories[i];
                $('tr[data-value=%s]'.format(problemCategoryId), '#problem-categories').remove();
            }
        }
    </script>
    <script type="text/javascript">
        function onSubmit() {
            var problemCategorySlug     = $('#category-slug').val(),
                problemCategoryName     = $('#category-name').val(),
                parentProblemCategory   = $('#category-parent').val();

            $('.alert-error', '#new-category-form').addClass('hide');
            $('button[type=submit]', '#new-category-form').attr('disabled', 'disabled');
            $('button[type=submit]', '#new-category-form').html('请稍后...');

            return doCreateProblemCategoryAction(problemCategorySlug, problemCategoryName, parentProblemCategory);
        }
    </script>
    <script type="text/javascript">
        function doCreateProblemCategoryAction(problemCategorySlug, problemCategoryName, parentProblemCategory) {
            var postData = {
                'problemCategorySlug': problemCategorySlug,
                'problemCategoryName': problemCategoryName,
                'parentProblemCategory': parentProblemCategory
            };

            $.ajax({
                type: 'POST',
                url: '<c:url value="/administration/createProblemCategory.action" />',
                data: postData,
                dataType: 'JSON',
                success: function(result){
                    return processCreateProblemCategoryResult(result);
                }
            });
        }
    </script>
    <script type="text/javascript">
        function processCreateProblemCategoryResult(result) {
            if ( result['isSuccessful'] ) {
                window.location.reload();
            } else {
                var errorMessage  = '';

                if ( result['isProblemCategoryNameEmpty'] ) {
                    errorMessage += ' 请填写分类目录名称.<br>';
                } else if ( !result['isProblemCategoryNameLegal'] ) {
                    errorMessage += '分类目录的名称不得超过32个字符<br>';
                }
                if ( result['isProblemCategorySlugEmpty'] ) {
                    errorMessage += '请填写分类目录别名.<br>';
                } else if ( !result['isProblemCategorySlugLegal'] ) {
                    errorMessage += '分类目录别名不得超过32个字符.<br>';
                } else if ( result['isProblemCategorySlugExists'] ) {
                    errorMessage += '分类目录别名已被占用.<br>';
                }
                $('.alert-error', '#new-category-form').html(errorMessage);
                $('.alert-error', '#new-category-form').removeClass('hide');
            }
            $('button[type=submit]', '#new-category-form').removeAttr('disabled');
            $('button[type=submit]', '#new-category-form').html('添加试题分类');
        }
    </script>
    <script type="text/javascript">
        function getParentProblemCategoriesOptions() {
            var options = '';

            for (var problemCategoryId in problemCategoriesOptions) {
                var problemCategory = problemCategoriesOptions[problemCategoryId];

                if ( problemCategoriesOptions.hasOwnProperty(problemCategoryId) ) {
                    options += '<option value="%s">%s</option>'.format(
                        problemCategory['problemCategorySlug'], 
                        problemCategory['problemCategoryName']
                    );
                }
            }
            return options;
        }
    </script>
</body>
</html>