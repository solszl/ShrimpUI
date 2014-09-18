package com.shrimp.framework.interfaces
{
	import com.shrimp.framework.utils.XMLBuilder;

	public interface IXMLConvertable
	{
		function toXML():XML;
		function parseXML(xml:XML, builder:XMLBuilder = null):void;
	}
}