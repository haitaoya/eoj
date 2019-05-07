<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html lang="zh_CN">
<head>
    <meta charset="UTF-8">
    <title>帮助 | ${websiteName}</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="author" content="Haitao Wang">
    <!-- Icon -->
    <link href="/web/assets/img/favicon.ico" rel="shortcut icon" type="image/x-icon">
    <!-- StyleSheets -->
    <link rel="stylesheet" type="text/css" href="/web/assets/css/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="/web/assets/css/bootstrap-responsive.min.css" />
    <link rel="stylesheet" type="text/css" href="/web/assets/css/flat-ui.min.css" />
    <link rel="stylesheet" type="text/css" href="/web/assets/css/font-awesome.min.css" />
    <link rel="stylesheet" type="text/css" href="/web/assets/css/style.css" />
    <link rel="stylesheet" type="text/css" href="/web/assets/css/misc/about.css" />
    <!-- JavaScript -->
    <script type="text/javascript" src="/web/assets/js/jquery-1.11.1.min.js"></script>
    <script type="text/javascript" src="/web/assets/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="/web/assets/js/md5.min.js"></script>
</head>
<body>
    <!-- Header -->
    <%@ include file="/WEB-INF/views/include/header.jsp" %>
    <!-- Content -->
    <div id="content">
        <div id="ribbon"></div> <!-- #ribbon -->
        <div class="container">
            <div class="row-fluid">
            <div class="span2">
                    <div id="sidebar-nav">
                        <h5>帮助</h5>
                        <ul class="contents">
                            <li><a href="#io">输入和输出</a></li>
                            <li><a href="#io">内存和时间限制</a></li>
                            <li><a href="#judge-results">评测结果的含义</a></li>
                            <li><a href="#compile-error">编译错误的原因</a></li>
                        </ul>
                    </div> <!-- #sidebar-nav -->
                </div> <!-- .span2 -->
                <div class="span10">
                    <div id="main-content">
                        <div class="section">
                            <h3 id="io">输入和输出</h3>
                            <div class="markdown">您的程序应该从标准输入读取数据并将结果输出到标准输出. 例如, 您可以在C和C++程序中使用&acute;scanf&acute;和&acute;cin&acute;读取来自标准输入的数据, 使用&acute;printf&acute;和&acute;cout&acute;输出结果至标准输出.在java中可以使用Scanner类定义输入,使用System.out.print进行输出.</div> <!-- .markdown -->
                        </div> <!-- .section -->
                        <div class="section">
                            <h3 id="io">内存和时间限制</h3>
                            <div class="markdown">- 对于C/C++按照题目给定的时间和内存进行限制.
- 对于Java按照题目给定时间和内存的一倍进行限制.</div> <!-- .markdown -->
                        </div> <!-- .section -->
                        <div class="section">
                            <h3 id="judge-results">评测结果的含义</h3>
                            <div class="markdown">- **Pending**: 排队中.
- **Accepted**: 答案正确.
- **Wrong Answer**: 答案错误.
- **Time Limit Exceeded**: 时间超限.
- **Memory Limit Exceeded**:内存超限.
- **Output Limit Exceeded**: 输出超限.
- **Runtime Error**: 运行错误.
- **Presentation Error**: 格式错误.
- **Compile Error**: 编译错误.
- **System Error**: 系统错误.</div> <!-- .markdown -->
                        </div> <!-- .section -->
                        <div class="section">
                            <h3 id="compile-error">编译错误的原因</h3>
                            <div class="markdown"> 对于Java,类的名称必须为&acute;Main&acute;.
                            
在使用中, GNU和VC++存在一些差别, 例如:

- main必须被声明为int, void main将会导致编译错误.
- i 需要在循环体外 &acute;for (int i = 0...) {...}&acute; 重新声明.
- itoa 并不是ANSI的函数.
- __int64 是VC中使用的, 请在ANSI中为64位整型数据使用long long类型.
</div> <!-- .markdown -->
                        </div> <!-- .section -->
                    </div> <!-- #main-content -->
                </div> <!-- .span10 -->

            </div> <!-- .row-fluid -->
        </div> <!-- .container -->
    </div> <!-- #content -->
    <!-- Footer -->
    <%@ include file="/WEB-INF/views/include/footer.jsp" %>
    <!-- Java Script -->
    <!-- Placed at the end of the document so the pages load faster -->
    <script type="text/javascript" src="/web/assets/js/site.js"></script>
    <script type="text/javascript">
        $.getScript('/web/assets/js/markdown.min.js', function() {
            converter = Markdown.getSanitizingConverter();
            $('.markdown').each(function() {
                var plainContent    = $(this).text(),
                    markdownContent = converter.makeHtml(plainContent.replace(/\\\n/g, '\\n'));
                
                $(this).html(markdownContent);
            });
        });
    </script>
    <c:if test="${GoogleAnalyticsCode != ''}">
    ${googleAnalyticsCode}
    </c:if>
</body>
</html>