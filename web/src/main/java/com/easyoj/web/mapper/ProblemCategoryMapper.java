package com.easyoj.web.mapper;

import java.util.List;

import org.apache.ibatis.annotations.CacheNamespace;
import org.apache.ibatis.annotations.Param;
import com.easyoj.web.model.ProblemCategory;
import com.easyoj.web.model.ProblemCategoryRelationship;

/**
 * ProblemCategory Data Access Object.
 * 
 * @author Haitao Wang
 */
@CacheNamespace(implementation = org.mybatis.caches.ehcache.EhcacheCache.class)
public interface ProblemCategoryMapper {
	/**
	 * 获取全部的试题分类.
	 * @return 包含全部试题分类的列表
	 */
	List<ProblemCategory> getProblemCategories();
	
	/**
	 * 通过试题分类的唯一标识符获取试题分类对象.
	 * @param problemCategoryId - 试题分类的唯一标识符
	 * @return 预期的试题分类对象或空引用
	 */
	ProblemCategory getProblemCategoryUsingCategoryId(int problemCategoryId);
	
	/**
	 * 获取试题的分类列表.
	 * @param problemId - 试题的唯一标识符.
	 * @return 包含试题分类的列表
	 */
	List<ProblemCategory> getProblemCategoriesUsingProblemId(long problemId);

	/**
	 * 获取某个区间内各试题的分类.
	 * @param keyword 试题关键字
	 * @param problemCategoryId 试题分类唯一id
	 * @param problemTagId	试题标签唯一ID
	 * @param isPublicOnly	是否公开试题
	 * @param offset 试题唯一标识符的起始序号
	 * @param limit 每次加载试题的数量
	 * @return 包含试题分类信息的列表
	 */
	List<ProblemCategoryRelationship> getProblemCategoriesOfProblems(
			@Param("keyword") String keyword, 
			@Param("problemCategoryId") int problemCategoryId,
			@Param("problemTagId") long problemTagId,
			@Param("isPublicOnly") boolean isPublicOnly,
			@Param("problemId") long offset, @Param("limit") int limit);
	
	/**
	 * 通过试题分类的别名获取试题分类对象.
	 * @param problemCategorySlug - 试题分类的别名
	 * @return 预期的试题分类对象或空引用
	 */
	ProblemCategory getProblemCategoryUsingCategorySlug(String problemCategorySlug);
	
	/**
	 * 创建试题分类对象.
	 * @param problemCategory - 待创建的试题分类对象
	 */
	int createProblemCategory(ProblemCategory problemCategory);
	
	/**
	 * 创建试题及试题分类的关系.
	 * @param problemId - 试题的唯一标识符
	 * @param problemCategory - 试题分类对象
	 */
	int createProblemCategoryRelationship(@Param(value="problemId") long problemId, @Param(value="problemCategory") ProblemCategory problemCategory);
	
	/**
	 * 更新试题分类对象.
	 * @param problemCategory - 待更新的试题分类对象
	 */
	int updateProblemCategory(ProblemCategory problemCategory);
	
	/**
	 * 删除试题分类对象.
	 * @param problemCategoryId - 待删除试题分类对象的唯一标识符
	 */
	int deleteProblemCategory(int problemCategoryId);
	
	/**
	 * 删除试题的全部分类关系.
	 * @param problemId - 试题的唯一标识符
	 */
	int deleteProblemCategoryRelationship(long problemId);
}
