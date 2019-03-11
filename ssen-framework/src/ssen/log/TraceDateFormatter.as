package ssen.log {
import mx.formatters.DateFormatter;

/** 날짜 포맷팅 */
public class TraceDateFormatter {
	private static var _long:DateFormatter;

	private static var _short:DateFormatter;

	/** 길게 보여주기 */
	public static function long(date:Date):String {
		if (_long == null) {
			_long = new DateFormatter;
			_long.formatString = "MM/DD A LL:NN:SS";
		}

		return _long.format(date);
	}

	/** 짧게 보여주기 */
	public static function short(date:Date):String {
		if (_short == null) {
			_short = new DateFormatter;
			_short.formatString = "LL:NN:SS";
		}

		return _short.format(date);
	}
}
}