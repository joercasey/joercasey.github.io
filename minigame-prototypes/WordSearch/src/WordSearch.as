package  
{
	import fl.controls.Button;
	import fl.controls.TextInput;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author Joe
	 */
	public class WordSearch extends Sprite
	{
		private var _game:Game;
		
		private var _newWordBtn:Button;
		private var _newGridBtn:Button;
		
		private var _inputPatternLength:TextInput;
		private var _inputNumColors:TextInput;
		private var _inputGridSize:TextInput;
		
		private var _status:TextField;
		
		public function WordSearch() 
		{
			_newWordBtn = new Button();
			_newWordBtn.label = "New Pattern";
			_newWordBtn.addEventListener(MouseEvent.CLICK, onNewWord);
			_newWordBtn.x = 20;
			_newWordBtn.y = 220;
			this.addChild(_newWordBtn);
			
			_newGridBtn = new Button();
			_newGridBtn.label = "New Game";
			_newGridBtn.addEventListener(MouseEvent.CLICK, onNewGame);
			_newGridBtn.x = 130;
			_newGridBtn.y = 220;
			this.addChild(_newGridBtn);
			
			var instrTF:TextFormat = new TextFormat("Arial", 14, 0, true);
			var instructions:TextField = new TextField();
			instructions.defaultTextFormat = instrTF;
			instructions.selectable = false;
			instructions.x = 10;
			instructions.y = 20;
			instructions.width = 200;
			instructions.height = 200;
			instructions.wordWrap = true;
			instructions.text = "Look for the following pattern in the grid. "
			+"It may appear backwards, forwards, and diagonal. \n\n"
			+"Click and drag the mouse to highlight sections of the grid.";
			this.addChild(instructions);
			
			_status = new TextField();
			_status.defaultTextFormat = instrTF;
			_status.selectable = false;
			_status.x = 300;
			_status.y = 10;
			_status.width = 300;
			_status.height = 35;
			_status.wordWrap = true;
			this.addChild(_status);
			
			var labelTF:TextFormat = new TextFormat("Arial", 10, 0);			
			var patternLabel:TextField = new TextField();
			patternLabel.defaultTextFormat = labelTF;
			patternLabel.selectable = false;
			patternLabel.text = "Pattern Length";
			patternLabel.x = 125;
			patternLabel.y = 280;
			this.addChild(patternLabel);
			_inputPatternLength = new TextInput();
			_inputPatternLength.x = 20;
			_inputPatternLength.y = 280;
			_inputPatternLength.text = "" + 5;
			this.addChild(_inputPatternLength);
			
			var colorLabel:TextField = new TextField();
			colorLabel.defaultTextFormat = labelTF;
			colorLabel.selectable = false;
			colorLabel.text = "Num Colors";
			colorLabel.x = 125;
			colorLabel.y = 310;
			this.addChild(colorLabel);
			_inputNumColors = new TextInput();
			_inputNumColors.x = 20;
			_inputNumColors.y = 310;
			_inputNumColors.text = "" + 7;
			this.addChild(_inputNumColors);
			
			var gridLabel:TextField = new TextField();
			gridLabel.defaultTextFormat = labelTF;
			gridLabel.selectable = false;
			gridLabel.text = "Grid Size";
			gridLabel.x = 125;
			gridLabel.y = 340;
			this.addChild(gridLabel);
			_inputGridSize = new TextInput();
			_inputGridSize.x = 20;
			_inputGridSize.y = 340;
			_inputGridSize.text = "" + 10;
			this.addChild(_inputGridSize);
			
			newGame();
		}
		
		private function newGame():void
		{
			if ( _game )
			{
				if ( this.getChildIndex(_game) != -1 )
					this.removeChild(_game);
				_game.removeEventListener(Event.COMPLETE, onGameComplete);
				_game.removeEventListener(Event.CANCEL, onSelectClear);
			}
			
			_game = new Game(int(_inputNumColors.text), int(_inputGridSize.text), int(_inputGridSize.text));
			_game.addEventListener(Event.COMPLETE, onGameComplete);
			_game.addEventListener(Event.CANCEL, onSelectClear);
			this.addChildAt(_game, 0);
			
			_game.newWord(int(_inputPatternLength.text));
		}
		
		private function onGameComplete(event:Event):void
		{		
			_status.text = "Congrats! You found the pattern!";
		}
		
		private function onSelectClear(event:Event):void
		{		
			_status.text = "";
		}
		
		private function onNewWord(event:MouseEvent):void
		{
			_game.newWord(int(_inputPatternLength.text));
			_status.text = "Generated new pattern.";
		}
		
		private function onNewGame(event:MouseEvent):void
		{
			newGame();
			_status.text = "Generated new game.";
		}
	}

}