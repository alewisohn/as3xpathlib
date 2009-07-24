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
import com.watchthosecorners.xpath.INodeTest;
import com.watchthosecorners.xpath.NodeSet;
import com.watchthosecorners.xpath.Step;
import com.watchthosecorners.xpath.nodeTests.NodeNodeTest;
import com.watchthosecorners.xpath.nodeTests.QNameNodeTest;
import com.watchthosecorners.xpath.nodeTests.StarNodeTest;
import com.watchthosecorners.xpath.utils.XMLUtil;
	
[ExcludeClass]
	
public class LocationPath extends AbstractExpr
{
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 * 
	 * @param isAbsolute If <code>true</code>, the location path represents an 
	 * 		absolute path.
	 * 
	 * @param steps An array of Step objects.
	 */
	public function LocationPath(isAbsolute:Boolean, steps:Array)
	{
		super();
		
		_isAbsolute = isAbsolute;
		_steps = steps;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  isAbsolute
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _isAbsolute:Boolean;

	/**
	 * If <code>true</code>, the location path represents an absolute path.
	 */
	public function get isAbsolute():Boolean
	{
		return _isAbsolute;
	}
	
	/**
	 * @private
	 */
	public function set isAbsolute(value:Boolean):void
	{
		_isAbsolute = value;
	}
	
	//----------------------------------
	//  steps
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _steps:Array;

	/**
	 * An array of path steps to evaluate.
	 */
	public function get steps():Array
	{
		return _steps;
	}
	
	/**
	 * @private
	 */
	public function set steps(value:Array):void
	{
		_steps = value;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Overriden methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @inheritDoc
	 */
	override public function evaluate(context:EvaluationContext):*
	{
		var nodeSet:NodeSet;
		var contextNode:XML;
		
		if(context.node == null)
		{
			nodeSet = new NodeSet();
		}
		else if(_isAbsolute)
		{
			contextNode = XMLUtil.getDocumentRoot(context.node);
			nodeSet = new NodeSet(contextNode);	
		}
		else
		{
			contextNode = context.node;
			nodeSet = new NodeSet(context.node);
		}
		
		if(_steps && _steps.length > 0)
		{
			var step:Step = _steps[0];
			var execFirstStep:Boolean = false;
				
			if(step.nodeTest is QNameNodeTest)
			{
				execFirstStep = INodeTest(step.nodeTest).test(context, contextNode, null);
			}
			else if(step.nodeTest is StarNodeTest
					&& step.axis == Axis.CHILD)
			{
				execFirstStep = context.node.parent() == null;
			}
			
			if(execFirstStep)
			{
				for(var i:int = 0; i < step.predicates.length; i++)
				{
					nodeSet = step.predicates[i].filter(context, nodeSet, step.axis.direction);
				}
				
				_steps.splice(0, 1);
			}
		}
		
		return filter(context, nodeSet);
	}

	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Filters the supplied nodeSet by evaluating the collection of steps against 
	 * the given evaluation context.
	 * 
	 * @param context The evaluation context.
	 * 
	 * @param nodeSet The nodeSet to filter.
	 */
	public function filter(context:EvaluationContext, nodeSet:NodeSet):NodeSet
	{
		flatten();
		
		var stepLen:uint = _steps.length;
				
		for(var i:uint = 0; i < stepLen; i++)
		{
			var step:Step = _steps[i];
			nodeSet = step.filter(context, nodeSet);
		}
		
		return nodeSet;
	}
	
	/**
	 * @private
	 * Examine each step and the step that follows it. If the current step is a
	 * Descendant or DescendantOrSelf Axis, and the following step is a Child
	 * Axis, merge the steps together and splice out the uncessary step.
	 */		
	private function flatten():void
	{
		var stepLen:uint = _steps.length;
		var i:int = 0;
		
		while(i < stepLen)
		{
			var step:Step = _steps[i];
			var nextStep:Step = _steps[i + 1];
			
			if(nextStep == null) break;
			
			if((step.axis == Axis.DESCENDANT
				|| step.axis == Axis.DESCENDANT_OR_SELF)
				&& nextStep.axis == Axis.CHILD)
			{	
				if(!(nextStep.nodeTest is NodeNodeTest)
					&& !(nextStep.nodeTest is StarNodeTest))
				{
					step.nodeTest = nextStep.nodeTest;
					step.predicates = step.predicates.concat(nextStep.predicates);
					
					_steps.splice(i + 1, 1);
					stepLen = _steps.length;
				}
			}
			
			i++;
		}
	}
}
}