/*
 * Copyright (c) 2009 Andrew Lewisohn
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */ 
package com.watchthosecorners.xpath
{
import flash.errors.IllegalOperationError;

[ExcludeClass]

public class Axis
{
	//--------------------------------------------------------------------------
	//
	//  Static initializer
	//
	//--------------------------------------------------------------------------
	
		
	//--------------------------------------------------------------------------
	//
	//  Class variables
	//
	//--------------------------------------------------------------------------
	
	public static var CHILD:Axis; 					
	public static var DESCENDANT:Axis; 				
	public static var DESCENDANT_OR_SELF:Axis; 		
	public static var PARENT:Axis; 					
	public static var ANCESTOR:Axis;				
	public static var ANCESTOR_OR_SELF:Axis;  		
	public static var FOLLOWING_SIBLING:Axis;  		
	public static var PRECEDING_SIBLING:Axis; 		
	public static var FOLLOWING:Axis; 				
	public static var PRECEDING:Axis;  				
	public static var ATTRIBUTE:Axis;  				
	public static var NAMESPACE:Axis;  				
	public static var SELF:Axis;
	
	//--------------------------------------------------------------------------
	//
	//  Class properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//   Direction
	//----------------------------------
	
	/**
	 * @private
	 */
	private static var _Direction:AxisDirection;

	/**
	 * Documentation Required
	 */
	public static function get Direction():AxisDirection
	{
		if(_Direction == null)
			_Direction = new AxisDirection();
		
		return _Direction;
	}
	
	//----------------------------------
	//   Name
	//----------------------------------
	
	/**
	 * @private
	 */
	private static var _Name:AxisNames;

	/**
	 * Documentation Required
	 */
	public static function get Name():AxisNames
	{
		if(_Name == null)
			_Name = new AxisNames();
		
		return _Name;
	}
	
	/**
	 * @private
	 * Initializes private classes.
	 */
	public static function get initialized():Boolean
	{
		CHILD 				= new Child();
		DESCENDANT			= new Descendant(); 				
		DESCENDANT_OR_SELF 	= new DescendantOrSelf(); 		
		PARENT 				= new Parent(); 					
		ANCESTOR			= new Ancestor();				
		ANCESTOR_OR_SELF 	= new AncestorOrSelf();  		
		FOLLOWING_SIBLING 	= new FollowingSibling();  		
		PRECEDING_SIBLING 	= new PrecedingSibling(); 		
		FOLLOWING 			= new Following(); 				
		PRECEDING 			= new Preceding();  				
		ATTRIBUTE 			= new Attribute();  				
		NAMESPACE 			= new NamespaceAxis();  				
		SELF 				= new Self();
		
		return true;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function Axis(name:String, direction:int=0)
	{
		_name = name;
		_direction = direction;
	}

	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  direction
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _direction:int;

	/**
	 * Documentation Required
	 */
	public function get direction():int
	{
		return _direction;
	}
	
	/**
	 * @private
	 */
	public function set direction(value:int):void
	{
		_direction = value;
	}	
	
	//----------------------------------
	//  name
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _name:String;

	/**
	 * Documentation Required
	 */
	public function get name():String
	{
		return _name;
	}
	
	/**
	 * @private
	 */
	public function set name(value:String):void
	{
		_name = value;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	public function filter(nodeSet:NodeSet, nodeTest:INodeTest):NodeSet
	{
		var result:NodeSet = new NodeSet();
		var setLen:int = nodeSet.length - 1;
		for(var i:int = 0; i <= setLen; i++)
		{
			if(i == 0)
			{
				result = filterNode(nodeSet[i], nodeTest);
			}
			else
			{
				var resultSet:NodeSet = filterNode(nodeSet[i], nodeTest);
				result.addAll(resultSet);
			}
		}
		return postFilter(result, nodeTest);
	}
	
	public function filterNode(node:XML, nodeTest:INodeTest):NodeSet
	{
		throw new IllegalOperationError("Abstract Method not implemented in base class.");
	}
	
	protected function postFilter(nodeSet:NodeSet, nodeTest:INodeTest):NodeSet
	{
		return nodeTest.filter(null, nodeSet, this);
	}
	
	public function toString():String
	{
		return '[object Axis name="' + _name + '" direction="' + _direction + '"]';
	}
}
}
	
import com.watchthosecorners.xpath.Axis;
import com.watchthosecorners.xpath.DefaultNamespaces;
import com.watchthosecorners.xpath.INodeTest;
import com.watchthosecorners.xpath.NodeSet;
import com.watchthosecorners.xpath.nodeTests.QNameNodeTest;
import com.watchthosecorners.xpath.nodeTests.TextNodeTest;
import com.watchthosecorners.xpath.nodeTests.CommentNodeTest;
import com.watchthosecorners.xpath.nodeTests.ProcessingInstructionNodeTest;
import com.watchthosecorners.xpath.nodeTests.NamespaceNodeTest;
import com.watchthosecorners.xpath.nodeTests.NodeNodeTest;
import com.watchthosecorners.xpath.nodeTests.StarNodeTest;

class Child extends Axis
{
	public function Child()
	{
		super(Axis.Name.CHILD);
	}
	
	override public function filterNode(node:XML, nodeTest:INodeTest):NodeSet
	{
		var nodeSet:NodeSet = new NodeSet();
		if(node.nodeKind() != "attribute")
		{
			if(nodeTest is QNameNodeTest)
			{
				nodeSet.addAllUnique(node.child(QNameNodeTest(nodeTest).qname.toQName(node)));
			}
			else if(nodeTest is TextNodeTest)
			{
				nodeSet.addAllUnique(node.text());
			}
			else if(nodeTest is CommentNodeTest)
			{
				nodeSet.addAllUnique(node.comments());
			}
			else if(nodeTest is ProcessingInstructionNodeTest)
			{
				if(ProcessingInstructionNodeTest(nodeTest).target)
				{
					nodeSet.addAllUnique(node.processingInstructions(ProcessingInstructionNodeTest(nodeTest).target));
				}
				else
				{
					nodeSet.addAllUnique(node.processingInstructions());
				}
			}
			else if(nodeTest is NamespaceNodeTest)
			{
				nodeSet.addAllUnique(node.*.(namespace().uri == NamespaceNodeTest(nodeTest).namespaceURI));
			}
			else
			{
				nodeSet.addAllUnique(node.children());
			}
		}
		return nodeSet;
	}
	
	override protected function postFilter(nodeSet:NodeSet, nodeTest:INodeTest):NodeSet
	{
		if(nodeTest is NodeNodeTest 
			|| nodeTest is StarNodeTest)
		{
			return nodeTest.filter(null, nodeSet, this);
		}
		else
		{
			return nodeSet;
		}
	}
}

class Descendant extends Axis
{
	public function Descendant()
	{
		super(Axis.Name.DESCENDANT);
	}
	
	override public function filterNode(node:XML, nodeTest:INodeTest):NodeSet
	{
		if(node.nodeKind() == "attribute")
		{
			return new NodeSet();
		}
		
		var nodeSet:NodeSet = new NodeSet();
		if(nodeTest is QNameNodeTest)
		{
			nodeSet.addAllUnique(node.descendants(QNameNodeTest(nodeTest).qname.toQName(node)));
		}
		else if(nodeTest is TextNodeTest)
		{
			nodeSet.addAllUnique(node..*.(nodeKind() == "text"));
		}
		else if(nodeTest is CommentNodeTest)
		{
			nodeSet.addAllUnique(node..*.(nodeKind() == "comment"));
		}
		else if(nodeTest is ProcessingInstructionNodeTest)
		{
			if(ProcessingInstructionNodeTest(nodeTest).target)
			{
				nodeSet.addAllUnique(node..*.(nodeKind() == "processing-instruction" && name() == ProcessingInstructionNodeTest(nodeTest).name));
			}
			else
			{
				nodeSet.addAllUnique(node..*.(nodeKind() == "processing-instruction"));
			}
		}
		else if(nodeTest is NamespaceNodeTest)
		{
			nodeSet.addAllUnique(node..*.(namespace().uri == NamespaceNodeTest(nodeTest).namespaceURI));
		}
		else
		{
			nodeSet.addAllUnique(node.descendants());
		}
		return nodeSet;
	}
	
	override protected function postFilter(nodeSet:NodeSet, nodeTest:INodeTest):NodeSet
	{
		if(nodeTest is NodeNodeTest 
			|| nodeTest is StarNodeTest)
		{
			return nodeTest.filter(null, nodeSet, this);
		}
		else
		{
			return nodeSet;
		}
	}
}

class DescendantOrSelf extends Axis
{
	public function DescendantOrSelf()
	{
		super(Axis.Name.DESCENDANT_OR_SELF);
	}
	
	override public function filterNode(node:XML, nodeTest:INodeTest):NodeSet
	{
		if(node.nodeKind() == "attribute")
		{
			return new NodeSet();
		}
		
		var nodeSet:NodeSet = nodeTest.filter(null, new NodeSet(node), this);
		if(nodeTest is QNameNodeTest)
		{
			nodeSet.addAllUnique(node.descendants(QNameNodeTest(nodeTest).qname.toQName(node)));
		}
		else if(nodeTest is TextNodeTest)
		{
			nodeSet.addAllUnique(node..*.(nodeKind() == "text"));
		}
		else if(nodeTest is CommentNodeTest)
		{
			nodeSet.addAllUnique(node..*.(nodeKind() == "comment"));
		}
		else if(nodeTest is ProcessingInstructionNodeTest)
		{
			if(ProcessingInstructionNodeTest(nodeTest).target)
			{
				nodeSet.addAllUnique(node..*.(nodeKind() == "processing-instruction" && name() == ProcessingInstructionNodeTest(nodeTest).target));
			}
			else
			{
				nodeSet.addAllUnique(node..*.(nodeKind() == "processing-instruction"));
			}
		}
		else if(nodeTest is NamespaceNodeTest)
		{
			nodeSet.addAllUnique(node..*.(namespace().uri == NamespaceNodeTest(nodeTest).namespaceURI));
		}
		else
		{
			nodeSet.addAllUnique(node.descendants());
		}
		return nodeSet;		
	}
	
	override protected function postFilter(nodeSet:NodeSet, nodeTest:INodeTest):NodeSet
	{
		if(nodeTest is NodeNodeTest 
			|| nodeTest is StarNodeTest)
		{
			return nodeTest.filter(null, nodeSet, this);
		}
		else
		{
			return nodeSet;
		}
	}
}

class Parent extends Axis
{
	public function Parent()
	{
		super(Axis.Name.PARENT, Axis.Direction.REVERSE);
	}
	
	override public function filterNode(node:XML, nodeTest:INodeTest):NodeSet
	{
		if(node.nodeKind() == "attribute")
		{
			if(node.parent() != null)
			{
				return new NodeSet(node.parent());
			}
		}
		else if(node.parent() != null)
		{
			return new NodeSet(node.parent());
		}
		
		return new NodeSet();
	}
}

class Ancestor extends Axis
{
	public function Ancestor()
	{
		super(Axis.Name.ANCESTOR, Axis.Direction.REVERSE);
	}
	
	override public function filterNode(node:XML, nodeTest:INodeTest):NodeSet
	{
		var nodeSet:NodeSet = new NodeSet();
		var parent:NodeSet = Axis.PARENT.filterNode(node, nodeTest);
		
		node = parent.length > 0 ? parent[0] : null;
		
		while(node != null && node.parent() != null)
		{
			nodeSet.addUnique(node);
			node = node.parent();	
		}
		
		return nodeSet.reverse() as NodeSet;
	}
}

class AncestorOrSelf extends Axis
{
	public function AncestorOrSelf()
	{
		super(Axis.Name.ANCESTOR_OR_SELF, Axis.Direction.REVERSE);
	}
	
	override public function filterNode(node:XML, nodeTest:INodeTest):NodeSet
	{
		var nodeSet:NodeSet = new NodeSet();
		nodeSet.addUnique(node);
		nodeSet.addAllUnique(Axis.ANCESTOR.filterNode(node, nodeTest));
		return nodeSet;
	}
}

class FollowingSibling extends Axis
{
	public function FollowingSibling()
	{
		super(Axis.Name.FOLLOWING_SIBLING);
	}
	
	override public function filterNode(node:XML, nodeTest:INodeTest):NodeSet
	{
		var nodeSet:NodeSet = new NodeSet();
		var parent:XML = node.parent() as XML;
		
		if(parent != null)
		{
			for(var i:uint = node.childIndex() + 1; i < parent.children().length(); i++)
			{
				var nextSibling:XML = parent.children()[i];
				if(nextSibling == null)
					break;
					
				nodeSet.addUnique(nextSibling);
			}
		}
		return nodeSet;
	}
}

class PrecedingSibling extends Axis
{
	public function PrecedingSibling()
	{
		super(Axis.Name.PRECEDING_SIBLING, Axis.Direction.REVERSE);
	}
	
	override public function filterNode(node:XML, nodeTest:INodeTest):NodeSet
	{
		if(node.parent() == null)
			return new NodeSet();
			
		var nodeSet:NodeSet = new NodeSet();
		var parent:XML = node.parent() as XML;
		
		for(var i:int = node.childIndex() - 1; i >= 0; i--)
		{
			var prevSibling:XML = parent.children()[i];
			if(prevSibling == null)
				break;
					
			nodeSet.addUnique(prevSibling);
		}
		return nodeSet;
	}
}

class Following extends Axis
{
	public function Following()
	{
		super(Axis.Name.FOLLOWING);
	}
	
	override public function filterNode(node:XML, nodeTest:INodeTest):NodeSet
	{
		return following(node);
	}
	
	private function following(node:XML):NodeSet
	{
		var parent:XML = node.parent() as XML;
		if(parent == null)
			return new NodeSet();
		
		var children:XMLList = parent.children();
		
		try
		{	
			var nextSibling:XML = children[node.childIndex() + 1] as XML;	
			if(nextSibling != null)
			{
				var nodeSet:NodeSet = new NodeSet();
				nodeSet.addUnique(nextSibling);
				nodeSet.addAllUnique(following(nextSibling));
				return nodeSet;
			}
			else
			{
				return following(parent);
			}
		}
		catch(e:RangeError)
		{
			return following(parent);
		}
		
		return new NodeSet();
	}
}

class Preceding extends Axis
{
	public function Preceding()
	{
		super(Axis.Name.PRECEDING, Axis.Direction.REVERSE);
	}
	
	override public function filterNode(node:XML, nodeTest:INodeTest):NodeSet
	{
		return preceding(node);
	}
	
	private function preceding(node:XML):NodeSet
	{
		var parent:XML = node.parent() as XML;
		if(parent == null)
			return new NodeSet();
		
		var children:XMLList = parent.children();
		var prevSibling:XML = children[node.childIndex() - 1] as XML;	
		if(prevSibling != null)
		{
			return preceding(prevSibling).addUnique(prevSibling);
		}
		else if(node.parent() != null)
		{
			return preceding(node.parent());
		}
		else
		{
			return new NodeSet();
		}
	}
}

class Attribute extends Axis
{
	public function Attribute()
	{
		super(Axis.Name.ATTRIBUTE);
	}
	
	override public function filterNode(node:XML, nodeTest:INodeTest):NodeSet
	{
		if(node.attributes().length() == 0)
		{
			return new NodeSet();
		}
		
		var nodeSet:NodeSet = new NodeSet();
		if(nodeTest is QNameNodeTest)
		{
			nodeSet.addAllUnique(node.attribute(QNameNodeTest(nodeTest).qname.toQName(node)));
		}
		else
		{
			var attrs:XMLList = node.attributes();
		
			for(var i:int = attrs.length() - 1; i >= 0; i--)
			{
				var attribute:XML = attrs[i];
				nodeSet.addUnique(attribute);
			}
		}
		return nodeSet;
	}
}

class NamespaceAxis extends Axis
{
	public function NamespaceAxis()
	{
		super(Axis.Name.NAMESPACE);
	}
	
	override public function filter(nodeSet:NodeSet, nodeTest:INodeTest):NodeSet
	{
		return filterNode(nodeSet[0], nodeTest);
	}
	
	override public function filterNode(node:XML, nodeTest:INodeTest):NodeSet
	{
		if(node.nodeKind() != "element")
		{
			return new NodeSet(node);
		}
		
		var prefixes:Object = {};
		var nodeSet:NodeSet = new NodeSet();
		
		while(node != null && node.nodeKind() == "element")
		{
			var namespaces:Array = node.inScopeNamespaces();
			for(var i:uint = 0; i < namespaces.length; i++)
			{
				var ns:Namespace = namespaces[i];
				var uri:String = ns.uri;
				var prefix:String = ns.prefix ? ns.prefix : DefaultNamespaces.EMPTY_XMLNS;
				
				if(prefixes.hasOwnProperty(prefix))
				{
					continue;	
				}
				
				prefixes[prefix] = true;
				
				if(!(prefix == "" && uri == ""))
				{
					try
					{
						var namespaceNode:XML = <namespace {prefix}={uri}/>;
						var attr:XML = namespaceNode.attribute(prefix)[0];

						nodeSet.addUnique(attr);
					}
					catch(e:Error)
					{
						trace("Empty Namespace");
					}
				}
			}
			node = node.parent();
		}
		
		return nodeSet;
	}
}

class Self extends Axis
{
	public function Self()
	{
		super(Axis.Name.SELF);
	}
	
	override public function filter(nodeSet:NodeSet, nodeTest:INodeTest):NodeSet
	{
		return nodeSet;
	}
	
	override public function filterNode(node:XML, nodeTest:INodeTest):NodeSet
	{
		return new NodeSet(node);
	}
}

class AxisDirection
{
	//--------------------------------------------------------------------------
	//
	//  Constants
	//
	//--------------------------------------------------------------------------
	
	public var FORWARD:int										= 0;
	public var REVERSE:int										= 1;
	
	public function AxisDirection()
	{
	}
}

class AxisNames
{
	//--------------------------------------------------------------------------
	//
	//  Constants
	//
	//--------------------------------------------------------------------------
	
	public var CHILD:String 					= "child"; 					
	public var DESCENDANT:String 				= "descendant"; 				
	public var DESCENDANT_OR_SELF:String 		= "descendant-or-self"; 		
	public var PARENT:String 					= "parent"; 					
	public var ANCESTOR:String 					= "ancestor";				
	public var ANCESTOR_OR_SELF:String 			= "ancestor-or-self";  		
	public var FOLLOWING_SIBLING:String 		= "following-sibling";  		
	public var PRECEDING_SIBLING:String 		= "preceding-sibling";  		
	public var FOLLOWING:String 				= "following"; 				
	public var PRECEDING:String 				= "preceding";  				
	public var ATTRIBUTE:String 				= "attribute";  				
	public var NAMESPACE:String 				= "namespace";  				
	public var SELF:String 						= "self";  	
	
	public function AxisNames()
	{
	}
}