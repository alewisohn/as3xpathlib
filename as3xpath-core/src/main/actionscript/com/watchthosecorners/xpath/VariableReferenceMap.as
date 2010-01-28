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
import flash.utils.Dictionary;

[ExcludeClass]
	
public class VariableReferenceMap
{
	//--------------------------------------------------------------------------
	//
	//  Variables
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	private var variables:Dictionary = new Dictionary();
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function VariableReferenceMap()
	{
	}
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	public function lookupVariable(qname:QualifiedName):*
	{
		var value:* = variables[qname.toString()];
		if(value == undefined)
			throw new ReferenceError("No variable has been registered for the QualifiedName, '" + qname.toString() + "'.");
		
		return value;
	} 

	public function removeVariable(qname:QualifiedName):void
	{
		delete variables[qname.toString()];	
	}
	
	public function setVariable(qname:QualifiedName, value:*):void
	{
		variables[qname.toString()] = value;
	}
	
	public function toString():String
	{
		var str:String = "";
		for(var qname:String in variables)
		{
			str += qname + ": " + variables[qname] + "\n";
		}
		return str;	
	}
}
}