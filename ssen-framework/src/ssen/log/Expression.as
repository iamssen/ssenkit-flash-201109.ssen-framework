package ssen.log {

/** 문자 표현식 */ 
public class Expression {
	/** Date 를 길게 표시 */
	public static const TIME_LONG:String = "$T";

	/** Date 를 짧게 표시 */
	public static const TIME_SHORT:String = "$t";

	/** ClassName 을 길게 표시 */
	public static const CLASS_NAME_LONG:String = "$C";

	/** ClassName 을 짧게 표시 */
	public static const CLASS_NAME_SHORT:String = "$c";

	/** log 메세지 */
	public static const MESSAGE:String = "$M";
}
}