package com.easyoj.web.controller;

import java.util.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.easyoj.web.model.*;
import com.easyoj.web.service.*;
import com.easyoj.web.util.PageHelper;

/**
 * 处理应用程序公共的请求.
 * 
 * @author Haitao Wang
 */
@Controller
@RequestMapping(value="/bulletinboard")
public class BulletinBoardController {
	/**
	 * 公告栏控制器. mark
	 * @param request - HttpRequest对象
	 * @param response - HttpResponse对象
	 * @return 一个包含首页内容的ModelAndView对象
	 */
	@RequestMapping(value="/getBulletinBoardMessagePage", method=RequestMethod.GET)
	public @ResponseBody PageHelper<BulletinBoardMessage> allBulletinBoardMessage(BulletinBoardMessage bulletinBoardMessage,HttpServletRequest request, HttpServletResponse response) {
		 PageHelper<BulletinBoardMessage> pageHelper = new PageHelper<BulletinBoardMessage>();
			// 统计总记录数
			Long total = bulletinBoardService.getNumberOfBulletinBoardMessages();
			pageHelper.setTotal(total);
			// 查询当前页实体对象
			List<BulletinBoardMessage> list = bulletinBoardService.getBulletinBoardMessages(bulletinBoardMessage.getOffset(), bulletinBoardMessage.getLimit());
			pageHelper.setRows(list);
			return pageHelper;
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
	 * 每次加载布告栏消息的数量.
	 */
	/**
	 * 自动注入的BulletinBoardService对象.
	 * 用于获取布告板的最新消息.
	 */
	@Autowired
	private BulletinBoardService bulletinBoardService;
}
