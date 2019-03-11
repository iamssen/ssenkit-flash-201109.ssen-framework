package ssen.log {
import flash.events.TextEvent;

/** Virtual Console event */
public class VirtualConsoleEvent extends TextEvent {
	/** message 를 출력 */
	public static const TRACE_MESSAGE:String = "traceMessage";

	public function VirtualConsoleEvent(type:String, text:String = "") {
		super(type, false, false, text);
	}
}
}