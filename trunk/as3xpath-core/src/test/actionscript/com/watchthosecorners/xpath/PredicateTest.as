package com.watchthosecorners.xpath
{
import com.watchthosecorners.xpath.fixtures.XMLData;

import flexunit.framework.Assert;

public class PredicateTest
{
	// Reference declaration for class to test
	private var classToTestRef : com.watchthosecorners.xpath.Predicate;
	
	public function PredicateTest()
	{
	}
	
	[Test]
	public function testFilter():void
	{
		var xml:XML = XMLData.cdCatalogXML;
		var result:String = new XPath("/CATALOG/CD[@id = 'cd6']/TITLE").evaluate(xml);
		
		Assert.assertEquals("One night only", result);
	}
}
}