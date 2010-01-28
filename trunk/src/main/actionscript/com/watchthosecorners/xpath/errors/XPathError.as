/*
 * Copyright (c) 2009 Andrew Lewisohn
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */ 
package com.watchthosecorners.xpath.errors
{
import com.watchthosecorners.xpath.utils.StringUtil;
		
public class XPathError extends Error
{
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 * 
	 * @param xpath The XPath expression.
	 * 
	 * @param position The index in <code>xpath</code> where the error occurred.
	 * 
	 * @param cause If not <code>null</code>, the underlying error.
	 */
	public function XPathError(xpath:String, position:int, cause:Error=null)
	{
		super(StringUtil.substitute("Syntax error at character {0} '{1}': {2}{3}", position + 1, xpath.substr(position, 1), xpath, cause != null ? "\nCause: " + cause : ""));
		
		_xpath = xpath;
		_position = position;
		_cause = cause;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------

	//----------------------------------
	//  cause
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _cause:Error;

	/**
	 * If not <code>null</code>, the underlying error.
	 */
	public function get cause():Error
	{
		return _cause;
	}
	
	//----------------------------------
	//  position
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _position:int;

	/**
	 * The index in <code>xpath</code> where the error occurred.
	 */
	public function get position():int
	{
		return _position;
	}
		
	//----------------------------------
	//  xpath
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _xpath:String;

	/**
	 * The XPath expression.
	 */
	public function get xpath():String
	{
		return _xpath;
	}		
}
}