package com.easyoj.web.mapper;

import java.util.List;

import org.apache.ibatis.annotations.CacheNamespace;
import org.apache.ibatis.annotations.Param;
import com.easyoj.web.model.ProblemTag;
import com.easyoj.web.model.ProblemTagRelationship;

/**
 * ProblemTag Data Access Object.
 * 
 * @author Haitao Wang
 */
@CacheNamespace(implementation = org.mybatis.caches.ehcache.EhcacheCache.class)
public interface ProblemTagMapper {
	/**
	 * 获取全部的试题标签.
	 * @return 包含试题标签的列表
	 */
	List<ProblemTag> getProblemTags();
	
	/**
	 * 通过试题标签的唯一标识符获取试题标签对象.
	 * @param problemTagId - 试题标签的唯一标识符
	 * @return 预期的试题标签对象或空引用
	 */
	ProblemTag getProblemTagUsingTagId(long problemTagId);
	
	/**
	 * 通过试题的唯一标识符获取试题标签对象的列表.
	 * @param problemId - 试题的唯一标识符
	 * @return 预期的试题标签对象列表
	 */
	List<ProblemTag> getProblemTagsUsingProblemId(long problemId);

	/**
	 * 获取某个区间内各试题的标签.
	 * @param keyword 试题关键字
	 * @param problemCategoryId 试题分类唯一id
	 * @param problemTagId	试题标签唯一ID
	 * @param isPublicOnly	是否公开试题
	 * @param offset 试题唯一标识符的起始序号
	 * @param limit 每次加载试题的数量
	 * @return 包含试题标签信息的列表
	 */
	List<ProblemTagRelationship> getProblemTagsOfProblems(
			@Param("keyword") String keyword, 
			@Param("problemCategoryId") int problemCategoryId,
			@Param("problemTagId") long problemTagId,
			@Param("isPublicOnly") boolean isPublicOnly,
			@Param("problemId") long offset, @Param("limit") int limit);

	/**
	 * 通过试题标签的别名获取试题标签对象.
	 * @param problemTagSlug - 试题标签的别名
	 * @return 预期的试题标签对象或空引用
	 */
	ProblemTag getProblemTagUsingTagSlug(String problemTagSlug);
	
	/**
	 * 创建试题标签对象.
	 * @param problemTag - 待创建的试题标签对象
	 */
	int createProblemTag(ProblemTag problemTag);

	/**
	 * 创建试题及试题标签的关系.
	 * @param problemId - 试题的唯一标识符
	 * @param problemTag - 试题标签对象
	 */
	int createProblemTagRelationship(@Param(value="problemId") long problemId, @Param(value="problemTag") ProblemTag problemTag);
	
	/**
	 * 更新试题标签对象.
	 * @param problemTag - 待更新的试题标签对象
	 */
	int updateProblemTag(ProblemTag problemTag);
	
	/**
	 * 删除试题标签对象.
	 * @param problemTagId - 待删除试题标签对象的唯一标识符
	 */
	int deleteProblemTagUsingTagId(long problemTagId);

	/**
	 * 删除试题的全部标签.
	 * @param problemId - 试题的唯一标识符
	 */
	int deleteProblemTagRelationship(long problemId);
}
