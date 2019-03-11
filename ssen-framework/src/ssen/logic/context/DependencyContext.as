package ssen.logic.context {

import ssen.common.getQualifiedClassName2;
import ssen.log.SSenLogger;
import ssen.logic.Executer;
import ssen.logic.Trigger;
import ssen.logic.Wire;
import ssen.logic.logic_internal;

import mx.core.IMXMLObject;

import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.system.System;
import flash.utils.Dictionary;

use namespace logic_internal;
/** context 가 초기화 되었을때 */
[Event(name = "init", type = "flash.events.Event")]
[DefaultProperty("initializer")]
/** 클래스간의 의존 관계를 정의하는 곳 */
public class DependencyContext extends EventDispatcher implements IMXMLObject {

	/* *********************************************************************
	 * singleton
	 ********************************************************************* */
	private static var instance : DependencyContext;

	/** @private singleton instance 를 가져온다 */
	logic_internal static function getInstance() : DependencyContext {
		if (instance == null) {
			throw new Error("not constructed!!!!");
		}
		return instance;
	}

	/* *********************************************************************
	 * parameters
	 ********************************************************************* */
	/** (mxml parameter) 의존 관계 설정 */
	public var mapset : Vector.<map> = new Vector.<map>;

	/** (mxml parameter) map 을 구성하기 이전에 미리 실행되어야 하는 Command 들 */
	public var initializer : Array;

	/** (mxml parameter) useCodePage 를 활성화 할 것인지를 결정한다 */
	public var useCodePage : Boolean = false;

	public function DependencyContext() {
		log = new SSenLogger(this);

		if (instance) {
			throw new Error("Context is singleton!!!");
		}

		dmap = new Dictionary;
		instance = this;
	}

	/** @private */
	final public function initialized(document : Object, id : String) : void {
		System.useCodePage = useCodePage;
		init();
	}

	private function init() : void {
		if (initializer && initializer.length > 0) {
			var trigger : Trigger = new Trigger(mapping, initExeption);
			var executer : Executer = new Executer;
			executer.commands = initializer;
			executer.trigger = trigger;
			executer.exec();
		} else {
			mapping();
		}
	}

	private function mapping(trigger : Trigger = null) : void {
		if (mapset) {
			parseMaps();
		}

		dispatchEvent(new Event(Event.INIT));
	}

	private function initExeption(trigger : Trigger = null) : void {
		dispatchEvent(new ErrorEvent(ErrorEvent.ERROR));
	}

	/* *********************************************************************
	 * dependency interfaces
	 ********************************************************************* */
	/** 매 번 새로운 instance 를 만드는 의존관계 정의 */
	final protected function mapClass(boundary : String, whenAskedFor : Class, useInstantiateOf : Class, named : String = "default") : void {
		mapDefine(boundary, new DefineClass(whenAskedFor, useInstantiateOf), named);
	}

	/** singleton instance 를 만드는 의존관계 정의 */
	final protected function mapSingleton(boundary : String, whenAskedFor : Class, useSingletonOf : Class, named : String = "default") : void {
		mapDefine(boundary, new DefineSingleton(whenAskedFor, useSingletonOf), named);
	}

	/** 이미 만들어진 instance 를 singleton 으로 사용하는 의존관계 정의 */
	final protected function mapSingletonValue(boundary : String, whenAskedFor : Class, useSingletonValueIs : *, named : String = "default") : void {
		mapDefine(boundary, new DefineValue(whenAskedFor, useSingletonValueIs), named);
	}

	final logic_internal function clearMap(boundary : String, whenAskedFor : Class, named : String = "default") : void {
		var f : int = 10;
		var d : int = boundary.length;
		var sp : String;

		var whenAskedFor_str : String = getQualifiedClassName2(whenAskedFor);

		while (--f >= 0) {
			d = boundary.lastIndexOf(".", d);

			if (d < 0) {
				if (hasDefine("*", whenAskedFor_str, named)) {
					clearInstance("*", whenAskedFor_str, named);
					return;
				}
				return;
			}

			sp = boundary.substr(0, d) + ".*";

			if (hasDefine(sp, whenAskedFor_str, named)) {
				clearInstance(sp, whenAskedFor_str, named);
				return;
			}
			d--;
		}
	}

	/** @private 의존 관계로 정의된 instance 를 가져온다 */
	final logic_internal function getInstance(boundary : String, whenAskedFor : Class, named : String = "default") : * {
		var f : int = 10;
		var d : int = boundary.length;
		var sp : String;

		var whenAskedFor_str : String = getQualifiedClassName2(whenAskedFor);

		while (--f >= 0) {
			d = boundary.lastIndexOf(".", d);

			if (d < 0) {
				if (hasDefine("*", whenAskedFor_str, named)) {
					return getInstance2("*", whenAskedFor_str, named);
				}
				return undefined;
			}

			sp = boundary.substr(0, d) + ".*";

			if (hasDefine(sp, whenAskedFor_str, named)) {
				return getInstance2(sp, whenAskedFor_str, named);
			}
			d--;
		}

		return undefined;
	}

	/** @private 의존 관계 정의가 되어 있는지 확인한다 */
	final logic_internal function hasMapping(boundary : String, whenAskedFor : Class, named : String) : Boolean {
		var f : int = 10;
		var d : int = boundary.length;
		var sp : String;

		var whenAskedFor_str : String = getQualifiedClassName2(whenAskedFor);

		while (--f >= 0) {
			d = boundary.lastIndexOf(".", d);

			if (d < 0) {
				if (hasDefine("*", whenAskedFor_str, named)) {
					return true;
				}
				return false;
			}

			sp = boundary.substr(0, d) + ".*";

			if (hasDefine(sp, whenAskedFor_str, named)) {
				return true;
			}
			d--;
		}

		return false;
	}

	/* *********************************************************************
	 * dependency parse
	 ********************************************************************* */
	private var dmap : Dictionary;

	private var log : SSenLogger;

	private function parseMaps() : void {
		if (mapset.length == 0) {
			return;
		}

		var f : int = mapset.length;
		var s : int;
		var m : map;
		var d : dependency;

		while (--f >= 0) {
			m = mapset[f];
			s = m.dependencies.length;

			while (--s >= 0) {
				d = m.dependencies[s];

				if (d.useInstantiateOf) {
					mapDefine(m.boundary, new DefineClass(d.whenAskedFor, d.useInstantiateOf), d.named);
				} else if (d.useSingletonOf) {
					mapDefine(m.boundary, new DefineSingleton(d.whenAskedFor, d.useSingletonOf), d.named);
				} else if (d.useSingletonValueIs) {
					mapDefine(m.boundary, new DefineValue(d.whenAskedFor, d.useSingletonValueIs), d.named);
				}
			}
		}

		mapClass("*", Wire, Wire);

		mapset = null;
	}

	private function mapDefine(space : String, define : Define, named : String) : void {
		var id : String = getName(space, getQualifiedClassName2(define.asked), named);
		dmap[id] = define;
	}

	private function unmapDefine(space : String, define : Define, named : String) : void {
		var id : String = getName(space, getQualifiedClassName2(define.asked), named);
		delete dmap[id];
	}

	private function getName(space : String, asked : String, named : String) : String {
		return space + "::" + asked + "#" + named;
	}

	private function getInstance2(space : String, asked : String, named : String) : * {
		var define : Define = dmap[getName(space, asked, named)];
		return define.getInstance();
	}

	private function clearInstance(space : String, asked : String, named : String) : void {
		var define : Define = dmap[getName(space, asked, named)];
		define.clearInstance();
	}

	private function hasDefine(space : String, asked : String, named : String) : Boolean {
		if (dmap[getName(space, asked, named)]) {
			return true;
		}
		return false;
	}
}
}
class Define {

	public var asked : Class;

	public function getInstance() : * {
		return null;
	}

	public function clearInstance() : void {
	}
}
class DefineClass extends Define {

	public var useClass : Class;

	public function DefineClass(asked : Class, useClass : Class) {
		this.asked = asked;
		this.useClass = useClass;
	}

	override public function getInstance() : * {
		return new useClass();
	}
}
class DefineSingleton extends Define {

	public var useClass : Class;

	private var instance : Object;

	public function DefineSingleton(asked : Class, useClass : Class) {
		this.asked = asked;
		this.useClass = useClass;
	}

	override public function getInstance() : * {
		if (instance != null) {
			return instance;
		}
		instance = new useClass();
		return instance;
	}

	override public function clearInstance() : void {
		instance = null;
	}
}
class DefineValue extends Define {

	public var instance : Object;

	public function DefineValue(asked : Class, instance : *) {
		this.asked = asked;
		this.instance = instance;
	}

	override public function getInstance() : * {
		return instance;
	}
}
