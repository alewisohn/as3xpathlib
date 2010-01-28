package com.watchthosecorners.xpath
{
import com.watchthosecorners.xpath.fixtures.XMLData;
import com.watchthosecorners.xpath.utils.XMLUtil;

import flash.utils.getTimer;

import flexunit.framework.TestCase;

import mx.logging.ILogger;
import mx.logging.Log;

public class MiscellaneousTests extends TestCase
{
	//--------------------------------------------------------------------------
	//
	//  Logging
	//
	//--------------------------------------------------------------------------
	
	private static const LOGGER:ILogger = Log.getLogger("com.watchthosecorners.xpath.XPathMiscellaneousTests");
	
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
	private var startTime:uint;
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */	
	public function MiscellaneousTests(methodName:String=null)
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
	
	public function testAddAndResolveToFunctionMap():void
	{
		var test:Function = function():Boolean { return false; };
		var func:FunctionContext = new FunctionContext(test, false, FunctionContext.DefaultTo.NONE);
		var fmap:FunctionMap = new FunctionMap();
		fmap.registerFunction(new QualifiedName("test"), func);
		
		var xpath:XPath = new XPath("false() = test()");
		xpath.context.addFunctionMap(fmap);
		
		var result:Boolean = xpath.evaluate();
		
		assertEquals(xpath.source + " should equal true.", true, result);
	}
	
	/**
	 * Equation/Associativity Tests
	 */
	public function testAssociativity():void
	{
		var xpath:XPath = new XPath("(3 > 2) > 1");
		assertFalse("This is coerced left-associativity > ", xpath.evaluate(null));
		
		xpath = new XPath("3 > (2 > 1)");
		assertTrue("make sure that the opposite associativity is different > ", xpath.evaluate(null));
		
		xpath = new XPath("3 > 2 > 1");
		assertFalse("should be left-associative > ", xpath.evaluate(null));
		
		xpath = new XPath("(6 * 2) mod 3");
		assertEquals("This is coerced left-associativity- mod", 0, xpath.evaluate(null));
		
		xpath = new XPath("6 * (2 mod 3)");
		assertEquals("make sure that the opposite associativity is different- mod", 12, xpath.evaluate(null));
		
		xpath = new XPath("6 * 2 mod 3");
		assertEquals("should be left-associative- mod", 0, xpath.evaluate(null));
	}
	
	public function testAttributeSelfAxis():void
	{	
		var data:XML = 	<p>
						  <a href="http://www.watchthosecorners.com">link 1</a>
						  <a href="http://www.google.com">link 2</a>
						</p>;
		var url:String;
		url = XPath.evaluate("/p/a/@href[string(.) = 'http://www.watchthosecorners.com']", data);
		assertEquals("1 should match just the memorphic url", "http://www.watchthosecorners.com", url);
		url = XPath.evaluate("/p/a/@href[string() = 'http://www.watchthosecorners.com']", data);
		assertEquals("1.1 should match just the memorphic url", "http://www.watchthosecorners.com", url);
		url = XPath.evaluate("/p/a/@href[contains(self::node(),'watchthosecorners')]", data);
		assertEquals("2 should match just the memorphic url", "http://www.watchthosecorners.com", url);
		
		assertEquals("3 check id att", "cd4", XPath.evaluate("//@id[contains(.,'cd4')]", cds));
	}
	
	/**
	 * Custom Function Executes on an XPath Expression.
	 */
	public function testCustomFunctionExecsPath():void
	{
		var path:String = "/CATALOG/CD[last()]";
		var context:EvaluationContext = new EvaluationContext(cds);
		var lastCD:Function = function(context:EvaluationContext):NodeSet
		{
			return XPath.evaluate(path, context);
		}
		var lastCDFunction:FunctionContext = new FunctionContext(lastCD);
		
		context.registerFunction(new QualifiedName("lastCD"), lastCDFunction);
		
		var xpath:XPath = new XPath(path + " = " + path);
		
		assertTrue("sanity check", xpath.evaluate(context));
		assertTrue("call 'out' should not affect absolute paths", XPath.evaluate(path + " = lastCD()", context));
	}
	
	/**
	 * Identical nodes should be returned as seperate nodes in NodeSet.
	 */
	public function testIdenticalNodes():void
	{			
		var tree3:XML = <Root attr="test">
							<Child>
								<X attr="test"/>
								<X attr="test">
									<InnerX/>
								</X>
								<X attr="test">
									<InnerX/>
								</X>
							</Child>
						</Root>;
						
		var xpath:XPath = new XPath("//InnerX");
		var result:NodeSet = xpath.evaluate(tree3);
		assertEquals("length should be 2", 2, result.length);
	}
	
	/**
	 * Check for malformed XPath expressions.
	 */
	public function testInvalidExpression():void
	{
		var errorPaths:Array = [
			// "\\\\a\\b",
			"a b",
			"//self::node())", // extra ")"
			"/x/y[contains(self::node())", // missing "]"
			 "/x/y[contains(self::node()]", // missing ")"
			"***", 
			"///", 
			"text::a" // because text is not an axis
		];
		var n:int = errorPaths.length;
		for(var i:int=0; i<n; i++)
		{
			var error:Error;
			try
			{
				var xpath:XPath = new XPath(errorPaths[i]);
			}
			catch(e:Error)
			{
				error = e;
			}
			finally
			{
				assertNotNull("Lexing/Parsing/Evaluation Error: " + errorPaths[i], error);
			}
		}	
	}
	
	public function testNodeSetMethods():void
	{
		var nodeSet1:NodeSet = new NodeSet(<temp/>);
		var nodeSet2:NodeSet = new NodeSet(nodeSet1[0]);
		
		assertTrue(nodeSet1.equals(nodeSet2));
		
		nodeSet1.clear();
		nodeSet2.clear();
		
		assertTrue(nodeSet1.length == 0);
		assertTrue(nodeSet2.length == 0);	
		
		var x:XML = <temp>
						<sub-temp position="1"/>
						<sub-temp position="2"/>
					</temp>;
		
		nodeSet1 = XPath.evaluate("/temp/sub-temp[1]", x);
		nodeSet2 = XPath.evaluate("/temp/sub-temp[2]", x);
		
		assertEquals(nodeSet1.length, nodeSet2.length);
		assertFalse(nodeSet1.equals(nodeSet2));
		
		nodeSet2.clear();
		nodeSet2.addAll(nodeSet1);
		
		assertTrue(nodeSet1.equals(nodeSet2));
	}
	
	public function testNodeSetProxy():void
	{
		var expected:XML = <temp/>;
		var ns:NodeSet = new NodeSet();
		ns.add(expected);
		
		var node:XML = ns[0];
		
		assertNotNull("Should not be null.", node);
		assertEquals(expected.toXMLString() + " should equal " + node.toXMLString() + ".", expected, node);	
	}
	
	public function testNumberRelations():void
	{
		var xpath:XPath = new XPath("1 = 1");
		assertTrue("1 = 1", xpath.evaluate(null));
		
		xpath = new XPath("1 > 1");
		assertFalse("1 > 1", xpath.evaluate(null));
		
		xpath = new XPath("1 = 1");
		assertTrue("1 = 1", xpath.evaluate(null));
		
		xpath = new XPath("1 >= 1");
		assertTrue("1 >= 1", xpath.evaluate(null));
		
		xpath = new XPath("1 >= 1");
		assertTrue("1 <= 1", xpath.evaluate(null));
		
		xpath = new XPath("-1 = -1");
		assertTrue("-1 = -1", xpath.evaluate(null));
		
		xpath = new XPath("-1 > -1");
		assertFalse("-1 > -1", xpath.evaluate(null));
		
		xpath = new XPath("1 = 1");
		assertTrue("-1 = -1", xpath.evaluate(null));
		
		xpath = new XPath("-1 >= -1");
		assertTrue("-1 >= -1", xpath.evaluate(null));
		
		xpath = new XPath("-1 <= -1");
		assertTrue("-1 <= -1", xpath.evaluate(null));
		
		xpath = new XPath("1 = -1");
		assertFalse("1 = -1", xpath.evaluate(null));
		
		xpath = new XPath("29.99 = 30");
		assertFalse("29.99 = 30", xpath.evaluate(null));
	}
	
	/**
	 * Parse number in decimal format without preceeding 0.
	 */
	public function testDecimalWithoutPreceedingZero():void
	{
		var xpath:XPath = new XPath("ceiling((500000-.0001) div 1000)*1000");
		assertEquals(500000, xpath.evaluate());
		
		var x:XML = <root><node>500000</node></root>;
		xpath = new XPath("/root/node/.");
		assertEquals(500000, xpath.evaluate(x));
	}
		
	/**
	 * Node selection by a fully qualified name.
	 */
	public function testQualifiedNameNodeSelection():void
	{
		var xpath:XPath = new XPath("//xhtml:head");
		var result:* = xpath.evaluate(xhtml);
		
		assertEquals("only select one node", 1, result.length);
		assertEquals("local name should be <head>", "head", result[0].localName());
	}
		
	/**
	 * Retrieval of Referenced Nodes.
	 */ 
	public function testReferencedNodes():void
	{
		var expected:NodeSet = createResultSet(cds.CD[26]);
		var xpath:XPath = new XPath("/CATALOG/CD[last()]");
		var nodes:NodeSet = xpath.referencedNodes(cds);
		
		assertEquals(xpath.source + " should equal expected.", expected.toString(), nodes.toString())
		
		expected = new NodeSet(cds.CD[0].TITLE + cds.CD[26].TITLE);
		xpath = new XPath("/CATALOG/CD[last()]/TITLE = /CATALOG/CD[1]/TITLE");
		nodes = xpath.referencedNodes(cds);
		
		assertObjectEquals(xpath.source + " referenced nodes should be the first and last nodes of the xml.", expected, nodes);
		
		var result:Boolean = new XPath("/CATALOG/CD[position() = last() and local-name(..) = 'CATALOG']/TITLE = /CATALOG/CD[1]/TITLE").evaluate(cds);
		
		expected = new NodeSet(cds.CD[0].TITLE + cds + cds.CD[26].TITLE);
		xpath = new XPath("/CATALOG/CD[position() = last() and local-name(..) = 'CATALOG']/TITLE = /CATALOG/CD[1]/TITLE");
		nodes = xpath.referencedNodes(cds);
		
		assertObjectEquals(xpath.source + " referenced nodes should be the first and last nodes of the xml.", expected, nodes);
	}
	
	public function testSelectComments():void
	{
		XML.ignoreComments = false;
		XML.ignoreProcessingInstructions = false;
		
		var x:XML = 
					<foo>
			            <!-- comment -->
			            <?instruction ?>
			            <foo2>
			            	<!-- comment2 -->
			            	{cdata("Test")}
			            	{cdata("Test2")}
			            </foo2>
			        </foo>;
			
		var xpath:XPath = new XPath("string(//foo2/comment())");
		var result:* = xpath.evaluate(x);
		var expected:* = XMLUtil.stringValueOf(x.foo2.comments()[0]);
		
		assertEquals("", expected, result);
		
		xpath = new XPath("//comment()");
		result = xpath.evaluate(x);
		expected = createResultSet(x..*.(nodeKind() == "comment"));
		
		assertEquals("", expected.toString(), result.toString());
	}
	
	public function testSelectProcessingInstructions():void
	{
		XML.ignoreComments = false;
		XML.ignoreProcessingInstructions = false;
		
		var x:XML = 
					<foo>
			            <!-- comment -->
			            <?instruction ?>
			            <foo2>
			            	<?xml-stylesheet ?>
			            	<!-- comment -->
			            	{cdata("Test")}
			            	{cdata("Test2")}
			            </foo2>
			        </foo>;
			
		var xpath:XPath = new XPath("name(//processing-instruction('xml-stylesheet'))");
		var result:* = xpath.evaluate(x);
		var expected:* = x.foo2.processingInstructions('xml-stylesheet')[0].name().toString();
		
		assertEquals("", expected, result);
		
		xpath = new XPath("//processing-instruction()");
		result = xpath.evaluate(x);
		expected = createResultSet(x..*.(nodeKind() == "processing-instruction"));
		
		assertEquals("", expected.toString(), result.toString());
	}
	
	public function testSelectText():void
	{
		XML.ignoreComments = false;
		XML.ignoreProcessingInstructions = false;
		
		var x:XML = 
					<foo>
			            <!-- comment -->
			            <?instruction ?>
			            <foo2>
			            	<!-- comment -->
			            	{cdata("Test")}
			            	{cdata("Test2")}
			            </foo2>
			        </foo>;
			
		var xpath:XPath = new XPath("string(//text())");
		var result:* = xpath.evaluate(x);
		var expected:* = x.foo2.text()[0].toString();
		
		assertEquals("", expected, result);
	}
	
	public function testStaticMethods():void
	{
		var x:XML = 
					<foo>
			            <!-- comment -->
			            <?instruction ?>
			            <foo2>
			            	<!-- comment -->
			            	{cdata("Test")}
			            	{cdata("Test2")}
			            </foo2>
			        </foo>;
	
		var result:* = XPath.evaluate("/foo/foo2", x);
		var expected:* = new NodeSet(x.foo2);
		assertObjectEquals("NodeSets are not equal.", result, expected); 
		
		result = XPath.selectSingleNode("/foo/foo2", x);
		expected = x.foo2[0];
		assertEquals("Nodes are not equal.", result, expected);
		
		result = XPath.referencedNodes("/foo/foo2", x);
		expected = new NodeSet(x.foo2);
		assertObjectEquals("NodeSets are not equal.", result, expected);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Methods: Helpers
	//
	//--------------------------------------------------------------------------
	
	private function cdata(text:String):XML
	{
		return new XML("<![CDATA[" + text + "]]>");
	}	
	
	private function createResultSet(nodes:Object):NodeSet
	{
		return new NodeSet(nodes);
	}
}
}