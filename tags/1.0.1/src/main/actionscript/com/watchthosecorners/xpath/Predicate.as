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
package com.watchthosecorners.xpath
{
[ExcludeClass]
	
public class Predicate
{
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function Predicate(expression:IExpr)
	{
		this.expression = expression;
	}

	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  expression
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _expression:IExpr;

	/**
	 * Documentation Required
	 */
	public function get expression():IExpr
	{
		return _expression;
	}
	
	/**
	 * @private
	 */
	public function set expression(value:IExpr):void
	{
		_expression = value;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	public function filter(context:EvaluationContext, nodeSet:NodeSet, direction:int):NodeSet
	{
		var result:NodeSet = new NodeSet();
		var setLen:int = nodeSet.length;
		
		for(var i:int = setLen - 1; i >= 0; i--)
		{
			var filterContext:EvaluationContext = context.clone();
			filterContext.node = nodeSet[i];
			filterContext.size = setLen;
			filterContext.position = (direction == Axis.Direction.FORWARD ? i + 1 : setLen - i);
			
			var value:* = _expression.evaluate(filterContext);
			var matched:Boolean = value is Number
									? value == filterContext.position
									: CoreFunctions.BOOLEAN_FUNCTION.evaluate(value);
									
			if(matched)
			{
				result.add(nodeSet[i]);
			}
		}
		
		// Since we looped through the list in reverse, we need to reverse again
		// before returning it.
		result.reverse();
		
		return result;
		
	}	
}
}