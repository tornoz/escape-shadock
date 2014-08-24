package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.group.FlxTypedGroup;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxMath;
import flixel.util.FlxRandom;
import flixel.addons.display.FlxBackdrop;
import flixel.FlxObject;
import flixel.tile.FlxTileblock;
import flixel.FlxSubState;
import openfl.Assets;
import flixel.tile.FlxTilemap;
import flixel.util.FlxPoint;
import flixel.animation.FlxAnimation;
/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	
	
	private var map:FlxTilemap;
	private var map2:FlxTilemap;
	private var player:Player;
	private var objects:FlxGroup;
	private var objects1:FlxGroup;
	private var objects2:FlxGroup;
	private var spikes:FlxGroup;
	private var portals:FlxGroup;
	private var platforms:FlxTypedGroup<Entity>;
	private var buttons:FlxTypedGroup<Button>;
	private var eggs:FlxTypedGroup<Entity>;
    private var pumps:FlxTypedGroup<Entity>;
    private var gibis:FlxTypedGroup<Gibi>;
	private var switched:Bool = false;
	private var justSwitched:Bool = false;
	private var eggJustSwitched:Bool = false;
	private var pumpAnim:FlxAnimation;
	private var lost:Bool = false;
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		
		FlxG.mouse.visible = false;
		if(Reg.currentLevel > Reg.maxLevel) {
			FlxG.resetGame();
		}

		var level:Levels = Levels.getLevel(Reg.currentLevel);

		map = new FlxTilemap();
	
		map.loadMap(level.csvData1, "assets/images/tileset.png", 32,32,0,0,1,2);
		add(map);

		map2 = new FlxTilemap();
		map2.loadMap(level.csvData2, "assets/images/tileset.png", 32,32,0,0,1,2);
		
		player = new Player(Reg.CELL * 20, Reg.CELL * 10);
		
		add(player);

		objects = new FlxGroup();

		objects1 = new FlxGroup();
		objects2 = new FlxGroup();
		portals = new FlxGroup();
		eggs = new FlxTypedGroup<Entity>();
		pumps = new FlxTypedGroup<Entity>();

		gibis = new FlxTypedGroup<Gibi>();
		platforms = new FlxTypedGroup<Entity>();
		buttons = new FlxTypedGroup<Button>();
		add(portals);
		add(eggs);
		add(pumps);
		add(gibis);
		add(platforms);
		add(buttons);
		for(portal in level.portals) {
			
			portal.loadGraphic("assets/images/portal.png", true, 32,32, true);
			portal.animation.add("iddle", [0,1,2],6);
			portal.animation.play("iddle");
			
			portals.add(portal);
			objects.add(portal);
		}
		for(egg in level.eggs) {
			egg.loadGraphic("assets/images/egg.png", true, 32,32, true);
			egg.immovable = true;
			eggs.add(egg);
			if(egg.side == 1) {
				objects1.add(egg);
			}
			else if(egg.side == 2) {
				objects2.add(egg);
			}
			else {
				objects.add(egg);
			}
				
		}
		
		for(pump in level.pumps) {
			pump.loadGraphic("assets/images/pump.png", true, 64,64, true);
			pump.width = Reg.CELL;
			if(!pump.flipX)
				pump.offset.x = Reg.CELL;
			pump.immovable = true;
			pump.animation.add("pump", [1,2,3,3,2,1], 10, false);
			pump.animation.add("iddle", [0]);
			pumps.add(pump);
			objects.add(pump);
		}
		
		for(gibi in level.gibis) {
			gibi.offset.y = Reg.CELL/2;
			gibi.y += Reg.CELL/2;
			objects.add(gibi);
			gibis.add(gibi);
		}
		
		for(platform in level.platforms) {
			platform.loadGraphic("assets/images/platform.png", true, 32,16, true);
			platform.immovable = true;
		  
			platforms.add(platform);
		}
		
		for(button in level.buttons) {
			buttons.add(button);
			button.y += Reg.CELL/2;
			for(entity in button.targets) {
				if(!button.state) {
					platforms.remove(entity);
				}
			}
			if(button.state) {
				button.animation.play("on");
			}
			
		}
		
		objects.add(player);
		
		FlxG.camera.setBounds(0, 0, 800, 600, true);
		
		super.create();
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		if (FlxG.keys.justPressed.SPACE) {
			FlxG.overlap(player, pumps, doPump);
			FlxG.overlap(player, buttons, pressButton);
		}
		if (FlxG.keys.justPressed.ESCAPE) {
			die();
			
		}
		if(lost && player.animation.get("dead").finished) {
			FlxG.resetState();
		}
		if(!switched) {
			FlxG.collide(map, objects);
		}
		else {
			FlxG.collide(map2, objects);
		}
		FlxG.collide(player, eggs);
		FlxG.collide(map2, objects2);
		FlxG.collide(map, objects1);
		FlxG.collide(pumps,  eggs, stopEgg);
		
		FlxG.collide(platforms, eggs);
		if(!FlxG.overlap(eggs, portals, eggPortal)) {
			eggJustSwitched = false;
		}
		
		if (!FlxG.overlap(player, portals, enterPortal)) {
		
			justSwitched = false;
		}

		for(gibi in gibis) {
			if((gibi.side == 2) == switched) {
				gibi.alpha = 1;
			}
			else {
				gibi.alpha = 0;
			}
			
		}
		for(platform  in platforms) {
			if((platform.side == 2) == switched) {
				FlxG.collide(platform, player);
				platform.alpha = 1;
			}
			else {
				platform.alpha = 0;
			}
			
		}
		for(button  in buttons) {
			if((button.side == 2) == switched) {
				button.alpha = 1;
			}
			else {
				button.alpha = 0;
			}
			
		}
		for (egg in eggs) {
			if(egg.velocity.x == 0 && egg.velocity.y == 0) {
				stopEgg(null, egg);
			}
			if((egg.side == 2) == switched) {
				//egg.alpha = 1;
				egg.color = FlxColor.WHITE;
			}
			else {
				//egg.alpha = 0.5;
				egg.color = FlxColor.BLACK;
			}
			egg.angle = egg.angle + egg.velocity.x/20;
			if(egg.x/Reg.CELL <= 0 || egg.x/Reg.CELL >= 25) {
				FlxG.sound.play("assets/sounds/win.wav", 1, false,false);
				Reg.currentLevel++;
				FlxG.resetState();
			}
		}
		
		if(pumpAnim != null && pumpAnim.finished) {
			player.alpha = 1;
			for (pump in pumps) {
				pump.animation.play("iddle");
			}
			player.wait = false;
			pumpAnim = null;
		}
		FlxG.overlap(gibis, eggs, gibicide);
		FlxG.overlap(gibis, player, gibihit);
		
		super.update();



	}

	public function pressButton(player:Dynamic, button:Dynamic) {

		if((button.side ==2) == switched) {
			var targets:Array<Entity> = button.targets;
			if(button.state) {
				for(entity in targets) {
					platforms.remove(entity);
				}
				button.state = false;
				button.animation.play("off");
			
			}
			else {
				for(entity in targets) {
					platforms.add(entity);
				}
				button.state = true;
					button.animation.play("on");
			}
		}
	}
	
	public function gibihit(gibi:Dynamic, player:Dynamic) {
		if((gibi != null) && ((gibi.side ==2) == switched) && !gibi.dead && !lost) 
			die();

	}

	public function die() {
		player.animation.play("dead");
		FlxG.sound.play("assets/sounds/hit.wav", 1, false,false);
		player.wait = true;
		lost = true;
	}

	public function gibicide(gibi:Dynamic, egg:Dynamic) {
		gibi.animation.play("dead");
		gibi.solid = false;
		gibi.dead = true;
		gibi.velocity.x = 0;
		if(egg.velocity.x > 0)
			egg.velocity.x = 200;
		else
			egg.velocity.x = -200;
		//gibis.remove(gibi);
	}

	public function stopEgg(pump:Dynamic, egg:Dynamic) {
		egg.velocity.x = 0;
		if(pump != null && egg.x < pump.x) {
			egg.x = Std.int(egg.x/Reg.CELL) * Reg.CELL;
		}
		else if(pump != null && egg.x > pump.x) {
			//egg.x = (Std.int(egg.x/Reg.CELL)+1) * Reg.CELL;
		}
		egg.immovable = true;
		egg.acceleration.y = 0;
	}

	public function eggPortal(egg:Dynamic, portal:Dynamic) {
		if(!eggJustSwitched) {
			if(egg.side == 1) {
				objects1.remove(egg);
				objects2.add(egg);
				egg.side = 2;
			}
			else {
				objects2.remove(egg);
				objects1.add(egg);
				egg.side = 1;
			}
			eggJustSwitched = true;
		
		}
	}
	
	public function doPump(player:Dynamic, pump:Dynamic) {
		for(egg in eggs) {
			if(egg.y == pump.y + Reg.CELL
			&& Math.abs(egg.x/Reg.CELL - pump.x/Reg.CELL) == 1) {
				
				
				egg.immovable = false;
				egg.velocity.x = -200  * (pump.x/Reg.CELL - egg.x/Reg.CELL);
				egg.acceleration.y = 900; 
			}
		}
		FlxG.sound.play("assets/sounds/pump.wav", 1, false,false);
		player.wait = true;
		pump.animation.play("pump");
		pumpAnim = pump.animation.get("pump");
		player.alpha = 0;
	}

	
	public function enterPortal(player:Dynamic, portal:Dynamic):Void {
		
		if(!justSwitched) {
			if(switched) {
				replace(map2,map);
				switched = false;
				
			}
			else {
				replace(map,map2);
				switched = true;
			}
			justSwitched = true;
		} 
		
		
	}

}