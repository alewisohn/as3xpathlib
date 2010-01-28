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
import com.watchthosecorners.xpath.INodeTest;

[ExcludeClass]
	
public class Step
{
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function Step(axis:Axis, nodeTest:INodeTest, predicates:Array)
	{
		_axis = axis;
		_nodeTest = nodeTest;
		_predicates = predicates;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  axis
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _axis:Axis;

	/**
	 * Documentation Required
	 */
	public function get axis():Axis
	{
		return _axis;
	}
	
	/**
	 * @private
	 */
	public function set axis(value:Axis):void
	{
		_axis = value;
	}
	
	//----------------------------------
	//  nodeTest
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _nodeTest:INodeTest;

	/**
	 * Documentation Required
	 */
	public function get nodeTest():INodeTest
	{
		return _nodeTest;
	}
	
	/**
	 * @private
	 */
	public function set nodeTest(value:INodeTest):void
	{
		_nodeTest = value;
	}
	
	//----------------------------------
	//  predicates
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _predicates:Array;

	/**
	 * Documentation Required
	 */
	public function get predicates():Array
	{
		return _predicates;
	}
	
	/**
	 * @private
	 */
	public function set predicates(value:Array):void
	{
		_predicates = value;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	public function filter(context:EvaluationContext, nodeSet:NodeSet):NodeSet
	{
		nodeSet = _axis.filter(nodeSet, _nodeTest);
		
		for(var i:int = 0; i < _predicates.length; i++)
		{
			nodeSet = _predicates[i].filter(context, nodeSet, _axis.direction);
		}
		return nodeSet;
	}
}
}