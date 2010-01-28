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
import com.watchthosecorners.xpath.IExpr;
import com.watchthosecorners.xpath.Predicate;
import com.watchthosecorners.xpath.QualifiedName;
import com.watchthosecorners.xpath.Step;
import com.watchthosecorners.xpath.errors.InvalidTokenError;
import com.watchthosecorners.xpath.errors.XPathError;
import com.watchthosecorners.xpath.expressions.BinaryOperation;
import com.watchthosecorners.xpath.expressions.FilterExpr;
import com.watchthosecorners.xpath.expressions.FunctionCall;
import com.watchthosecorners.xpath.expressions.LiteralExpr;
import com.watchthosecorners.xpath.expressions.LocationPath;
import com.watchthosecorners.xpath.expressions.NumberExpr;
import com.watchthosecorners.xpath.expressions.PathExpr;
import com.watchthosecorners.xpath.expressions.UnaryExpr;
import com.watchthosecorners.xpath.expressions.VariableReference;
import com.watchthosecorners.xpath.nodeTests.CommentNodeTest;
import com.watchthosecorners.xpath.nodeTests.NamespaceNodeTest;
import com.watchthosecorners.xpath.nodeTests.NodeNodeTest;
import com.watchthosecorners.xpath.nodeTests.ProcessingInstructionNodeTest;
import com.watchthosecorners.xpath.nodeTests.QNameNodeTest;
import com.watchthosecorners.xpath.nodeTests.StarNodeTest;
import com.watchthosecorners.xpath.nodeTests.TextNodeTest;

import flash.utils.Dictionary;

[ExcludeClass]

/**
 * @private
 */	
public class Parser
{
	//--------------------------------------------------------------------------
	//
	//  Variables
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	private var cache:Dictionary;
	
	/**
	 * @private
	 */
	private var contextNode:XML;
	
	/**
	 * @private
	 */
	private var currentToken:Token;
	
	/**
	 * @private
	 */
	private var tokenizer:Tokenizer;

	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function Parser()
	{
		cache = new Dictionary();
	}

	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	public function parse(xpath:String, contextNode:XML):IExpr
	{
		var cached:Array;
		
		if((cached = cache[xpath]) != null)
		{
			for(var i:int = cached.length - 1; i >= 0; i--)
			{
				var cachedExp:CacheEntry = cached[i];
				if(cachedExp.contextNode == contextNode)
				{
					return cachedExp.expression;
				}
			}
		} 
		
		tokenizer = new Tokenizer(xpath);
		this.contextNode = contextNode;
		currentToken = tokenizer.currentToken;
		
		var expression:IExpr = parseExpression();
		
		needToken(TokenType.END);
		
		if(cache[xpath] == null)
		{
			cache[xpath] = [];
		} 
		
		cache[xpath].push(new CacheEntry(contextNode, expression));
		
		return expression;
	}
	
	private function parseExpression():IExpr
	{
		return parseOrExpression();
	}

	private function parseOrExpression():IExpr
	{
		return parseBinaryExpression(parseAndExpression, "left", [TokenType.OR]);
	}
	
	private function parseAndExpression():IExpr
	{
		return parseBinaryExpression(parseEqualityExpression, "left", [TokenType.AND]);
	}
	
	private function parseEqualityExpression():IExpr
	{
		return parseBinaryExpression(parseRelationalExpression, "left", [TokenType.EQUALS, TokenType.NOT_EQUALS]);
	}
	
	private function parseRelationalExpression():IExpr
	{
		return parseBinaryExpression(parseAdditiveExpression, "left", [TokenType.LESS_THAN, TokenType.GREATER_THAN, TokenType.LESS_THAN_OR_EQUAL_TO, TokenType.GREATER_THAN_OR_EQUAL_TO]);
	}
	
	private function parseAdditiveExpression():IExpr
	{
		return parseBinaryExpression(parseMultiplicativeExpression, "left", [TokenType.PLUS, TokenType.MINUS]);
	}
	
	private function parseMultiplicativeExpression():IExpr
	{
		return parseBinaryExpression(parseUnaryExpression, "left", [TokenType.MULTIPLY, TokenType.DIV, TokenType.MOD]);
	}
	
	private function parseUnionExpression():IExpr
	{
		return parseBinaryExpression(parsePathExpression, "left", [TokenType.UNION]);
	}
	
	private function parseBinaryExpression(parseSubExpression:Function, associativity:String, operators:Array):IExpr
	{
		function contains(array:Array, item:Object):Boolean
		{
			return array.indexOf(item) > -1;
		}
		
		var expression:IExpr;
		var operator:Token;
		
		switch(associativity)
		{
			case "left":
				expression = parseSubExpression();
				while(contains(operators, currentToken.type))
				{
					operator = currentToken;
					nextToken();
					expression = new BinaryOperation(operator.lexeme, expression, parseSubExpression());
				}
				return expression;
				
			case "right":
				expression = parseSubExpression();
				if(contains(operators, currentToken.type))
				{
					operator = currentToken;
					nextToken();
					expression = new BinaryOperation(operator.lexeme, expression, parseBinaryExpression(parseSubExpression, associativity, operators)); 
				}
				return expression;
		}
		
		return null;
	}
	
	private function parseUnaryExpression():IExpr
	{
		if(currentToken.type != TokenType.MINUS)
		{
			return parseUnionExpression();
		}
		
		var operator:Token = currentToken;
		nextToken();
		return new UnaryExpr(operator.lexeme, parseUnaryExpression());
	}
	
	private function parsePathExpression():IExpr
	{
		var filterExpression:IExpr = parseFilterExpression();
		var locationPath:LocationPath;
		
		if(filterExpression == null 
			|| currentToken.type == TokenType.SLASH
			|| currentToken.type == TokenType.SLASH_SLASH)
		{
			locationPath = parseLocationPath() as LocationPath;
		}
		
		if(locationPath == null)
		{
			return filterExpression;
		}
		else if(filterExpression == null)
		{
			return locationPath;
		}
		else
		{
			locationPath.isAbsolute = false;
		}
		
		return new PathExpr(filterExpression, locationPath);
	}
	
	private function parseFilterExpression():IExpr
	{
		var expression:IExpr = parsePrimaryExpression();
		if(expression == null)
		{
			return null;
		}
		
		while(currentToken.type == TokenType.LEFT_BRACKET)
		{
			expression = new FilterExpr(expression, parsePredicate());
		}
		
		return expression;
	}
	
	private function parsePrimaryExpression():IExpr
	{
		var expression:IExpr;
		
		switch(currentToken.type)
		{
			case TokenType.VARIABLE_REFERENCE:
				expression = new VariableReference(new QualifiedName(currentToken.lexeme.substr(1), contextNode));
				nextToken();
				break;
				
			case TokenType.LEFT_PARENTHESIS:
				skipToken(TokenType.LEFT_PARENTHESIS);
				expression = parseExpression();
				skipToken(TokenType.RIGHT_PARENTHESIS);
				break;
				
			case TokenType.LITERAL:
				expression = new LiteralExpr(currentToken.lexeme.slice(1, -1));
				nextToken();
				break;
				
			case TokenType.NUMBER:
				expression = new NumberExpr(Number(currentToken.lexeme));
				nextToken();
				break;
				
			case TokenType.FUNCTION_NAME:
				expression = parseFunctionCall();
				break;
		}	
		
		return expression;
	}
	
	private function parseFunctionCall():IExpr
	{
		needToken(TokenType.FUNCTION_NAME);
		
		var functionName:QualifiedName = new QualifiedName(currentToken.lexeme,contextNode);
		var args:Array = [];
		
		nextToken();
		skipToken(TokenType.LEFT_PARENTHESIS);
		
		if(currentToken.type != TokenType.RIGHT_PARENTHESIS)
		{
			args.push(parseExpression());
			
			while(currentToken.type == TokenType.COMMA)
			{
				nextToken();
				args.push(parseExpression());
			}
		}
		
		skipToken(TokenType.RIGHT_PARENTHESIS);
		
		return new FunctionCall(functionName, args);
	}
	
	private function parsePredicate():Predicate
	{
		skipToken(TokenType.LEFT_BRACKET);
		
		var expression:IExpr = parseExpression();
		
		skipToken(TokenType.RIGHT_BRACKET);
		
		return new Predicate(expression);
	}
	
	private function parseLocationPath():IExpr
	{
		var isAbsolute:Boolean = false;
		var stepsRequired:int = -1;
		var steps:Array = [];
		
		switch(currentToken.type)
		{
			case TokenType.SLASH:
				isAbsolute = true;
				stepsRequired = 0;
				nextToken();
				break;
				
			case TokenType.SLASH_SLASH:
				isAbsolute = true;
				stepsRequired = 2;
				steps.push(new Step(Axis.DESCENDANT_OR_SELF, new NodeNodeTest(), []));
				nextToken();
				break;
				
			default:
				isAbsolute = false;
				stepsRequired = 1;
				break;
		}
		
		steps = steps.concat(parseRelativeLocationPath());
		
		if(steps.length < stepsRequired)
		{
			throw new InvalidTokenError(currentToken);
		}
		
		return new LocationPath(isAbsolute, steps);
	}
	
	private function parseRelativeLocationPath():Array
	{
		var steps:Array = [];
		
		while(true)
		{
			switch(currentToken.type)
			{
				case TokenType.DOT:
					steps.push(new Step(Axis.SELF, new NodeNodeTest(), []));
					nextToken();
					break;
				
				case TokenType.DOT_DOT:
					steps.push(new Step(Axis.PARENT, new NodeNodeTest(), []));
					nextToken();
					break;
					
				default:
					var axis:Axis = Axis.CHILD;
					var defaultAxis:Boolean = true;
					
					if(currentToken.type.isAxisName) 
					{
          				switch(currentToken.type) 
          				{             
				            case TokenType.ANCESTOR:           
				            	axis = Axis.ANCESTOR;           
				            	break;
				            	
				            case TokenType.ANCESTOR_OR_SELF:   
				            	axis = Axis.ANCESTOR_OR_SELF;   
				            	break;
				            	
				            case TokenType.ATTRIBUTE:          
				            	axis = Axis.ATTRIBUTE;          
				            	break;
				            	
				            case TokenType.CHILD:              
				            	axis = Axis.CHILD;              
				            	break;
				            	
				            case TokenType.DESCENDANT:         
				            	axis = Axis.DESCENDANT;         
				            	break;
				            	
				            case TokenType.DESCENDANT_OR_SELF: 
				            	axis = Axis.DESCENDANT_OR_SELF; 
				            	break;
				            	
				            case TokenType.FOLLOWING:          
				            	axis = Axis.FOLLOWING;          
				            	break;
				            	
				            case TokenType.FOLLOWING_SIBLING:  
				            	axis = Axis.FOLLOWING_SIBLING;  
				            	break;
				            	
				            case TokenType.NAMESPACE:          
				            	axis = Axis.NAMESPACE;          
				            	break;
				            	
				            case TokenType.PARENT:             
				            	axis = Axis.PARENT;             
				            	break;
				            	
				            case TokenType.PRECEDING:          
				            	axis = Axis.PRECEDING;         
				            	break;
				            	
				            case TokenType.PRECEDING_SIBLING:  
				            	axis = Axis.PRECEDING_SIBLING;  
				            	break;
				            	
				            case TokenType.SELF:               
				            	axis = Axis.SELF;               
				            	break;
          				}
          				
          				defaultAxis = false;
          				nextToken();
          				skipToken(TokenType.COLON_COLON);
     				}
     				else if(currentToken.type == TokenType.ATTRIBUTE_SIGN)
     				{
     					axis = Axis.ATTRIBUTE;
     					defaultAxis = false;
     					nextToken();
     				}
     				
     				var nodeTest:NodeTest;
     				
     				try
     				{
     					switch(currentToken.type)
     					{
     						case TokenType.STAR:
     							nodeTest = new StarNodeTest();
     							nextToken();
     							break;
     							
     						case TokenType.NAMESPACE_TEST:
     							nodeTest = new NamespaceNodeTest(contextNode.namespace(currentToken.lexeme.split(":")[0]).uri);
     							nextToken();
     							break;
     							
     						case TokenType.QNAME:
     							nodeTest = new QNameNodeTest(new QualifiedName(currentToken.lexeme, contextNode));
     							nextToken();
     							break;
     							
     						case TokenType.COMMENT:
     							nodeTest = new CommentNodeTest();
     							nextToken();
     							skipToken(TokenType.LEFT_PARENTHESIS);
     							skipToken(TokenType.RIGHT_PARENTHESIS);
     							break;
     							
     						case TokenType.TEXT:
     							nodeTest = new TextNodeTest();
     							nextToken();
     							skipToken(TokenType.LEFT_PARENTHESIS);
     							skipToken(TokenType.RIGHT_PARENTHESIS);
     							break;
     							
     						case TokenType.PROCESSING_INSTRUCTION:
     							nextToken();
     							skipToken(TokenType.LEFT_PARENTHESIS);
     							if(currentToken.type == TokenType.LITERAL)
     							{
     								nodeTest = new ProcessingInstructionNodeTest(currentToken.lexeme.slice(1, -1));
     								nextToken();
     							}
     							else
     							{
     								nodeTest = new ProcessingInstructionNodeTest();
     							}
     							
     							skipToken(TokenType.RIGHT_PARENTHESIS);
     							break;
     							
     						case TokenType.NODE:
     							nodeTest = new NodeNodeTest();
     							nextToken();
     							skipToken(TokenType.LEFT_PARENTHESIS);
     							skipToken(TokenType.RIGHT_PARENTHESIS);
     							break;
     							
     						default:
     							if(defaultAxis && steps.length == 0)
     							{
     								return [];
     							}
     							
     							throw new InvalidTokenError(currentToken);
     							break;
     					}
     				}
     				catch(e:Error)
     				{
     					throw new XPathError(currentToken.xpath, currentToken.position, e);
     				}
     				
     				var predicates:Array = [];
     				
     				while(currentToken.type == TokenType.LEFT_BRACKET)
     				{
     					predicates.push(parsePredicate());
     				}
     				
     				steps.push(new Step(axis, nodeTest, predicates));
     				break;
   			}
   			
   			switch(currentToken.type)
   			{
   				case TokenType.SLASH:
   					nextToken();
   					break;
   					
   				case TokenType.SLASH_SLASH:
   					steps.push(new Step(Axis.DESCENDANT_OR_SELF, new NodeNodeTest(), []));
   					nextToken();
   					break;
   					
   				default:
   					return steps;
   			}				
		}
		
		return null;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Methods: Tokens
	//
	//--------------------------------------------------------------------------
	
	private function needToken(expectedTokenType:TokenType):void
	{
		if(currentToken.type != expectedTokenType)
		{
			throw new InvalidTokenError(currentToken);
		}	
	}
	
	private function nextToken():void
	{
		tokenizer.next();
		currentToken = tokenizer.currentToken;
	}
	
	private function skipToken(expectedTokenType:TokenType):void
	{
		needToken(expectedTokenType);
		nextToken();
	}
}
}

import com.watchthosecorners.xpath.IExpr;

class CacheEntry
{
	public var contextNode:XML;
	public var expression:IExpr;
	
	function CacheEntry(contextNode:XML, expression:IExpr)
	{
		this.contextNode = contextNode;
		this.expression = expression;
	}
}