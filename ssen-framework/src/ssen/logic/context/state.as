package ssen.logic.context {

final public class state {
	public var name:String;
	
	public var startup:Vector.<command>;
	
	public var shutdown:Vector.<command>;
	
	public var triggers:Vector.<trigger>;
}
}