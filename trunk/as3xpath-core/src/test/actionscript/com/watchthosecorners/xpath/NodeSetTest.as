package com.watchthosecorners.xpath
{
import flexunit.framework.Assert;

public class NodeSetTest
{
	public function NodeSetTest()
	{
	}
	
	[Test]
	public function testAdd():void
	{
		var xml:XML = <input value="null"/>;
		var node:XML = xml.@value[0];
		var nodeSet:NodeSet = new NodeSet();
		nodeSet.add(node);
		
		Assert.assertEquals(1, nodeSet.length);
	}
	
	[Test]
	public function testAddAll():void
	{
		var nodes:XMLList = <><input value="null"/><input value="null"/></>;
		var nodeSet:NodeSet = new NodeSet();
		nodeSet.addAll(nodes);
		
		Assert.assertEquals(2, nodeSet.length);
		
		nodes = nodes.@value;
		nodeSet.clear();
		nodeSet.addAll(nodes);
		
		Assert.assertEquals(2, nodeSet.length);
	}
	
	[Test]
	public function testAddAllUnique():void
	{
		var nodes:XMLList = <><input value="null"/><input value="null"/></>;
		var nodeSet:NodeSet = new NodeSet();
		nodeSet.addAllUnique(nodes);
		
		Assert.assertEquals(2, nodeSet.length);
		
		nodes = nodes.@value;
		nodeSet.clear();
		nodeSet.addAllUnique(nodes);
		
		Assert.assertEquals(2, nodeSet.length);
	}
	
	[Test]
	public function testAddUnique():void
	{
		var xml:XML = <input value="null"/>;
		var node:XML = xml.@value[0];
		var nodeSet:NodeSet = new NodeSet();
		nodeSet.addUnique(node);
		
		Assert.assertEquals(1, nodeSet.length);
	}
	
	[Test]
	public function testClear():void
	{
		var nodes:Array = [<input/>, <input/>];
		var nodeSet:NodeSet = new NodeSet(nodes);
		
		Assert.assertEquals(2, nodeSet.length);
		
		nodeSet.clear();
		
		Assert.assertEquals(0, nodeSet.length);
	}
	
	[Test]
	public function testContains():void
	{
		var nodes:Array = [<input/>, <input/>];
		var nodeSet:NodeSet = new NodeSet(nodes);
		
		Assert.assertTrue(nodeSet.contains(nodes[0]));
	}
	
	[Test]
	public function testEquals():void
	{
		var nodes:Array = [<input/>, <input/>];
		var nodeSet1:NodeSet = new NodeSet(nodes);
		var nodeSet2:NodeSet = new NodeSet(nodes);
		
		Assert.assertTrue(nodeSet1.equals(nodeSet2));
	}
	
	[Test]
	public function testNodeSet_Array():void
	{
		var nodes:Array = [<input/>, <input/>];
		var nodeSet:NodeSet = new NodeSet(nodes);
		
		Assert.assertEquals(2, nodeSet.length);
	}
	
	[Test]
	public function testNodeSet_XMLList():void
	{
		var nodes:XMLList = <><input/><input/></>;
		var nodeSet:NodeSet = new NodeSet(nodes);
		
		Assert.assertEquals(2, nodeSet.length);
	}
	
	[Test]
	public function testNodeSet_XML():void
	{
		var nodeSet:NodeSet = new NodeSet(<input/>);
		Assert.assertEquals(1, nodeSet.length);
		Assert.assertEquals("input", nodeSet[0].localName());
	}
}
}