package ssen.log {
import flash.utils.getQualifiedClassName;


/** 기본적인 console 에 표시하기 위한 Tracer */
public class ConsoleTracer implements ISSenLoggerTracer {
	/* *********************************************************************
	* parameter
	********************************************************************* */
	/** 각 level 별로 앞에 붙여줄 구분자 */
	public var depths:Vector.<String> = Vector.<String>([ "", "::::::",
														  "::::::::::::",
														  "::::::::::::::::::" ]);

	/** 특정 레벨만 나오도록 할 수 있다 */
	public var levelFilter:Array;

	/** 출력될 로그 형식 */
	public var expression:String = "$t [$c] $M";

	/* *********************************************************************
	* data
	********************************************************************* */
	private var _classNameLong:String;

	private var _classNameShort:String;

	/* *********************************************************************
	* initialize
	********************************************************************* */
	public function ConsoleTracer(levelFilter:Array = null,
								  expression:String = null,
								  depths:Vector.<String> = null) {
		// level filter
		this.levelFilter = levelFilter;

		// expression
		if (expression != null)
			this.expression = expression;

		// depths
		if (depths != null)
			this.depths = depths;
	}

	/* *********************************************************************
	* api
	********************************************************************* */
	/** @inheritDoc */
	final public function init(clazz:Object):void {
		// class name
		_classNameLong = getQualifiedClassName(clazz);
		var arr:Array = _classNameLong.split("::");
		_classNameShort = (arr.length > 1) ? arr[1] : arr[0];
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

		// 문자열 전환 
		var date:Date = new Date;
		var str:String = expression;
		str = str.replace(Expression.TIME_LONG, TraceDateFormatter.long(date));
		str = str.replace(Expression.TIME_SHORT, TraceDateFormatter.short(date));
		str = str.replace(Expression.CLASS_NAME_LONG, _classNameLong);
		str = str.replace(Expression.CLASS_NAME_SHORT, _classNameShort);
		str = str.replace(Expression.MESSAGE, msg.join(" "));
		str = depths[level] + " " + str;

		tracer(str);
	}

	/** @private */
	protected function tracer(str:String):void {
		trace(str);
	}
}
}