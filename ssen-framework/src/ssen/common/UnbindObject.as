package ssen.common {
import flash.events.EventDispatcher;


/** addEventListener 로 걸린 이벤트들을 deconstruct() 로 일괄 해제할 수 있다 */
public class UnbindObject extends EventDispatcher implements IDeconstructable {

	private var _cache:EventCache;

	public function UnbindObject() {
		_cache = new EventCache(this);
	}

	/** @inheritDoc */
	public function deconstruct():void {
		_cache.deconstruct();
		_cache = null;
	}

	/* *********************************************************************
	* override EventDispatcher
	********************************************************************* */
	/** @private */
	override public function addEventListener(type:String, listener:Function,
											  useCapture:Boolean = false,
											  priority:int = 0,
											  useWeakReference:Boolean = false):void {
		_cache.add(type, listener, useCapture, priority, useWeakReference);
		super.addEventListener(type, listener, useCapture, priority,
							   useWeakReference);
	}

	/** @private */
	override public function removeEventListener(type:String, listener:Function,
												 useCapture:Boolean = false):void {
		_cache.remove(type, listener, useCapture);
		super.removeEventListener(type, listener, useCapture);
	}

}
}