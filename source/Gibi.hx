package;

import flixel.FlxSprite;
import flixel.FlxObject;

class Gibi extends Entity {

	public var infBorn:Int;
	public var supBorn:Int;
	public var dead:Bool = false;
	
	public function new(x:Int, y:Int, side:Int, infBorn:Int, supBorn:Int) {
		super(x, y, side);
		loadGraphic("assets/images/gibi.png", true, 64,32, true);
		animation.add("walk", [0,1,2], 4);
		animation.add("dead", [3,4], 8);
		animation.play("walk");
		velocity.x = 50;
		height = Reg.CELL/2;
		immovable = true;
		//offset.y = Reg.CELL/2;
		setFacingFlip(FlxObject.LEFT,false, false);
		setFacingFlip(FlxObject.RIGHT, true, false);
		facing = FlxObject.RIGHT;
		this.infBorn = infBorn;
		this.supBorn = supBorn;
	}

	override public function update() {
		if(Std.int(x/Reg.CELL) == infBorn
		|| Std.int(x/Reg.CELL) == supBorn) {
			velocity.x = -velocity.x;
			if(velocity.x > 0)
				facing = FlxObject.RIGHT;
			else
				facing = FlxObject.LEFT;

		}
		super.update();
	}

}