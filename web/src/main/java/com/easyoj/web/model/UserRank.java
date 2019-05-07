package com.easyoj.web.model;

import java.io.Serializable;

import com.fasterxml.jackson.annotation.JsonIgnore;

/**
 * 用于存储排名信息的model
 * 没有对应数据库的表
 * 
 * @author Haitao Wang
 */
public class UserRank implements Serializable {
	/**
	 * 用户的默认构造函数. 
	 */
	public UserRank() { }
	
	/**
	 * 获取用户 ID
	 * @return 用户ID 
	 */
	public long getUid() {
		return uid;
	}

	/**
	 * 设置用户ID
	 * @param uid - 用户ID
	 */
	public void setUid(long uid) {
		this.uid = uid;
	}

	/**
	 * 获取用户名
	 * @return 用户名
	 */
	public String getUsername() {
		return username;
	}

	/**
	 * 设置用户名
	 * @param username - 用户名
	 */
	public void setUsername(String username) {
		this.username = username;
	}

	/**
	 * 获取用户总提交数
	 * @return 用户总提交数
	 */
	public Long getSubmissionNum() {
		return submissionNum;
	}

	/**
	 * 设置用户总提交数
	 * @param submissionNum - 用户总提交数
	 */
	public void setSubmissionNum(Long submissionNum) {
		this.submissionNum = submissionNum;
	}

	/**
	 * 获取用户通过试题数
	 * @return 用户通过试题数
	 */
	public Long getAcceptNum() {
		return acceptNum;
	}

	/**
	 * 设置用户通过试题数
	 * @param acceptNum - 用户通过试题数
	 */
	public void setAcceptNum(Long acceptNum) {
		this.acceptNum = acceptNum;
	}

	/* (non-Javadoc)
	 * @see java.lang.Object#hashCode()
	 */
	public int hashCode() {
		return (int) uid;
	}
	

	/* (non-Javadoc)
	 * @see java.lang.Object#toString()
	 */
	public String toString() {
		return String.format("UserRank: [Uid=%s, Username=%s, SubmissionNum=%s, AcceptNum=%s]",
				new Object[] { uid, username, submissionNum, acceptNum });
	}
	
	/**
	 * 用户的唯一标识符.
	 */
	private long uid;
	
	/**
	 * 用户名.
	 */
	private String username;

	/**
	 * 试题提交数
	 */
	private Long submissionNum;
	
	/**
	 * 试题通过数
	 */
	private Long acceptNum;
	
	
	/**
	 * 唯一的序列化标识符.
	 */
	private static final long serialVersionUID = 2264592151943252507L;
}
