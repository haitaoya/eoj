package com.easyoj.web.util;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.safety.Whitelist;

/**
 * HTML文本过滤组件.
 * 
 * @author Haitao Wang
 */
public class HtmlTextFilter {
	/**
	 * Utility classes should not have a public constructor.
	 */
	private HtmlTextFilter() { }
	
	/**
	 * 过滤包含HTML字符串.
	 * @param text - 待过滤的字符串
	 * @return 过滤后的字符串.
	 */
	public static String filter(String text) {
		if ( text == null ) {
			return text;
		}
		
		Document document = Jsoup.parse(text);
		document.outputSettings(new Document.OutputSettings().prettyPrint(false));
		//保留换行
		document.select("br").append("\\n");
		document.select("p").prepend("\\n\\n");
		String s = document.html().replaceAll("\\\\n", "\n");
		//使用Whitelist对输入的Html文档过滤，只允许特定的标签或者属性，防止恶意代码。  Whitelist.none() 只保留了文本
		return Jsoup.clean(s, "", Whitelist.none(), new Document.OutputSettings().prettyPrint(false));
	}
}
