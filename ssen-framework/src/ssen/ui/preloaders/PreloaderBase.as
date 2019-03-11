package ssen.ui.preloaders {
import flash.display.Sprite;
import flash.events.Event;
import flash.events.ProgressEvent;

import mx.events.FlexEvent;
import mx.preloaders.IPreloaderDisplay;

/** IPreloaderDisplay 에 대한 Sprite Abstract 구현 */
public class PreloaderBase extends Sprite implements IPreloaderDisplay {

	/* *********************************************************************
	 * abstract : createGraphics, progress, complete, initProgress, initComplete, deconstruct
	 ********************************************************************* */
	/** step 1 : graphics 를 만든다 */
	protected function createGraphics():void {
	}

	/** step 2 : progress 상태에서 graphics 를 컨트롤 한다 */
	protected function progress(event:ProgressEvent):void {
	}

	/** step 3 : data loading 의 끝 */
	protected function complete(event:Event):void {
	}

	/** step 4 : 초기화 progress */
	protected function initProgress(event:FlexEvent):void {
	}

	/** step 5 : 초기화 완료 >> graphics 의 제거 애니메이션 이후, deconstruct 를 호출해 줘야 함 */
	protected function initComplete(event:FlexEvent):void {
	}

	/** step 6 : 리소스 삭제, super.deconstruct() 를 꼭 호출해 줘야 함 */
	protected function deconstruct():void {
		_preloader.removeEventListener(ProgressEvent.PROGRESS, progress);
		_preloader.removeEventListener(Event.COMPLETE, complete);
		_preloader.removeEventListener(FlexEvent.INIT_PROGRESS, initProgress);
		_preloader.removeEventListener(FlexEvent.INIT_COMPLETE, initComplete);
		dispatchEvent(new Event(Event.COMPLETE));
	}

	/* *********************************************************************
	 * 2 flow : initialize, set preloader
	 ********************************************************************* */
	private var _preloader:Sprite;

	/** @private */
	final public function initialize():void {
		createGraphics();
	}

	/** @private */
	final public function set preloader(preloader:Sprite):void {
		_preloader = preloader;
		addPreloaderEvent();
	}

	private function addPreloaderEvent():void {
		_preloader.addEventListener(ProgressEvent.PROGRESS, progress);
		_preloader.addEventListener(Event.COMPLETE, complete);
		_preloader.addEventListener(FlexEvent.INIT_PROGRESS, initProgress);
		_preloader.addEventListener(FlexEvent.INIT_COMPLETE, initComplete);
	}

	/* *********************************************************************
	* 1 set values : set backgroundColor, backgroundAlpha, backgroundImage,
	* 					backgroundSize, stageWidth, stageHeight
	********************************************************************* */
	private var _backgroundAlpha:Number;

	private var _backgroundColor:uint;

	private var _backgroundImage:Object;

	private var _backgroundSize:String;

	private var _stageHeight:Number;

	private var _stageWidth:Number;


	/** @private */
	final public function get backgroundAlpha():Number {
		return _backgroundAlpha;
	}

	final public function set backgroundAlpha(value:Number):void {
		_backgroundAlpha = value;
	}

	/** @private */
	final public function get backgroundColor():uint {
		return _backgroundColor;
	}

	final public function set backgroundColor(value:uint):void {
		_backgroundColor = value;
	}

	/** @private */
	final public function get backgroundImage():Object {
		return _backgroundImage;
	}

	final public function set backgroundImage(value:Object):void {
		_backgroundImage = value;
	}

	/** @private */
	final public function get backgroundSize():String {
		return _backgroundSize;
	}

	final public function set backgroundSize(value:String):void {
		_backgroundSize = value;
	}

	/** @private */
	final public function get stageHeight():Number {
		return _stageHeight;
	}

	final public function set stageHeight(value:Number):void {
		_stageHeight = value;
	}

	/** @private */
	final public function get stageWidth():Number {
		return _stageWidth;
	}

	final public function set stageWidth(value:Number):void {
		_stageWidth = value;
	}



}
}