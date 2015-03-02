package  
{
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author Joe
	 */
	public class Game extends Sprite
	{
		private var _timer:Timer
		private var _lastFrame:Date;
		
		private var _powerBars:Array;
		private var _activeBar:PowerBar;
		
		private var _timeSinceSwap:Number = 0;
		private var _minTimeBtwSwap:Number = 0.5;
		private var _maxTimeBtwSwap:Number = 2;	
		private var _nextSwap:Number = 0;
		
		public var keys:int;
		public static const KEY_UP:int = 1;
		public static const KEY_DOWN:int = 2;
		public static const KEY_LEFT:int = 4;
		public static const KEY_RIGHT:int = 8;
		
		public function Game() 
		{
			_powerBars = [];
			for ( var i:int = 0; i < 4; i++ )
			{
				var pb:PowerBar = new PowerBar(i);
				_powerBars.push(pb);
				
				pb.x = 250
				pb.y = 200;
				
				switch( pb.orientation )
				{
					case PowerBar.ORIENT_WEST:
					pb.x -= 50;
					pb.y += PowerBar.HEIGHT;
					break;
					
					case PowerBar.ORIENT_NORTH:
					pb.x -= 25 + (PowerBar.HEIGHT/2);
					pb.y -= 15;
					break;
					
					case PowerBar.ORIENT_SOUTH:
					pb.x -= 25- (PowerBar.HEIGHT/2);
					pb.y += 35;
					break;
				}
			
				this.addChild(pb);
			}
			
			//_nextSwap = Math.random() * (_maxTimeBtwSwap - _minTimeBtwSwap) + _minTimeBtwSwap;
			
			_lastFrame = new Date();
			_timer = new Timer(33);
			_timer.addEventListener(TimerEvent.TIMER, onTick);
			_timer.start();
		}
		
		private function onTick(event:TimerEvent):void
		{
			//calc dt
			var thisFrame:Date = new Date();
			var dt:Number = (thisFrame.getTime() - _lastFrame.getTime())/1000.0;
	    	_lastFrame = thisFrame;
			
			//check swap times
			_timeSinceSwap += dt;
			if ( _timeSinceSwap >= _nextSwap )
			{
				_timeSinceSwap = 0;
				_nextSwap = Math.random() * (_maxTimeBtwSwap - _minTimeBtwSwap) + _minTimeBtwSwap;
				
				if( _activeBar )
					_activeBar.active = false;
				_activeBar = null;
				var pbToActivate:int = int(Math.random() * (_powerBars.length + 1))
				if ( pbToActivate < _powerBars.length )
				{
					_activeBar = _powerBars[pbToActivate]
					_activeBar.active = true;
				}
			}
			
			//handle key presses
			var keyOrientation:int = -1;
			switch( keys )
			{
				case KEY_DOWN:
				keyOrientation = PowerBar.ORIENT_SOUTH;
				break;
				
				case KEY_LEFT:
				keyOrientation = PowerBar.ORIENT_WEST;
				break;
				
				case KEY_RIGHT:
				keyOrientation = PowerBar.ORIENT_EAST;
				break;
				
				case KEY_UP:
				keyOrientation = PowerBar.ORIENT_NORTH;
				break;
			}
			
			for ( var i:int = 0; i < _powerBars.length; i++ )
				_powerBars[i].state = PowerBar.STATE_IDLE;
			if ( _activeBar )
			{
				if ( _activeBar.orientation == keyOrientation )
				{
					_activeBar.state = PowerBar.STATE_CHARGE;
				}
				else if( keys == 0 )
				{
					trace("passive drain");
					for ( var i:int = 0; i < _powerBars.length; i++ )
						_powerBars[i].state = PowerBar.STATE_ACTIVE_DRAIN;
				}
				else if ( keys != 0 )
				{
					trace("active drain");
					for ( var i:int = 0; i < _powerBars.length; i++ )
						_powerBars[i].state = PowerBar.STATE_ACTIVE_DRAIN;
				}
			}
			else if ( keys != 0 )
			{
				trace("active drain");
				for ( var i:int = 0; i < _powerBars.length; i++ )
					_powerBars[i].state = PowerBar.STATE_ACTIVE_DRAIN;
			}
			
			//update power bars
			for ( var i:int = 0; i < _powerBars.length; i++ )
			{
				var pb:PowerBar = _powerBars[i];
				pb.update(dt);
			}
		}
		
		public function onUpArrow():void
		{
			trace("up");
			if ( _activeBar.orientation == PowerBar.ORIENT_NORTH )
				_activeBar.state = PowerBar.STATE_CHARGE;
			else
			{
				for ( var i:int = 0; i < _powerBars.length; i++ )
				{
					_activeBar.state = PowerBar.STATE_ACTIVE_DRAIN;
				}
			}
		}
		
		public function onLeftArrow():void
		{
			trace("left");
			if ( _activeBar.orientation == PowerBar.ORIENT_WEST )
				_activeBar.state = PowerBar.STATE_CHARGE;
			else
			{
				for ( var i:int = 0; i < _powerBars.length; i++ )
				{
					_activeBar.state = PowerBar.STATE_ACTIVE_DRAIN;
				}
			}
		}
		
		public function onDownArrow():void
		{
			trace("down");
			if ( _activeBar.orientation == PowerBar.ORIENT_SOUTH )
				_activeBar.state = PowerBar.STATE_CHARGE;
			else
			{
				for ( var i:int = 0; i < _powerBars.length; i++ )
				{
					_activeBar.state = PowerBar.STATE_ACTIVE_DRAIN;
				}
			}
		}
		
		public function onRightArrow():void
		{
			trace("right");
			
		}
	}

}