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

/**
 * Expression evaluation occurs with respect to a context. The context consists 
 * of:
 * <ul>
 * <li>a node (the context node)</li>
 * <li>a pair of non-zero positive integers (the context position and the 
 * 		context size)</li>
 * <li>a set of variable bindings</li>
 * <li>a function library</li>
 * <li>the set of namespace declarations in scope for the expression</li>
 * </ul>
 * 
 * The context position is always less than or equal to the context size.
 *
 * The variable bindings consist of a mapping from variable names to variable 
 * values. The value of a variable is an object, which can be of any of the 
 * types that are possible for the value of an expression, and may also be of 
 * additional types not specified here.
 * 
 * The function library consists of a mapping from function names to functions. 
 * Each function takes zero or more arguments and returns a single result. 
 * For a function in the core function library, arguments and result are of the 
 * four basic types.
 * 
 * The namespace declarations consist of a mapping from prefixes to namespace 
 * URIs.
 * 
 * <p>
 * <b>Author:</b> Andrew Lewisohn<br/>
 * <b>Version:</b> $Revision: 15 $, $Date: 2010-01-28 12:26:11 -0500 (Thu, 28 Jan 2010) $, $Author: alewisohn $<br/>
 * <b>Since:</b> 1.0
 * </p>
 */		
public class EvaluationContext
{
	//--------------------------------------------------------------------------
	//
	//  Class constants
	//
	//--------------------------------------------------------------------------
	
	private static const CORE_FMAP_KEY:String	 					= "core";
	
	private static const CUSTOM_FMAP_KEY:String						= "custom";
	
	private static const DEFAULT_CONTEXT_NODE:XML = <defaultprefixes 
														xmlns:html={DefaultNamespaces.XHTML}
														xmlns:xhtml={DefaultNamespaces.XHTML}
														xmlns:events={DefaultNamespaces.EVENTS}
														xmlns:event={DefaultNamespaces.EVENTS}
														xmlns:ev={DefaultNamespaces.EVENTS}
														xmlns:xs={DefaultNamespaces.SCHEMA}
														xmlns:xsd={DefaultNamespaces.SCHEMA}
														xmlns:schema={DefaultNamespaces.SCHEMA}
														xmlns:xsl={DefaultNamespaces.XSL}
														xmlns:xslt={DefaultNamespaces.XSL}/>;
	
	//--------------------------------------------------------------------------
	//
	//  Class properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  defaultContextNode
	//----------------------------------
	
	/**
	 * A context node that includes namespaces default known namespaces.
	 */
	public static function get defaultContextNode():XML
	{
		return DEFAULT_CONTEXT_NODE;	
	}	
												
	//--------------------------------------------------------------------------
	//
	//  Variables
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	private var defaultNamespaces:DefaultNamespaces = new DefaultNamespaces();
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 * 
	 * @param node The context node.
	 * 
	 * @param position The context position.
	 * 
	 * @param size The context size. 
	 */
	public function EvaluationContext(node:XML, position:int=1, size:int=1)
	{
		_node = node;
		_position = position;
		_size = size;

		CoreFunctions.initialized;
		functionResolvers[CORE_FMAP_KEY] = XPath.CORE_FUNCTIONS;
		functionResolvers[CUSTOM_FMAP_KEY] = XPath.CUSTOM_FUNCTIONS;
	}

	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  functionResolvers
	//----------------------------------
	
	/**
	 * Contains the XPath.CORE_FUNCTIONS Function Map and a Function Map for
	 * custom functions by default.
	 */
	protected var functionResolvers:Array = [];
	
	//----------------------------------
	//  node
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _node:XML;

	/**
	 * The context node.
	 */
	public function get node():XML
	{
		return _node;
	}
	
	/**
	 * @private
	 */
	public function set node(value:XML):void
	{
		_node = value;
	}	

	//----------------------------------
	//  position
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _position:int;

	/**
	 * The context position. It is always less than or equal to the context
	 * size.
	 */
	public function get position():int
	{
		return _position;
	}
	
	/**
	 * @private
	 */
	public function set position(value:int):void
	{
		_position = value;
	}

	//----------------------------------
	//  size
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _size:int;

	/**
	 * The context size.
	 */
	public function get size():int
	{
		return _size;
	}
	
	/**
	 * @private
	 */
	public function set size(value:int):void
	{
		_size = value;
	}
	
	//----------------------------------
	//  variableReferences
	//----------------------------------
	
	/**
	 * A Map of all user-defined variable references. Mapped by QName.
	 */
	protected var variableReferences:VariableReferenceMap = new VariableReferenceMap();
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Allows the addition of a custom FunctionMap instance to the evaluation
	 * context.
	 * 
	 * @param fmap The FunctionMap to add.
	 */
	public function addFunctionMap(fmap:FunctionMap):void
	{
		functionResolvers.push(fmap);
	}
	
	/**
	 * Creates a copy of the evaluation context.
	 */
	public function clone():EvaluationContext
	{
		var context:EvaluationContext = new EvaluationContext(_node, _position, _size);
		context.functionResolvers = functionResolvers;
		context.variableReferences = variableReferences;
		return context;
	}
	
	/**
	 * Performs a lookup of the function based on a qualifed name. First the
	 * core function map is checked, then the custom function map. Finally, 
	 * any function maps that were added by addFunctionMap() are searched.
	 * 
	 * @param qname The qualified name of the function.
	 */
	public function lookupFunction(qname:QualifiedName):FunctionContext
	{
		// Check the Core Function Map
		var func:FunctionContext = functionResolvers[CORE_FMAP_KEY].lookupFunction(qname);
		if(func != null)
			return func;
		
		// Check the Custom Function Map 
		func = functionResolvers[CUSTOM_FMAP_KEY].lookupFunction(qname);
		if(func != null)
			return func;
		
		// Check any Function Maps added by addFunctionMap
		for(var i:int = 0; i < functionResolvers.length; i++)
		{
			func = functionResolvers[i].lookupFunction(qname);
			if(func != null)
				return func;
		}
		
		return null;
	}
	
	/**
	 * Performs a variable lookup by qualified name.
	 * 
	 * @param qname The qualified name of the variable.
	 */
	public function lookupVariable(qname:QualifiedName):*
	{
		return variableReferences.lookupVariable(qname);
	}
	
	/**
	 * Registers a function context by its qualified name.
	 * 
	 * @param qname The qualified name of the function.
	 * 
	 * @param func The function context object containing the function.
	 */
	public function registerFunction(qname:QualifiedName, func:FunctionContext):void
	{
		functionResolvers[CUSTOM_FMAP_KEY].registerFunction(qname, func);
	}
	
	/**
	 * Destroys the variable referenced by the qualified name.
	 * 
	 * @param qname The qualified name of the variable reference.
	 */
	public function removeVariable(qname:QualifiedName):void
	{
		variableReferences.removeVariable(qname);
	}
	
	/**
	 * Sets the value of the variable reference for the qualified name.
	 * 
	 * @param qname The qualified name of the variable reference.
	 * 
	 * @param value The value of the variable reference.
	 */
	public function setVariable(qname:QualifiedName, value:*):void
	{
		variableReferences.setVariable(qname, value);
	}
	
	/**
	 * Generates a string representation of the evaluation context.
	 */
	public function toString():String
	{
		return '[object EvaluationContext node="' + _node.name() + '" position="' + _position + '" size="' + _size + '"]';
	}
}
}