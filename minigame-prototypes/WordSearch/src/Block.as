package  
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author Joe
	 */
	public class Block extends Sprite
	{
		private static const BLOCKTF:TextFormat = new TextFormat("Arial", 18,0, true);
		
		public static const COLOR_RED:int = 		0xFF0000;
		public static const COLOR_CYAN:int = 		0x00FFFF;
		public static const COLOR_LIME:int = 		0x00FF00;
		
		public static const COLOR_BLUE:int = 		0x0000FF;
		public static const COLOR_GREEN:int =		0x008000
		public static const COLOR_YELLOW:int = 		0xFFFF00;
		
		public static const COLOR_ORANGE:int = 		0xFF8000;
		public static const COLOR_MAGENTA:int = 	0xFF00FF;
		public static const COLOR_NAVY:int = 		0x000080;
		
		public static const COLOR_PURPLE:int = 		0x800080;
		public static const COLOR_MAROON:int = 		0x800000;
		public static const COLOR_OLIVE:int = 		0x808000;
		
		public static const COLOR_TEAL:int = 		0x008080;
		public static const COLOR_SILVER:int = 		0xC0C0C0;
		public static const COLOR_GREY:int = 		0x808080;
		//15
		public static const COLOR_BLACK:int = 		0x000000;
		public static const COLOR_WHITE:int = 		0xFFFFFF;
		//17
		
		public static const COLORS:Array = [
											COLOR_RED,
											COLOR_CYAN,
											COLOR_LIME,
											COLOR_BLUE,
											COLOR_GREEN,
											COLOR_YELLOW,
											COLOR_ORANGE,
											COLOR_MAGENTA,
											COLOR_NAVY,
											COLOR_PURPLE,
											COLOR_MAROON,
											COLOR_OLIVE,
											COLOR_TEAL,
											COLOR_SILVER,
											COLOR_GREY,
											//COLOR_BLACK,
											COLOR_WHITE
											];
											
		public static const BLOCKSIZE:int = 25;
											
		private var _color:int;
		private var _number:int = 0;
		
		public function Block(color:int) 
		{
			this._color = color;
			
			this.graphics.beginFill(color);
			this.graphics.drawRoundRect(0, 0, BLOCKSIZE, BLOCKSIZE, 5);
			
			var text:TextField = new TextField();
			text.defaultTextFormat = BLOCKTF;
			text.text = findNumber();
			text.width = BLOCKSIZE;
			text.height = BLOCKSIZE;
			text.selectable = false;
			this.addChild(text);
		}
		
		public function findNumber():String
		{
			for ( var i:int = 0; i < COLORS.length; i++ )
			{
				if ( this._color == COLORS[i] )
				{
					_number = i;
					break;
				}
			}
			
			return _number + "";
		}
		
		public function get color():int
		{
			return _color;
		}
		
		public function get number():int
		{
			return _number;
		}
	}

}