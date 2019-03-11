package ssen.airconnection {

/** AIR Connection 설정 */
public interface IConnectionConfig {
	/** target 이 되는 air app 의 id */
	//function get appId():String;
	/** target 이 되는 swf 의 domain */
	//function get domain():String;
	/** connection prefix name */
	function get connectionName():String;
	/** 총 channel 숫자, 한 화면에 들어갈 수 있는 swf 의 최대 수량을 적으면 됨 */
	function get channels():int;
}
}