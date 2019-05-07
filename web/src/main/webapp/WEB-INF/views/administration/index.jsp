<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh_CN">
<head>
    <meta charset="UTF-8">
    <title>运维管理 | ${websiteName}</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="author" content="Haitao Wang">
    <!-- Icon -->
    <link href="/web/assets/img/favicon.ico?" rel="shortcut icon" type="image/x-icon">
    <!-- StyleSheets -->
    <link rel="stylesheet" type="text/css" href="/web/assets/css/bootstrap.min.css?" />
    <link rel="stylesheet" type="text/css" href="/web/assets/css/bootstrap-responsive.min.css?" />
    <link rel="stylesheet" type="text/css" href="/web/assets/css/flat-ui.min.css?" />
    <link rel="stylesheet" type="text/css" href="/web/assets/css/font-awesome.min.css?" />
    <link rel="stylesheet" type="text/css" href="/web/assets/css/administration/style.css?" />
    <link rel="stylesheet" type="text/css" href="/web/assets/css/administration/dashboard.css?" />
    <!-- JavaScript -->
    <script type="text/javascript" src="/web/assets/js/jquery-1.11.1.min.js?"></script>
    <script type="text/javascript" src="/web/assets/js/bootstrap.min.js?"></script>
    <script type="text/javascript" src="/web/assets/js/md5.min.js?"></script>
    <script type="text/javascript" src="/web/assets/js/pace.min.js?"></script>
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
                <h2 class="page-header">
                    <i class="fa fa-dashboard"></i> 控制板
                </h2>
                <div id="overview" class="row-fluid">
                    <div class="span3">
                        <div id="overview-users" class="widget">
                            <div class="row-fluid glance">
                                <div class="span4 text-center">
                                    <i class="fa fa-users"></i>
                                </div> <!-- .span4 -->
                                <div class="span8">
                                    <span class="text-uppercase">用户总数</span>
                                    <h2>${totalUsers}</h2>
                                </div> <!-- .span8 -->
                            </div> <!-- .row-fluid -->
                            <div class="row-fluid">
                                <div class="span6 border-right">
                                    <span class="text-uppercase">今日注册用户</span>
                                    <h4>${newUsersToday}</h4>
                                </div> <!-- .span6 -->
                                <div class="span6">
                                    <span class="text-uppercase">当前在线用户</span>
                                    <h4>${onlineUsers}</h4>
                                </div> <!-- .span6 -->
                            </div> <!-- .row-fluid -->
                        </div> <!-- #overview-users -->
                    </div> <!-- .span3 -->
                    <div class="span3">
                        <div id="overview-problems" class="widget">
                            <div class="row-fluid glance">
                                <div class="span4 text-center">
                                    <i class="fa fa-question-circle"></i>
                                </div> <!-- .span4 -->
                                <div class="span8">
                                    <span class="text-uppercase">试题总数</span>
                                    <h2>${totalProblems}</h2>
                                </div> <!-- .span8 -->
                            </div> <!-- .row-fluid -->
                            <div class="row-fluid">
                                <div class="span6 border-right">
                                    <span class="text-uppercase">评测点总数</span>
                                    <h4>${numberOfCheckpoints}</h4>
                                </div> <!-- .span6 -->
                                <div class="span6">
                                    <span class="text-uppercase">私有试题数</span>
                                    <h4>${privateProblems}</h4>
                                </div> <!-- .span6 -->
                            </div> <!-- .row-fluid -->
                        </div> <!-- #overview-problems -->
                    </div> <!-- .span3 -->
                    <div class="span3">
                        <div id="overview-contests" class="widget">
                            <div class="row-fluid glance">
                                <div class="span4 text-center">
                                    <i class="fa fa-paperclip"></i>
                                </div> <!-- .span4 -->
                                <div class="span8 text-right">
                                    <span class="text-uppercase">即将开始的竞赛</span>
                                    <h2>0</h2>
                                </div> <!-- .span8 -->
                            </div> <!-- .row-fluid -->
                            <a href="<c:url value="/administration/all-contests" />" class="more">
                                	更多竞赛 <i class="fa fa-arrow-circle-right"></i> 
                            </a>
                        </div> <!-- #overview-contests -->
                    </div> <!-- .span3 -->
                    <div class="span3">
                        <div id="overview-submissions" class="widget">
                            <div class="row-fluid glance">
                                <div class="span4 text-center">
                                    <i class="fa fa-code"></i>
                                </div> <!-- .span4 -->
                                <div class="span8 text-right">
                                    <span class="text-uppercase">今日提交</span>
                                    <h2>${submissionsToday}</h2>
                                </div> <!-- .span8 -->
                            </div> <!-- .row-fluid -->
                            <a href="<c:url value="/administration/all-submissions" />" class="more">
                            	    更多提交 <i class="fa fa-arrow-circle-right"></i> 
                            </a>
                        </div> <!-- #overview-submissions -->
                    </div> <!-- .span3 -->
                </div> <!-- #overview -->
                <div class="row-fluid">
                    <div class="span8">
                        <div id="submissions-panel" class="panel">
                            <div class="header">
                                <div class="row-fluid">
                                    <div class="span8">
                                        <h5>
                                            <i class="fa fa-bar-chart"></i> 
                                            	提交状态
                                        </h5>
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
                        </div> <!-- #submissions-panel -->
                    </div> <!-- .span8 -->
                    <div class="span4">
                        <div id="system-panel" class="panel">
                            <div class="header">
                                <h5>
                                    <i class="fa fa-info-circle"></i> 
                                    	系统信息
                                </h5>
                            </div> <!-- .header -->
                            <div class="body">
                                <div class="row-fluid">
                                    <div class="span4">内存使用</div> <!-- .span4 -->
                                    <div class="span8">${memoryUsage} MB</div> <!-- .span8 -->
                                </div> <!-- .row-fluid -->
                                <div class="row-fluid">
                                    <div class="span4">在线的评测机</div> <!-- .span4 -->
                                    <div class="span8">${onlineJudgers}</div> <!-- .span8 -->
                                </div> <!-- .row-fluid -->
                            </div> <!-- .body -->
                        </div> <!-- #system-panel -->
                    </div> <!-- .span4 -->
                </div> <!-- .row-fluid -->
            </div> <!-- #content -->
        </div> <!-- #container -->
    </div> <!-- #wrapper -->
    <!-- Java Script -->
    <!-- Placed at the end of the document so the pages load faster -->
    <%@ include file="/WEB-INF/views/administration/include/footer-script.jsp" %>
    <script type="text/javascript">
        $.getScript('/web/assets/js/highcharts.min.js?', function() {
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
                url: '<c:url value="/administration/getNumberOfSubmissions.action" />',
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
                        text: '提交统计'
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
</body>
</html>