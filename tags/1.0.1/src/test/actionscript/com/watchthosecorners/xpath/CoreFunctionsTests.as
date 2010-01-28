package com.watchthosecorners.xpath
{
import com.watchthosecorners.xpath.fixtures.XMLData;

import flash.utils.getTimer;

import flexunit.framework.TestCase;

import mx.logging.ILogger;
import mx.logging.Log;

public class CoreFunctionsTests extends TestCase
{
	//--------------------------------------------------------------------------
	//
	//  Logging
	//
	//--------------------------------------------------------------------------
	
	private static const LOGGER:ILogger = Log.getLogger("com.watchthosecorners.xpath.XPathCoreFunctionsTests");
	
	//--------------------------------------------------------------------------
	//
	//  Variables
	//
	//--------------------------------------------------------------------------
	
	private var adobe:XML;
	private var feed:XML;
	private var cds:XML;
	private var reg:XML;
	private var menu:XML;
	private var xpath:XPath;
	private var startTime:int;
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */	
	public function CoreFunctionsTests(methodName:String=null)
	{
		super(methodName);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Methods: Configuration
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	override public function setUp():void
	{
		feed = XMLData.adobeBlogsRDF;
		cds = XMLData.cdCatalogXML;
		reg = XMLData.registerHTML;
		menu = XMLData.foodMenuXML;
		adobe = XMLData.adobeBlogsRDF;
		
		EvaluationContext.defaultContextNode.addNamespace(new Namespace("rss", "http://purl.org/rss/1.0/"));
		
		startTime = getTimer();
	}
	
	/**
	 * @private
	 */
	public override function tearDown():void
	{			
		LOGGER.debug("{0}() Execution Time: {1}", methodName, (getTimer() - startTime) / 1000);
		
		feed = null;
		cds = null;
		reg = null;
		menu = null;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Methods: Tests
	//
	//--------------------------------------------------------------------------
	
	public function testLast():void
	{
		// item whose position is 2 less than the last one
		xpath = new XPath("/rdf:RDF/rss:item[position()=last()-2]/rss:title", feed);
		var title:String = xpath.evaluate(feed).toString();
		assertEquals("title should match", "LipSync MX v2", title);
		
		// last item (shortcut syntax)
		xpath = new XPath("/rdf:RDF/rss:item[last()]/rss:title", feed);
		title = xpath.evaluate(feed).toString();
		assertEquals("title should match", "How to Wow with Flash", title);
	}

	public function testCount():void
	{
		xpath = new XPath("count(rdf:RDF/rss:item)", feed);
		var numItems:int = xpath.evaluate(feed);
		assertEquals("should be 15 items", 15, numItems);
		
		// item whose position is the same as the number of children it has in the dublin-core namespace
		// (they all have 4)
		xpath = new XPath("/rdf:RDF/rss:item[count(dc:*)]/rss:title", feed);
		var title:String = xpath.evaluate(feed).toString();
		assertEquals("title should match", "The Best Apollo Information Out There", title);
		
		// items with at least 3 children that contain the word "Flex"
		xpath = new XPath("/rdf:RDF/rss:item[count(child::node()[contains(text(), 'Flex')]) >= 3]", feed);
		var result:NodeSet = xpath.evaluate(feed);
		assertEquals("should have selected 2 items", 2, result.length);
		assertEquals("first item title should match", "Flex Web Services Question", result[0].*::title.toString());
		assertEquals("second item title should match", "Updated Debug Flash Player 7 for Flex 1.5 and Flex Builder 1.5", result[1].*::title.toString());
		
		xpath = new XPath("count(/doesntexist)", feed);
		var num:int = xpath.evaluate(feed);
		assertEquals("testing count() on empty node set", 0, num);
	}
	
	public function testID():void
	{
		var cdData:XML = XMLData.cdCatalogXML;
		xpath = new XPath("id('cd10')/TITLE", cdData);
		var result:NodeSet = xpath.evaluate(cdData);
		assertEquals("title should be Percy Sledge classic", "When a man loves a woman", result.toString());
	}	
	
	public function testPosition():void
	{
		var xpath:XPath = new XPath("/rdf:RDF/rss:item[position()=8]/rss:title", feed);
		var title:String = xpath.evaluate(feed).toString();
		assertEquals("title should match", "Daniel Dura on Apollo", title);
		
		var paths:Array = [
						"breakfast-menu/food[2]/name",
						"breakfast-menu/food[7-5]/name",
						"breakfast-menu/food[(7-5)]/name",
						"breakfast-menu/food[(2+2)-(5 *3-13)]/name",
						"breakfast-menu/food[position() = 2]/name",
						"breakfast-menu/food[position()=2]/name",
						"breakfast-menu/food[last()-3]/name"];
		
		var result:NodeSet;
		var n:int = paths.length;
		var expected:String = menu.food.name.toXMLString();
		
		for(var i:int=0; i<n; i++)
		{
			result = XPath.evaluate(paths[i], menu);
			assertEquals(i+" should be only one element", 1, result.length);
			assertEquals(i+" check name", "Strawberry Belgian Waffles", result.toString());
			assertEquals(i+" should be second element", menu.food.name[1], result[0]);
		}
	}
	
	public function testNamesWithNamespaces():void
	{
		xpath = new XPath("local-name(/rdf:RDF/child::node()[2])", feed);
		var localName:String = xpath.evaluate(feed);
		assertEquals("localName should match", "item", localName);
		
		xpath = new XPath("namespace-uri(/rdf:RDF/child::node()[2])", feed);
		var uri:String = xpath.evaluate(feed);
		assertEquals("uri should match", "http://purl.org/rss/1.0/", uri);
		
		xpath = new XPath("name(/rdf:RDF/child::node()[2])", feed);
		var name:String = xpath.evaluate(feed);
		assertEquals("name should match", "http://purl.org/rss/1.0/:item", name);
	}
	
	public function testNamesWithoutNamespaces():void
	{
		xpath = new XPath("local-name(CATALOG/CD[1])", cds);
		var localName:String = xpath.evaluate(cds);
		assertEquals("localName should match", "CD", localName);
		
		xpath = new XPath("namespace-uri(CATALOG/CD[1])", cds);
		var uri:String = xpath.evaluate(cds);
		assertEquals("uri should match", "", uri);
		
		xpath = new XPath("name(CATALOG/CD[1])", cds);
		var name:String = xpath.evaluate(cds);
		assertEquals("name should match", "CD", name);
	}
	
	public function testString():void
	{
		xpath = new XPath("string(CATALOG/CD[(position() > 2) and (position() < 7)]/ARTIST)", cds);
		assertEquals("string() should only act on the first node in the set", "Dolly Parton", xpath.evaluate(cds));
		
		xpath = new XPath("string(CATALOG[position() > last()])", cds);
		assertEquals("empty node set should become ''", "", xpath.evaluate(cds));
		
		xpath = new XPath("string(count(CATALOG/CD))", cds);
		assertEquals("string() should convert a number to a string", "27", xpath.evaluate(cds));
		assertTrue("string() should convert a number to a string",  xpath.evaluate(cds) is String);
		
		xpath = new XPath("string(3 = 3)");
		assertEquals("string() should convert a true to 'true'", "true", xpath.evaluate(null));
		xpath = new XPath("string(1 = 3)");
		assertEquals("string() should convert a false to 'false'", "false", xpath.evaluate(null));
	}
	
	public function testConcat():void
	{
		xpath = new XPath("concat('a','b')");
		assertEquals("should concat into one string", "ab", xpath.evaluate(null));
		xpath = new XPath("concat('a','b', '')");
		assertEquals("should concat into one string", "ab", xpath.evaluate(null));
		xpath = new XPath("concat('','b')");
		assertEquals("should concat into one string", "b", xpath.evaluate(null));
		
		xpath = new XPath("concat(CATALOG/CD[1]/COUNTRY, CATALOG/CD[2]/COUNTRY, CATALOG/CD[3]/COUNTRY)", cds);
		assertEquals("should concat into one string", "USAUKUSA", xpath.evaluate(cds));
		
	}
	
	public function testStartsWith():void
	{
		xpath = new XPath("starts-with('a','b')");
		assertEquals("should be false", false, xpath.evaluate(null));
		
		xpath = new XPath("starts-with('a','a')");
		assertEquals("should be true", true, xpath.evaluate(null));
		
		xpath = new XPath("starts-with('hello','hell')");
		assertEquals("should be true", true, xpath.evaluate(null));
		
		xpath = new XPath("starts-with('hello','ello')");
		assertEquals("should be false", false, xpath.evaluate(null));
		
		xpath = new XPath("starts-with('ello','hello')");
		assertEquals("should be false", false, xpath.evaluate(null));
		
		xpath = new XPath("starts-with('hell','hello')");
		assertEquals("should be false", false, xpath.evaluate(null));
		
		xpath = new XPath("starts-with('h','H')");
		assertEquals("should be false", false, xpath.evaluate(null));
	}

	public function testContains():void
	{
		xpath = new XPath("contains('a','b')");
		assertEquals(xpath.source + " should be false.", false, xpath.evaluate(null));
		
		xpath = new XPath("contains('a','a')");
		assertEquals(xpath.source + " should be true", true, xpath.evaluate(null));
		
		xpath = new XPath("contains('abc','a')");
		assertEquals(xpath.source + " should be true", true, xpath.evaluate(null));
		
		xpath = new XPath("contains('xzyabc','a')");
		assertEquals(xpath.source + " should be true", true, xpath.evaluate(null));
		
		xpath = new XPath("contains('xzya','a')");
		assertEquals(xpath.source + " should be true", true, xpath.evaluate(null));
		
		xpath = new XPath("contains('xzybc','a')");
		assertEquals(xpath.source + " should be false", false, xpath.evaluate(null));
		
		xpath = new XPath("contains('The rain in Spain falls mainly on the plain','in fal')");
		assertEquals(xpath.source + " should be true", true, xpath.evaluate(null));
		
		xpath = new XPath("contains('The rain in Spain falls mainly on the plain','spain')");
		assertEquals(xpath.source + " should be false because Spain is upper-case", false, xpath.evaluate(null));
		
		xpath = new XPath("contains(/CATALOG, 'Luciano Pavarotti')", cds);
		assertEquals(xpath.source + " should be true", true, xpath.evaluate(cds));
		
		xpath = new XPath("contains(/CATALOG, 'Flat Buoy Slimey')", cds);
		assertEquals(xpath.source + " should be false", false, xpath.evaluate(cds));		
	}
	
	public function testSubstringBefore():void
	{
		// [From spec] For example, substring-before("1999/04/01","/") returns 1999.
		xpath = new XPath("substring-before('1999/04/01','/')");
		assertEquals("result should match example in spec", "1999", xpath.evaluate(null));
		
		xpath = new XPath("substring-before(id('cd6')/TITLE, ' only')", cds);
		assertEquals("only first two words of 'One night only'", "One night", xpath.evaluate(cds));
	}
	
	public function testSubstringAfter():void
	{
		// [From spec] For example, substring-after("1999/04/01","/") returns 04/01, 
		xpath = new XPath("substring-after('1999/04/01','/')");
		assertEquals("result should match example in spec", "04/01", xpath.evaluate(null));
		// and substring-after("1999/04/01","19") returns 99/04/01.
		xpath = new XPath('substring-after("1999/04/01","19")');
		assertEquals("result should match example in spec", "99/04/01", xpath.evaluate(null));
		
		xpath = new XPath('substring-after("Peter Piper picked a peck of pickled pepper","pepper")');
		assertEquals("result should be empty", "", xpath.evaluate(null));
		
	}
	
	public function testSubstring():void
	{
		xpath = new XPath("substring('12345', 2)");
		assertEquals("result should match example in spec", "2345", xpath.evaluate(null));
		
		xpath = new XPath("substring('12345', 2, 3)");
		assertEquals("result should match example in spec", "234", xpath.evaluate(null));
		
		// Edge Cases
		
		xpath = new XPath("substring('12345', 1.5, 2.6)");
		assertEquals("result should match example in spec", "234", xpath.evaluate(null));
		
		xpath = new XPath("substring('12345', 0, 3)");
		assertEquals("result should match example in spec", "12", xpath.evaluate(null));
		
		xpath = new XPath("substring('12345', 0 div 0)");
		assertEquals("result should match example in spec", "", xpath.evaluate(null));
		
		xpath = new XPath("substring('12345', 1, 0 div 0)");
		assertEquals("result should match example in spec", "", xpath.evaluate(null));
		
		xpath = new XPath("substring('12345', -42, 1 div 0)");
		assertEquals("result should match example in spec", "12345", xpath.evaluate(null));
		
		xpath = new XPath("substring('12345', -1 div 0, 1 div 0)");
		assertEquals("result should match example in spec", "", xpath.evaluate(null));
	}
	
	
	public function testStringLength():void
	{
		var qname:QualifiedName = new QualifiedName("str");
		var context:EvaluationContext = new EvaluationContext(menu);

		xpath = new XPath("string-length($str)");
		context.setVariable(qname, "");
		assertEquals("0. Length should be correct", 0, xpath.evaluate(context));
		
		context.setVariable(qname, "12345");
		assertEquals("1. Length should be correct", 5, xpath.evaluate(context));
		
		context.setVariable(qname, 3.12345);
		assertEquals("2. Length should be correct", 7, xpath.evaluate(context));
		
		xpath = new XPath("//food/name[string-length() = string-length('French Toast')]");
		assertEquals("3. Testing no-args", 'French Toast', xpath.evaluate(context));
	}
	
	public function testNormalizeSpace():void
	{
		var result:String;
		xpath = new XPath("normalize-space(' \t\n I had      my\r\r\r\n spaces  removed        \n\t\n')");
		result = xpath.evaluate(null);
		assertTrue("0 result should be string", result is String);
		assertEquals("1 result should have spaces removed",
				"I had my spaces removed", result); 
	
		xpath = new XPath("normalize-space(//div[@class='Hit' and contains(h3, 'Apollo')][1]/div[@class='Abstract'])", reg);
		result = xpath.evaluate(reg);
		assertTrue("1 result should be string", result is String);
		assertEquals("1 result should have spaces removed",
				"There was a bit of a buzz in the air on Monday when Adobe rolled out " + 
				"the first public alpha release of its Apollo desktop internet application " + 
				"client – along with a whole truckload of developer tools and documentation. " + 
				"Apollo is an interesting proposition, a platform that mixes Flash (though you " + 
				"do need to use code that's …", result);
	}
	
	public function testTranslate():void
	{
		var x:XML = <AAA > <BBB>bbb </BBB>  <CCC>ccc </CCC> </AAA>;
		var qname1:QualifiedName = new QualifiedName("a1");
		var qname2:QualifiedName = new QualifiedName("a2");
		var context:EvaluationContext = new EvaluationContext(x);
		
		// testing to example at http://www.zvon.org/xxl/XSLTreference/OutputExamples/example_2_57_frame.html
		xpath = new XPath("translate('ABCABCABC',$a1,$a2)");
		
		context.setVariable(qname1, 'AB');
		context.setVariable(qname2, 'XY');
		assertEquals("1", "XYCXYCXYC", xpath.evaluate(context));
		
		context.setVariable(qname1, 'ABC');
		context.setVariable(qname2, 'XY');
		assertEquals("2", "XYXYXY", xpath.evaluate(context));
		
		context.setVariable(qname1, 'AB');
		context.setVariable(qname2, 'XYZ');
		assertEquals("3", "XYCXYCXYC", xpath.evaluate(context));
		
		context.setVariable(qname1, 'ABC');
		context.setVariable(qname2, 'XXX');
		assertEquals("4", "XXXXXXXXX", xpath.evaluate(context));
		
		// From http://developer.mozilla.org/en/docs/XPath:Functions:translate
		xpath = new XPath("translate('The quick brown fox.', 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')");
		assertEquals("5", "THE QUICK BROWN FOX.", xpath.evaluate(null));
		
		xpath = new XPath("translate('The quick brown fox.', 'brown', 'red')");
		assertEquals("5", "The quick red fdx.", xpath.evaluate(null));
		
		xpath = new XPath("translate('--aaa--', 'abc-', 'ABC')");
		assertEquals("6", "AAA", xpath.evaluate(null));
	}
	
	
	public function testBools():void
	{
		xpath = new XPath("true()");
		assertEquals("1", true, xpath.evaluate(null));
		xpath = new XPath("false()");
		assertEquals("2", false, xpath.evaluate(null));
		xpath = new XPath("false()=true()");
		assertEquals("3", false, xpath.evaluate(null));
		xpath = new XPath("not(true())");
		assertEquals("4", false, xpath.evaluate(null));
		xpath = new XPath("not(false())");
		assertEquals("5", true, xpath.evaluate(null));
		
		var values:Array = 	[1,		0,		-1,		NaN, 	2,		{},		"",		" ", 	"true", "false",true, false];
		var results:Array = [true,	false,	true, 	false,	true,	true,	false,	true, 	true, 	true, 	true, false];
		var context:EvaluationContext = new EvaluationContext(cds);
		context.setVariable(new QualifiedName("test"), null);
		
		xpath = new XPath("boolean($test)");
		for(var i:int = 0; i < values.length; i++)
		{
			context.setVariable(new QualifiedName("test"), values[i]);
			assertEquals("a"+i, results[i], xpath.evaluate(context));
		}
		
		xpath = new XPath("boolean(//a/b/c)", cds);
		assertFalse("empty node set should be false", xpath.evaluate(cds));
		
		xpath = new XPath("boolean(//CD)", cds);
		assertTrue("non-empty node set should be true", xpath.evaluate(cds));
	}
	
	public function testNamespaceURI():void
	{
		xpath = new XPath("namespace-uri(/)");
		var result:String = xpath.evaluate(feed);
		var expected:String = Namespace(feed.namespace()).uri;
		
		assertEquals("Select Namespace URI.", expected, result);
	}
}
}