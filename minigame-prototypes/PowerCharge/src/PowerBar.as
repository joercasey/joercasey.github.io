package  
{
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Joe
	 */
	public class PowerBar extends Sprite
	{
		public static const ORIENT_NORTH:int = 3;
		public static const ORIENT_SOUTH:int = 1;
		public static const ORIENT_EAST:int = 0;
		public static const ORIENT_WEST:int = 2;
		
		public static const STATE_IDLE:int = 0;
		public static const STATE_CHARGE:int = 1;
		public static const STATE_PASSIVE_DRAIN:int = 2;
		public static const STATE_ACTIVE_DRAIN:int = 3;
		
		public static var charge_rate:int = 60;
		public static var passive_drain_rate:int = 1;
		public static var active_drain_rate:int = 5;
		
		public static const WIDTH:int = 150;
		public static const HEIGHT:int = 20;
		
		private var _charge:int = 0;
		private var _orientation:int = -1;
		private var _state:int = STATE_IDLE;
		private var _active:Boolean = false;
		
		public function PowerBar(orientation:int) 
		{
			_orientation = orientation;
		}
		
		public function update(dt:Number):void
		{
			switch( _state )
			{
				case STATE_CHARGE:
				_charge += charge_rate * dt;
				if ( _charge > 100 )
					_charge = 100;
				
				break;
				
				case STATE_PASSIVE_DRAIN:
				_charge -= passive_drain_rate * dt;
				if ( _charge < 0 )
					_charge = 0;
					
				break;
				
				case STATE_ACTIVE_DRAIN:
				_charge -= active_drain_rate * dt;
				if ( _charge < 0 )
					_charge = 0;
					
				break;
			}
			
			draw();
		}
		
		private function draw():void
		{
			this.graphics.clear();
			if ( _active )
			{
				this.graphics.beginFill(0x4000FF);
				this.graphics.drawRect( -10, -10, WIDTH + 20, HEIGHT + 20);
			}
			
			this.graphics.lineStyle(3);
			this.graphics.moveTo( -3, -3);
			this.graphics.lineTo(WIDTH + 3, -3);
			this.graphics.lineTo(WIDTH + 3, HEIGHT + 3);
			this.graphics.lineTo( -3, HEIGHT + 3);
			this.graphics.lineTo( -3, -3);
			
			this.graphics.lineStyle(undefined);
			
			var green:int = 255 * (_charge / 100);
			var red:int = 255 - green;
			var color:int = (red << 16) + (green << 8);
			this.graphics.beginFill(color);
			this.graphics.drawRect(0, 0, WIDTH * (_charge / 100), HEIGHT);
			
			var m:Matrix = this.transform.matrix;
			var gpos:Point = localToGlobal(new Point(0, 0));
			m.identity();
			m.rotate((90 * _orientation * Math.PI) / 180);
			m.translate( gpos.x, gpos.y );
			this.transform.matrix = m;
		}
		
		public function get orientation():int
		{
			return _orientation;
		}
		
		public function set active(val:Boolean):void
		{
			this._active = val;
		}
		
		public function set state(val:int):void
		{
			_state = val;
		}
		
	}

}