package ssen.log {
import spark.components.TextArea;

/** Text Area Base 의 console, 화면에 놓아두면 VirtualTracer 의 trace log 를 찍어줌 */
public class TextAreaConsole extends TextArea {
	public function TextAreaConsole() {
		VirtualConsoleDispatcher.getInstance().addEventListener(VirtualConsoleEvent.TRACE_MESSAGE,
																traceMessage);
	}

	private function traceMessage(event:VirtualConsoleEvent):void {
		appendText(event.text + "\n");
	}
}
}