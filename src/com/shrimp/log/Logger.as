package com.shrimp.log
{
	import com.shrimp.utils.StringUtil;

	public class Logger
	{
		private static var loggers:Array=[];
		public static var mcOutputClip:ILoggerClip;
		private var category:String="ROOT";
		//debug,info,warning,error,fatal
		private static const DEBUG:String="#FFFFFF";
		private static const INFO:String="#09d209";
		private static const WARNING:String="#23d4fa";
		private static const ERROR:String="#cf2dfe";
		private static const FATAL:String="#dd0707";
		public static function getLogger(category:String="ROOT"):Logger
		{
			var logger:Logger
			category=category.toLowerCase();
			var length:Number=Logger.loggers.length;
			for (var i:Number=0; i < length; i++)
			{
				logger=Logger.loggers[i];
				if (logger.category == category)
				{
					return logger;
				}
			}
			
			logger=new Logger(category);
			Logger.loggers.push(logger);
			
			return logger;
		}
		
		public function Logger(category:String)
		{
			this.category=category;
		}
		
		public function debug(... arg):void
		{
			output(createOutputMessage(Logger.DEBUG,arg.join(",")));
		}
		public function info(... arg):void
		{
			output(createOutputMessage(Logger.INFO,arg.join(",")));
		}
		public function warning(... arg):void
		{
			output(createOutputMessage(Logger.WARNING,arg.join(",")));
		}
		public function error(... arg):void
		{
			output(createOutputMessage(Logger.ERROR,arg.join(",")));
		}
		public function fatal(... arg):void
		{
			output(createOutputMessage(Logger.FATAL,arg.join(",")));
		}
		
		private function createOutputMessage(levelColor:String,message:String):String
		{
			var msg:String = "{2}:<font color='{0}'>{1}</font>"
			var sOutput:String=StringUtil.substitute(msg,levelColor,message,this.category.toUpperCase());
			return sOutput;
		}
		private function output(message:String):void
		{
			if (mcOutputClip != null)
			{
				mcOutputClip.output(message);
			}
			else
			{
				trace(message);
			}
		}
	}
}