package;
import openfl.Assets;
class Levels {
	public var csvData1:String;
	public var csvData2:String;
	public var eggs:Array<Entity>;
	public var pumps:Array<Entity>;
	public var portals:Array<Entity>;
	public var spikes:Array<Entity>;
	public var gibis:Array<Gibi>;
	public var buttons:Array<Button>;
	public var platforms:Array<Entity>;
	
	public function new(path:String, eggs:Array<Entity>, pumps:Array<Entity>, portals:Array<Entity>, spikes:Array<Entity>, gibis:Array<Gibi>, buttons:Array<Button>, platforms:Array<Entity>) {
			csvData1 = Assets.getText(path);
			csvData2 = Assets.getText(path + ".2");
			this.eggs = eggs;
			this.pumps = pumps;
			this.portals = portals;
			this.spikes = spikes;
			this.gibis = gibis;
			this.buttons = buttons;
			this.platforms = platforms;
		
	}

	public static function getLevel(number:Int):Levels {
		switch(number) {
			case 0:
				return new Levels(
					"assets/data/level0.txt",
					[new Entity(22,3,2)],
					[new Entity(23,2,0)],
					[new Entity(8,9,0)],
					[],
					[],[],[]);
			case 1:
				return new Levels(
					"assets/data/level1.txt",
					[new Entity(12,3,1)],
					[new Entity(11,2,0, true), new Entity(1,11,0, true), new Entity(23,6,0)],
					[new Entity(5,8,0), new Entity(18,4,0),new Entity(4,16,0)],
					[],
					[new Gibi(7,12,1, 3,15), new Gibi(18,7,2,8,21)],[],[]);
			case 2:
					var platforms1 = [new Entity(9,13,1), new Entity(10,13,1), new Entity(11,13,1)];
					var platforms2 = [new Entity(9,8,1), new Entity(10,8,1), new Entity(11,8,1)];
					var platforms3 = [new Entity(9,4,1), new Entity(10,4,1), new Entity(11,4,1)];
				return new Levels(
					"assets/data/level3.txt",
					[new Entity(3,3,1)], //eggs
					[new Entity(2,2,0, true), new Entity(8,15,0,true)], //pumps,
					[new Entity(2,9),new Entity(21,4)], //portals
					[], //spikes
					[], //gibis
					[new Button(3,12,1,platforms1, true), new Button(21,7,2,platforms2, true), new Button(6,3,1,platforms3,true)], //platforms
					platforms1.concat(platforms2).concat(platforms3)
				);

			case 3 :
				var platforms = [new Entity(13,9,2), new Entity(14,9,2), new Entity(15,9,2)];
				return new Levels(
					"assets/data/level2.txt",
					[new Entity(15,3,1)], //eggs
					[new Entity(16,2,0), new Entity(1,4,0,true), new Entity(19,7,0), new Entity(1,10,0,true)], //pumps,
					[new Entity(5,16,0),new Entity(9,5,0), new Entity(5,3)], //portals
					[], //spikes
					[new Gibi(9,11,2,5,12)], //gibis
					[new Button(3,16,1,platforms)], //platforms
					platforms //buttons,
				);

		}
		return null;

	}
	




}