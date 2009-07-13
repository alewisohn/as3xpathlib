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

[ExcludeClass]
	
public class PathExpr extends AbstractExpr
{
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 * 
	 * @param A filter expression.
	 * 
	 * @param A location path.
	 */
	public function PathExpr(filterExpr:IExpr, locationPath:LocationPath)
	{
		super();
		
		_filterExpr = filterExpr;
		_locationPath = locationPath;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  filterExpr
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _filterExpr:IExpr;

	/**
	 * A filter expression.
	 */
	public function get filterExpr():IExpr
	{
		return _filterExpr;
	}

	//----------------------------------
	//  locationPath
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _locationPath:LocationPath;

	/**
	 * A location path.
	 */
	public function get locationPath():LocationPath
	{
		return _locationPath;
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
		return _locationPath.filter(context, _filterExpr.evaluate(context)); 
	}
}
}