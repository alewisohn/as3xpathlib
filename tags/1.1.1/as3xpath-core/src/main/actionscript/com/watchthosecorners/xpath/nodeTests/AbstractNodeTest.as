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
package com.watchthosecorners.xpath.nodeTests
{
import com.watchthosecorners.xpath.Axis;
import com.watchthosecorners.xpath.EvaluationContext;
import com.watchthosecorners.xpath.INodeTest;
import com.watchthosecorners.xpath.NodeSet;

import flash.errors.IllegalOperationError;
	
[ExcludeClass]
	
public class AbstractNodeTest implements INodeTest
{
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function AbstractNodeTest()
	{
	}
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @inheritDoc
	 */
	public function filter(context:EvaluationContext, nodeSet:NodeSet, axis:Axis):NodeSet
	{
		var result:NodeSet = new NodeSet();
		
		for(var i:int = 0; i < nodeSet.length; i++)
		{
			var node:XML = nodeSet[i];
			if(test(context, node, axis))
			{
				result.addUnique(node);
			}
		}
		
		return result;
	}
	
	/**
	 * @inheritDoc
	 */
	public function test(context:EvaluationContext, node:XML, axis:Axis):Boolean
	{
		throw new IllegalOperationError("Abstract Method must be Overridden in subclass.");	
	}
}
}