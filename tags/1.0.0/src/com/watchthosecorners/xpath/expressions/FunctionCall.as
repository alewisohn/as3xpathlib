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
import com.watchthosecorners.xpath.NodeSet;
import com.watchthosecorners.xpath.QualifiedName;
import com.watchthosecorners.xpath.FunctionContext;

[ExcludeClass]
	
public class FunctionCall extends AbstractExpr
{
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 * 
	 * @param functionQName The qualified name of the function to call.
	 * 
	 * @param args The arguments to be supplied to the function.
	 */
	public function FunctionCall(functionQName:QualifiedName, args:Array)
	{
		super();

		_functionQName = functionQName;
		_args = args;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------

	//----------------------------------
	//  args
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _args:Array;

	/**
	 * The arguments to be supplied to the function.
	 */
	public function get args():Array
	{
		return _args;
	}
	
	//----------------------------------
	//  functionQName
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _functionQName:QualifiedName;

	/**
	 * The qualified name of the function to call.
	 */
	public function get functionQName():QualifiedName
	{
		return _functionQName;
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
		var func:FunctionContext = context.lookupFunction(_functionQName);
		var args:Array = [];
		
		if(func == null)
		{
			throw new Error("XPath function '" + _functionQName + "' not found.");
		}
		
		var argLen:int = _args.length;
		for(var i:uint = 0; i < argLen; i++)
		{
			args.push(_args[i].evaluate(context));	
		}
		
		return func.call(context, args);
	}
	
	/**
	 * @inheritDoc
	 */
	override public function referencedNodes(context:EvaluationContext):NodeSet
	{
		if(_args.length == 0)
		{
			var func:FunctionContext = context.lookupFunction(_functionQName);
			if(func == null)
			{
				throw new Error("XPath function '" + _functionQName + "' not found.");
			}
			
			if(func.defaultTo != FunctionContext.DefaultTo.NONE)
			{
				return new NodeSet(context.node);
			}
			else
			{
				return new NodeSet();
			}
		}
		else
		{
			var referencedNodes:NodeSet = new NodeSet();
			for(var i:int = 0; i < _args.length; i++)
			{
				referencedNodes.addAll(_args[i].referencedNodes(context));
			}
			return referencedNodes;
		}
	}
}
}