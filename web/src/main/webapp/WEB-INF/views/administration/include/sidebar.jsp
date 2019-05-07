       <%@ page language="java"  pageEncoding="UTF-8"%>
        <div id="sidebar">
            <div id="logo">
                <a href="<c:url value="/" />">
                    <!-- <h4 style="color: #ffffff">Easy Online Judge</h4> -->
                    <img src="/web/assets/img/logo-line.png" alt="Logo">
                </a>
            </div> <!-- #logo -->
            <div id="sidebar-nav">
                <ul class="nav">
                    <li class="nav-item primary-nav-item">
                        <a href="<c:url value="/administration" />"><i class="fa fa-dashboard"></i>控制板</a>
                    </li>
                    <li class="nav-item primary-nav-item nav-item-has-children">
                        <a href="javascript:void(0);"><i class="fa fa-users"></i>用户 <i class="fa fa-caret-right"></i></a>
                        <ul class="sub-nav nav">
                            <li class="nav-item secondary-nav-item"><a href="<c:url value="/administration/all-users" />">所有用户</a></li>
                            <li class="nav-item secondary-nav-item"><a href="<c:url value="/administration/new-user" />">创建用户</a></li>
                            <li class="nav-item secondary-nav-item hide"><a href="<c:url value="/administration/edit-user" />">编辑用户</a></li>
                        </ul>
                    </li>
                    <li class="nav-item primary-nav-item nav-item-has-children">
                        <a href="javascript:void(0);"><i class="fa fa-question-circle"></i> 试题 <i class="fa fa-caret-right"></i></a>
                        <ul class="sub-nav nav">
                            <li class="nav-item secondary-nav-item"><a href="<c:url value="/administration/all-problems" />">所有试题</a></li>
                            <li class="nav-item secondary-nav-item"><a href="<c:url value="/administration/new-problem" />">创建试题</a></li>
                            <li class="nav-item secondary-nav-item"><a href="<c:url value="/administration/problem-categories" />">试题分类</a></li>
                            <li class="nav-item secondary-nav-item hide"><a href="<c:url value="/administration/edit-problem" />">试题编辑</a></li>
                        </ul>
                    </li>
                    <li class="nav-item primary-nav-item nav-item-has-children">
                        <a href="javascript:void(0);"><i class="fa fa-paperclip"></i> 竞赛 <i class="fa fa-caret-right"></i></a>
                        <ul class="sub-nav nav">
                            <li class="nav-item secondary-nav-item"><a href="<c:url value="/administration/all-contests" />">所有竞赛</a></li>
                            <li class="nav-item secondary-nav-item"><a href="<c:url value="/administration/new-contest" />">创建竞赛</a></li>
                            <li class="nav-item secondary-nav-item hide"><a href="<c:url value="/administration/edit-contest" />">竞赛编辑</a></li>
                        </ul>
                    </li>
                    <li class="nav-item primary-nav-item nav-item-has-children">
                        <a href="javascript:void(0);"><i class="fa fa-code"></i> 提交 <i class="fa fa-caret-right"></i></a>
                        <ul class="sub-nav nav">
                            <li class="nav-item secondary-nav-item"><a href="<c:url value="/administration/all-submissions" />">所有提交记录</a></li>
                        </ul>
                    </li>
                    <li class="nav-item primary-nav-item nav-item-has-children">
                        <a href="javascript:void(0);"><i class="fa fa-cogs"></i> 设置 <i class="fa fa-caret-right"></i></a>
                        <ul class="sub-nav nav">
                            <li class="nav-item secondary-nav-item"><a href="<c:url value="/administration/general-settings" />">网站信息设置</a></li>
                            <li class="nav-item secondary-nav-item"><a href="<c:url value="/administration/language-settings" />">编程语言设置</a></li>
                        </ul>
                    </li>
                </ul>
            </div> <!-- #sidebar-nav -->
        </div> <!-- #sidebar -->