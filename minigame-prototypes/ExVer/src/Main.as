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
	public class Main extends Sprite
	{
		private var _instructions:TextField;
		private var _numColorsInput:TextInput;
		private var _subsetSizeInput:TextInput;
		private var _stripSizeInput:TextInput;
		
		private var newGameBtn:Button;
		
		private static var _gameStatus:TextField;
		private static var gameStatusTF = new TextFormat("Arial", 36, Block.COLOR_MAROON, true);
		{
			_gameStatus = new TextField();
			_gameStatus.defaultTextFormat = gameStatusTF;
			_gameStatus.text = "EXACT COVER FOUND!";
			_gameStatus.selectable = false;
			_gameStatus.width = 400;
			_gameStatus.height = 50;
			_gameStatus.x = 50;
			_gameStatus.y = 50;
		}
		
		private var _game:Game;
		
		public function Main() 
		{
			guiSetup();
		
			createGame();
			
			//_game = new Game();
			//_game.addEventListener(Event.COMPLETE, onGameEnd);
			//this.addChild(_game);
			
			//stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			//stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			//stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}
		
		private function createGame():void
		{
			var numColors:int = int(_numColorsInput.text);
			var subsetSize:int = int(_subsetSizeInput.text);
			var stripSize:int = int(_stripSizeInput.text);
			
			if ( numColors > Block.COLORS.length )
				return;
				
			if ( stripSize < subsetSize )
				return;
				
			if ( subsetSize > numColors )
				return;
				
			if ( numColors % subsetSize != 0 )
				return;
			
			_game = new Game(numColors,subsetSize,stripSize);
			_game.addEventListener(Event.COMPLETE, onGameEnd);
			this.addChildAt(_game,0);
		}
		
		private function guiSetup():void
		{
			var instTF:TextFormat = new TextFormat("Arial", 14, 0x000000, true);
			
			_instructions = new TextField();
			_instructions.defaultTextFormat = instTF;
			_instructions.text = "Slide rows left or right using the arrow buttons"
			+"\nsuch that exactly one block of every number is in the black box.";
			_instructions.width = stage.stageWidth;
			_instructions.height = 50;
			_instructions.selectable = false;
			_instructions.x = 20;
			_instructions.y = 20;
			this.addChild(_instructions);
			
			var statusBar:TextField = new TextField();
			statusBar.defaultTextFormat = instTF;
			statusBar.text = "Color = OK\nGrey = Not present or duplicate";
			statusBar.width = 240;
			statusBar.height = 50;
			statusBar.selectable = false;
			statusBar.x = 25;
			statusBar.y = 275;
			this.addChild(statusBar);
			
			_numColorsInput = new TextInput();
			_numColorsInput.x = 400;
			_numColorsInput.y = 310;
			_numColorsInput.width = 20;
			_numColorsInput.text = ""+8;
			this.addChild(_numColorsInput);
			
			var numColorsLabel:TextField = new TextField();
			numColorsLabel.selectable = false;
			numColorsLabel.x = 430;
			numColorsLabel.y = 310;
			numColorsLabel.text = "Colors";
			this.addChild(numColorsLabel);
			
			_subsetSizeInput = new TextInput();
			_subsetSizeInput.x = 400;
			_subsetSizeInput.y = 340;
			_subsetSizeInput.width = 20;
			_subsetSizeInput.text = ""+2;
			this.addChild(_subsetSizeInput);
			
			var subsetLabel:TextField = new TextField();
			subsetLabel.selectable = false;
			subsetLabel.x = 430;
			subsetLabel.y = 340;
			subsetLabel.text = "Subset Size";
			this.addChild(subsetLabel);
			
			_stripSizeInput = new TextInput();
			_stripSizeInput.x = 400;
			_stripSizeInput.y = 370;
			_stripSizeInput.width = 20;
			_stripSizeInput.text = ""+4;
			this.addChild(_stripSizeInput);
			
			var stripLabel:TextField = new TextField();
			stripLabel.selectable = false;
			stripLabel.x = 430;
			stripLabel.y = 370;
			stripLabel.text = "Row Size";
			this.addChild(stripLabel);
			
			newGameBtn = new Button();
			newGameBtn.label = "New Game";
			newGameBtn.x = 280;
			newGameBtn.y = 340;
			newGameBtn.addEventListener(MouseEvent.CLICK, onNewGameClick);
			this.addChild(newGameBtn);
		}
		
		private function onNewGameClick(event:MouseEvent):void
		{
			if ( this.contains(_game) )
			{
				_game.removeEventListener(Event.COMPLETE, onGameEnd);
				this.removeChild(_game);
			}
			
			if ( this.contains(_gameStatus) )
				this.removeChild(_gameStatus);
			
			createGame();
		}
		
		private function onGameEnd(event:Event):void
		{
			this.addChild(_gameStatus);
			_game.disable();
			
			return;
		}
		
		/*private function onMouseMove(event:MouseEvent):void
		{
			_game.onStripMouseMove();
		}
		
		private function onMouseUp(event:MouseEvent):void
		{
			_game.onStripMouseUp();
		}
		
		private function onMouseDown(event:MouseEvent):void
		{
			_game.onStripMouseDown( event.currentTarget as Strip );
		}*/
		
	}

}