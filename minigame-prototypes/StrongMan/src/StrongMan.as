package  
{
	import fl.controls.Button;
	import fl.controls.TextInput;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author Joe
	 */
	public class StrongMan extends Sprite
	{
		private var _game:Game;
		
		private var _newGameBtn:Button;
		private var _numSegmentsInput:TextInput;
		private var _minSpeedInput:TextInput;
		private var _maxSpeedInput:TextInput;
		
		private var _status:TextField;
		
		public function StrongMan() 
		{
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			
			_newGameBtn = new Button();
			_newGameBtn.label = "New Game";
			_newGameBtn.x = 400;
			_newGameBtn.y = 150;
			_newGameBtn.addEventListener(MouseEvent.CLICK, onNewGame);
			this.addChild(_newGameBtn);
			
			_numSegmentsInput = new TextInput();
			_numSegmentsInput.x = 400;
			_numSegmentsInput.y = 240;
			_numSegmentsInput.text = "" + 4;
			this.addChild(_numSegmentsInput);
			
			_minSpeedInput = new TextInput();
			_minSpeedInput.x = 400;
			_minSpeedInput.y = 290;
			_minSpeedInput.text = "" + 100;
			this.addChild(_minSpeedInput);
			
			_maxSpeedInput = new TextInput();
			_maxSpeedInput.x = 400;
			_maxSpeedInput.y = 340;
			_maxSpeedInput.text = "" + 200;
			this.addChild(_maxSpeedInput);
			
			var inputTF:TextFormat = new TextFormat("Arial", 10);
			
			var segLabel:TextField = new TextField();
			segLabel.defaultTextFormat = inputTF;
			segLabel.selectable = false;
			segLabel.x = 400;
			segLabel.y = 225;
			segLabel.width = 120;
			segLabel.height = 15;
			segLabel.text = "Number of Segments"
			this.addChild(segLabel);
			
			var minLabel:TextField = new TextField();
			minLabel.defaultTextFormat = inputTF;
			minLabel.selectable = false;
			minLabel.x = 400;
			minLabel.y = 275;
			minLabel.height = 15;
			minLabel.text = "Min Speed";
			this.addChild(minLabel);
			
			var maxLabel:TextField = new TextField();
			maxLabel.defaultTextFormat = inputTF;
			maxLabel.selectable = false;
			maxLabel.x = 400;
			maxLabel.y = 325;
			maxLabel.height = 15;
			maxLabel.text = "Max Speed";
			this.addChild(maxLabel);
			
			var instrTF:TextFormat = new TextFormat("Arial", 14, 0x00, true);
			var instructions:TextField = new TextField();
			instructions.defaultTextFormat = instrTF;
			instructions.selectable = false;
			instructions.x = 10;
			instructions.y = 10;
			instructions.width = 530;
			instructions.height = 50;
			instructions.text = "Press Enter to stop the bar when it is as full as possible."
				+ "\nThe fuller the bar, the more points you get.";
			instructions.wordWrap = true;
			this.addChild(instructions);
			
			_status = new TextField();
			_status.defaultTextFormat = instrTF;
			_status.selectable = false;
			_status.x = 10;
			_status.y = 350;
			_status.width = 530;
			_status.height = 50;
			_status.wordWrap = true;
			_status.text = "PLEASE CLICK ON THE GAME SO THAT IT GAINS FOCUS IN THE BROWSER!";
			this.addChild(_status);
			
			this.stage.addEventListener(MouseEvent.CLICK, onClick);
			
			newGame();
		}
		
		private function onNewGame(event:MouseEvent):void
		{
			newGame();
		}
		
		private function newGame():void
		{
			if ( _game )
			{
				if ( this.getChildIndex(_game) != -1 )
					this.removeChild(_game);
			}
			
			_game = new Game(
				int(_numSegmentsInput.text), 
				int(_minSpeedInput.text), 
				int(_maxSpeedInput.text));
			_game.addEventListener(Event.COMPLETE, onGameComplete);
			this.addChildAt(_game, 0);
		}
		
		private function onGameComplete(event:Event):void
		{		
			_status.text = "Score: " + _game.score + " / " 
				+ int(_numSegmentsInput.text) * 100;
		}
		
		private function onKeyDown(event:KeyboardEvent):void
		{
			if ( event.keyCode == 13 && _game )
			{
				var score:int = _game.onEnter();
				if ( score == -1 )
					return;
				
				if ( score < 50 )
					_status.text = "You only got " + score + " points.";
				else if ( score > 50 && score < 70 )
					_status.text = "A measily " + score + " points.";
				else if ( score > 70 && score < 90 )
					_status.text = "Good job! " + score + " points!";
				else if ( score > 90 )
					_status.text = "Wow, you're quick! " + score + " points!";
			}
		}
		
		private function onClick(event:MouseEvent):void
		{
			this.stage.removeEventListener(MouseEvent.CLICK, onClick);
			_status.text = "Focus gained. Thanks";
		}
	}

}