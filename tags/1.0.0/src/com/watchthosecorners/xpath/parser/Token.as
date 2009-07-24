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
package com.watchthosecorners.xpath.parser
{
[ExcludeClass]

/**
 * @private
 */	
public class Token
{
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function Token(type:TokenType, lexeme:String, xpath:String=null, position:int=0)
	{
		if(!xpath)
			xpath = lexeme;
			
		_type = type;
		_lexeme = lexeme;
		_xpath = xpath;
		_position = position;
	}

	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------

	//----------------------------------
	//  lexeme
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _lexeme:String;

	/**
	 * 
	 */
	public function get lexeme():String
	{
		return _lexeme;
	}

	//----------------------------------
	//  position
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _position:int;

	/**
	 * 
	 */
	public function get position():int
	{
		return _position;
	}
	
	//----------------------------------
	//  type
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _type:TokenType;

	/**
	 * 
	 */
	public function get type():TokenType
	{
		return _type;
	}
	
	/**
	 * @private
	 */
	public function set type(value:TokenType):void
	{
		_type = value;
	}
	
	//----------------------------------
	//  xpath
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _xpath:String;

	/**
	 * 
	 */
	public function get xpath():String
	{
		return _xpath;
	}

	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	public function toString():String
	{
		return _lexeme + " [" + _type + "]";
	}
}
}