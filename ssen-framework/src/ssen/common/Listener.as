package ssen.common {

/** @private */
public class Listener {
	public var type:String;

	public var listener:Function;

	public var useCapture:Boolean;

	public var priority:int;

	public var useWeakReference:Boolean;

	public function Listener(type:String, listener:Function, useCapture:Boolean,
							 priority:int, useWeakReference:Boolean) {
		this.type = type;
		this.listener = listener;
		this.useCapture = useCapture;
		this.priority = priority;
		this.useWeakReference = useWeakReference;
	}
}
}