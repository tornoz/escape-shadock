package;

import flixel.FlxSprite;
import flixel.FlxObject;

class Button extends Entity {

	public var targets:Array<Entity>;
	public var state:Bool = false;

	public function new(x:Int, y:Int, side:Int, targets:Array<Entity>, ?init:Bool = false) {
		super(x, y, side);
		this.targets = targets;
		loadGraphic("assets/images/button.png", true, 32,16, true);
		animation.add("off", [0]);
		animation.add("on", [1]);
		this.state = init;

	}

	override public function update() {
		
	}

}