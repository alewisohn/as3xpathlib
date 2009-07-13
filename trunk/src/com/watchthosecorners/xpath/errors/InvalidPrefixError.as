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
public class InvalidPrefixError extends XPathError
{
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 *
	 * @param contextNode The XML node being evaluated.
	 * 
	 * @param prefix The namespace prefix.
	 */
	public function InvalidPrefixError(contextNode:XML, prefix:String)
	{
		super(null, -1);
		
		_contextNode = contextNode;
		_prefix = prefix;
		message = 'Unable to resolve namespace prefix "' + _prefix + '".';
	}
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------

	//----------------------------------
	//  contextNode
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _contextNode:XML;

	/**
	 * The XML node being evaluated.
	 */
	public function get contextNode():XML
	{
		return _contextNode;
	}
	
	//----------------------------------
	//  prefix
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _prefix:String;

	/**
	 * The namespace prefix.
	 */
	public function get prefix():String
	{
		return _prefix;
	}	
}
}