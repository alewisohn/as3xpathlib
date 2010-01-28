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
package com.watchthosecorners.xpath.expressions
{
import com.watchthosecorners.xpath.CoreFunctions;
import com.watchthosecorners.xpath.EvaluationContext;

[ExcludeClass]
	
public class UnaryExpr extends AbstractExpr
{
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 * 
	 * @param operator The unary operator (-) expressed as a string.
	 * 
	 * @param operand The target of the unary operation.
	 */
	public function UnaryExpr(operator:String, operand:Object)
	{
		super();
		
		_operator = operator;
		_operand = operand;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------

	//----------------------------------
	//  operand
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _operand:Object;

	/**
	 * The target of the unary operation.
	 */
	public function get operand():Object
	{
		return _operand;
	}
	
	//----------------------------------
	//  operator
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _operator:String;

	/**
	 * The unary operator (-) expressed as a string.
	 */
	public function get operator():String
	{
		return _operator;
	}	
	
	//--------------------------------------------------------------------------
	//
	//  Overridden methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @inheritDoc
	 */
	override public function evaluate(context:EvaluationContext):*
	{
		switch(_operator)
		{
			case "-":
				return -(CoreFunctions.NUMBER_FUNCTION.evaluate(operand.evaluate(context)));
				
			default:
				throw new TypeError("Invalid unary operator: " + _operator);
		}
	}	
}
}