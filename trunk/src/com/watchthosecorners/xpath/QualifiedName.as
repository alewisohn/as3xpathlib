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
import com.watchthosecorners.xpath.errors.InvalidPrefixError;
import com.watchthosecorners.xpath.utils.XMLUtil;
	
public class QualifiedName
{
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 * 
	 * @param name Either a string or a QName object.
	 * 
	 * @param contextNode The from which to draw the namespace URI.
	 */
	public function QualifiedName(name:Object, contextNode:XML=null)
	{
		var nsURI:String;
		var localName:String;
		
		if(name is String)
		{
			var parts:Array = name.split(":");
			if(parts.length == 2)
			{
				if(parts[0].toString() == "*")
				{
					nsURI = null;
				}
				else
				{
					var ns:Namespace = contextNode.namespace(parts[0].toString()) as Namespace;
					if(ns == null)
					{
						throw new InvalidPrefixError(contextNode, parts[0]);
					}
					nsURI = ns.uri;
				}
				
				localName = parts[1];
				
				if(nsURI == "" || nsURI == "undefined")
				{
					throw new InvalidPrefixError(contextNode, parts[0]);
				}
			}
			else 
			{
				nsURI = "";
				localName = name.toString();
			}
		}
		else if(name is QName)
		{
			nsURI = QName(name).uri;
			localName = QName(name).localName;
		}
	
		_namespaceURI = nsURI;
		_localName = localName;
	}

	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  localName
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _localName:String;

	/**
	 * The local name.
	 */
	public function get localName():String
	{
		return _localName;
	}
	
	//----------------------------------
	//  namespaceURI
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _namespaceURI:String;

	/**
	 * The namespace URI.
	 */
	public function get namespaceURI():String
	{
		return _namespaceURI;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Compares two QualifiedName instances and returns <code>true</code> if
	 * they are equal.
	 */
	public function equals(qname:QualifiedName):Boolean
	{
		return qname.localName == _localName
				&& qname.namespaceURI == _namespaceURI;
	}
	
	/**
	 * Compares a QualifiedName instance to the default namespace and local name
	 * of an XML node.
	 */
	public function match(node:XML):Boolean
	{
		var localName:String = node.localName();
		var nsURI:String = XMLUtil.getNamespaceURI(node);
		
		if(_namespaceURI == null || _namespaceURI == "")
		{
			return localName == _localName;
		}
		else
		{
			return localName == _localName
					&& nsURI == _namespaceURI;
		}
	} 
	
	/**
	 * Convert the QualifiedName instance to a QName instance.
	 * 
	 * @param node An XML node from which to pull the default namespace.
	 */
	public function toQName(node:XML):QName
	{
		var qname:QName;
		if(_namespaceURI)
			qname = new QName(_namespaceURI, _localName);
		else if(node.namespace())
			qname = new QName(node.namespace().uri, _localName);
		else
			qname = new QName(_localName);
		return qname;	
	}
	
	/**
	 * Generates a string representation of the QualifiedName.
	 */
	public function toString():String
	{
		return _namespaceURI == ""
				? _localName
				: _namespaceURI + ":" + _localName;	
	}
}
}