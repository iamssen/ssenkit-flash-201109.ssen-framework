package ssen.logic {
import ssen.common.IDeconstructable;
import ssen.logic.context.DependencyContext;

use namespace logic_internal;

public class Actor implements IDeconstructable {
	
	private var _wire:Wire;
	
	/** wire 가 만들어졌는지 확인한다 */
	final protected function hasWire():Boolean {
		return _wire != null;
	}
	
	final protected function get wire():Wire {
		if (!hasWire()) {
			if (DependencyContext.getInstance()) {
				_wire = new Wire(this);
			}
		}
		return _wire;
	}
	
	/** @inheritDoc */
	public function deconstruct():void {
		if (_wire) {
			_wire.deconstruct();
			_wire = null;
		}
	}

}
}