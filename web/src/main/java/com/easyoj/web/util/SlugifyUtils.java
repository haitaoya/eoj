package com.easyoj.web.util;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.text.Normalizer;
import java.text.Normalizer.Form;
import java.util.regex.Pattern;

/**
 * 字符串Slug处理类.
 * Ref: 
 * - https://github.com/slugify/slugify
 * - http://slugify.net/libraries
 * -   用于将字符串 中的所有空格替换成连接符（-），并将所有字符转换为小写。 这样其实就生成了一个 slug ，可以很好的用于创建 URI 。
 * @author Haitao Wang
 */
public class SlugifyUtils {
	/**
	 * 获取字符串的Slug.
	 * @param str - 待获取Slug的字符串
	 * @return 字符串对应的Slug
	 */
	public static String getSlug(String str) {
		if ( str == null ) {
			return "";
		}
		
		// Rid of White Spaces
		String noWhiteSpace = WHITESPACE.matcher(str.trim()).replaceAll("-");
		// Processing Non-ASCII Characters
		try {
			noWhiteSpace = URLEncoder.encode(noWhiteSpace, "UTF-8");
		} catch (UnsupportedEncodingException e) {
			// Never reach here
		}
		// Slugify String
		String normalized = Normalizer.normalize(noWhiteSpace, Form.NFD);
		
		return normalized.toLowerCase();
	}
	
	/**
	 * 空格的正则表达式模式. 
	 */
	private static final Pattern WHITESPACE = Pattern.compile("[\\s]");
}
