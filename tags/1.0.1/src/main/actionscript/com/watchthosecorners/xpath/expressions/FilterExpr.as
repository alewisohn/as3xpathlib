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
import com.watchthosecorners.xpath.Axis;
import com.watchthosecorners.xpath.EvaluationContext;
import com.watchthosecorners.xpath.IExpr;
import com.watchthosecorners.xpath.NodeSet;
import com.watchthosecorners.xpath.Predicate;

[ExcludeClass]
	
public class FilterExpr extends AbstractExpr
{
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 * 
	 * @param expression The expression that generates the initial node set.
	 * 
	 * @param predicate The predicate filter to apply to the node set generated
	 * 		from <code>expression</code>.
	 */
	public function FilterExpr(expression:IExpr, predicate:Predicate)
	{
		super();
		
		_expression = expression;
		_predicate = predicate;
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
	 * The expression that generates the initial node set.
	 */
	public function get expression():IExpr
	{
		return _expression;
	}

	//----------------------------------
	//  predicate
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _predicate:Predicate;

	/**
	 * The predicate filter to apply to the node set generated
	 * 		from <code>expression</code>.
	 */
	public function get predicate():Predicate
	{
		return _predicate;
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
		return _predicate.filter(context, _expression.evaluate(context), Axis.Direction.FORWARD);	
	}
	
	/**
	 * @inheritDoc
	 */
	override public function referencedNodes(context:EvaluationContext):NodeSet
	{
		var nodeSet:NodeSet = super.referencedNodes(context);
		var predicateContext:EvaluationContext = context.clone();
		predicateContext.node = nodeSet[0];
		nodeSet.addAll(_predicate.expression.referencedNodes(predicateContext));
		return nodeSet;
	}
}
}