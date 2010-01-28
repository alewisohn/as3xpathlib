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
[ExcludeClass]
	
public class DefaultNamespaces
{
	//--------------------------------------------------------------------------
	//
	//  Class constants
	//
	//--------------------------------------------------------------------------
	
	public static const EMPTY_XMLNS:String	= "empty-xmlns-namespace-identifier";
	public static const EVENTS:String		= "http://www.w3.org/2001/xml-events";
	public static const SCHEMA:String 		= "http://www.w3.org/1999/XMLSchema";
	public static const XHTML:String		= "http://www.w3.org/1999/xhtml";
	public static const XML:String			= "http://www.w3.org/XML/1998/namespace";
	public static const XSL:String			= "http://www.w3.org/1999/XSL/Transform";
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	public function DefaultNamespaces()
	{
	}
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  events
	//----------------------------------
	
	public function get events():String
	{
		return EVENTS;
	}
	
	//----------------------------------
	//  schema
	//----------------------------------
	
	public function get schema():String
	{
		return SCHEMA;
	}	
	
	//----------------------------------
	//  xhtml
	//----------------------------------
	
	public function get xhtml():String
	{
		return XHTML;
	}
	
	//----------------------------------
	//  xml
	//----------------------------------
	
	public function get xml():String
	{
		return XML;
	}
	
	//----------------------------------
	//  xsl
	//----------------------------------
	
	public function get xsl():String
	{
		return XSL;
	}
}
}