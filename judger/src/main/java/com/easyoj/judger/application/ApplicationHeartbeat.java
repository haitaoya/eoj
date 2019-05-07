package com.easyoj.judger.application;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import com.easyoj.judger.mapper.UserMapper;
import com.easyoj.judger.messenger.MessageSender;
import com.easyoj.judger.model.User;
import com.easyoj.judger.util.DigestUtils;

/**
 * 应用程序心跳.
 * 用于向Web模块发送Keep-Alive信息.
 * 
 * @author Haitao Wang
 */
@Component
public class ApplicationHeartbeat implements Runnable {
	/* (non-Javadoc)
	 * @see java.lang.Runnable#run()
	 */
	public void run() {
		if ( !isIdentityValid() ) {
			LOGGER.error("Unauthorized: Please check your username and password.");
			System.exit(-1);
		}
		Calendar calendar = Calendar.getInstance();
		long currentTime = calendar.getTimeInMillis();
		
		Map<String, Object> mapMessage = new HashMap<>();
		mapMessage.put("event", "KeepAlive");
		mapMessage.put("username", judgerUsername);
		mapMessage.put("description", getDescription());
		mapMessage.put("heartbeatTime", currentTime);
		messageSender.sendMessage(mapMessage);
		LOGGER.info("Heartbeat sent to the web server.");
	}
	
	/**
	 * 检查评测机的身份信息是否有效.
	 * @return 评测机的身份信息是否有效
	 */
	private boolean isIdentityValid() {
		User user = userMapper.getUserUsingUsername(judgerUsername);
		
		if ( user != null && "judgers".equals(user.getUserGroup().getUserGroupSlug()) &&
				user.getPassword().equals(DigestUtils.md5Hex(judgerPassword))) {
			return true;
		}
		return false;
	}
	
	/**
	 * 获取评测机的描述信息.
	 * TODO 使用JNI获取计算机的硬件信息
	 * @return 评测机的描述信息
	 */
	private String getDescription() {
		return judgerDescription;
	}
	
	/**
	 * 评测机身份信息.
	 * 评测机的用户名.
	 */
	@Value("${judger.username}")
	private String judgerUsername;
	
	/**
	 * 评测机身份信息.
	 * 评测机的密码.
	 */
	@Value("${judger.password}")
	private String judgerPassword;
	
	/**
	 * 评测机身份信息.
	 * 评测机的密码.
	 */
	@Value("${judger.description}")
	private String judgerDescription;
	
	/**
	 * 自动注入的MessageSender对象.
	 * 用于向消息队列发送消息.
	 */
	@Autowired
	private MessageSender messageSender;
	
	/**
	 * 自动注入的UserMapper对象.
	 * 用于验证评测机的身份信息.
	 */
	@Autowired
	private UserMapper userMapper;
	
	/**
	 * 日志记录器.
	 */
	private static final Logger LOGGER = LogManager.getLogger(ApplicationHeartbeat.class);
}
