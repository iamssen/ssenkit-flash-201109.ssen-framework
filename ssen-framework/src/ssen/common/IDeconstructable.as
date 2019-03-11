package ssen.common {

/** 수동 자원 파괴가 가능한 오브젝트 인터페이스 */
public interface IDeconstructable {
	/** 내부적으로 사용된 자원들을 파괴한다 */
	function deconstruct():void;
}
}