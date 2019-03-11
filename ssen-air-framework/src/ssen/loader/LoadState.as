package ssen.loader {
import ssen.common.Enumeration;

/** 로드의 상태 */
public class LoadState extends Enumeration {
	/** 준비 상태, 아무런 작동도 시작하지 않았음 */
	public static const READY:LoadState = new LoadState("ready");

	/** 진행 중 중지된 상태 */
	public static const PAUSED:LoadState = new LoadState("paused");

	/** 진행 중 */
	public static const LOAD:LoadState = new LoadState("load");

	/** 프로세스 처리 등의 이유로 잠시 대기 중 */
	public static const WAIT:LoadState = new LoadState("wait");

	/** 완료 되었음 */
	public static const COMPLETE:LoadState = new LoadState("complete");

	/** 에러 발생으로 중지 되었음 */
	public static const ERROR:LoadState = new LoadState("error");

	public function LoadState(annotation:String = "") {
		super(annotation);
	}

	/** 문자열로 State 를 가져옴 */
	public static function getState(str:String):LoadState {
		switch (str) {
			case "ready":
				return READY;
				break;
			case "paused":
				return PAUSED;
				break;
			case "load":
				return LOAD;
				break;
			case "wait":
				return WAIT;
				break;
			case "complete":
				return COMPLETE;
				break;
			case "error":
				return ERROR;
				break;
		}
		return null;
	}
}
}