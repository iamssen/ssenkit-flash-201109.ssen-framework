package ssen.net {

import flash.net.URLRequest;
import flash.net.URLVariables;


public class URLStreamService {
	
	public var root:String;
	
	[Inspectable(enumeration="get,post")]
	public var method:String = "post";
	
	public function send(path:String, result:Function, fault:Function,
						 parameters:Object = null):void {
		var req:URLRequest = new URLRequest;
		req.url = root + path;
		
		if (parameters) {
			var vars:URLVariables = new URLVariables;
			
			for (var k:String in parameters) {
				if (parameters[k] != undefined && parameters[k] != null) {
					vars[k] = parameters[k];
				}
			}
			
			req.data = vars;
		}
		
		req.method = method;
		
		var stream:Stream = new Stream(result, fault);
		stream.load(req);
	}
}
}

import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLStream;

class Stream extends URLStream {
	private var result:Function;
	
	private var fault:Function;
	
	public function Stream(result:Function, fault:Function) {
		this.result = result;
		this.fault = fault;
		
		addEventListener(Event.COMPLETE, completeHandler);
		addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		addEventListener(SecurityErrorEvent.SECURITY_ERROR,
						 securityErrorHandler);
	}
	
	private function completeHandler(event:Event):void {
		result(this);
		deconstruct();
	}
	
	private function ioErrorHandler(event:IOErrorEvent):void {
		fault(new Error(event.text));
		deconstruct();
	}
	
	private function securityErrorHandler(event:SecurityErrorEvent):void {
		fault(new Error(event.text));
		deconstruct();
	}
	
	private function deconstruct():void {
		removeEventListener(Event.COMPLETE, completeHandler);
		removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		removeEventListener(SecurityErrorEvent.SECURITY_ERROR,
			securityErrorHandler);
		result = null;
		fault = null;
	}
}
