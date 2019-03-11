package ssen.airconnection {
import ssen.common.Enumeration;

/** WebConnection.send option */
public class SendTo extends Enumeration {
	/** AIR 로만 메세지 보내기 */
	public static const AIR_ONLY:SendTo = new SendTo("airOnly");

	/** AIR 와 Web 모두 메세지 보내기 */
	public static const AIR_AND_WEB:SendTo = new SendTo("airAndWeb");

	/** Web 으로만 보내기 */
	public static const WEB_ONLY:SendTo = new SendTo("webOnly");

	public function SendTo(annotation:String = "") {
		super(annotation);
	}
}
}