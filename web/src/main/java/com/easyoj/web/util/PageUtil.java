package com.easyoj.web.util;
/**
 * 分页基类 用于继承
 * @author Haitao Wang
 */
public class PageUtil {
		//每页显示数量
		private int limit;
		//页码
		private int page;
		//sql语句起始索引
		private Long offset;
		public int getLimit() {
			return limit;
		}
		public void setLimit(int limit) {
			this.limit = limit;
		}
		public int getPage() {
			return page;
		}
		public void setPage(int page) {
			this.page = page;
		}
		public Long getOffset() {
			return offset;
		}
		public void setOffset(Long offset) {
			this.offset = offset;
		}
		
	}

