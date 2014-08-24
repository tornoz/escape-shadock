package;



import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxTypedGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.gamepad.XboxButtonID;
import flixel.ui.FlxButton;
import flixel.ui.FlxVirtualPad;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;


class Player extends FlxSprite {

	private var jumpPower:Int = 350;
	public var wait = false;
	
	public var isReadyToJump:Bool = true;
	public var doubleJump : Bool = true;
	public var timePress:Float = 0;
	
	public function new(X:Int, Y:Int){
		super(X, Y);
		
		setFacingFlip(FlxObject.LEFT,true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);
		
		loadGraphic("assets/images/player.png", true, 32,64);
		
		animation.add("idle", [0]);
		animation.add("run", [1, 2,3], 6);
		animation.add("jump", [4]);
		animation.add("fall", [5]);
		animation.add("dead", [6,7],4, false);
		// Basic player physics
		var runSpeed:Int = 160;
		drag.x = runSpeed * 8;
		acceleration.y = 840;
		maxVelocity.set(runSpeed, jumpPower);
	}

	
	override public function update():Void {
		acceleration.x = 0;
		
		if(velocity.y == 0 && doubleJump == false) {
		    doubleJump = true;
	    }
		// INPUT
		if (FlxG.keys.pressed.LEFT && !wait)	{
			
			moveLeft();
		}
		else if (FlxG.keys.pressed.RIGHT && !wait) {
			moveRight();
		}
		if (FlxG.keys.justPressed.X ||FlxG.keys.justPressed.UP  ){
			jump();
			
			timePress = 0;
			if(isTouching(FlxObject.FLOOR)) {
		       doubleJump = true;
	        }
	    }
		else if((FlxG.keys.pressed.X  ||FlxG.keys.pressed.UP )&& timePress != -1) {
			timePress += FlxG.elapsed;
			if(timePress > 0.2) {
				velocity.y += -jumpPower/5;
				timePress = -1;
			}
		}
		
		if(!wait) {
			if (velocity.y < 0){
				
				animation.play("jump");
	
			}
			else if (velocity.y > 0){
				animation.play("fall");
			}
			else if (velocity.x == 0){
				animation.play("idle");
			}
			else if (velocity.x != 0){
				animation.play("run");
			}
		}

		
	    
		super.update();
	}

	function moveLeft():Void {
		facing = FlxObject.LEFT;
		acceleration.x -= drag.x;
	}
	function moveRight():Void{
		facing = FlxObject.RIGHT;
		acceleration.x += drag.x;
	}
	function jump():Void	{
		if (isReadyToJump && (velocity.y == 0) || doubleJump)
			{
				FlxG.sound.play("assets/sounds/jump.wav", 1, false,false);
				velocity.y = -jumpPower;
				if(doubleJump)
					doubleJump = false;
			}
	}


}