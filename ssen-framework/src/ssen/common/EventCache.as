package ssen.common {
import flash.events.IEventDispatcher;
import flash.utils.Dictionary;

/** 이벤트들을 캐싱하고, 한꺼번에 removeEventListener 로 돌릴 수 있게 해준다 */
public class EventCache implements IDeconstructable {
	private var _cache:Dictionary;

	private var _dispatcher:IEventDispatcher;

	public function EventCache(dispatcher:IEventDispatcher) {
		_cache = new Dictionary;
		_dispatcher = dispatcher;
	}

	/** 모든 이벤트들을 일괄해제 시키고, 이 객체를 파괴한다 */
	public function deconstruct():void {
		if (_cache == null) {
			return;
		}

		var list:Vector.<Listener>;
		var l:Listener;
		var f:int;
		for each (list in _cache) {
			f = list.length;
			while (--f >= 0) {
				l = list[f];
				_dispatcher.removeEventListener(l.type, l.listener,
												l.useCapture);
			}
		}

		_cache = null;
		_dispatcher = null;
	}

	/** 현재 캐싱된 이벤트들을 특정 dispatcher 에 복구 시켜준다 */
	public function restore(dispatcher:IEventDispatcher = null):void {
		if (_cache == null) {
			return;
		}

		if (dispatcher == null) {
			dispatcher = _dispatcher;
		}

		var list:Vector.<Listener>;
		var l:Listener;
		var f:int;
		for each (list in _cache) {
			f = list.length;
			while (--f >= 0) {
				l = list[f];
				dispatcher.addEventListener(l.type, l.listener, l.useCapture,
											l.priority, l.useWeakReference);
			}
		}
	}

	/** 이벤트를 추가 */
	public function add(type:String, listener:Function,
						useCapture:Boolean = false, priority:int = 0,
						useWeakReference:Boolean = false):void {
		var l:Listener = new Listener(type, listener, useCapture, priority,
									  useWeakReference);

		var list:Vector.<Listener>;
		if (_cache[type] === undefined) {
			_cache[type] = new Vector.<Listener>;
		}
		list = _cache[type];
		list.push(l);
	}


	/** 이벤트를 삭제 */
	public function remove(type:String, listener:Function,
						   useCapture:Boolean = false):void {
		if (_cache[type] === undefined) {
			return;
		}

		var list:Vector.<Listener> = _cache[type];
		var l:Listener;

		if (list.length > 1) {
			var f:int = list.length;

			while (--f >= 0) {
				l = list[f];

				if (l.listener === listener && l.useCapture === useCapture) {
					list.splice(f, 1);
					break;
				}
			}
		} else {
			l = list[0];
			delete _cache[type];
		}
	}

}
}