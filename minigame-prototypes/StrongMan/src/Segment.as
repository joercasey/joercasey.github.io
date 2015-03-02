package  
{
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Joe
	 */
	public class Segment extends Sprite
	{
		private static const LEFT:int = 0;
		private static const RIGHT:int = 1;
		
		public static const WIDTH:int = 300;
		public static const HEIGHT:int = 15;
		public static const VERTICAL_MARGIN:int = 10;
		
		var _speed:int = 0;
		private var _score:int = 0;
		
		private var _position:int = 0;
		private var _direction:int = RIGHT;
		
		public function Segment(speed:int) 
		{
			this._speed = speed;
		}
		
		public function update(dt:Number):void
		{
			var diff:Number= _speed * dt;
			if ( _direction == RIGHT )
				_position += diff;
			else
				_position -= diff;
				
			if ( _position > 100 )
			{
				_position = 100;
				_direction = LEFT;
			}
			else if ( _position < 0 )
			{
				_position = 0;
				_direction = RIGHT;
			}
				
			draw();
		}
		
		private function draw():void
		{
			//trace(_position);
			
			var green:int = 255 * (_position / 100);
			var red:int = 255 - green;
			var color:int = (red << 16) + (green << 8);
			
			//trace("R G Color", red, green, color);
			
			this.graphics.clear();
			this.graphics.beginFill(color);
			this.graphics.drawRect(0, 0, WIDTH*(_position / 100), HEIGHT);
		}
		
		public function stop():int
		{
			_score = _position;
			
			return _score;
		}
		
		public function get score():int
		{
			return _score;
		}
	}

}