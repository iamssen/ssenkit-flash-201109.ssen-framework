package ssen.log {
import com.demonsters.debugger.MonsterDebugger;

import flash.utils.getQualifiedClassName;

/** 몬스터 디버거를 활용 */
public class MonsterDebuggerTracer implements ISSenLoggerTracer {
	/* *********************************************************************
	* parameter
	********************************************************************* */
	/** 레벨별 색상 */
	public var colors:Vector.<uint> = Vector.<uint>([ 0xc4baba, 0x393333,
													  0xd60000, 0x1700c6 ]);

	/** 특정 레벨만 나오도록 할 수 있다 */
	public var levelFilter:Array;

	/* *********************************************************************
	* data
	********************************************************************* */
	private var _class:Object;

	/* *********************************************************************
	* initialize
	********************************************************************* */
	public function MonsterDebuggerTracer(levelFilter:Array = null) {
		// level filter
		this.levelFilter = levelFilter;
	}

	/* *********************************************************************
	* api
	********************************************************************* */
	/** @inheritDoc */
	final public function init(clazz:Object):void {
		_class = clazz;
	}

	/** @inheritDoc */
	final public function error(msg:Array):void {
		logger(3, msg);
	}

	/** @inheritDoc */
	final public function info(msg:Array):void {
		logger(1, msg);
	}

	/** @inheritDoc */
	final public function log(msg:Array):void {
		logger(0, msg);
	}

	/** @inheritDoc */
	final public function warning(msg:Array):void {
		logger(2, msg);
	}

	/* *********************************************************************
	* utils
	********************************************************************* */
	private function logger(level:int, msg:Array):void {
		// 레벨 필터링 
		if (levelFilter != null && levelFilter.indexOf(level) > -1) {
			return;
		}

		// 연관배열일 경우 파싱 
		var f:int = -1;
		var max:int = msg.length;
		var obj:Object;
		var clazz:String;
		while (++f < max) {
			clazz = getQualifiedClassName(msg[f]);
			if (clazz == "Object" || clazz == "flash.utils::Dictionary") {
				msg[f] = objectParser(msg[f]);
			}
		}

		tracer(level, msg.join(" "));
	}

	private function tracer(level:int, str:String):void {
		// 레벨 필터링 
		if (levelFilter != null && levelFilter.indexOf(level) > -1) {
			return;
		}

		MonsterDebugger.trace(_class, str, "", "", colors[level]);
	}

}
}