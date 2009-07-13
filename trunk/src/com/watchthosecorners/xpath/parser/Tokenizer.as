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
import com.watchthosecorners.xpath.Axis;
import com.watchthosecorners.xpath.errors.InvalidCharacterError;

import flash.utils.Dictionary;

[ExcludeClass]

/**
 * @private
 */	
public class Tokenizer
{
	//--------------------------------------------------------------------------
	//
	//  Class variables
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 * If <code>true</code>, the class has been initialized.
	 */
	private static var initialized:Boolean = false;
	
	/**
	 * @private
	 * An array of RegExps, indexed for iteration in a particular order.
	 */
	private static var regexList:Array;
	
	/**
	 * @private
	 * Dictionary of RegExps for fast access. Stored by token type. 
	 */
	private static var regexMap:Dictionary;
	
	//--------------------------------------------------------------------------
	//
	//  Class methods: Initialization
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 * Initializes regular expresssion productions.
	 */
	public static function initialize():void
	{
		if(!initialized)
		{
			regexMap = new Dictionary();
			regexMap[TokenType.LEFT_PARENTHESIS] = /^(?:\()/;
		    regexMap[TokenType.RIGHT_PARENTHESIS] = /^(?:\))/;
		    regexMap[TokenType.LEFT_BRACKET] = /^(?:\[)/;
		    regexMap[TokenType.RIGHT_BRACKET] = /^(?:\])/;
		    regexMap[TokenType.DOT_DOT] = /^(?:\.\.)/;
		    regexMap[TokenType.DOT] = /^(?:\.)/;
		    regexMap[TokenType.ATTRIBUTE_SIGN] = /^(?:@)/;
		    regexMap[TokenType.COMMA] = /^(?:,)/;
		    regexMap[TokenType.COLON_COLON] = /^(?:::)/;
		
		    regexMap[TokenType.STAR] = /^(?:\*)/;
		    regexMap[TokenType.NAMESPACE_TEST] = new RegExp("^(?:" + RegExTokens.NCNAME + ":\\*)");
		    regexMap[TokenType.QNAME] = new RegExp("^(?:" + RegExTokens.QNAME + ")");
				    
		    regexMap[TokenType.COMMENT] = /^(?:comment)/;
		    regexMap[TokenType.TEXT] = /^(?:text)/;
		    regexMap[TokenType.PROCESSING_INSTRUCTION] = /^(?:processing-instruction)/;
		    regexMap[TokenType.NODE] = /^(?:node)/;
		
		    regexMap[TokenType.AND] = /^(?:and)/;
		    regexMap[TokenType.OR] = /^(?:or)/;
		    regexMap[TokenType.MOD] = /^(?:mod)/;
		    regexMap[TokenType.DIV] = /^(?:div)/;
		    regexMap[TokenType.SLASH_SLASH] = /^(?:\/\/)/;
		    regexMap[TokenType.SLASH] = /^(?:\/)/;
		    regexMap[TokenType.UNION] = /^(?:\|)/;
		    regexMap[TokenType.PLUS] = /^(?:\+)/;
		    regexMap[TokenType.MINUS] = /^(?:-)/;
		    regexMap[TokenType.MULTIPLY] = /^(?:\*)/;
		    regexMap[TokenType.EQUALS] = /^(?:=)/;
		    regexMap[TokenType.NOT_EQUALS] = /^(?:!=)/;
		    regexMap[TokenType.LESS_THAN_OR_EQUAL_TO] = /^(?:<=)/;
		    regexMap[TokenType.LESS_THAN] = /^(?:<)/;
		    regexMap[TokenType.GREATER_THAN_OR_EQUAL_TO] = /^(?:>=)/;
		    regexMap[TokenType.GREATER_THAN] = /^(?:>)/;
		
		  	regexMap[TokenType.FUNCTION_NAME] = new RegExp("^(?:" + RegExTokens.QNAME + ")");
		
		    regexMap[TokenType.ANCESTOR] = /^(?:ancestor)/;
		    regexMap[TokenType.ANCESTOR_OR_SELF] = /^(?:ancestor-or-self)/;
		    regexMap[TokenType.ATTRIBUTE] = /^(?:attribute)/;
		    regexMap[TokenType.CHILD] = /^(?:child)/;
		    regexMap[TokenType.DESCENDANT] = /^(?:descendant)/;
		    regexMap[TokenType.DESCENDANT_OR_SELF] = /^(?:descendant-or-self)/;
		    regexMap[TokenType.FOLLOWING] = /^(?:following)/;
		    regexMap[TokenType.FOLLOWING_SIBLING] = /^(?:following-sibling)/;
		    regexMap[TokenType.NAMESPACE] = /^(?:namespace)/;
		    regexMap[TokenType.PARENT] = /^(?:parent)/;
		    regexMap[TokenType.PRECEDING] = /^(?:preceding)/;
		    regexMap[TokenType.PRECEDING_SIBLING] = /^(?:preceding-sibling)/;
		    regexMap[TokenType.SELF] = /^(?:self)/;
		
		    regexMap[TokenType.LITERAL] = /^(?:"[^"]*"|'[^']*')/;
		    regexMap[TokenType.NUMBER] = /^(?:[0-9]+(?:\.[0-9]*)?|\.[0-9]+)/;
		    regexMap[TokenType.VARIABLE_REFERENCE] = new RegExp("^(?:\\$" + RegExTokens.QNAME + ")");
		
		    regexMap[TokenType.END] = /^(?:"")/;		
		    
		    regexList = [];
			regexList[regexList.length] = createRegExpEntry(TokenType.LEFT_PARENTHESIS);
			regexList[regexList.length] = createRegExpEntry(TokenType.RIGHT_PARENTHESIS);
			regexList[regexList.length] = createRegExpEntry(TokenType.LEFT_BRACKET);
			regexList[regexList.length] = createRegExpEntry(TokenType.RIGHT_BRACKET);
			regexList[regexList.length] = createRegExpEntry(TokenType.DOT_DOT);
			regexList[regexList.length] = createRegExpEntry(TokenType.DOT);
			regexList[regexList.length] = createRegExpEntry(TokenType.ATTRIBUTE_SIGN);
			regexList[regexList.length] = createRegExpEntry(TokenType.COMMA);
			regexList[regexList.length] = createRegExpEntry(TokenType.COLON_COLON);
			
			regexList[regexList.length] = createRegExpEntry(TokenType.STAR);
			regexList[regexList.length] = createRegExpEntry(TokenType.NAMESPACE_TEST);
			regexList[regexList.length] = createRegExpEntry(TokenType.QNAME);
			
			regexList[regexList.length] = createRegExpEntry(TokenType.COMMENT);
			regexList[regexList.length] = createRegExpEntry(TokenType.TEXT);
			regexList[regexList.length] = createRegExpEntry(TokenType.PROCESSING_INSTRUCTION);
			regexList[regexList.length] = createRegExpEntry(TokenType.NODE);
			
			regexList[regexList.length] = createRegExpEntry(TokenType.AND);
			regexList[regexList.length] = createRegExpEntry(TokenType.OR);
			regexList[regexList.length] = createRegExpEntry(TokenType.MOD);
			regexList[regexList.length] = createRegExpEntry(TokenType.DIV);
			regexList[regexList.length] = createRegExpEntry(TokenType.SLASH_SLASH);	
			regexList[regexList.length] = createRegExpEntry(TokenType.SLASH);
			regexList[regexList.length] = createRegExpEntry(TokenType.UNION);
			regexList[regexList.length] = createRegExpEntry(TokenType.PLUS);
			regexList[regexList.length] = createRegExpEntry(TokenType.MINUS);
			regexList[regexList.length] = createRegExpEntry(TokenType.MULTIPLY);
			regexList[regexList.length] = createRegExpEntry(TokenType.EQUALS);
			regexList[regexList.length] = createRegExpEntry(TokenType.NOT_EQUALS);
			regexList[regexList.length] = createRegExpEntry(TokenType.LESS_THAN_OR_EQUAL_TO);
			regexList[regexList.length] = createRegExpEntry(TokenType.LESS_THAN);
			regexList[regexList.length] = createRegExpEntry(TokenType.GREATER_THAN_OR_EQUAL_TO);
			regexList[regexList.length] = createRegExpEntry(TokenType.GREATER_THAN);
			
			regexList[regexList.length] = createRegExpEntry(TokenType.FUNCTION_NAME);
			
			regexList[regexList.length] = createRegExpEntry(TokenType.ANCESTOR);
			regexList[regexList.length] = createRegExpEntry(TokenType.ANCESTOR_OR_SELF);
			regexList[regexList.length] = createRegExpEntry(TokenType.ATTRIBUTE);
			regexList[regexList.length] = createRegExpEntry(TokenType.CHILD);
			regexList[regexList.length] = createRegExpEntry(TokenType.DESCENDANT);
			regexList[regexList.length] = createRegExpEntry(TokenType.DESCENDANT_OR_SELF);
			regexList[regexList.length] = createRegExpEntry(TokenType.FOLLOWING);
			regexList[regexList.length] = createRegExpEntry(TokenType.FOLLOWING_SIBLING);
			regexList[regexList.length] = createRegExpEntry(TokenType.NAMESPACE);
			regexList[regexList.length] = createRegExpEntry(TokenType.PARENT);
			regexList[regexList.length] = createRegExpEntry(TokenType.PRECEDING);
			regexList[regexList.length] = createRegExpEntry(TokenType.PRECEDING_SIBLING);
			regexList[regexList.length] = createRegExpEntry(TokenType.SELF);
			
			regexList[regexList.length] = createRegExpEntry(TokenType.LITERAL);
			regexList[regexList.length] = createRegExpEntry(TokenType.NUMBER);
			regexList[regexList.length] = createRegExpEntry(TokenType.VARIABLE_REFERENCE);
			
			regexList[regexList.length] = createRegExpEntry(TokenType.END);
			
			initialized = true;
		}
	}
	
	private static function createRegExpEntry(tokenType:TokenType):Object
	{
		return {tokenType: tokenType, regexp: regexMap[tokenType]};
			
	}
	
	public static function regexFor(tokenType:TokenType):RegExp
	{
		return regexMap[tokenType];
	}
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 * 
	 * @param xpath An XPath expression to parse.
	 */
	public function Tokenizer(xpath:String)
	{
		if(!initialized)
		{
			initialize();
		}
		
		_xpath = xpath;
		_position = 0;
		_currentToken = null;
		
		next();
	}

	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------

	//----------------------------------
	//  currentToken
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _currentToken:Token;

	/**
	 * The current token.
	 */
	public function get currentToken():Token
	{
		return _currentToken;
	}
	
	//----------------------------------
	//  position
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _position:int;

	/**
	 * The position of the cursor in the string.
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
	 * The XPath expression that is being parsed.
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
	
	private function disambiguateToken(nextToken:Token):void
	{
		var currentToken:Token = _currentToken;
		
		if((nextToken.type == TokenType.STAR 
			|| nextToken.type == TokenType.QNAME)
			&& currentToken != null)
		{
			if(currentToken.type != TokenType.ATTRIBUTE_SIGN
				&& currentToken.type != TokenType.COLON_COLON
				&& currentToken.type != TokenType.LEFT_PARENTHESIS
				&& currentToken.type != TokenType.LEFT_BRACKET
				&& currentToken.type != TokenType.COMMA
				&& !currentToken.type.isOperator)
			{
				switch(nextToken.lexeme)
				{
					case "*":
						nextToken.type = TokenType.MULTIPLY;
						break;
						
					case "and":
						nextToken.type = TokenType.AND;
						break;
						
					case "or":
						nextToken.type = TokenType.OR;
						break;
						
					case "mod":
						nextToken.type = TokenType.MOD;
						break;
						
					case "div":
						nextToken.type = TokenType.DIV;
						break;
				}
			}
		}
		
		if(nextToken.type == TokenType.QNAME
			&& _xpath.substr(_position).match(/^\s*\(/))
		{
			switch(nextToken.lexeme)
			{
				case "comment":
					nextToken.type = TokenType.COMMENT;
					break;
					
				case "text":
					nextToken.type = TokenType.TEXT;
					break;
					
				case "processing-instruction":
					nextToken.type = TokenType.PROCESSING_INSTRUCTION;
					break;
					
				case "node":
					nextToken.type = TokenType.NODE;
					break;
					
				default:
					nextToken.type = TokenType.FUNCTION_NAME;
					break;
			}
		}
		
		if(nextToken.type == TokenType.QNAME 
			&& _xpath.substr(_position).match(/^\s*::/))
		{
			switch(nextToken.lexeme) 
			{
			  	case Axis.Name.ANCESTOR:           
			  		nextToken.type = TokenType.ANCESTOR;           
			  		break;
			  		
			  	case Axis.Name.ANCESTOR_OR_SELF:   
			  		nextToken.type = TokenType.ANCESTOR_OR_SELF;   
			  		break;
			  		
			  	case Axis.Name.ATTRIBUTE:          
			  		nextToken.type = TokenType.ATTRIBUTE;          
			  		break;
			  		
			  	case Axis.Name.CHILD:              
			  		nextToken.type = TokenType.CHILD;              
			  		break;
			  		
			  	case Axis.Name.DESCENDANT:         
			  		nextToken.type = TokenType.DESCENDANT;         
			  		break;
			  		
			  	case Axis.Name.DESCENDANT_OR_SELF: 
			  		nextToken.type = TokenType.DESCENDANT_OR_SELF; 
			  		break;
			  		
			  	case Axis.Name.FOLLOWING:          
			  		nextToken.type = TokenType.FOLLOWING;          
			  		break;
			  		
			  	case Axis.Name.FOLLOWING_SIBLING:  
			  		nextToken.type = TokenType.FOLLOWING_SIBLING;  
			  		break;
			  		
			  	case Axis.Name.NAMESPACE:          
			  		nextToken.type = TokenType.NAMESPACE;          
			  		break;
			  		
			  	case Axis.Name.PARENT:             
			  		nextToken.type = TokenType.PARENT;             
			  		break;
			  		
			  	case Axis.Name.PRECEDING:          
			  		nextToken.type = TokenType.PRECEDING;          
			  		break;
			  		
			  	case Axis.Name.PRECEDING_SIBLING:  
			  		nextToken.type = TokenType.PRECEDING_SIBLING;  
			  		break;
			  		
			  	case Axis.Name.SELF:               	
			  		nextToken.type = TokenType.SELF;               
			  		break;
    		}	
		}
	}
	
	private function getToken():Token
	{
		skipWhiteSpace();
	
		if(_position == _xpath.length)
			return new Token(TokenType.END, "", _xpath, _xpath.length);
		
		var len:int = regexList.length;
		for(var i:int = 0; i < len; i++)
		{
			var entry:Object = regexList[i];
			var tokenType:TokenType = entry.tokenType;
			var regexp:RegExp = entry.regexp;
			
			if(tokenType == TokenType.END)
			{
				continue;
			}

			var substr:String = _xpath.substr(_position);
			var match:Object = regexp.exec(substr);
			if(match != null)
			{
				_position += match[0].length;
				
				return new Token(tokenType, match[0], _xpath, _position - match[0].length);
			}
		} 	
				
		throw new InvalidCharacterError(_xpath, _position);
	}
	
	/**
	 * Retrieves the next token without advancing <code>position</code> or 
	 * updating the value of <code>currentToken</code>.
	 */
	public function lookahead():Token
	{
		var startPos:uint = _position;
		var token:Token = getToken();
		disambiguateToken(token);
		_position = startPos;
		return token;
	}
	
	/**
	 * Retrieves the next token.
	 */
	public function next():void
	{
		var nextToken:Token = getToken();
		
		disambiguateToken(nextToken);
		_currentToken = nextToken;
	}
	
	private function skipWhiteSpace():void
	{
		while(_position < _xpath.length && _xpath.substr(_position, 1).match(/^\s$/))
		{
			_position++;
		}
	}
}
}