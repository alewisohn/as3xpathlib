package com.watchthosecorners.xpath.ext.functions.xpath {

import com.watchthosecorners.xpath.EvaluationContext;
import com.watchthosecorners.xpath.FunctionContext;
import com.watchthosecorners.xpath.QualifiedName;
import com.watchthosecorners.xpath.XPath;

import org.as3commons.logging.ILogger;
import org.as3commons.logging.LoggerFactory;

public class Functions {
	
	//--------------------------------------------------------------------------
	//
	//  Logging
	//
	//--------------------------------------------------------------------------
	
	private static const LOGGER:ILogger = LoggerFactory.getClassLogger(Functions);
	
	//--------------------------------------------------------------------------
	//
	//  Class variables
	//
	//--------------------------------------------------------------------------
	
	public static var LEFT:FunctionContext;
	public static var LOWER_CASE:FunctionContext;
	public static var LTRIM:FunctionContext;
	public static var NORMALIZE_SPACE:FunctionContext;
	public static var RIGHT:FunctionContext;
	public static var ROUND:FunctionContext;
	public static var RTRIM:FunctionContext;
	public static var TRIM:FunctionContext;
	public static var UPPER_CASE:FunctionContext;
	
	//--------------------------------------------------------------------------
	//
	//  Class methods: Initialization
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Forces static initializer to run.
	 */
	public static function initialize():void {
		if (LOWER_CASE == null) {
			
			LOGGER.info("Initializing XPath Extension Functions.");
			
			EvaluationContext.defaultContextNode.addNamespace(new Namespace("fn", "http://www.w3.org/2005/xpath-functions"));
			
			LEFT	 		= new FunctionContext(left, false);
			LOWER_CASE 		= new FunctionContext(lowerCase, false);
			LTRIM			= new FunctionContext(ltrim, false);
			NORMALIZE_SPACE = new FunctionContext(normalizeSpace, false);
			RIGHT			= new FunctionContext(right, false);
			ROUND			= new FunctionContext(round, false);
			RTRIM			= new FunctionContext(rtrim, false);
			TRIM			= new FunctionContext(trim, false);
			UPPER_CASE		= new FunctionContext(upperCase, false);
			
			XPath.CORE_FUNCTIONS.registerFunction(new QualifiedName("fn:left"),				LEFT);
			XPath.CORE_FUNCTIONS.registerFunction(new QualifiedName("fn:lower-case"),		LOWER_CASE);
			XPath.CORE_FUNCTIONS.registerFunction(new QualifiedName("fn:ltrim"),			LTRIM);
			XPath.CORE_FUNCTIONS.registerFunction(new QualifiedName("fn:normalize-space"), 	NORMALIZE_SPACE);
			XPath.CORE_FUNCTIONS.registerFunction(new QualifiedName("fn:right"),			RIGHT);
			XPath.CORE_FUNCTIONS.registerFunction(new QualifiedName("fn:round"),			ROUND);
			XPath.CORE_FUNCTIONS.registerFunction(new QualifiedName("fn:rtrim"),			RTRIM);
			XPath.CORE_FUNCTIONS.registerFunction(new QualifiedName("fn:trim"),				TRIM);
			XPath.CORE_FUNCTIONS.registerFunction(new QualifiedName("fn:upper-case"),		UPPER_CASE);
		}
	}
	
	//--------------------------------------------------------------------------
	//
	//  Class methods: Functions
	//
	//--------------------------------------------------------------------------
	
	private static function left(string:String, length:int):String {
		if (string != null) {
			string = string.substr(0, length);
		}	
		return string;
	}
	
	private static function lowerCase(string:String):String {
		if (string != null && string.length > 0) {
			string = string.toLowerCase();
		}
		return string;
	}
	
	private static function ltrim(string:String):String {
		if (string != null) {
			string = string.replace(/^\s+/, "");
		}
		return string;
	}
	
	private static function normalizeSpace(string:String):String {
		if (string != null) {
			string = rtrim(ltrim(string)).replace(/\s+/g, " ");
		}
		return string;
	}

	private static function right(string:String, length:int):String {
		if (string != null) {
			string = string.substr(string.length - length);
		}	
		return string;
	}
	
	private static function round(value:Number, decimal:int):Number {
		var precision:Number = Math.pow(10, decimal);
		return Math.round(value * precision) / precision;
	}

	private static function rtrim(string:String):String {
		if (string != null) {
			string = string.replace(/\s+$/, "");
		}
		return string;
	}
	
	private static function trim(string:String):String {
		if (string != null) {
			string = ltrim(rtrim(string));
		}
		return string;
	}
	
	private static function upperCase(string:String):String {
		if (string != null && string.length > 0) {
			string = string.toUpperCase();
		}
		return string;
	}
}
}