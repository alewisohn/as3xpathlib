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
public class FunctionContext
{
	//--------------------------------------------------------------------------
	//
	//  Class properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//   DefaultTo
	//----------------------------------
	
	/**
	 * @private
	 */
	private static var _DefaultTo:FunctionContextDefaults;

	/**
	 * Access to the FunctionContextDefaults enumeration.
	 */
	public static function get DefaultTo():FunctionContextDefaults
	{
		if(_DefaultTo == null)
			_DefaultTo = new FunctionContextDefaults();
			
		return _DefaultTo;
	}

	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 * 
	 * @param body The function to execute.
	 * 
	 * @param acceptContext If <code>true</code>, the function accepts an
	 * 			EvaluationContext as its first argument.
	 * 
	 * @param defaultTo Determines the type of argument passed to the function. 
	 */
	public function FunctionContext(body:Function, acceptContext:Boolean=true, defaultTo:int=-1)
	{
		_evaluate = body;
		_acceptContext = acceptContext;
		_defaultTo = defaultTo;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  acceptContext
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _acceptContext:Boolean;

	/**
	 * If <code>true</code>, the function accepts an EvaluationContext as its
	 * first argument.
	 */
	public function get acceptContext():Boolean
	{
		return _acceptContext;
	}
	
	//----------------------------------
	//  defaultTo
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _defaultTo:int;

	/**
	 * Determines the type of arguments passed to the function. 
	 */
	public function get defaultTo():int
	{
		return _defaultTo;
	}	
	
	//----------------------------------
	//  evaluate
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _evaluate:Function;

	/**
	 * The function.
	 */
	public function get evaluate():Function
	{
		return _evaluate;
	}	
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Executes the function.
	 * 
	 * @param context The evaluation context for the execution.
	 * 
	 * @param args The arguments that are passed to the function.
	 */
	public function call(context:EvaluationContext, args:Array):*
	{
		if(args.length == 0)
		{
			switch(_defaultTo)
			{
				case DefaultTo.CONTEXT_NODE:
					if(context.node != null)
						args = [context.node];
					break;
					
				case DefaultTo.CONTEXT_NODESET:
					if(context.node != null)
						args = [new NodeSet(context.node)];
					break;
					
				case DefaultTo.CONTEXT_STRING:
					args = [CoreFunctions.STRING_FUNCTION.evaluate(new NodeSet(context.node))];
					break;
			}
		}
		
		if(_acceptContext)
		{
			args.unshift(context);
		}
		
		return _evaluate.apply(null, args);
	}
	
	/**
	 * Generates a string representation of the FunctionContext.
	 */
	public function toString():String
	{
		return '[object FunctionContext acceptContext="' + _acceptContext + '" defaultTo="' + _defaultTo + '"]';
	}
}
}