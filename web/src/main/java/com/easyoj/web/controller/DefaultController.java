package com.easyoj.web.controller;

import java.util.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.easyoj.web.messenger.ApplicationEventListener;
import com.easyoj.web.model.*;
import com.easyoj.web.service.*;

/**
 * 处理应用程序公共的请求.
 * 
 * @author Haitao Wang
 */
@Controller
@RequestMapping(value="/")
public class DefaultController {
	/**
	 * 显示应用程序的首页. mark
	 * @param request - HttpRequest对象
	 * @param response - HttpResponse对象
	 * @return 一个包含首页内容的ModelAndView对象
	 */
	@RequestMapping(value="/", method=RequestMethod.GET)
	public ModelAndView indexView(HttpServletRequest request, HttpServletResponse response) {
		//List<Contest> contests = contestService.getContests(null, 0, NUMBER_OF_CONTESTS_PER_REQUEST);
		List<BulletinBoardMessage> bulletinBoardMessages = bulletinBoardService.getBulletinBoardMessages(
				0, NUMBER_OF_BULLETIN_MESSAGES_PER_REQUEST);

		ModelAndView view = new ModelAndView("index");
		view.addObject("currentTime", new Date());
		view.addObject("bulletinBoardMessages", bulletinBoardMessages);
		return view;
	}

	/**
	 * 显示评测机信息页面.
	 * @param request - HttpRequest对象
	 * @param response - HttpResponse对象
	 * @return 一个包含评测机信息页面内容的ModelAndView对象
	 */
	@RequestMapping(value="/judgers", method=RequestMethod.GET)
	public ModelAndView judgersView(
			HttpServletRequest request, HttpServletResponse response) {
		ModelAndView view = new ModelAndView("misc/judgers");
		view.addObject("languages", languageService.getAllLanguages());
		return view;
	}
	
	/**
	 * 获取评测机列表.
	 * @param offset - 当前加载评测机的UID
	 * @param request - HttpRequest对象
	 * @return 一个包含评测机列表信息的List<Map<String, String>>对象
	 */
	@RequestMapping(value="/getJudgers.action", method=RequestMethod.GET)
	public @ResponseBody Map<String, Object> getJudgersAction(
			@RequestParam(value="startIndex", required=false, defaultValue="0") long offset,
			HttpServletRequest request) {
		Map<String, Object> result = new HashMap<>();
		List<Map<String, String>> judgers = getJudgers(offset);
		
		result.put("isSuccessful", judgers != null && !judgers.isEmpty());
		result.put("judgers", judgers);
		return result;
	}
	/**
	 * 加载排名页面.
	 * @param request - HttpRequest对象
	 * @param response - HttpResponse对象
	 * @param page - 页数
	 * @param scope - 查询范围
	 * @return 包含用户列表页面信息的ModelAndView对象
	 */
	@RequestMapping(value="/rankList", method=RequestMethod.GET)
	public ModelAndView allUsersView(
			@RequestParam(value="page", required=false, defaultValue="1") long pageNumber,
			@RequestParam(value="scope", required=false, defaultValue="") String scope,
			HttpServletRequest request, HttpServletResponse response) {
		final int NUMBER_OF_USERS_PER_PAGE = 100;
		UserGroup userGroup = userService.getUserGroupUsingSlug("users");
		long totalUsers = userService.getNumberOfUsers(userGroup);
		long offset = (pageNumber >= 1 ? pageNumber - 1 : 0) * NUMBER_OF_USERS_PER_PAGE;
		List<UserRank> ranklist = userService.getRankListOfUsers(userGroup,offset, NUMBER_OF_USERS_PER_PAGE,scope);
		
		ModelAndView view = new ModelAndView("rankList/rankList");
		view.addObject("currentPage", pageNumber);
		view.addObject("totalPages", (long) Math.ceil(totalUsers * 1.0 / NUMBER_OF_USERS_PER_PAGE));
		view.addObject("ranklist", ranklist);
		return view;
	}
	/**
	 * 获取评测机的详细信息.
	 * @param offset - 当前加载评测机的UID
	 * @return 包含评测机的详细信息的List<Map<String, String>>对象
	 */
	private List<Map<String, String>> getJudgers(long offset) {
		UserGroup userGroup = userService.getUserGroupUsingSlug("judgers");
		List<User> judgersList = userService.getUserUsingUserGroup(userGroup, offset, NUMBER_OF_JUDGERS_PER_REQUEST);
		List<Map<String, String>> judgers = new ArrayList<Map<String, String>>();
		
		for ( User judger : judgersList ) {
			Map<String, String> judgerInformation = new HashMap<>(3, 1);
			String username = judger.getUsername();
			String description = keepAliveEventListener.getJudgerDescription(username);
			
			judgerInformation.put("username", username);
			judgerInformation.put("description", description);
			judgers.add(judgerInformation);
		}
		return judgers;
	}
	
	/**
	 * 显示帮助页面.
	 * @param request - HttpRequest对象
	 * @param response - HttpResponse对象
	 * @return 一个包含帮助页面内容的ModelAndView对象
	 */
	@RequestMapping(value="/help", method=RequestMethod.GET)
	public ModelAndView helpView(
			HttpServletRequest request, HttpServletResponse response) {
		ModelAndView view = new ModelAndView("misc/help");
		return view;
	}
		
	/**
	 * 对于所有未正常映射URL的页面, 显示页面未找到.
	 * @param request - HttpRequest对象
	 * @param response - HttpResponse对象
	 * @return 返回一个包含异常信息的ModelAndView对象
	 */
	@RequestMapping(value="/*", method=RequestMethod.GET)
	public ModelAndView notFoundView(
			HttpServletRequest request, HttpServletResponse response) {
		ModelAndView view = new ModelAndView("errors/404");
		return view;
	}
	
	/**
	 * 显示升级浏览器页面.
	 * @param request - HttpRequest对象
	 * @param response - HttpResponse对象
	 * @return 一个包含升级浏览器页面内容的ModelAndView对象
	 */
	@RequestMapping(value="/not-supported", method=RequestMethod.GET)
	public ModelAndView notSupportedView(
			HttpServletRequest request, HttpServletResponse response) {
		ModelAndView view = new ModelAndView("errors/not-supported");
		return view;
	}
	
	/**
	 * 每次加载评测机的数量.
	 */
	private static final int NUMBER_OF_JUDGERS_PER_REQUEST = 10;



	/**
	 * 每次加载公告消息的数量.
	 */
	private static final int NUMBER_OF_BULLETIN_MESSAGES_PER_REQUEST = 10;
	
	/**
	 * 自动注入的UserService对象.
	 * 用于获取评测机页面的评测机列表.
	 */
	@Autowired
	private UserService userService;
	
	/**
	 * 自动注入的SubmissionService对象.
	 * 用于获取排名列表.
	 */
	@Autowired
	private SubmissionService submissionService;
	/**
	 * 自动注入的LanguageService对象.
	 * 用于获取评测机页面的编译命令.
	 */
	@Autowired
	private LanguageService languageService;

	/**
	 * 自动注入的BulletinBoardService对象.
	 * 用于获取布告板的最新消息.
	 */
	@Autowired
	private BulletinBoardService bulletinBoardService;
	
	/**
	 * 自动注入的ApplicationEventListener对象.
	 * 用于获取评测机的在线状态.
	 */
	@Autowired
	private ApplicationEventListener keepAliveEventListener;
}
