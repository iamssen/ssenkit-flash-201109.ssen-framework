package ssen.log {
import mx.core.IMXMLObject;

[DefaultProperty("tracers")]
/**
 * Debug 용 Logger
 */
public class SSenLogger implements IMXMLObject {
	/** logger 의 전체 활성화 여부 */
	public static var enabled : Boolean = true;
	/** Log 에 사용할 Tracer 들을 지정 */
	public var tracers : Vector.<ISSenLoggerTracer> = Vector.<ISSenLoggerTracer>([new ConsoleTracer]);

	public function SSenLogger(clazz : Object = null, ... tracers : Array) {
		if (tracers.length > 0) {
			this.tracers = Vector.<ISSenLoggerTracer>(tracers);
		}

		if (clazz != null) {
			init(clazz);
		}
	}

	/** @private */
	public function initialized(document : Object, id : String) : void {
		init(document);
	}

	private function init(clazz : Object) : void {
		if (clazz is ISSenLoggerTracer) {
			throw new Error("첫번째 인자가 비정상적으로 입력되었습니다. tracers 이전에 target class 를 입력해주세요.");
		}

		var f : int = -1;
		var max : int = tracers.length;
		while (++f < max) {
			tracers[f].init(clazz);
		}
	}

	/** level 3 : 오류 */
	public function error(... msg) : void {
		if (!enabled) {
			return;
		}
		var f : int = -1;
		var max : int = tracers.length;
		while (++f < max) {
			tracers[f].error(msg);
		}
	}

	/** level 1 : 정보 */
	public function info(... msg) : void {
		if (!enabled) {
			return;
		}
		var f : int = -1;
		var max : int = tracers.length;
		while (++f < max) {
			tracers[f].info(msg);
		}
	}

	/** level 0 : 단순 메세지 */
	public function log(... msg) : void {
		if (!enabled) {
			return;
		}
		var f : int = -1;
		var max : int = tracers.length;
		while (++f < max) {
			tracers[f].log(msg);
		}
	}

	/** level 2 : 경고 */
	public function warning(... msg) : void {
		if (!enabled) {
			return;
		}
		var f : int = -1;
		var max : int = tracers.length;
		while (++f < max) {
			tracers[f].warning(msg);
		}
	}
}
}