package  
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author Joe
	 */
	public class Game extends Sprite
	{
		private var _minSpeed:int = 0;
		private var _maxSpeed:int = 0;
		
		private var _segments:Array;
		private var _activeSegmentIndex:int = 0;
		
		private var _score:int = 0;
		
		private var _timer:Timer;
		private var _lastFrame:Date;
		
		public function Game(numSegments:int = 3, minSpeed:int = 100, maxSpeed:int = 200) 
		{
			if ( numSegments <= 0 )
				return;
				
			_minSpeed = minSpeed;
			_maxSpeed = maxSpeed;
			
			_segments = [];
			this.graphics.lineStyle(3);
			for ( var i:int = 0; i < numSegments; i++ )
			{
				var speed:int = Math.random() * (maxSpeed - minSpeed) + minSpeed;
				var seg:Segment = new Segment(speed);
				_segments.push(seg);
				
				seg.x = 50;
				seg.y = 60+(Segment.HEIGHT + Segment.VERTICAL_MARGIN) * (i);
				
				this.addChild(seg);
				
				this.graphics.moveTo(seg.x - 3, seg.y - 3);
				this.graphics.lineTo(seg.x + Segment.WIDTH + 3, seg.y - 3);
				this.graphics.lineTo(seg.x + Segment.WIDTH + 3, seg.y + Segment.HEIGHT + 3);
				this.graphics.lineTo(seg.x - 3, seg.y + Segment.HEIGHT + 3);
				this.graphics.lineTo(seg.x - 3, seg.y - 3);
			}
			
			_activeSegmentIndex = 0;
			
			_lastFrame = new Date();
			_timer = new Timer(33);
			_timer.addEventListener(TimerEvent.TIMER, onTick);
			_timer.start();
		}
		
		private function onTick(event:TimerEvent):void
		{
			var thisFrame:Date = new Date();
			var dt:Number = (thisFrame.getTime() - _lastFrame.getTime())/1000.0;
	    	_lastFrame = thisFrame;
			
			_segments[_activeSegmentIndex].update(dt);
		}
		
		public function onEnter():int
		{
			var score:int = _segments[_activeSegmentIndex++].stop();
			
			if ( _activeSegmentIndex >= _segments.length )
			{
				tallyScore();
				score = -1;
			}
				
			return score;
		}
		
		private function tallyScore():void
		{
			for ( var i:int = 0; i < _segments.length; i++ )
			{
				_score += _segments[i].score;
			}
			
			_timer.removeEventListener(TimerEvent.TIMER, onTick);
			_timer.stop();
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function get score():int
		{
			return _score;
		}
		
	}

}