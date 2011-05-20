package com.watchthosecorners.xpath.ext.functions.xpath {
import com.watchthosecorners.xpath.XPath;

import org.flexunit.Assert;

public class FunctionsTest {		
	
	[Before]
	public function setUp():void {
	}
	
	[After]
	public function tearDown():void {
	}
	
	[BeforeClass]
	public static function setUpBeforeClass():void {
		Functions.initialize();
	}
	
	[AfterClass]
	public static function tearDownAfterClass():void {
	}
	
	[Test]
	public function testInteger():void {
		Assert.assertEquals(1, XPath.evaluate("fn:integer(1.5)", null));
		Assert.assertEquals(-1, XPath.evaluate("fn:integer(-1.5)", null));
		Assert.assertEquals(10, XPath.evaluate("fn:integer(10.35)", null));
		Assert.assertEquals(-10, XPath.evaluate("fn:integer(-10.35)", null));
	}
	
	[Test]
	public function testLeft():void {
		Assert.assertEquals("browns", XPath.evaluate("fn:left('brownsrule', 6)", null));
		Assert.assertEquals("jets", XPath.evaluate("fn:left('jetsrule', 4)", null));
	}
	
	[Test]
	public function testLowerCase():void {
		Assert.assertEquals("text", XPath.evaluate("fn:lower-case('TEXT')", null));
		Assert.assertEquals("text", XPath.evaluate("fn:lower-case('tExT')", null));
	}
	
	[Test]
	public function testLtrim():void {
		Assert.assertEquals("text", XPath.evaluate("fn:ltrim('    text')", null));
		Assert.assertEquals("text", XPath.evaluate("fn:ltrim(' text')", null));
	}
	
	[Test]
	public function testNormalizeSpace():void {
		Assert.assertEquals("The quick brown fox jumped over the lazy dog.", XPath.evaluate("fn:normalize-space('    The quick   brown fox jumped over    the lazy dog. ')", null));
	}
	
	[Test]
	public function testRight():void {
		Assert.assertEquals("nj", XPath.evaluate("fn:right('ihatenj', 2)", null));
		Assert.assertEquals("britania", XPath.evaluate("fn:right('rulebritania', 8)", null));
	}
	
	[Test]
	public function testRound():void {
		Assert.assertEquals(10.3, XPath.evaluate("fn:round(10.25, 1)", null));
		Assert.assertEquals(10.2, XPath.evaluate("fn:round(10.24, 1)", null));
		Assert.assertEquals(101000, XPath.evaluate("fn:round(100500, -3)", null));
		Assert.assertEquals(100000, XPath.evaluate("fn:round(100499, -3)", null));
	}
	
	[Test]
	public function testRtrim():void {
		Assert.assertEquals("text", XPath.evaluate("fn:rtrim('text   ')", null));
		Assert.assertEquals("text", XPath.evaluate("fn:rtrim('text ')", null));
	}
	
	[Test]
	public function testTrim():void {
		Assert.assertEquals("text word stuff", XPath.evaluate("fn:trim('  text word stuff  ')", null));
		Assert.assertEquals("text word stuff", XPath.evaluate("fn:trim(' text word stuff ')", null));
		Assert.assertEquals("text word stuff", XPath.evaluate("fn:trim(' text word stuff   ')", null));
		Assert.assertEquals("text word stuff", XPath.evaluate("fn:trim('   text word stuff ')", null));
	}
	
	[Test]
	public function testUpperCase():void {
		Assert.assertEquals("TEXT", XPath.evaluate("fn:upper-case('text')", null));
		Assert.assertEquals("TEXT", XPath.evaluate("fn:upper-case('tExT')", null));
	}
}
}