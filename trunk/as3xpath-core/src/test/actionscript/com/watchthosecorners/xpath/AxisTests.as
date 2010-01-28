package com.watchthosecorners.xpath
{
import com.watchthosecorners.xpath.fixtures.XMLData;

import flash.utils.getTimer;

import flexunit.framework.TestCase;

import mx.logging.ILogger;
import mx.logging.Log;

public class AxisTests extends TestCase
{
	//--------------------------------------------------------------------------
	//
	//  Logging
	//
	//--------------------------------------------------------------------------
	
	private static const LOGGER:ILogger = Log.getLogger("com.watchthosecorners.xpath.XPathAxisTests");
	
	//--------------------------------------------------------------------------
	//
	//  Variables
	//
	//--------------------------------------------------------------------------
	
	private var cds:XML;
	private var menu:XML;
	private var xhtml:XML;
	private var register:XML;
	private var rdf:XML;
	private var xpath:XPath;
	private var result:*;
	private var startTime:uint;

	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */	
	public function AxisTests(methodName:String=null)
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
		cds = XMLData.cdCatalogXML;
		menu = XMLData.foodMenuXML;
		xhtml = XMLData.adobeHomeXHTML;
		rdf = XMLData.adobeBlogsRDF;
		register = XMLData.registerHTML;
		startTime = getTimer();
	}
	
	/**
	 * @private
	 */
	public override function tearDown():void
	{	
		LOGGER.debug("{0}() Execution Time: {1}", methodName, (getTimer() - startTime) / 1000);
				
		cds = null;
		menu = null;
		xhtml = null;
		rdf = null;
		register = null;
		xpath = null;
		result = null;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Methods: Tests
	//
	//--------------------------------------------------------------------------
	
	public function testAncestor():void
	{
		var expected:NodeSet = createResultSet(menu.food.name.(text() == "Belgian Waffles").parent());
		xpath = new XPath("//name[text() = 'Belgian Waffles']/ancestor::food");
		result = xpath.evaluate(menu);
		assertTrue(xpath.source + " should select one node.", 1, result.length);
		assertEquals(xpath.source + " should select the following.", expected.toString(), result.toString());
		
		checkXMLUnaffected();
	}
	
	public function testAncestorOrSelf():void
	{
		var expected:NodeSet = createResultSet(menu.food.name.(text() == "Strawberry Belgian Waffles").parent());
		xpath = new XPath("//name[text() = 'Strawberry Belgian Waffles']/ancestor-or-self::food");
		result = xpath.evaluate(menu);
		assertTrue(xpath.source + " should select one node.", 1, result.length);
		assertEquals(xpath.source + " should select the following.", expected.toString(), result.toString());
		
		checkXMLUnaffected();
	}
	
	public function testAttribute():void
	{
		xpath = new XPath("CATALOG/CD[1]/attribute::id");
		assertEquals("1 check id att", "cd1", xpath.evaluate(cds));
		
		xpath = new XPath("CATALOG/CD[1]/@id");
		assertEquals("2 check id att", "cd1", xpath.evaluate(cds));
		
		checkXMLUnaffected();
	}
	
	public function testChild():void
	{
		result = XPath.evaluate("/breakfast-menu/child::*/name", menu);
		
		var expected:NodeSet = createResultSet(cds.CD);
		xpath = new XPath("/CATALOG/CD");
		result = xpath.evaluate(cds);
		
		assertEquals(xpath.source + " should select 27 nodes.", 27, result.length);	
		assertEquals(xpath.source + " should equal expected.", expected.toString(), result.toString());
		assertEquals(xpath.source + " should equal expected.", expected.toString(), XPath.evaluate("/child::CATALOG/child::CD", cds).toString());
	}
	
	public function testDescendant():void
	{
		var xpath:XPath = new XPath("/descendant::CD[1]/attribute::id");
		var result:* = xpath.evaluate(cds);
		assertEquals("check id att for " + xpath.source, "cd1", result.toString());
		
		xpath = new XPath("/descendant::*[1]/attribute::id");
		result = xpath.evaluate(cds);
		assertEquals("check id att for " + xpath.source, "cd1", result.toString());

		checkXMLUnaffected();
	}
	
	public function testDescendantOrSelf():void
	{
		var xpath:XPath = new XPath("//CD[1]/attribute::id");
		var result:* = xpath.evaluate(cds);
		assertEquals("check id att for " + xpath.source, "cd1", result.toString());
		
		xpath = new XPath("//*[1]/attribute::id");
		result = xpath.evaluate(cds);
		assertEquals("check id att for " + xpath.source, "cd1", result.toString());
		
		checkXMLUnaffected();
	}
	
	public function testFollowing():void
	{
		var tree:XML =	<AAA>
				          <BBB>
				               <CCC/>
				               <ZZZ>
				                    <DDD/>
				                    <DDD>
				                         <EEE/>
				                    </DDD>
				               </ZZZ>
				               <FFF>
				                    <GGG/>
				               </FFF>
				          </BBB>
				          <XXX>
				               <DDD>
				                    <EEE/>
				                    <DDD/>
				                    <CCC/>
				                    <FFF/>
				                    <FFF>
				                         <GGG/>
				                    </FFF>
				               </DDD>
				          </XXX>
				          <CCC>
				               <DDD/>
				          </CCC>
			     		</AAA>;

		var expected:NodeSet = createResultSet(tree.CCC);
		xpath = new XPath("/AAA/XXX/following::*");
		result = xpath.evaluate(tree);
		assertEquals(xpath.source + " should equal expected.", expected.toString(), result.toString());
	
		expected = createResultSet(tree.BBB.FFF + tree.XXX + tree.CCC);
		xpath = new XPath("//ZZZ/following::*");
		result = xpath.evaluate(tree);
		assertEquals(xpath.source + " should equal expected.", expected.toString(), result.toString());
	}
	
	public function testFollowingSibling():void
	{
		var expected:NodeSet = createResultSet(menu.food.(childIndex() > 0)); 
		var xpath:XPath = new XPath("breakfast-menu/food/following-sibling::food");
		var result:* = xpath.evaluate(menu);
		assertEquals(xpath.source + " should select four nodes.", 4, result.length);
		assertEquals(xpath.source + " should match the expected result.", expected.toString(), result.toString());
	}
	
	public function testNamespace():void
	{
		var rdfURI:String = "http://www.w3.org/1999/02/22-rdf-syntax-ns#";
		var defualtURI:String = "http://purl.org/rss/1.0/";
		
		var xpath:XPath = new XPath("/*/namespace::node()[name() = 'rdf']");
		var result:* = xpath.evaluate(rdf);
		
		assertEquals(xpath.source + " should select 1 node.", 1, result.length);
		assertEquals(xpath.source + " should equal.", rdfURI, result[0].toString());
		
		xpath = new XPath("/*/namespace::node()[name() = '']");
		result = xpath.evaluate(rdf);
		
		assertEquals(xpath.source + " should select 1 node.", 1, result.length);
		assertEquals(xpath.source + " should equal.", defualtURI, result[0].toString());
	}
	
	public function testParent():void
	{			
		var startNode:XML = menu.food[3].price[0];
		var resultNode:XML = XPath.evaluate("../self::node()", startNode)[0];
		assertEquals("Should be parent of the node we started with", startNode.parent(), resultNode);
		
		resultNode = XPath.evaluate("parent::node()", startNode)[0];
		assertEquals("Should be parent of the node we started with", startNode.parent(), resultNode);
		
		checkXMLUnaffected();
	}
	
	public function testPreceding():void
	{
		var tree:XML =	<AAA>
				          <BBB>
				               <CCC/>
				               <ZZZ>
				                    <DDD/>
				               </ZZZ>
				          </BBB>
				          <XXX>
				               <DDD>
				                    <EEE/>
				                    <DDD/>
				                    <CCC/>
				                    <FFF/>
				                    <FFF>
				                         <GGG/>
				                    </FFF>
				               </DDD>
				          </XXX>
				          <CCC>
				               <DDD/>
				          </CCC>
				     </AAA>;
			     		
		var expected:NodeSet = createResultSet(tree.BBB + tree.XXX.DDD.children().(childIndex() < 4));
		var xpath:XPath = new XPath("//GGG/preceding::*");
		var result:NodeSet = xpath.evaluate(tree);
		assertEquals(xpath.source + " should equal expected.", expected.toString(), result.toString());
		
		expected = createResultSet(tree.BBB);
		xpath = new XPath("/AAA/XXX/preceding::*");
		result = xpath.evaluate(tree);
		assertEquals(xpath.source + " should equal expected.", expected.toString(), result.toString());
		
	}
	
	public function testPrecedingSibling():void
	{
		var expected:NodeSet = createResultSet(menu.food.(childIndex() == 0)); 
		var xpath:XPath = new XPath("breakfast-menu/food[2]/preceding-sibling::food");
		var result:* = xpath.evaluate(menu);
		assertEquals(xpath.source + " should select one node.", 1, result.length);
		assertEquals(xpath.source + " should match the expected result.", expected.toString(), result.toString());
	}
	
	public function testSelf():void
	{
		var tree:XML =	<AAA>
				          <BBB>
				               <CCC/>
				               <ZZZ>
				                    <DDD/>
				               </ZZZ>
				          </BBB>
				          <XXX>
				               <DDD>
				                    <EEE/>
				                    <DDD/>
				                    <CCC/>
				                    <FFF/>
				                    <FFF>
				                         <GGG/>
				                    </FFF>
				               </DDD>
				          </XXX>
				          <CCC>
				               <DDD/>
				          </CCC>
				     </AAA>;
			     		
		var expected:NodeSet = createResultSet(tree.BBB.ZZZ);
		var xpath:XPath = new XPath("//ZZZ/self::*");
		var result:NodeSet = xpath.evaluate(tree);
		assertEquals(xpath.source + " should equal expected.", expected.toString(), result.toString());
		
		xpath = new XPath("//ZZZ/.");
		result = xpath.evaluate(tree);
		assertEquals(xpath.source + " should equal expected.", expected.toString(), result.toString());
		
		expected = createResultSet(tree);
		xpath = new XPath(".");
		result = xpath.evaluate(tree);
		assertEquals(xpath.source + " should equal expected.", expected.toString(), result.toString());
	}
	
	//--------------------------------------------------------------------------
	//
	//  Methods: Others
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Axis names are not reserved words, so an Axis name can also be an NCName.
	 * This test checks that /foo/self is a valid expression and is equivalent
	 * to /foo/child::self not /foo/self::*.
	 */
	public function testAxisNamesCanBeNCNames():void
	{
		var data:XML = <foo><self>hello</self></foo>;
		var xpath:XPath = new XPath("/foo/self");
		var result:* = xpath.evaluate(data);
		
		assertEquals("Axis names should be allowed as NCNames if the context is right",
				result.toString(), "hello");
	}
	
	public function testSimpleSteps():void
	{
		// All of these queries should have the same results.
		var paths:Array = ["breakfast-menu/food/name",
						"/breakfast-menu/food/name",
						"/breakfast-menu/food//name",
						"breakfast-menu//name",
						"/breakfast-menu//name",
						"//food/name",
						"//food//name",
						"//name",
						"/child::breakfast-menu/child::food/child::name",
						"/breakfast-menu/food/parent::node()/food/name",
						"/breakfast-menu/food/../food/name",
						"descendant::breakfast-menu/food/name",
						"descendant-or-self::node()/name[local-name(.)='name']",
						"/descendant-or-self::node()/name[string(local-name(.))='name']",
						"/descendant-or-self::node()/name[local-name(../child::node())='name']",
						"//*/name",
						"*//name",
						"*/food/name",
						"/*/*/name"
						];
						
		var result:NodeSet;
		var n:int = paths.length;
		var expected:NodeSet = createResultSet(menu.food.name);

		for(var i:int=0; i<n; i++)
		{
			result = XPath.evaluate(paths[i], menu);
			assertTrue(paths[i]+" result should be NodeSet", result is NodeSet);
			assertEquals(paths[i]+" should select 5 items", 5, result.length);
			assertEquals(paths[i]+" should select a <name> node", "name", result[0].localName());
			assertEquals(paths[i]+" should match the expected result", expected.toString(), result.toString());
		}
		checkXMLUnaffected();
	}
	
	//--------------------------------------------------------------------------
	//
	//  Methods: Helpers
	//
	//--------------------------------------------------------------------------
		
	private function checkXMLUnaffected():void
	{
		assertEquals("test should not change the XML data", XMLData.adobeBlogsRDF.toXMLString(), rdf.toXMLString());
		assertEquals("test should not change the XML data", XMLData.adobeHomeXHTML.toXMLString(), xhtml.toXMLString());
		assertEquals("test should not change the XML data", XMLData.cdCatalogXML.toXMLString(), cds.toXMLString());
		assertEquals("test should not change the XML data", XMLData.foodMenuXML.toXMLString(), menu.toXMLString());
		assertEquals("test should not change the XML data", XMLData.registerHTML.toXMLString(), register.toXMLString());
	}
	
	private function createResultSet(nodes:Object):NodeSet
	{
		return new NodeSet(nodes);
	}
}
}