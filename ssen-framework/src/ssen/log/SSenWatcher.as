package ssen.log {
import mx.binding.utils.BindingUtils;
import mx.core.IMXMLObject;

[DefaultProperty("capture")]

/** Binding 문자열로 지정된 요소들이 변경될때마다 Log 를 남긴다 */
public class SSenWatcher implements IMXMLObject {
	/** Log 에 사용할 Tracer 들을 지정 */
	public var tracers:Vector.<ISSenLoggerTracer> =
		Vector.<ISSenLoggerTracer>([ new ConsoleTracer ]);

	/** 캡쳐 대상이 될 Bindable 문장 */
	[Bindable]
	public var capture:String;

	public function SSenWatcher(clazz:Object = null, ... tracers:Array) {
		if (tracers.length > 0)
			this.tracers = Vector.<ISSenLoggerTracer>(tracers);

		if (clazz != null) {
			init(clazz);
		}
	}

	/** @private */
	public function initialized(document:Object, id:String):void {
		init(document);
		BindingUtils.bindSetter(setter, this, "capture");
	}

	private function init(clazz:Object):void {
		var f:int = -1;
		var max:int = tracers.length;
		while (++f < max) {
			tracers[f].init(clazz);
		}
	}

	private function setter(msg:String):void {
		var f:int = -1;
		var max:int = tracers.length;
		while (++f < max) {
			tracers[f].log([ msg ]);
		}
	}
}
}