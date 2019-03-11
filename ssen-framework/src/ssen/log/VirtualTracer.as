package ssen.log {


/** VirtualConsoleDispatcher 를 수신하는 Object 들에게 trace 를 보내준다 */
public class VirtualTracer extends ConsoleTracer {
	public function VirtualTracer(levelFilter:Array = null,
								  expression:String = null,
								  depths:Vector.<String> = null) {
		super(levelFilter, expression, depths);
	}

	/** @private */
	override protected function tracer(str:String):void {
		VirtualConsoleDispatcher.getInstance().dispatchEvent(new VirtualConsoleEvent(VirtualConsoleEvent.TRACE_MESSAGE,
																					 str));
	}
}
}