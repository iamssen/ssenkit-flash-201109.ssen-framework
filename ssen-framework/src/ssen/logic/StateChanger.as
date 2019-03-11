package ssen.logic {
import ssen.logic.context.FlowContext;

use namespace logic_internal;

/** @private State 전환을 위한 Command */
final public class StateChanger extends Command {
	
	private var to:String;
	
	private var context:FlowContext;
	
	public function StateChanger(context:FlowContext, to:String) {
		this.context = context;
		this.to = to;
	}
	
	override protected function execute():void {
		context.setCurrentState(to);
		next();
	}
	
	/** @inheritDoc */
	override public function deconstruct():void {
		context = null;
		to = null;
		super.deconstruct();
	}


}
}