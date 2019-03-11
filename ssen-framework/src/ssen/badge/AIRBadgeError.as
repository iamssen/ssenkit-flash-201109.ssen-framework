package ssen.badge {

public class AIRBadgeError extends Error {
	public static const INVALID_UPDATE_URL:AIRBadgeError = new AIRBadgeError("update url 이 정확하지 않습니다");

	public static const INVALID_ARGUMENT:AIRBadgeError = new AIRBadgeError("잘못된 argument 를 입력, A-Za-z0-9:-= 만 입력 가능");

	public static const STATE_NOT_CHECKED:AIRBadgeError = new AIRBadgeError("state 를 체크하지 않았습니다!!!");
	
	public static const UNAVAILABLE:AIRBadgeError = new AIRBadgeError("air 를 사용할 수 없는 환경입니다.");

	public function AIRBadgeError(message:String = "") {
		super(message);
	}
}
}