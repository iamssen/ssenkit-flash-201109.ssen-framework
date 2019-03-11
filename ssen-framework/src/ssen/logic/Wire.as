package ssen.logic {

import ssen.common.EventCache;
import ssen.common.IDeconstructable;
import ssen.common.getQualifiedClassName2;
import ssen.logic.context.DependencyContext;

import mx.core.IMXMLObject;

import flash.events.Event;
import flash.events.IEventDispatcher;

use namespace logic_internal;
public class Wire implements IMXMLObject, IDeconstructable, IEventDispatcher {

	/* *********************************************************************
	 * properties
	 ********************************************************************* */
	private var _cache : EventCache;

	private var _space : String;

	private var _context : DependencyContext;

	/* *********************************************************************
	 * construct
	 ********************************************************************* */
	public function Wire(document : Object = null) {
		_context = DependencyContext.getInstance();
		_cache = new EventCache(this);

		if (document) {
			defineSpace(document);
		}
	}

	private function defineSpace(document : Object) : void {
		_space = getQualifiedClassName2(document);
	}

	public function initialized(document : Object, id : String) : void {
		defineSpace(document);
	}

	/* *********************************************************************
	 * IDeconstructable
	 ********************************************************************* */
	/** @inheritDoc */
	public function deconstruct() : void {
		_context = null;
		_cache.deconstruct();
		_cache = null;
	}

	/* *********************************************************************
	 * implement IEventDispatcher
	 ********************************************************************* */
	final public function addEventListener(type : String, listener : Function, useCapture : Boolean = false, priority : int = 0, useWeakReference : Boolean = false) : void {
		_cache.add(type, listener, useCapture, priority, useWeakReference);

		if (_context != null) {
			_context.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
	}

	final public function dispatchEvent(event : Event) : Boolean {
		return _context.dispatchEvent(event);
	}

	final public function hasEventListener(type : String) : Boolean {
		return _context.hasEventListener(type);
	}

	final public function removeEventListener(type : String, listener : Function, useCapture : Boolean = false) : void {
		_cache.remove(type, listener, useCapture);

		if (_context != null) {
			_context.removeEventListener(type, listener, useCapture);
		}
	}

	final public function willTrigger(type : String) : Boolean {
		return _context.willTrigger(type);
	}

	/* *********************************************************************
	 * Location
	 ********************************************************************* */
	/** mapping 시킨 instance 를 가져온다 */
	final public function getInstance(asked : Class, named : String = "default") : * {
		return _context.getInstance(_space, asked, named);
	}

	final public function clearInstance(asked : Class, named : String = "default") : void {
		_context.clearMap(_space, asked, named);
	}

	/** mapping 되어 있는지 확인한다 */
	final public function hasMapping(asked : Class, named : String = "default") : Boolean {
		return _context.hasMapping(_space, asked, named);
	}
}
}