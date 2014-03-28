package com.shrimp.framework.net.socket
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	public class TCPService
	{
		private static var lossConnectHandle:Function;
		protected static var _socket:CommonSocket;

		public function TCPService()
		{
			
		}
			
		public function init(socket:CommonSocket=null):void
		{
			if (socket == null)
			{
				socket=new CommonSocket();
			}

			_socket=socket;
			if (temp.length > 0)
			{
				while (temp.length > 0)
				{
					var dic:Dictionary=temp.pop() as Dictionary;
					for (var key:* in dic)
					{
						_socket.register(key, dic[key]);
					}
				}
			}

			_socket.register(Event.CONNECT, onConnect);
			_socket.register(Event.CLOSE, onDisConnect)
			_socket.register(IOErrorEvent.IO_ERROR, onConnectFailed)
			_socket.register(SecurityErrorEvent.SECURITY_ERROR, onConnectFailed);

			lossConnectHandle=lossContnect;
		}

		public function connect(host:String, port:int):void
		{
			if (!_socket)
			{
				init()
			}
			_socket.connect(host, port)
		}

		public function get connected():Boolean
		{
			return _socket ? _socket.connected : false;
		}

		private var temp:Array=[];

		public function registerMessageReciever(reciever:AbstractMessageReceiver):void
		{
			var dic:Dictionary=reciever.getObservers();
			if (_socket)
			{
				for (var key:* in dic)
				{
					_socket.register(key, dic[key]);
				}
			}
			else
			{
				temp.push(dic);
			}
		}

		public function removeMessageReciver(reciever:AbstractMessageReceiver):void
		{
			if (_socket)
			{
				var dic:Dictionary=reciever.getObservers();
				for (var key:* in dic)
				{
					_socket.unRegister(key);
				}
			}
		}

		public static function sendPackage(cmd:int, body:ByteArray):void
		{
			if (_socket && _socket.connected)
			{
				_socket.sendPackage(cmd, body);
			}
			else
			{
				if (_socket.connected == false)
				{
					lossConnectHandle();
				}
			}
		}

		public static function sendBodyData(body:ByteArray):void
		{
			if (_socket && _socket.connected)
			{
				_socket.sendBodyData(body);
			}
			else
			{
				if (_socket.connected == false)
				{
					lossConnectHandle();
				}
			}
		}


		public static function closeConnect():void
		{
			if (_socket.connected)
			{
				_socket.close();
			}
		}

		protected function onConnect(e:Event):void
		{

		}

		protected function onDisConnect(e:Event):void
		{

		}

		protected function onConnectFailed(e:Event):void
		{
		}

		protected function lossContnect():void
		{

		}

	}
}
