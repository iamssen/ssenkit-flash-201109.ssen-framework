package ssen.log {
import flash.external.ExternalInterface;

/** console 이 지원되는 웹브라우저에서 로그를 본다 */
public class JSConsoleTracer extends ConsoleTracer implements ISSenLoggerTracer {
	/** @private */
	override protected function tracer(str:String):void {
		if (ExternalInterface.available) {
			ExternalInterface.call("console.log", str);
		}
	}

}
}