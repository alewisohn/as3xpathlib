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
import com.watchthosecorners.xpath.EvaluationContext;
import com.watchthosecorners.xpath.IExpr;
import com.watchthosecorners.xpath.NodeSet;

[ExcludeClass]
	
public class BinaryOperation extends AbstractExpr
{
	//--------------------------------------------------------------------------
	//
	//  Class variables
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 * Storage for the operators property.
	 */
	protected static var _operators:Object;
	
	/**
	 * Mapping of operator tokens to a specific operation.
	 */
	protected static function get operators():Object
	{
		if(!_operators)
		{
			_operators = {
							"|":   new UnionOperator     (),
			  
				  			"or":  new BooleanOperator   (function(left:Object, right:Object):Boolean { return left || right; }),
				 			"and": new BooleanOperator   (function(left:Object, right:Object):Boolean { return left && right; }),
				  			"=":   new EqualityOperator  (function(left:Object, right:Object):Boolean { return left == right; }),
				  			"!=":  new EqualityOperator  (function(left:Object, right:Object):Boolean { return left != right; }),
			  				"<=":  new RelationalOperator(function(left:Object, right:Object):Boolean { return left <= right; }),
				  			"<":   new RelationalOperator(function(left:Object, right:Object):Boolean { return left <  right; }),
				  			">=":  new RelationalOperator(function(left:Object, right:Object):Boolean { return left >= right; }),
				  			">":   new RelationalOperator(function(left:Object, right:Object):Boolean { return left >  right; }),
				
				  			"+":   new ArithmeticOperator(function(left:Number, right:Number):Number { return left +  right; }),
				  			"-":   new ArithmeticOperator(function(left:Number, right:Number):Number { return left -  right; }),
				  			"*":   new ArithmeticOperator(function(left:Number, right:Number):Number { return left *  right; }),
				  			"div": new ArithmeticOperator(function(left:Number, right:Number):Number { return left /  right; }),
				  			"mod": new ArithmeticOperator(function(left:Number, right:Number):Number { return left %  right; })
						};
		}
		return _operators;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 * 
	 * @param operator The token that represents the operation to perform.
	 * 
	 * @param leftOperand The left-hand argument of the binary operation.
	 * 
	 * @param rightOperand The right-hand argument of the binary operation.
	 */
	public function BinaryOperation(operator:String, leftOperand:IExpr, rightOperand:IExpr)
	{
		super();
		
		_operator = operators[operator];
		_leftOperand = leftOperand;
		_rightOperand = rightOperand;	
	}
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  operator
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _operator:IOperator;

	/**
	 * The operation to perform.
	 */
	public function get operator():IOperator
	{
		return _operator;
	}	

	//----------------------------------
	//  leftOperand
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _leftOperand:IExpr;

	/**
	 * The left-hand argument of the binary operation.
	 */
	public function get leftOperand():IExpr
	{
		return _leftOperand;
	}
	
	//----------------------------------
	//  rightOperand
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _rightOperand:IExpr;

	/**
	 * The right-hand argument of the binary operation.
	 */
	public function get rightOperand():IExpr
	{
		return _rightOperand;
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
		return _operator.evaluate(_leftOperand.evaluate(context), _rightOperand.evaluate(context));
	}
	
	/**
	 * @inheritDoc
	 */
	override public function referencedNodes(context:EvaluationContext):NodeSet
	{
		return _leftOperand.referencedNodes(context).addAll(_rightOperand.referencedNodes(context));
	}
}
}

import com.watchthosecorners.xpath.CoreFunctions;
import com.watchthosecorners.xpath.NodeSet;
import com.watchthosecorners.xpath.utils.XMLUtil;

import flash.errors.IllegalOperationError;

interface IOperator
{
	function evaluate(left:Object, right:Object):*;
}

class UnionOperator implements IOperator
{
	public function evaluate(left:Object, right:Object):*
	{
		return left.addAll(right);
	}
}

class BooleanOperator implements IOperator
{
	private var handler:Function;
	
	public function BooleanOperator(handler:Function)
	{
		this.handler = handler;		
	}
	
	public function evaluate(left:Object, right:Object):*
	{
		var l:Boolean = CoreFunctions.BOOLEAN_FUNCTION.evaluate(left);
		var r:Boolean = CoreFunctions.BOOLEAN_FUNCTION.evaluate(right);
		
		return handler(l, r);
	}
}

class ComparisonOperator implements IOperator
{
	protected var handler:Function;
	
	public function ComparisonOperator(handler:Function)
	{
		this.handler = handler;		
	}
	
	public function compare(left:Object, right:Object):Boolean
	{
		throw new IllegalOperationError("Abstract method must be overridden in sub-class.");
	}
	
	public function evaluate(left:Object, right:Object):*
	{
		var i:int;
		var j:int;
		var leftString:String;
		var rightString:String;
		
		if(left is NodeSet && right is NodeSet)
		{
			for(i = NodeSet(left).length - 1; i >= 0; i--)
			{
				for(j = NodeSet(right).length - 1; j >= 0; j--)
				{
					leftString = XMLUtil.stringValueOf(NodeSet(left)[i]);
					rightString = XMLUtil.stringValueOf(NodeSet(right)[j]);
					if(compare(leftString, rightString))
					{
						return true;
					}
				}
			}
			return false;
		}
		
		if(left is NodeSet)
		{
			switch(true)
			{
				case right is Number:
					for(i = NodeSet(left).length - 1; i >= 0; i--)
					{
						leftString = XMLUtil.stringValueOf(NodeSet(left)[i]);
						if(compare(CoreFunctions.NUMBER_FUNCTION.evaluate(leftString), right))
						{
							return true;
						}
					}
					return false;
					
				case right is String:
					for(i = NodeSet(left).length - 1; i >= 0; i--)
					{
						leftString = XMLUtil.stringValueOf(NodeSet(left)[i]);
						if(compare(leftString, right))
						{
							return true;
						}
					}
					return false;
					
				case right is Boolean:
					return compare(CoreFunctions.BOOLEAN_FUNCTION.evaluate(left), right);
			}
		}
		
		if(right is NodeSet)
		{
			switch(true)
			{
				case left is Number:
					for(i = NodeSet(right).length - 1; i >= 0; i--)
					{
						rightString = XMLUtil.stringValueOf(NodeSet(right)[i]);
						if(compare(left, CoreFunctions.NUMBER_FUNCTION.evaluate(rightString)))
						{
							return true;
						}
					}
					return false;
					
				case left is String:
					for(i = NodeSet(right).length - 1; i >= 0; i--)
					{
						rightString = XMLUtil.stringValueOf(NodeSet(right)[i]);
						if(compare(left, rightString))
						{
							return true;
						}
					}
					return false;
					
				case left is Boolean:
					return compare(left, CoreFunctions.BOOLEAN_FUNCTION.evaluate(right));
			}
		}
		
		return compare(left, right);
	}
}

class EqualityOperator extends ComparisonOperator
{
	public function EqualityOperator(handler:Function)
	{
		super(handler);
	}
	
	override public function compare(left:Object, right:Object):Boolean
	{
		if(left is Boolean || right is Boolean)
		{
			left = CoreFunctions.BOOLEAN_FUNCTION.evaluate(left);
			right = CoreFunctions.BOOLEAN_FUNCTION.evaluate(right);
		}
		else if(left is Number || right is Number)
		{
			left = CoreFunctions.NUMBER_FUNCTION.evaluate(left);
			right = CoreFunctions.NUMBER_FUNCTION.evaluate(right);
		}
				
		return handler(left, right);
	}
}

class RelationalOperator extends ComparisonOperator
{
	public function RelationalOperator(handler:Function)
	{
		super(handler);
	}
	
	override public function compare(left:Object, right:Object):Boolean
	{
		left = CoreFunctions.NUMBER_FUNCTION.evaluate(left);
 		right = CoreFunctions.NUMBER_FUNCTION.evaluate(right);
		
		return handler(left, right);
	}
}

class ArithmeticOperator implements IOperator
{
	private var handler:Function;
	
	public function ArithmeticOperator(handler:Function)
	{
		this.handler = handler;		
	}
	
	public function evaluate(left:Object, right:Object):*
	{
		left = CoreFunctions.NUMBER_FUNCTION.evaluate(left);
 		right = CoreFunctions.NUMBER_FUNCTION.evaluate(right);
		
		return handler(left, right);
	}
}