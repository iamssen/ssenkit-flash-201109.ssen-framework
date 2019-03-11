package ssen.log {

/** Tracer Interface : SSenLog 에서 사용 가능한 Tracer 의 인터페이스 */
public interface ISSenLoggerTracer {

	/**
	 * 초기화
	 * @param clazz log 대상이 되는 Class 또는 Object
	 */
	function init(clazz:Object):void;
	/** 단순 메세지 */
	function log(msg:Array):void;
	/** level 1 : 정보 메세지 */
	function info(msg:Array):void;
	/** level 2 : 경고 메세지 */
	function warning(msg:Array):void;
	/** level 3 : 오류 메세지 */
	function error(msg:Array):void;
}
}