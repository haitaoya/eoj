package com.easyoj.web.util;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
/**
 * 分页帮助泛型类 
 * @author Haitao Wang
 * @param <T>
 */
public class PageHelper<T>{
	//实体类集合
    private List<T> rows = new ArrayList<T>();
    //数据总条数
    private Long total;
 
    public PageHelper() {
        super();
    }
 
    public List<T> getRows() {
        return rows;
    }
 
    public void setRows(List<T> rows) {
        this.rows = rows;
    }

	public Long getTotal() {
		return total;
	}

	public void setTotal(Long total) {
		this.total = total;
	}
}
