package ssen.common {

import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.display.Shape;

/**
 * 테스트에 사용하는 컨텐츠들을 만든다
 * @author SSen
 */
public class TestContents {
	/** 스크롤 테스트에 사용할 큰 박스를 만든다 */
	public static function getLineBox():DisplayObject {
		var s:Shape = new Shape();
		var g:Graphics = s.graphics;
		var w:int = MathX.rand(600, 4500);
		var h:int = MathX.rand(600, 4500);
		g.beginFill(MathX.rand(0x000000, 0xffffff));
		g.drawRect(0, 0, w, h);
		g.endFill();
		g.beginFill(0xC5D5FC);
		g.drawRect(0, 0, w, 10);
		g.drawRect(0, 10, 10, h - 20);
		g.drawRect(w - 10, 10, 10, h - 20);
		g.drawRect(0, h - 10, w, 10);
		g.endFill();

		return s;
	}

	/** 스크롤 테스트에 사용할 장문의 글을 만든다 */
	public static function getLongText():String {
		var str:String = "START\n";
		var rand:int = MathX.rand(10, 500);
		var f:int = -1;
		var a:String;
		var i:int;
		while (++f < rand) {
			i = MathX.rand(10, 300);
			a = "";
			while (--i >= 0) {
				a += "A";
			}
			str += f + a + "X\n";
		}
		str += "END";
		return str;
	}
}
}
