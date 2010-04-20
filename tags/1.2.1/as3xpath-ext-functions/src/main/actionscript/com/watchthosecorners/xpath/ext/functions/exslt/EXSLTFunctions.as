package com.watchthosecorners.xpath.ext.functions.exslt
{
import com.watchthosecorners.xpath.EvaluationContext;
import com.watchthosecorners.xpath.FunctionContext;
import com.watchthosecorners.xpath.NodeSet;
import com.watchthosecorners.xpath.QualifiedName;
import com.watchthosecorners.xpath.XPath;

import flash.utils.Dictionary;

import org.as3commons.logging.ILogger;
import org.as3commons.logging.LoggerFactory;

public class EXSLTFunctions
{
	//--------------------------------------------------------------------------
	//
	//  Logging
	//
	//--------------------------------------------------------------------------
	
	private static const LOGGER:ILogger = LoggerFactory.getClassLogger(EXSLTFunctions);
	
	//--------------------------------------------------------------------------
	//
	//  Class variables
	//
	//--------------------------------------------------------------------------
	
	public static var MATCH:FunctionContext;
	public static var REPLACE:FunctionContext;
	public static var TEST:FunctionContext;
	
	private static var regexpMap:Dictionary = new Dictionary();
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Forces static initializer to run.
	 */
	public static function initialize():void
	{
		if(MATCH == null)
		{
			LOGGER.info("Initializing EXSLT Extension Functions.");
			
			EvaluationContext.defaultContextNode.addNamespace(new Namespace("regexp", "http://exslt.org/regular-expressions"));
			
			MATCH 		= new FunctionContext(match, false);
			REPLACE 	= new FunctionContext(replace, false);
			TEST		= new FunctionContext(test, false);
			
			XPath.CUSTOM_FUNCTIONS.registerFunction(new QualifiedName("regexp:match"), 		MATCH);
			XPath.CUSTOM_FUNCTIONS.registerFunction(new QualifiedName("regexp:replace"), 	REPLACE);
			XPath.CUSTOM_FUNCTIONS.registerFunction(new QualifiedName("regexp:test"), 		TEST);
		}
	}
	
	//--------------------------------------------------------------------------
	//
	//  Class methods: Functions
	//
	//--------------------------------------------------------------------------
	
	private static function match(string:String, pattern:String, flags:String):NodeSet
	{
		var regexp:RegExp;
		var result:NodeSet = new NodeSet();
		
		try
		{
			regexp = getRegExp(pattern, flags);
			result.addAllUnique(string.match(regexp));
		}
		catch(e:Error)
		{
			return new NodeSet();
		}
		
		return result;
	}
	
	private static function replace(string:String, pattern:String, flags:String, replace:String):String
	{
		var regexp:RegExp;
		var result:String
		
		try
		{
			regexp = new RegExp(pattern, flags)
			result = string.replace(regexp, replace);
		}
		catch(e:Error)
		{
			return string;
		}
		
		return result;
	}
	
	private static function test(string:String, pattern:String, flags:String):Boolean
	{
		var regexp:RegExp;
		var result:Boolean = false;
	
		try
		{
			regexp = new RegExp(pattern, flags)
			result = regexp.test(string);
		}
		catch(e:Error)
		{
			return false;
		}
		
		return result;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Class methods: Helpers
	//
	//--------------------------------------------------------------------------
	
	private static function getRegExp(pattern:String, flags:String):RegExp
	{
		var regexp:RegExp = regexpMap[pattern + ":" + flags];
		if(regexp == null) 
		{
			regexp = new RegExp(pattern, flags);
			regexpMap[pattern + ":" + flags] = regexp;
		}
		return regexp;
	}
}
}