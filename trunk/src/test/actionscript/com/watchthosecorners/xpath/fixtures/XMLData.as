package com.watchthosecorners.xpath.fixtures
{
import flash.utils.ByteArray;

public class XMLData
{


	public static function get adobeBlogsRDF():XML
	{
		return new XML(adobeBlogsRDFString);
	}
		
	public static function get adobeHomeXHTML():XML{
		return new XML(adobeHomeXHTMLString);
	}

	public static function get foodMenuXML():XML{
		return new XML(foodMenuString);
	}

	public static function get cdCatalogXML():XML{
		return new XML(cdCatalogXMLString);
	}
	public static function get registerHTML():XML{
		return new XML(registerHTMLString);
	}



	[Embed(source="flash_xpath.rdf", mimeType="application/octet-stream")]
	private static const XPATH_FLASH_RDF_RAW:Class;
	
	public static const adobeBlogsRDFString:String = getString(new XPATH_FLASH_RDF_RAW());

	[Embed(source="adobe.xhtml", mimeType="application/octet-stream")]
	private static const ADOBE_HOME_RAW:Class;
	
	public static const adobeHomeXHTMLString:String = getString(new ADOBE_HOME_RAW());

	[Embed(source="cd_catalog.xml", mimeType="application/octet-stream")]
	private static const CD_CAT_RAW:Class;
	
	public static const cdCatalogXMLString:String = getString(new CD_CAT_RAW());

	[Embed(source="menu.xml", mimeType="application/octet-stream")]
	private static const MENU_RAW:Class;
	
	public static const foodMenuString:String = getString(new MENU_RAW());


	[Embed(source="register.html", mimeType="application/octet-stream")]
	private static const REGISTER_RAW:Class;
	
	public static const registerHTMLString:String = getString(new REGISTER_RAW());


	private static function getString(data:ByteArray):String
	{
		return data.readUTFBytes(data.length);
	}



}

}