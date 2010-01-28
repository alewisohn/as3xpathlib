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
public class TokenType
{
	//--------------------------------------------------------------------------
	//
	//  Class constants
	//
	//--------------------------------------------------------------------------
	
	public static const LEFT_PARENTHESIS:TokenType 			= new TokenType("LEFT_PARENTHESIS");
	public static const RIGHT_PARENTHESIS:TokenType			= new TokenType("RIGHT_PARENTHESIS");
	public static const LEFT_BRACKET:TokenType             	= new TokenType("LEFT_BRACKET");
	public static const RIGHT_BRACKET:TokenType            	= new TokenType("RIGHT_BRACKET");
	public static const DOT:TokenType                      	= new TokenType("DOT");
	public static const DOT_DOT:TokenType                  	= new TokenType("DOT_DOT");
	public static const ATTRIBUTE_SIGN:TokenType           	= new TokenType("ATTRIBUTE_SIGN");
	public static const COMMA:TokenType                    	= new TokenType("COMMA");
	public static const COLON_COLON:TokenType              	= new TokenType("COLON_COLON");
	                                                                                      
	public static const STAR:TokenType                     	= new TokenType("STAR");
	public static const NAMESPACE_TEST:TokenType           	= new TokenType("NAMESPACE_TEST");
	public static const QNAME:TokenType                    	= new TokenType("QNAME");
	                                                                                      
	public static const COMMENT:TokenType                  	= new TokenType("COMMENT", "isNodeType", true);
	public static const TEXT:TokenType                     	= new TokenType("TEXT", "isNodeType", true);
	public static const PROCESSING_INSTRUCTION:TokenType   	= new TokenType("PROCESSING_INSTRUCTION", "isNodeType", true);
	public static const NODE:TokenType                     	= new TokenType("NODE", "isNodeType", true);
	                                                                                      
	public static const AND:TokenType                      	= new TokenType("AND", "isOperator", true);
	public static const OR:TokenType                       	= new TokenType("OR", "isOperator", true);
	public static const MOD:TokenType                      	= new TokenType("MOD", "isOperator", true);
	public static const DIV:TokenType                      	= new TokenType("DIV", "isOperator", true);
	public static const MULTIPLY:TokenType                 	= new TokenType("MULTIPLY", "isOperator", true);
	public static const SLASH:TokenType                    	= new TokenType("SLASH", "isOperator", true);
	public static const SLASH_SLASH:TokenType              	= new TokenType("SLASH_SLASH", "isOperator", true);
	public static const UNION:TokenType                    	= new TokenType("UNION", "isOperator", true);
	public static const PLUS:TokenType                     	= new TokenType("PLUS", "isOperator", true);
	public static const MINUS:TokenType                    	= new TokenType("MINUS", "isOperator", true);
	public static const EQUALS:TokenType                   	= new TokenType("EQUALS", "isOperator", true);
	public static const NOT_EQUALS:TokenType               	= new TokenType("NOT_EQUALS", "isOperator", true);
	public static const LESS_THAN:TokenType                	= new TokenType("LESS_THAN", "isOperator", true);
	public static const LESS_THAN_OR_EQUAL_TO:TokenType    	= new TokenType("LESS_THAN_OR_EQUAL_TO", "isOperator", true);
	public static const GREATER_THAN:TokenType             	= new TokenType("GREATER_THAN", "isOperator", true);
	public static const GREATER_THAN_OR_EQUAL_TO:TokenType 	= new TokenType("GREATER_THAN_OR_EQUAL_TO", "isOperator", true);
	                                                                                      
	public static const FUNCTION_NAME:TokenType            	= new TokenType("FUNCTION_NAME");
	                                                                                      
	public static const ANCESTOR:TokenType                 	= new TokenType("ANCESTOR", "isAxisName", true);
	public static const ANCESTOR_OR_SELF:TokenType         	= new TokenType("ANCESTOR_OR_SELF", "isAxisName", true);
	public static const ATTRIBUTE:TokenType                	= new TokenType("ATTRIBUTE", "isAxisName", true);
	public static const CHILD:TokenType                    	= new TokenType("CHILD", "isAxisName", true);
	public static const DESCENDANT:TokenType               	= new TokenType("DESCENDANT", "isAxisName", true);
	public static const DESCENDANT_OR_SELF:TokenType       	= new TokenType("DESCENDANT_OR_SELF", "isAxisName", true);
	public static const FOLLOWING:TokenType                	= new TokenType("FOLLOWING", "isAxisName", true);
	public static const FOLLOWING_SIBLING:TokenType        	= new TokenType("FOLLOWING_SIBLING", "isAxisName", true);
	public static const NAMESPACE:TokenType                	= new TokenType("NAMESPACE", "isAxisName", true);
	public static const PARENT:TokenType                   	= new TokenType("PARENT", "isAxisName", true);
	public static const PRECEDING:TokenType                	= new TokenType("PRECEDING", "isAxisName", true);
	public static const PRECEDING_SIBLING:TokenType        	= new TokenType("PRECEDING_SIBLING", "isAxisName", true);
	public static const SELF:TokenType                     	= new TokenType("SELF", "isAxisName", true);
	                                                                                      
	public static const LITERAL:TokenType                  	= new TokenType("LITERAL");
	public static const NUMBER:TokenType                   	= new TokenType("NUMBER");
	public static const VARIABLE_REFERENCE:TokenType       	= new TokenType("VARIABLE_REFERENCE");
	                                                                                      
	// Virtual token returned by the tokenizer at the end of every XPath expression.
	public static const END:TokenType                      	= new TokenType("END");
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function TokenType(name:String, ...rest)
	{
		_name = name;
		if(rest.length > 0)
			this["_" + rest[0]] = rest[1];
	}
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  name
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _name:String;

	/**
	 * 
	 */
	public function get name():String
	{
		return _name;
	}

	//----------------------------------
	//  isAxisName
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _isAxisName:Boolean = false;

	/**
	 * Documentation Required
	 */
	public function get isAxisName():Boolean
	{
		return _isAxisName;
	}
	
	//----------------------------------
	//  isOperator
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _isOperator:Boolean = false;

	/**
	 * Documentation Required
	 */
	public function get isOperator():Boolean
	{
		return _isOperator;
	}
	
	//----------------------------------
	//  isNodeType
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _isNodeType:Boolean = false;

	/**
	 * Documentation Required
	 */
	public function get isNodeType():Boolean
	{
		return _isNodeType;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	public function isValidLexeme(lexeme:String):Boolean
	{
		return lexeme.match(new RegExp("^(?:" + Tokenizer.regexFor(this) + ")$")) != null;
	}
	
	public function toString():String
	{
		return _name;
	}
}
}