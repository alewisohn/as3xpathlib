package com.watchthosecorners.xpath
{
import flexunit.framework.Assert;

public class QualifiedNameTest
{
	private var node:XML = <name xmlns:xf="http://www.w3.org/2002/xforms"/>;
	
	private var qualifiedName:QualifiedName;
	
	public function QualifiedNameTest()
	{
	}
	
	[Before]
	public function setUp():void
	{
		try
		{
			qualifiedName = new QualifiedName("xf:instance", node);
		}
		catch(e:Error)
		{
			trace(e);
		}
	}
	
	[Test]
	public function testEquals():void
	{
		Assert.assertTrue(qualifiedName.equals(new QualifiedName("xf:instance", node)));
	}
	
	[Test]
	public function testGet_localName():void
	{
		Assert.assertEquals("instance", qualifiedName.localName);
	}
	
	[Test]
	public function testMatch():void
	{
		Assert.assertTrue(qualifiedName.match(<xf:instance xmlns:xf="http://www.w3.org/2002/xforms"/>));
	}
	
	[Test]
	public function testGet_namespaceURI():void
	{
		Assert.assertEquals("http://www.w3.org/2002/xforms", qualifiedName.namespaceURI);
	}
	
	[Test]
	public function testQualifiedName():void
	{
		Assert.assertNotNull(new QualifiedName("xf:instance", node));
	}
	
	[Test(expects="com.watchthosecorners.xpath.errors.InvalidPrefixError")]
	public function testQualifiedNameFail():void
	{
		Assert.assertNotNull(new QualifiedName("xf:instance"));
	}
	
	[Test]
	public function testToQName():void
	{
		Assert.assertEquals(new QName("http://www.w3.org/2002/xforms", "instance"), qualifiedName.toQName(node));
	}
	
	[Test]
	public function testToString():void
	{
		Assert.assertEquals("http://www.w3.org/2002/xforms:instance", qualifiedName.toString());
	}
}
}