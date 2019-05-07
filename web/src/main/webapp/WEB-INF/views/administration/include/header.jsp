            <%@ page language="java"  pageEncoding="UTF-8"%>
            <div id="header">
                <a id="sidebar-toggle" href="javascript:void(0);"><i class="fa fa-arrows-alt"></i></a>
                <ul class="nav inline">
                    <li class="dropdown">
                      
                      <a href="<c:url value="/accounts/user/${myProfile.uid}" />"><img src="/web/assets/img/user-white.png" alt="avatar">  ${myProfile.username}</a>
                     
                    </li>
                    <li class="dropdown">
                        <a href="<c:url value="/accounts/login?logout=true" />">注销</a>
					</li>
                </ul>
            </div> <!-- #header -->