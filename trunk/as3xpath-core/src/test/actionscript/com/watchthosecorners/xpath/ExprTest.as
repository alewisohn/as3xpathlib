package com.watchthosecorners.xpath
{
import com.watchthosecorners.xpath.fixtures.XMLData;

import flash.utils.getTimer;

import flexunit.framework.TestCase;

import mx.logging.ILogger;
import mx.logging.Log;

public class ExprTest extends TestCase
{
	//--------------------------------------------------------------------------
	//
	//  Logging
	//
	//--------------------------------------------------------------------------
	
	private static const LOGGER:ILogger = Log.getLogger("com.watchthosecorners.xpath.XPathExprTests");
	
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
	private var startTime:int;
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */	
	public function ExprTest(methodName:String=null)
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
	}
	
	//--------------------------------------------------------------------------
	//
	//  Methods: Tests
	//
	//--------------------------------------------------------------------------
	
	/**
	 * When using an absolute path node selections should be made from the root
	 * of the document.
	 */
	public function testAbsolutePathFromChildStartNode():void
	{
		var xpath:XPath = new XPath( "/CATALOG/CD[1]/@id");
		var child:XML = cds.CD[3].COUNTRY[0];
		assertEquals("sanity check", "cd1", xpath.evaluate(cds));
		assertEquals("results should be the same because it's absolute", "cd1", xpath.evaluate(child));
		checkXMLUnaffected();
	}
	
	/**
	 * Test the existence of attributes.
	 */
	public function testAttributeExistence():void
	{
		var xpath:XPath = new XPath("count(xhtml:html//xhtml:img[@alt='' or string-length(@alt)>0])");
		var numImgWithAlt:int = xpath.evaluate(register);
		assertEquals("Reference check for number of alt tags", 6, numImgWithAlt);
		
		xpath = new XPath("count(xhtml:html//xhtml:img[@alt=''])");
		var numImgWithEmptyAlt:int = xpath.evaluate(register);
		assertEquals("Reference check for number of empty alt tags", 4, numImgWithEmptyAlt);
		
		xpath = new XPath("count(xhtml:html//xhtml:img[@alt])");
		assertEquals("Num images with alt attribute should be "+numImgWithAlt, numImgWithAlt, xpath.evaluate(register));
		
		xpath = new XPath("count(xhtml:html//xhtml:img[@alt and string-length(@alt)=0])");
		assertEquals("Num images with empty alt attribute should be "+numImgWithEmptyAlt, numImgWithEmptyAlt, xpath.evaluate(register));
		
		checkXMLUnaffected();
	}
	
	/**
	 * Parsing of Compound Expression.
	 */ 
	public function testCompoundExpression():void
	{
		var path:String = "//name[1]/text() = 'Belgian Waffles' and //name[2]/text() = 'Strawberry Belgian Waffles' and //name[5]/text() = 'Homestyle Breakfast'";
		var xpath:XPath = new XPath(path);
		var result:Boolean = xpath.evaluate(menu);
		
		assertTrue(xpath.source + " should be true.", true, result);
	}
		
	/**
	 * Select Nodes and Apply Filter
	 */
	public function testFilterExpr():void
	{
		var selectSecondNode:Function = function(context:EvaluationContext, nodeSet:NodeSet):NodeSet
		{
			if(context.position == 2)
			{
				return new NodeSet(nodeSet[0]);
			}
			else
			{
				return new NodeSet();
			}
		}
		
		var secondNode:FunctionContext = new FunctionContext(selectSecondNode, true);
		
		var context:EvaluationContext = new EvaluationContext(menu);
		context.registerFunction(new QualifiedName("secondNode"), secondNode);
		
		var xpath:XPath = new XPath( "breakfast-menu/food[secondNode(.)[1]=.]/name");
		
		var result:NodeSet = xpath.evaluate(context);
		assertEquals("only select one node", 1, result.length);
		assertEquals("check name", "Strawberry Belgian Waffles", result.toString());
		
		checkXMLUnaffected();
	}
	
	/**
	 * Numeric Literals.
	 */
	public function testNumberExpression():void
	{
		var xpath:XPath = new XPath("1");
		var result:* = xpath.evaluate(null);
		assertEquals("1", 1, result);
		
		xpath = new XPath("2");
		result = xpath.evaluate(null);
		assertEquals("2", 2, result);
		
		xpath = new XPath("0");
		result = xpath.evaluate(null);
		assertEquals("0", 0, result);
		
		xpath = new XPath("-0");
		result = xpath.evaluate(null);
		assertEquals("-0", 0, result);
		
		xpath = new XPath("1.0");
		result = xpath.evaluate(null);
		assertEquals("1.0", 1, result);
		
		xpath = new XPath("0.1");
		result = xpath.evaluate(null);
		assertEquals("0.1", 0.1, result);
		
		xpath = new XPath("-2");
		result = xpath.evaluate(null);
		assertEquals("-2", -2, result);
		
		xpath = new XPath("0.0000001");
		result = xpath.evaluate(null);
		assertEquals("0.0000001", 0.0000001, result);
		
		xpath = new XPath("29.99");
		result = xpath.evaluate(null);
		assertEquals("29.99", 29.99, result);
	}
	
	/**
	 * Union Expression.
	 */
	public function testUnionExpr():void
	{
		var xpath:XPath = new XPath("//name[text() = 'Belgian Waffles'] | //name[text() = 'Strawberry Belgian Waffles']");	
		var result:NodeSet = xpath.evaluate(menu);
		var expected:NodeSet = createResultSet(menu..name.(text() == "Belgian Waffles" || text() == "Strawberry Belgian Waffles"));
		
		assertTrue(xpath.source + " should select 2 nodes.", 2, result.length);
		assertEquals(xpath.source + " equals expected.", expected.toString(), result.toString());
	}
	
	public function testVariableReference():void
	{
		var a:QualifiedName = new QualifiedName("a");
		var context:EvaluationContext = new EvaluationContext(menu, 1, 1);
		context.setVariable(a, 1);
		
		var xpath:XPath = new XPath("breakfast-menu/food[$a]/name/text()");
		assertEquals("1 let's see if this works?", "Belgian Waffles", xpath.evaluate(context));
		
		xpath = new XPath("breakfast-menu/food[$a]/name/text()", context);
		xpath.context.setVariable(a, 2);
		assertEquals("2 let's see if this works?", "Strawberry Belgian Waffles", xpath.evaluate());
		
		context.removeVariable(a);
		xpath = new XPath("breakfast-menu/food[$a]/name/text()");
		var error:Error = null;
		try
		{
			xpath.evaluate(menu);
		}
		catch(e:ReferenceError)
		{
			error = e;
		}
		assertNotNull("3 This should throw an error because no variable", error);
		
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