package
{
	import fl.controls.Button;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	public class Main extends Sprite
	{
		private var _game:Game;
		
		private var _guessBtn:Button;
		private var _clearBtn:Button;
		private var _newGameBtn:Button;
		
		private var _status:TextField;
		
		public function Main()
		{
			gui();
			createGame();
		}
		
		private function gui():void
		{
			_guessBtn = new Button();
			_guessBtn.label = "Submit Guess";
			_guessBtn.x = 400;
			_guessBtn.y = 200;
			_guessBtn.addEventListener(MouseEvent.CLICK, onGuessClick);
			_guessBtn.enabled = false;
			this.addChild(_guessBtn);
			
			_clearBtn = new Button();
			_clearBtn.label = "Clear Guess";
			_clearBtn.x = 400;
			_clearBtn.y = 170;
			_clearBtn.addEventListener(MouseEvent.CLICK, onClearClick);
			this.addChild(_clearBtn);
			
			_newGameBtn = new Button();
			_newGameBtn.label = "New Game";
			_newGameBtn.x = 10;
			_newGameBtn.y = 370;
			_newGameBtn.addEventListener(MouseEvent.CLICK, onNewGame);
			this.addChild(_newGameBtn);
			
			var tf:TextFormat = new TextFormat("Arial", 14, 0x0000, true);
			var instructions:TextField = new TextField();
			instructions.defaultTextFormat = tf;
			instructions.width = 550;
			instructions.height = 200;
			instructions.wordWrap = true;
			instructions.selectable = false;
			instructions.text = "Click on the colors above to form a guess at the code. \n"
			+"Clues will appear to the right after you submit your guess. \n"
			+"- Each green clue = one if your guess blocks is in the correct position. \n"
			+"- Each grey clue = one of your guess blocks is not in the correct position. ";
			instructions.x = 10;
			instructions.y = 410;
			this.addChild(instructions);
			
			var statusTF:TextFormat = new TextFormat("Arial", 20, 0xCC0033, true);
			_status = new TextField();
			_status.defaultTextFormat = statusTF;
			_status.selectable = false;
			_status.width = 220;
			_status.x = 340;
			_status.y = 60;
			_status.text = "";
			this.addChild(_status);
		}
		
		private function onNewGame(event:MouseEvent):void
		{
			removeGame();
			createGame();
		}
		
		private function onGuessClick(event:MouseEvent):void
		{
			_game.submitGuess();
			_guessBtn.enabled = false;
		}
		
		private function onClearClick(event:MouseEvent):void
		{
			_guessBtn.enabled = false;
			_game.clearGuess();
		}
		
		private function createGame():void
		{
			_game = new Game();
			addGameListeners();
			this.addChildAt(_game, 0);
		}
		
		private function removeGame():void
		{
			if ( _game != null )
			{
				this.removeChild(_game);
				removeGameListeners();
				_game = null;
			}
			_status.text = "";
		}
		
		private function onGameChange(event:Event):void
		{
			if ( _game.currentGuess.length == _game.solution.length )
			{
				_guessBtn.enabled = true;
			}
		}
		
		private function onGameComplete(event:Event):void
		{
			if ( _game.won )
				_status.text = "CODE DISCOVERED!";
			else
			{
				_status.text = "FAILURE!";
				_game.disable();
			}
		}
		
		private function addGameListeners():void
		{
			_game.addEventListener(Event.CHANGE, onGameChange);
			_game.addEventListener(Event.COMPLETE, onGameComplete);
		}
		
		private function removeGameListeners():void
		{
			_game.removeEventListener(Event.CHANGE, onGameChange);
			_game.removeEventListener(Event.COMPLETE, onGameComplete);
		}
	}
}