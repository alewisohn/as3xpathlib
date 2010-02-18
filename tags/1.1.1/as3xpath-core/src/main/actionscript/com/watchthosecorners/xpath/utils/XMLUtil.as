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
package com.watchthosecorners.xpath.utils
{	
public class XMLUtil
{
	//--------------------------------------------------------------------------
	//
	//  Class methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Returns the XML root document.
	 * 
	 * @param node The node to find the root for.
	 */
	public static function getDocumentRoot(node:XML):XML
	{
		while(node.parent() != null)
		{
			node = node.parent();
		}
		
		return node;
	}
	
	/**
	 * Gets the namespace uri of a node.
	 * 
	 * @param node The node to get the namespace uri for.
	 */
	public static function getNamespaceURI(node:XML):String
	{
		var name:Object;
		
		if(node.nodeKind() == "element"
			|| node.nodeKind() == "attribute")
		{
			name = node.name();
		}
		else
		{
			name = node.parent().name();
		}
		
		return name.uri;	
	}
	
	/**
	 * Retrieves the string value of a node.
	 * 
	 * @param node The node to convert to a string.
	 */
	public static function stringValueOf(node:XML):String
	{
		switch(node.nodeKind())
		{
			case "element":
				var string:String;
				if(node.hasSimpleContent())
					string = node.text().toString();
				else
					string = node..*::*.text().toString();
				return string;
				
			case "comment":
				return node.toString().replace("<!--", "").replace("-->", "");
			
			case "processing-instruction":
				return node.toString().replace("<?", "").replace("?>", "");
			
			case "attribute":
			case "text":
				return node.toString();
					
			default:
				throw new Error("Unknown node-type '" + node.nodeKind() + "'");
		}
	}
}
}