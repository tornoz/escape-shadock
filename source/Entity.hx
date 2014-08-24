package;

import flixel.FlxSprite;

class Entity extends FlxSprite {

	//0 both
	public var side:Int;

	public function new(x:Int, y:Int, ?side:Int = 0, ?flip:Bool = false) {
		super(Reg.CELL * x, Reg.CELL * y);
		this.side = side;
		this.flipX = flip;
	}

}