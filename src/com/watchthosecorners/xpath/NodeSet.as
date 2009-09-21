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
public dynamic class NodeSet extends Array
{
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 * 
	 * @param value Can be either XML or an XMLList with which to prepopulate
	 * 		the node-set.
	 */
	public function NodeSet(value:Object=null)
	{
		super();
		
		if(value is XML)
		{
			add(value as XML);
		}
		else if(value is XMLList)
		{
			for each(var node:XML in value)
			{
				add(node);
			}
		}
	}
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Add a node to the node-set.
	 */
	public function add(node:XML):void
	{
		if(node != null && !contains(node))
		{
			push(node);
		}
	}
	
	/**
	 * Add a collection of nodes.
	 */
	public function addAll(nodes:Object):NodeSet
	{
		var nodeLen:int = nodes is XMLList ? nodes.length() : nodes.length;
		for(var i:int = 0; i < nodeLen; i++)
		{
			add(nodes[i]);
		}
		
		return this;
	} 
	
	/**
	 * Add a node without testing for uniqueness.
	 */
	public function addUnique(node:XML):NodeSet
	{
		if(node != null)
		{
			push(node);
		}
		return this;
	}
	
	/**
	 * Add a collection of unique nodes.
	 */
	public function addAllUnique(nodes:Object):NodeSet
	{
		var nodeLen:int = nodes is XMLList ? nodes.length() : nodes.length;
		for(var i:int = 0; i < nodeLen; i++)
		{
			addUnique(nodes[i]);
		}
		
		return this;
	}
	
	/**
	 * Evaluates equivalency of two node-sets. Items in the node-set are tested
	 * by strict equality and in the order in which they appear in the node-set.
	 */
	public function equals(nodeSet:NodeSet):Boolean
	{
		if(nodeSet == null)
			return false;
			
		if(length != nodeSet.length)
			return false;	
			
		for(var i:uint = 0; i < length; i++)
		{
			if(this[i] !== nodeSet[i])
				return false;
		}
		
		return true;
	}
	
	/**
	 * Check if the node-set already contains the given node.
	 */
	public function contains(node:XML):Boolean
	{
		return indexOf(node) > -1;
	}
	
	/**
	 * Clears the contents of the node-set.
	 */
	public function clear():void
	{
		while(length > 0)
		{
			shift();
		}
	}
}
}