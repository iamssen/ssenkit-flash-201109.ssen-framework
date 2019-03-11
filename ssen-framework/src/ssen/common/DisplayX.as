package ssen.common {
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.geom.Point;

/**
 * Display 관련 util
 */
public class DisplayX {
	/** prev 객체의 다음 위치에 배치한다 */
	public static function nextPos(prev:DisplayObject, object:DisplayObject,
								   br:Boolean = false, spaceX:int = 5,
								   spaceY:int = 5):void {
		if (br) {
			object.x = prev.x;
			object.y = prev.y + prev.height + spaceY;
		} else {
			object.x = prev.x + prev.width + spaceX;
			object.y = prev.y;
		}
	}

	/** 객체의 stage 위치를 가져온다 */
	public static function getStagePos(object:DisplayObject):Point {
		if (!object.parent)
			return new Point(0, 0);
		var p:Point = new Point;
		p.x = object.x;
		p.y = object.y;
		return object.parent.localToGlobal(p);
	}

	/** 특정 객체를 stage 기준으로 위치시킨다 */
	public static function setStagePos(object:DisplayObject, x:Number,
									   y:Number):void {
		var p:Point = new Point;
		p.x = x;
		p.y = y;
		p = object.parent.globalToLocal(p);
		object.x = p.x;
		object.y = p.y;
	}

	/** 특정 객체를 BitmapData 로 캡쳐한다 */
	public static function capture(object:DisplayObject):BitmapData {
		var bitmapData:BitmapData = new BitmapData(object.width, object.height,
												   true, 0x00ffffff);
		bitmapData.draw(object);
		return bitmapData;
	}

	/** 객체들을 정렬한다 */
	public static function align(objecties:Array, startX:int = 0,
								 startY:int = 0, maxX:int = 400, spaceX:int = 5,
								 spaceY:int = 10, valign:String = "middle"):void {
		var d:DisplayObject;
		var f:int = -1;
		var nx:Number = startX;
		var ny:Number = startY;
		var nh:Number = 0;
		var va:Boolean = valign != "top";
		if (va) {
			var line:Array = new Array;
			var s:int;
		}
		while (++f < objecties.length) {
			d = objecties[f];
			d.x = nx;
			d.y = ny;

			if (va)
				line.push(d);
			if (d.height > nh)
				nh = d.height;
			nx += d.width + spaceX;
			if (nx > maxX) {
				if (va) {
					if (valign == "middle") {

						s = line.length;
						while (--s >= 0) {
							d = line[s];
							d.y += (nh >> 1) - (d.height >> 1);
						}
					} else if (valign == "bottom") {
						s = line.length;
						while (--s >= 0) {
							d = line[s];
							d.y += nh - d.height;
						}
					}
					line.length = 0;
				}

				nx = startX;
				ny += nh + spaceY;
				nh = 0;
			}
		}
	}
}
}
