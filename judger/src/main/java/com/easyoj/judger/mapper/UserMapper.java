package com.easyoj.judger.mapper;

import org.apache.ibatis.annotations.CacheNamespace;
import org.apache.ibatis.annotations.One;
import org.apache.ibatis.annotations.Options;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Result;
import org.apache.ibatis.annotations.Results;
import org.apache.ibatis.annotations.Select;

import com.easyoj.judger.model.Language;
import com.easyoj.judger.model.User;
import com.easyoj.judger.model.UserGroup;

/**
 * User Data Access Object.
 * 
 * @author Haitao Wang
 */
@CacheNamespace(implementation = org.mybatis.caches.ehcache.EhcacheCache.class)
public interface UserMapper {
	/**
	 * 通过用户名获取用户对象.
	 * @param username - 用户名
	 * @return 预期的用户对象或空引用
	 */
	@Select("SELECT * FROM eoj_users WHERE username = #{username}")
	@Options(useCache = false)
	@Results(value = {
		@Result(property = "userGroup", column = "user_group_id", javaType = UserGroup.class, one = @One(select="com.easyoj.judger.mapper.UserGroupMapper.getUserGroupUsingId")),
		@Result(property = "preferLanguage", column = "prefer_language_id", javaType = Language.class, one = @One(select="com.easyoj.judger.mapper.LanguageMapper.getLanguageUsingId"))
	})
	User getUserUsingUsername(@Param("username") String username);
}
