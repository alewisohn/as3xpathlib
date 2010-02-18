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
import com.watchthosecorners.xpath.utils.XMLUtil;

[ExcludeClass]

public class CoreFunctions
{
	//--------------------------------------------------------------------------
	//
	//  Static initializer
	//
	//--------------------------------------------------------------------------
	
	{
		BOOLEAN_FUNCTION 			= new FunctionContext(booleanFunction, false);
		CEILING_FUNCTION 			= new FunctionContext(ceilingFunction, false);
		CONCAT_FUNCTION 			= new FunctionContext(concatFunction, false);
		CONTAINS_FUNCTION 			= new FunctionContext(containsFunction, false);
		COUNT_FUNCTION 				= new FunctionContext(countFunction, false);
		FALSE_FUNCTION 				= new FunctionContext(function():Boolean { return false; });
		FLOOR_FUNCTION 				= new FunctionContext(floorFunction, false);
		ID_FUNCTION 				= new FunctionContext(idFunction);
		LANG_FUNCTION 				= new FunctionContext(langFunction);
		LAST_FUNCTION 				= new FunctionContext(lastFunction);
		LOCAL_NAME_FUNCTION 		= new FunctionContext(localNameFunction, false, FunctionContext.DefaultTo.CONTEXT_NODESET);
		NAMESPACE_URI_FUNCTION 		= new FunctionContext(namespaceURIFunction, false, FunctionContext.DefaultTo.CONTEXT_NODESET);
		NAME_FUNCTION 				= new FunctionContext(nameFunction, false, FunctionContext.DefaultTo.CONTEXT_NODESET);
		NORMALIZE_SPACE_FUNCTION 	= new FunctionContext(normalizeSpaceFunction ,false, FunctionContext.DefaultTo.CONTEXT_STRING);
		NOT_FUNCTION 				= new FunctionContext(notFunction, false);
		NUMBER_FUNCTION 			= new FunctionContext(numberFunction, false, FunctionContext.DefaultTo.CONTEXT_NODESET);
		POSITION_FUNCTION 			= new FunctionContext(positionFunction);
		ROUND_FUNCTION 				= new FunctionContext(roundFunction, false);
		STARTS_WITH_FUNCTION 		= new FunctionContext(startsWithFunction, false);
		STRING_FUNCTION 			= new FunctionContext(stringFunction, false, FunctionContext.DefaultTo.CONTEXT_NODESET);
		STRING_LENGTH_FUNCTION 		= new FunctionContext(stringLengthFunction, false, FunctionContext.DefaultTo.CONTEXT_STRING);
		SUBSTRING_FUNCTION 			= new FunctionContext(substringFunction, false);
		SUBSTRING_AFTER_FUNCTION 	= new FunctionContext(substringAfterFunction, false);
		SUBSTRING_BEFORE_FUNCTION 	= new FunctionContext(substringBeforeFunction, false);
		SUM_FUNCTION 				= new FunctionContext(sumFunction, false);
		TRANSLATE_FUNCTION 			= new FunctionContext(translateFunction, false);
		TRUE_FUNCTION 				= new FunctionContext(function():Boolean { return true; });
		
		XPath.CORE_FUNCTIONS.registerFunction(new QualifiedName("last"),             LAST_FUNCTION);
		XPath.CORE_FUNCTIONS.registerFunction(new QualifiedName("position"),         POSITION_FUNCTION);
		XPath.CORE_FUNCTIONS.registerFunction(new QualifiedName("count"),            COUNT_FUNCTION);
		XPath.CORE_FUNCTIONS.registerFunction(new QualifiedName("id"),               ID_FUNCTION);
		XPath.CORE_FUNCTIONS.registerFunction(new QualifiedName("local-name"),       LOCAL_NAME_FUNCTION);
		XPath.CORE_FUNCTIONS.registerFunction(new QualifiedName("namespace-uri"),    NAMESPACE_URI_FUNCTION);
		XPath.CORE_FUNCTIONS.registerFunction(new QualifiedName("name"),             NAME_FUNCTION);
		                                                                    
		XPath.CORE_FUNCTIONS.registerFunction(new QualifiedName("string"),           STRING_FUNCTION);
		XPath.CORE_FUNCTIONS.registerFunction(new QualifiedName("concat"),           CONCAT_FUNCTION);
		XPath.CORE_FUNCTIONS.registerFunction(new QualifiedName("starts-with"),      STARTS_WITH_FUNCTION);
		XPath.CORE_FUNCTIONS.registerFunction(new QualifiedName("contains"),         CONTAINS_FUNCTION);
		XPath.CORE_FUNCTIONS.registerFunction(new QualifiedName("substring-before"), SUBSTRING_BEFORE_FUNCTION);
		XPath.CORE_FUNCTIONS.registerFunction(new QualifiedName("substring-after"),  SUBSTRING_AFTER_FUNCTION);
		XPath.CORE_FUNCTIONS.registerFunction(new QualifiedName("substring"),        SUBSTRING_FUNCTION);
		XPath.CORE_FUNCTIONS.registerFunction(new QualifiedName("string-length"),    STRING_LENGTH_FUNCTION);
		XPath.CORE_FUNCTIONS.registerFunction(new QualifiedName("normalize-space"),  NORMALIZE_SPACE_FUNCTION);
		XPath.CORE_FUNCTIONS.registerFunction(new QualifiedName("translate"),        TRANSLATE_FUNCTION);
		
		XPath.CORE_FUNCTIONS.registerFunction(new QualifiedName("boolean"),          BOOLEAN_FUNCTION);
		XPath.CORE_FUNCTIONS.registerFunction(new QualifiedName("not"),              NOT_FUNCTION);
		XPath.CORE_FUNCTIONS.registerFunction(new QualifiedName("true"),             TRUE_FUNCTION);
		XPath.CORE_FUNCTIONS.registerFunction(new QualifiedName("false"),            FALSE_FUNCTION);
		XPath.CORE_FUNCTIONS.registerFunction(new QualifiedName("lang"),             LANG_FUNCTION);
		
		XPath.CORE_FUNCTIONS.registerFunction(new QualifiedName("number"),           NUMBER_FUNCTION);
		XPath.CORE_FUNCTIONS.registerFunction(new QualifiedName("sum"),              SUM_FUNCTION);
		XPath.CORE_FUNCTIONS.registerFunction(new QualifiedName("floor"),            FLOOR_FUNCTION);
		XPath.CORE_FUNCTIONS.registerFunction(new QualifiedName("ceiling"),          CEILING_FUNCTION);
		XPath.CORE_FUNCTIONS.registerFunction(new QualifiedName("round"),            ROUND_FUNCTION);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Class variables
	//
	//--------------------------------------------------------------------------
	
	public static var BOOLEAN_FUNCTION:FunctionContext;
	public static var CEILING_FUNCTION:FunctionContext;
	public static var CONCAT_FUNCTION:FunctionContext;
	public static var CONTAINS_FUNCTION:FunctionContext;
	public static var COUNT_FUNCTION:FunctionContext;
	public static var FALSE_FUNCTION:FunctionContext;
	public static var FLOOR_FUNCTION:FunctionContext;
	public static var ID_FUNCTION:FunctionContext;
	public static var LANG_FUNCTION:FunctionContext;
	public static var LAST_FUNCTION:FunctionContext;
	public static var LOCAL_NAME_FUNCTION:FunctionContext;
	public static var NAME_FUNCTION:FunctionContext;
	public static var NAMESPACE_URI_FUNCTION:FunctionContext;
	public static var NORMALIZE_SPACE_FUNCTION:FunctionContext;
	public static var NOT_FUNCTION:FunctionContext;
	public static var NUMBER_FUNCTION:FunctionContext;
	public static var POSITION_FUNCTION:FunctionContext;
	public static var ROUND_FUNCTION:FunctionContext;
	public static var STARTS_WITH_FUNCTION:FunctionContext;
	public static var STRING_FUNCTION:FunctionContext;
	public static var STRING_LENGTH_FUNCTION:FunctionContext;
	public static var SUBSTRING_FUNCTION:FunctionContext;
	public static var SUBSTRING_AFTER_FUNCTION:FunctionContext;
	public static var SUBSTRING_BEFORE_FUNCTION:FunctionContext;
	public static var SUM_FUNCTION:FunctionContext;
	public static var TRANSLATE_FUNCTION:FunctionContext;
	public static var TRUE_FUNCTION:FunctionContext;
	
	//--------------------------------------------------------------------------
	//
	//  Class properties
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Forces static initializer to run.
	 */
	public static function get initialized():Boolean
	{
		return true;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Class methods
	//
	//--------------------------------------------------------------------------
	
	private static function booleanFunction(object:*):Boolean
	{
		switch(true)
		{
			case object is String:
				return object != "";
				
			case object is Number:
				return object != 0 && !isNaN(object);
				
			case object is Boolean:
				return object as Boolean;
				
			case object is NodeSet:
				return object.length > 0;
				
			case object is XMLList:
				return object.length() > 0;
				
			default:
				return true;
		}
	}
	
	private static function ceilingFunction(number:Object):Number
	{
		number = NUMBER_FUNCTION.evaluate(number);
		return Math.ceil(number as Number);
	}
	
	private static function concatFunction():String
	{
		var string:String = "";
		var argLen:int = arguments.length;
		
		for(var i:uint = 0; i < argLen; i++)
		{
			string += STRING_FUNCTION.evaluate(arguments[i]);
		}
		
		return string;	
	}
	
	private static function containsFunction(string:String, substr:String):Boolean
	{
		string = STRING_FUNCTION.evaluate(string);
		substr = STRING_FUNCTION.evaluate(substr);
		
		return string.indexOf(substr) != -1;
	}
	
	private static function countFunction(nodeSet:NodeSet):int
	{
		return nodeSet.length;		
	}
	
	private static function idFunction(context:EvaluationContext, object:Object):NodeSet
	{
		var result:NodeSet = new NodeSet();
		if(object is NodeSet)
		{
			for(var i:int = object.length - 1; i >= 0; i--)
			{
				result.addAll(NodeSet(ID_FUNCTION.evaluate(context, object[i])));
			}
		}
		else if(context.node != null)
		{
			var ids:Array = STRING_FUNCTION.evaluate(object).split(/\s+/);
			var document:XML = XMLUtil.getDocumentRoot(context.node);
			
			var rootId:String = document.@id.toString();
			if(rootId != "" && ids.indexOf(rootId))
				result.add(document);
			
			for(var a:int = ids.length - 1; a >= 0; a--)
			{
				result.addAll(document..*::*.(attribute("id") != undefined && @id == ids[a]));
			}
		}
		return result;
	}
	
	private static function floorFunction(number:Object):Number
	{
		number = NUMBER_FUNCTION.evaluate(number);
		return Math.floor(number as Number);
	}
	
	private static function langFunction(context:EvaluationContext, language:String):Boolean
	{
		language = STRING_FUNCTION.evaluate(language);
		
		var node:XML = context.node;
		while(node != null)
		{
			if(node.attributes().length() == 0)
				continue;
				
			var xmlLang:Object = node.attribute(new QName(DefaultNamespaces.XML, "lang"));
			if(xmlLang != null)
			{
				xmlLang = xmlLang.toString().toLowerCase();
				language = language.toLowerCase();
				
				return xmlLang.indexOf(language) == 0
					&& (language.length == xmlLang.length || language.charAt(xmlLang.length) ==  "-");
			}
			
			node = node.parent();
		}
		
		return false;
	}
	
	private static function lastFunction(context:EvaluationContext):int
	{
		return context.size;
	}
	
	private static function localNameFunction(nodeSet:NodeSet):String
	{
		if(nodeSet.length == 0)
			return "";
		
		var node:XML = nodeSet[0];
		var nodeName:String = nodeSet[0].localName().toString();
		
		if(node.nodeKind() == "attribute" && nodeName == DefaultNamespaces.EMPTY_XMLNS)
		{
			return "";
		}	
		
		return nodeName;
	}
	
	private static function nameFunction(nodeSet:NodeSet):String
	{
		if(nodeSet.length == 0)
			return "";
		
		var node:XML = nodeSet[0];
		var nodeName:String = nodeSet[0].name().toString().replace("::", ":");
		
		if(node.nodeKind() == "attribute" && nodeName == DefaultNamespaces.EMPTY_XMLNS)
		{
			return "";
		}

		return nodeName;
	}
	
	private static function namespaceURIFunction(nodeSet:NodeSet):String
	{
		if(nodeSet.length == 0)
			return "";
			
		return XMLUtil.getNamespaceURI(nodeSet[0]);	
	}
	
	private static function normalizeSpaceFunction(string:String):String
	{
		string = STRING_FUNCTION.evaluate(string);
		
		return string.replace(/^\s+|\s+$/g, "").replace(/\s+/g, " ");	
	}
	
	private static function notFunction(condition:Object):Boolean
	{
		condition = BOOLEAN_FUNCTION.evaluate(condition);
		return !condition;
	}
	
	private static function numberFunction(object:*):Number
	{
		switch(true)
		{
			case object is String:
				return object.toString().match(/^\s*-?(\d+(\.\d+)?|\.\d+)*\s*$/) != null ? Number(object) : NaN;
				
			case object is Number:
				return object;
				
			case object is Boolean:
				return object ? 1 : 0;
				
			case object is NodeSet:
				return NUMBER_FUNCTION.evaluate(STRING_FUNCTION.evaluate(object));
				
			default:
				return -1;
		}
	}
	
	private static function positionFunction(context:EvaluationContext):int
	{
		return context.position;
	}
	
	private static function roundFunction(number:Object):Number
	{
		var num:Number = NUMBER_FUNCTION.evaluate(number);
		return Math.round(num);
	}
	
	private static function startsWithFunction(string:String, prefix:String):Boolean
	{
		string = STRING_FUNCTION.evaluate(string);
		prefix = STRING_FUNCTION.evaluate(prefix);
		
		return string.indexOf(prefix) == 0;	
	}
	
	private static function stringFunction(object:Object):String
	{
		if(object == null)
			throw new ArgumentError("object is null.");
			
		switch(true)
		{
			case object is String:
				return object as String;
				
			case object is Boolean:
				return object ? "true" : "false";
				
			case object is NodeSet:
				return object.length > 0 ? XMLUtil.stringValueOf(object[0]) : "";
				
			case object is Number:
				var string:String = object.toString();
				return string;
		}
		
		return "";
	}
	
	private static function stringLengthFunction(string:String):int
	{
		string = STRING_FUNCTION.evaluate(string);
		
		return string.length;
	}
	
	private static function substringFunction(string:Object, startIndex:Object, length:Object=0x7fffffff):String
	{
		string = STRING_FUNCTION.evaluate(string);
		startIndex = NUMBER_FUNCTION.evaluate(startIndex);
		length = NUMBER_FUNCTION.evaluate(length);
		
		if(startIndex > 0)
			startIndex = Number(startIndex) - 1;
		else if(startIndex <= 0)
			length = Number(length) - Math.abs(1 - Number(startIndex));
			
		startIndex = ROUND_FUNCTION.evaluate(startIndex);
		length = ROUND_FUNCTION.evaluate(length);
		
		if(isNaN(Number(startIndex)) || isNaN(Number(length)))
		{
			return "";
		}
		var result:String = string.substr(startIndex, length);
		return result;
	}
	
	private static function substringAfterFunction(string:Object, substr:Object):String
	{
		var str:String = STRING_FUNCTION.evaluate(string);
		var substring:String = STRING_FUNCTION.evaluate(substr);
		
		var index:int = str.indexOf(substring);
		if(index == -1)
		{
			return "";
		}	
		
		return str.substring(index + substring.length);
	}
	
	private static function substringBeforeFunction(string:String, substr:String):String
	{
		string = STRING_FUNCTION.evaluate(string);
		substr = STRING_FUNCTION.evaluate(substr);
		
		return string.substring(0, string.indexOf(substr));
	}
	
	private static function sumFunction(nodeSet:NodeSet):Number
	{
		var sum:Number = 0;
		
		for(var i:int = nodeSet.length - 1; i >= 0; i--)
		{
			sum += NUMBER_FUNCTION.evaluate(XMLUtil.stringValueOf(nodeSet[i]));
		}	
		
		return sum;
	}
	
	private static function translateFunction(string:String, from:String, to:String):String
	{
		string = STRING_FUNCTION.evaluate(string);
		from = STRING_FUNCTION.evaluate(from);
		to = STRING_FUNCTION.evaluate(to);
		
		var result:String = "";
		var strLen:int = string.length;
		
		for(var i:uint = 0; i < strLen; i++)
		{
			var index:int = from.indexOf(string.charAt(i));
			if(index == -1)
			{
				result += string.charAt(i);
			}
			else
			{
				result += to.charAt(index);
			}
		}
		
		return result;
	}
}
}