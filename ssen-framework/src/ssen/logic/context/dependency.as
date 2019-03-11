package ssen.logic.context {

final public class dependency {
	public var whenAskedFor:Class;
	
	public var useInstantiateOf:Class;
	
	public var useSingletonOf:Class;
	
	public var useSingletonValueIs:*;
	
	public var named:String = "default";
}
}