package ssen.common {

/** 입력한 요소들 중에서 랜덤한 값을 뽑아낸다 */
public class Random {

	private var _props:Array;

	public function Random(... properties:Array) {
		_props = properties;
	}

	/** 문자열 형태로 랜덤값을 가져온다 */
	public function getString():String {
		return String(getProperty());
	}

	/** 숫자 형태로 랜덤값을 가져온다 */
	public function getNumber():Number {
		return Number(getProperty());
	}

	/** 랜덤값을 가져온다 */
	public function getProperty():Object {
		return _props[MathX.rand(0, _props.length - 1)];
	}
}
}