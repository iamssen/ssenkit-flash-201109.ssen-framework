package ssen.common {

/**
 * Date 관련 util
 */
public class DateX {
	/** 현재 시간을 epoch time 형식으로 가져온다 */
	public static function EPOCH_TIME():int {
		return new Date().time / 1000;
	}

	/** epoch time 을 date 형식으로 변환한다 */
	public static function EPOCH_TIME2Date(epoch:int, date:Date = null):Date {
		if (!date)
			date = new Date;
		date.time = epoch * 1000;
		return date;
	}

	/** date 형식을 epoch time 으로 바꾼다 */
	public static function EPOCH_TIMEFromDate(date:Date):int {
		return date.time / 1000;
	}
}
}
