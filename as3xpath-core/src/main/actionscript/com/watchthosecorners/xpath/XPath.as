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
import com.watchthosecorners.xpath.parser.Parser;

import org.as3commons.logging.ILogger;
import org.as3commons.logging.LoggerFactory;

/**
 * The XPath class is the entry point for an XPath query. 
 * 
 * It supports instance and static methods for evaluating an expression, 
 * selecting a single node, and retrieving the nodes referenced by an expression.
 *  
 * <p>
 * <b>Author:</b> Andrew Lewisohn<br/>
 * <b>Version:</b> $Revision: 15 $, $Date: 2010-01-28 12:26:11 -0500 (Thu, 28 Jan 2010) $, $Author: alewisohn $<br/>
 * <b>Since:</b> 1.0
 * </p>
 */	
public class XPath
{
	//--------------------------------------------------------------------------
	//
	//  Logging
	//
	//--------------------------------------------------------------------------
	
	private static const LOGGER:ILogger = LoggerFactory.getClassLogger(XPath);
	
	//--------------------------------------------------------------------------
	//
	//  Class constants
	//
	//--------------------------------------------------------------------------
	
	/**
	 * FunctionMap instance containing the core functions defined by the XPath
	 * specification.
	 */
	public static const CORE_FUNCTIONS:FunctionMap = new FunctionMap();
	
	/**
	 * FunctionMap instance containing any custom functions.a
	 */
	public static const CUSTOM_FUNCTIONS:FunctionMap = new FunctionMap();
	
	//--------------------------------------------------------------------------
	//
	//  Class methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Evaluates an XPath expression.
	 * 
	 * @param context The evaluation context for the XPath expression.
	 * 
	 * @return The result of the XPath, which is either a string, number, 
	 * 			boolean, or node-set.
	 */
	public static function evaluate(expression:String, context:Object):*
	{
		var contextNode:XML;
		if(context is XML)
			contextNode = context as XML;
			
		var xpath:XPath = new XPath(expression, contextNode);
		return xpath.evaluate(context);
	}
	
	/**
	 * Retrieves a node-set containing XML nodes referenced by the XPath 
	 * expression.
	 *  
	 * @param context The evaluation context for the XPath expression.
	 *
	 * @return A node-set containing any nodes referenced by the XPath expression.
	 */
	public static function referencedNodes(expression:String, context:Object):NodeSet
	{
		var contextNode:XML;
		if(context is XML)
			contextNode = context as XML;
			
		var xpath:XPath = new XPath(expression, contextNode);
		return xpath.referencedNodes(context);
	}
	
	/**
	 * Retrieves a single XML node.
	 * 
	 * @param context The evaluation context for the XPath expression.
	 * 
	 * @return An XML node.
	 */
	public static function selectSingleNode(expression:String, context:Object):XML
	{
		var contextNode:XML;
		if(context is XML)
			contextNode = context as XML;
			
		var xpath:XPath = new XPath(expression, contextNode);
		return xpath.selectSingleNode(context);			
	}
	
	//--------------------------------------------------------------------------
	//
	//  Class variables
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 * Single parser instance.
	 */											
	private static var parser:Parser = new Parser();
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 * 
	 * @param source The XPath expression.
	 * 
	 * @param context The evaluation context for the XPath expression Can be 
	 * 			either an XML node or an instance of EvaluationContext.
	 */
	public function XPath(source:String, context:Object=null)
	{
		if(!Axis.initialized)
			throw new Error("Unable to initialize Axis implementations.");
		
		var contextNode:XML;
		if(context == null)
		{
			contextNode = EvaluationContext.defaultContextNode;
			context = new EvaluationContext(null);
		}
		else if(context is XML)
		{
			var namespaces:Array = XML(context).inScopeNamespaces();
			namespaces = namespaces.concat(EvaluationContext.defaultContextNode.namespaceDeclarations());
			
			contextNode = XML(context).copy();
			context = new EvaluationContext(null);
				
			for(var i:uint = 0; i < namespaces.length; i++)
			{
				var ns:Namespace = namespaces[i];
				var contextNS:Namespace = contextNode.namespace(ns.prefix);
				if(contextNS == null)
				{
					contextNode.addNamespace(ns);
				}
			}
		}
		else if(!(context is EvaluationContext))
		{
			throw new ArgumentError("Argument 'context' must be of type EvaluationContext, XML, or null.");
		}
		
		_context = context as EvaluationContext;
		_source = source;
		_expression = parser.parse(source, contextNode);
	}

	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------

	//----------------------------------
	//  context
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _context:EvaluationContext;

	/**
	 * The evaluation context for the XPath expression instance.
	 */
	public function get context():EvaluationContext
	{
		return _context;
	}

	//----------------------------------
	//  expression
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _expression:IExpr;

	/**
	 * The compiled XPath expression.
	 */
	public function get expression():IExpr
	{
		return _expression;
	}
	
	//----------------------------------
	//  source
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _source:String;

	/**
	 * The XPath expression as a string.
	 */
	public function get source():String
	{
		return _source;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Evaluates an XPath expression.
	 * 
	 * @param context The evaluation context for the XPath expression.
	 * 
	 * @return The result of the XPath, which is either a string, number, 
	 * 			boolean, or node-set.
	 */
	public function evaluate(context:Object=null):*
	{
		if(context is XML)
		{
			_context = new EvaluationContext(context as XML, 1, 1);
		}
		else if(context is EvaluationContext)
		{
			_context = EvaluationContext(context);
		}
		else if(context == null && _context == null)
		{
			_context = new EvaluationContext(null);
		}

		return _expression.evaluate(_context as EvaluationContext);
	}
	
	/**
	 * Retrieves a node-set containing XML nodes referenced by the XPath 
	 * expression.
	 *  
	 * @param context The evaluation context for the XPath expression.
	 *
	 * @return A node-set containing any nodes referenced by the XPath expression.
	 */
	public function referencedNodes(context:Object=null):NodeSet
	{
		if(context is XML)
		{
			_context = new EvaluationContext(context as XML, 1, 1);
		}
		else if(context is EvaluationContext)
		{
			_context = EvaluationContext(context);
		}
		else if(context == null && _context == null)
		{
			_context = new EvaluationContext(null);
		}
		
		return _expression.referencedNodes(_context as EvaluationContext);
	}
		
	/**
	 * Retrieves a single XML node.
	 * 
	 * @param context The evaluation context for the XPath expression.
	 * 
	 * @return An XML node.
	 */
	public function selectSingleNode(context:Object=null):XML
	{
		var nodeSet:Object = evaluate(context);
		if(nodeSet.length == 0)
		{
			return null;
		}
		else
		{
			return nodeSet[0] as XML;
		}
	}
}
}