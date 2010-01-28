package com.watchthosecorners.xpath.ext.functions.exslt
{
import com.watchthosecorners.xpath.XPath;

import mx.utils.StringUtil;

import org.flexunit.Assert;

public class EXSLTFunctionsTest
{
	[BeforeClass]
	public static function initializeClass():void
	{
		EXSLTFunctions.initialize();
	}
	
	[Test]
	public function testRegexMatchPass():void
	{
		var string:String = "Hello, Bob.";
		var pattern:String = "^Hello,";
		var query:String = StringUtil.substitute("regexp:match('{0}', '{1}', 'gi')", string, pattern);
		var match:Object = XPath.evaluate(query, null);
		
		Assert.assertEquals("Strings does not match, 'Hello,'.", "Hello,", match);		
	}
	
	[Test (expects="flexunit.framework.AssertionFailedError")]
	public function testRegexMatchFail():void
	{
		var string:String = "Hello, Bob. Hello.";
		var pattern:String = "Hello";
		var query:String = StringUtil.substitute("regexp:match('{0}', '{1}', 'gi')", string, pattern);
		var match:Object = XPath.evaluate(query, null);
		
		Assert.assertEquals("Strings does not match, 'Hello,'.", "Hello,", match);		
	}
	
	[Test]
	public function testRegexReplacePass():void
	{
		var string:String = "She sells seashells be the seashore.";
		var expected:String = "She sells sandshells be the sandshore.";
		var pattern:String = "sea";
		var replace:String = "sand";
		var query:String = StringUtil.substitute("regexp:replace('{0}', '{1}', 'gi', '{2}')", string, pattern, replace);
		var result:String = XPath.evaluate(query, null);
				
		Assert.assertEquals("Strings do not match.", expected, result);
	}
	
	[Test (expects="flexunit.framework.AssertionFailedError")]
	public function testRegexReplaceFail():void
	{
		var string:String = "She sells seashells be the seashore.";
		var pattern:String = "sea";
		var replace:String = "sand";
		var query:String = StringUtil.substitute("regexp:replace('{0}', '{1}', 'gi', '{2}')", string, pattern, replace);
		var result:String = XPath.evaluate(query, null);
		
		Assert.assertEquals("Strings do match.", string, result);
	}
	
	[Test]
	public function testRegexTestPass():void
	{
		var string:String = "She sells seashells be the seashore.";
		var pattern:String = "sea";
		var query:String = StringUtil.substitute("regexp:test('{0}', '{1}', 'gi')", string, pattern);
		var result:Boolean = XPath.evaluate(query, null);
		
		Assert.assertTrue("Result should be true.", result);
	}
	
	[Test (expects="flexunit.framework.AssertionFailedError")]
	public function testRegexTestFail():void
	{
		var string:String = "She sells seashells be the seashore.";
		var pattern:String = "sea";
		var query:String = StringUtil.substitute("regexp:test('{0}', '{1}', 'gi')", string, pattern);
		var result:Boolean = XPath.evaluate(query, null);
		
		Assert.assertFalse("Result should be false.", result);
	}
}
}