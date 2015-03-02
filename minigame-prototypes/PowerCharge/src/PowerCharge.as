package  
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	/**
	 * ...
	 * @author Joe
	 */
	public class PowerCharge extends Sprite
	{
		private var _game:Game;
		
		public function PowerCharge() 
		{
			newGame();
			
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			this.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		
		private function newGame():void
		{
			if ( _game )
			{
				if ( this.getChildIndex(_game) != -1 )
					this.removeChild(_game);
			}
			
			_game = new Game();
			_game.addEventListener(Event.COMPLETE, onGameComplete);
			this.addChildAt(_game, 0);
		}
		
		private function onGameComplete(event:Event):void
		{		
			
		}
		
		private function onKeyDown(event:KeyboardEvent):void
		{
			if ( _game )
			{
				switch( event.keyCode )
				{
					case 38: //up arrow
					//_game.onUpArrow();
					_game.keys |= Game.KEY_UP;
					break;
					
					case 37: //left arrow
					//_game.onLeftArrow();
					_game.keys |= Game.KEY_LEFT;
					break;
					
					case 40: //down arrow
					//_game.onDownArrow();
					_game.keys |= Game.KEY_DOWN;
					break;
					
					case 39: //right arrow
					//_game.onRightArrow();
					_game.keys |= Game.KEY_RIGHT;
					break;
				}
			}
				
		}
		
		private function onKeyUp(event:KeyboardEvent):void
		{
			if ( _game )
			{
				switch( event.keyCode )
				{
					case 38: //up arrow
					_game.keys ^= Game.KEY_UP;
					break;
					
					case 37: //left arrow
					_game.keys ^= Game.KEY_LEFT;
					break;
					
					case 40: //down arrow
					_game.keys ^= Game.KEY_DOWN;
					break;
					
					case 39: //right arrow
					_game.keys ^= Game.KEY_RIGHT;
					break;
				}
			}
		}
	}

}