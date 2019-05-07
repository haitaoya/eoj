package com.easyoj.web.controller;

import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import com.easyoj.web.model.ProblemTag;

import com.easyoj.web.exception.ResourceNotFoundException;
import com.easyoj.web.model.*;
import com.easyoj.web.service.LanguageService;
import com.easyoj.web.service.ProblemService;
import com.easyoj.web.service.SubmissionService;
import com.easyoj.web.util.CsrfProtector;
import com.easyoj.web.util.HttpRequestParser;
import com.easyoj.web.util.HttpSessionParser;

/**
 * 处理用户的查看试题/提交评测等请求.
 * 
 * @author Haitao Wang
 */
@Controller
@RequestMapping(value="/p")
public class ProblemsController {
	/**
	 * 显示试题库中的全部试题.
	 * @param startIndex - 试题的起始下标
	 * @param keyword - 关键词
	 * @param problemCategorySlug - 试题分类的别名
	 * @param request - HttpRequest对象
	 * @param response - HttpResponse对象
	 * @return 包含试题库页面信息的ModelAndView对象
	 * @throws UnsupportedEncodingException 
	 */
	@RequestMapping(value="", method=RequestMethod.GET)
	public ModelAndView problemsView(
			@RequestParam(value="start", required=false, defaultValue="1") long startIndex,
			@RequestParam(value="keyword", required = false) String keyword,
			@RequestParam(value="category", required = false) String problemCategorySlug,
			@RequestParam(value="tag", required = false) String problemTag,
			HttpServletRequest request, HttpServletResponse response) throws UnsupportedEncodingException {
		long startIndexOfProblems = getFirstIndexOfProblems();//最小题号id
		if ( startIndex < startIndexOfProblems ) {
			startIndex = startIndexOfProblems;
		}
		
		List<Problem> problems = problemService.getProblemsUsingFilters(startIndex, keyword, problemCategorySlug, problemTag, true, NUMBER_OF_PROBLEMS_PER_PAGE);
		//xml 方法重写 和 getProblemsUsingFilters 查询保持一致
		long totalProblems = problemService.getNumberOfProblemsUsingFilters(keyword, problemCategorySlug, true);
		//add tag function
		//Map<Long, List<ProblemTag>> problemTagRelationships =problemService.getProblemTagsOfProblems(startIndex, startIndex + NUMBER_OF_PROBLEMS_PER_PAGE);
		Map<Long, List<ProblemTag>> problemTagRelationships =problemService.getProblemTagsOfProblems(startIndex, keyword, problemCategorySlug, problemTag, true, NUMBER_OF_PROBLEMS_PER_PAGE);
		ModelAndView view = new ModelAndView("problems/problems");
		view.addObject("problems", problems)
			.addObject("startIndexOfProblems", startIndexOfProblems)
			.addObject("numberOfProblemsPerPage", NUMBER_OF_PROBLEMS_PER_PAGE)
			.addObject("totalProblems", totalProblems)
			.addObject("problemCategories", problemService.getProblemCategoriesWithHierarchy());
		view.addObject("problemTagRelationships", problemTagRelationships);
		
		HttpSession session = request.getSession();
		if ( isLoggedIn(session) ) {
			//当前用户的试题完成状态
			long userId = (Long)session.getAttribute("uid");
			long endIndex = problemService.getLastIndexOfProblems(true, startIndex, NUMBER_OF_PROBLEMS_PER_PAGE);
			// endIndex+1 获取到最后一个边界值
			Map<Long, Submission> submissionOfProblems = submissionService.getSubmissionOfProblems(userId, startIndex, endIndex+1);
			view.addObject("submissionOfProblems", submissionOfProblems);
		}
		return view;
	}
	
	/**
	 * 获取试题的起始编号.
	 * @return 试题的起始编号
	 */
	private long getFirstIndexOfProblems() {
		return problemService.getFirstIndexOfProblems();
	}
	
	/**
	 * 获取试题列表的json格式 用于显示更多试题.
	 * @param startIndex - 试题的起始下标
	 * @param request - HttpRequest对象
	 * @return 一个包含试题列表的HashMap对象
	 */
	@RequestMapping(value="/getProblems.action", method=RequestMethod.GET)
	public @ResponseBody Map<String, Object> getProblemsAction(
			@RequestParam(value="startIndex") long startIndex,
			@RequestParam(value="keyword", required = false) String keyword,
			@RequestParam(value="category", required = false) String problemCategorySlug,
			@RequestParam(value="tag", required = false) String problemTag,
			HttpServletRequest request) {
		HttpSession session = request.getSession();
		List<Problem> problems = problemService.getProblemsUsingFilters(startIndex, keyword, problemCategorySlug, problemTag, true, NUMBER_OF_PROBLEMS_PER_PAGE);
		Map<Long, Submission> submissionOfProblems = null;
		Map<Long, List<ProblemTag>> problemTagRelationships =problemService.getProblemTagsOfProblems(startIndex, keyword, problemCategorySlug, problemTag, true, NUMBER_OF_PROBLEMS_PER_PAGE);
		if ( isLoggedIn(session) ) {
			long userId = (Long)session.getAttribute("uid");
			submissionOfProblems = submissionService.
					getSubmissionOfProblems(userId, startIndex, startIndex + NUMBER_OF_PROBLEMS_PER_PAGE);
		}
		
		Map<String, Object> result = new HashMap<>(4, 1);
		result.put("isSuccessful", problems != null && !problems.isEmpty());
		result.put("problems", problems);
		result.put("submissionOfProblems", submissionOfProblems);
		result.put("problemTagRelationships", problemTagRelationships);
		return result;
	}
	
	/**
	 * 检查用户是否已经登录.
	 * @param session - HttpSession 对象
	 * @return 用户是否已经登录
	 */
	private boolean isLoggedIn(HttpSession session) {
		Boolean isLoggedIn = (Boolean)session.getAttribute("isLoggedIn");
		if ( isLoggedIn == null || !isLoggedIn.booleanValue() ) {
			return false;
		}
		return true;
	}
	
	/**
	 * 加载试题的详细信息.
	 * @param problemId - 试题的唯一标识符
	 * @param request - HttpRequest对象
	 * @param response - HttpResponse对象
	 * @return 包含试题详细信息的ModelAndView对象
	 */
	@RequestMapping(value="/{problemId}", method=RequestMethod.GET)
	public ModelAndView problemView(
			@PathVariable("problemId") long problemId,
			HttpServletRequest request, HttpServletResponse response) {
		HttpSession session = request.getSession();
		boolean isLoggedIn = isLoggedIn(session);
		Problem problem = problemService.getProblem(problemId);
		
		if ( problem == null ) {
			throw new ResourceNotFoundException();
		} else if ( !problem.isPublic() ) {
			boolean isAllowToAccess = false;
			
			if ( isLoggedIn ) {
				User currentUser = HttpSessionParser.getCurrentUser(session);
				if ( currentUser.getUserGroup().getUserGroupSlug().equals("administrators") ) {
					isAllowToAccess = true;
				}
			}
			if ( !isAllowToAccess ) {
				throw new ResourceNotFoundException();
			}
		}
		
		ModelAndView view = new ModelAndView("problems/problem");
		view.addObject("problem", problem);
		if ( isLoggedIn ) {
			long userId = (Long)session.getAttribute("uid");
			//最新评测结果
			Map<Long, Submission> submissionOfProblems = submissionService.getSubmissionOfProblems(userId, problemId, problemId + 1);
			//List<Submission> submissions = submissionService.getSubmissionUsingProblemIdAndUserId(problemId, userId, NUMBER_OF_SUBMISSIONS_PER_PROBLEM);
			List<Language> languages = languageService.getAllLanguages();
			
			view.addObject("latestSubmission", submissionOfProblems);
			//view.addObject("submissions", submissions);
			view.addObject("languages", languages);
			view.addObject("csrfToken", CsrfProtector.getCsrfToken(session));
		}
		return view;
	}
	
	
	/**
	 * 创建提交.
	 * @param problemId - 试题的唯一标识符
	 * @param languageSlug - 编程语言的别名
	 * @param code - 代码
	 * @param csrfToken - 用于防止CSRF攻击的Token
	 * @param request - HttpRequest对象
	 * @return 一个包含提交记录创建结果的Map<String, Object>对象
	 */
	@RequestMapping(value="/createSubmission.action", method=RequestMethod.POST)
	public @ResponseBody Map<String, Object> createSubmissionAction(
			@RequestParam(value="problemId") long problemId,
			@RequestParam(value="languageSlug") String languageSlug,
			@RequestParam(value="code") String code,
			@RequestParam(value="csrfToken") String csrfToken,
			HttpServletRequest request) {
		HttpSession session = request.getSession();
		String ipAddress = HttpRequestParser.getRemoteAddr(request);
		User currentUser = HttpSessionParser.getCurrentUser(session);
		boolean isCsrfTokenValid = CsrfProtector.isCsrfTokenValid(csrfToken, session);
		
		Map<String, Object> result = submissionService.createSubmission(
				currentUser, problemId, languageSlug, code, isCsrfTokenValid);
		boolean isSuccessful = (Boolean)result.get("isSuccessful");
		if ( isSuccessful ) {
			long submissionId = (Long)result.get("submissionId");
			LOGGER.info(String.format("User: {%s} submitted code with SubmissionId #%s at %s", 
					new Object[] {currentUser, submissionId, ipAddress}));
		}
		return result;
	}
	
	/**
	 * 每次请求所加载试题数量.
	 */
	private static final int NUMBER_OF_PROBLEMS_PER_PAGE = 100;
	
	/**
	 * 每个试题加载最近提交的数量.
	 */
	private static final int NUMBER_OF_SUBMISSIONS_PER_PROBLEM = 10;

	/**
	 * 每个试题加载讨论的数量.
	 */
	//private static final int NUMBER_OF_DISCUSSTION_THREADS_PER_PROBLEM = 1;
	
	/**
	 * 自动注入的ProblemService对象.
	 * 用于完成试题的逻辑操作.
	 */
	@Autowired
	private ProblemService problemService;
	
	/**
	 * 自动注入的SubmissionService对象.
	 * 用于处理试题详情页的提交请求.
	 */
	@Autowired
	private SubmissionService submissionService;
	
	/**
	 * 自动注入的LanguageService对象.
	 * 用于加载试题详情页的语言选项.
	 */
	@Autowired
	private LanguageService languageService;

	/**
	 * 自动注入的DiscussionService对象.
	 * 用于获取试题相关的讨论.
	 */
	/*
	@Autowired
	private DiscussionService discussionService;
	*/
	
	/**
	 * 日志记录器.
	 */
	private static final Logger LOGGER = LogManager.getLogger(ProblemsController.class);
}
