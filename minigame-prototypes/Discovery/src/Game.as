package  
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Joe
	 */
	public class Game extends Sprite
	{
		private var _guessHistory:Array;
		private var _clueHistory:Array;
		private var _currentGuess:Array;
		
		private var _solution:Array;
		
		private var _numGuesses:int;
		private var _numColors:int;
		private var _solutionLength:int;
		
		private var _guessButtonContainer:Sprite;
		
		private var _won:Boolean = false;
		
		public function Game(numGuesses:int = 10, numColors:int = 6, solutionLength = 4) 
		{
			_numGuesses = numGuesses;
			_numColors = numColors;
			_solutionLength = solutionLength;
			
			_solution = [];
			_guessHistory = [];
			_clueHistory = [];
			_currentGuess = [];
			
			createSolution();
			gui(); 
			//displaySolution(400,10);
		}
		
		public function clearGuess():void
		{
			for ( var i:int = 0; i < _currentGuess.length; i++ )
			{
				if ( this.getChildIndex(_currentGuess[i]) != -1 )
					this.removeChild(_currentGuess[i]);
			}
			_currentGuess = [];
			trace("guess cleared");
		}
		
		public function submitGuess():void
		{
			if ( isGuessCorrect() )
			{
				trace("you win!");
				_won = true;
				dispatchEvent(new Event(Event.COMPLETE));
				displaySolution(400,10);
			}
			
			var guessIndex:uint = _guessHistory.push( _currentGuess.concat() ) - 1;
			
			var container:Sprite = new Sprite();
			for ( var i:int = 0; i < _solutionLength; i++ )
			{					
				var block:Block = new Block(_guessHistory[guessIndex][i].color);
				block.x = (block.width + 5) * i;
				//block.y = ;
				
				container.addChild(block);
			}
			
			container.x = 20;
			container.y = 15 + (_solution[0].height + 10) * guessIndex;
			this.addChild(container);
			
			var clue:Sprite = getClueRow();
			var clueIndex:uint = _clueHistory.push(clue) - 1;
			clue.x = 190;
			clue.y = 15 + (25 + 10) * clueIndex;
			this.addChild(clue);
			
			clearGuess();
			
			if ( !_won && _guessHistory.length >= _numGuesses )
			{
				displaySolution(400,10);
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		private function getClueRow():Sprite
		{
			var clue:Sprite = new Sprite();
			var clueIndex:int = 0;
			var guessRemaining:Array = _currentGuess.concat();
			var solutionRemaining:Array = _solution.concat();
			
			for ( var i:int = 0; i < _currentGuess.length; i++ )
			{	
				if ( _currentGuess[i].number == _solution[i].number )
				{
					var exactClue:ExactClue = new ExactClue();
					exactClue.x = (exactClue.width + 5) * clueIndex++;
					solutionRemaining[i] = -1;
					guessRemaining[i] = -1;
					clue.addChild(exactClue);
					trace("index " + i + " is exact!");
				}
			}

			trace("solution remaining:", solutionRemaining);
			for ( var j:int = 0; j < guessRemaining.length; j++ )
			{
				if ( guessRemaining[j] == -1 )
					continue;
					
				for ( var solIndex:int = 0; solIndex < solutionRemaining.length; solIndex++ )
				{
					if ( solutionRemaining[solIndex] == -1 )
						continue;
						
					if ( guessRemaining[j].number == solutionRemaining[solIndex].number )
					{
						var oopClue:OutOfPlaceClue = new OutOfPlaceClue();
						oopClue.x = (oopClue.width + 5) * clueIndex++;
						solutionRemaining[solIndex] = -1;
						clue.addChild(oopClue);
						break;
					}
				}
			}
			
			return clue;
		}
		
		private function getIndexOfBlock(arr:Array, block:Block):Array
		{
			var retval:Array = [];
			for ( var i:int = 0; i < arr.length; i++ )
			{
				if ( arr[i].number == block.number )
					retval.push(i);
			}
			return retval;
		}
		
		private function guessContains(block:Block):Boolean
		{
			for ( var i:int = 0; i < _currentGuess.length; i++ )
			{
				if ( _currentGuess[i].number == block.number )
					return true;
			}
			return false;
		}
		
		private function isGuessCorrect():Boolean
		{
			for ( var i:int = 0; i < _solutionLength; i++ )
			{
				if ( _currentGuess[i].number != _solution[i].number )
					return false;
			}
			return true;
		}
		
		private function createSolution():void
		{
			for ( var i:int = 0; i < _solutionLength; i++ )
			{
				var color:int = Block.COLORS[ int(Math.random() * _numColors) ];
				var block:Block = new Block(color);
				
				_solution.push(block);
			}
		}
		
		private function displaySolution(__x:int, __y:int):void
		{
			var container:Sprite = new Sprite();
			for ( var i:int = 0; i < _solutionLength; i++ )
			{
				var block:Block = _solution[i] as Block;
				block.x = (block.width + 3) * i;
				container.addChild(_solution[i]);
			}
			
			container.x = __x;
			container.y = __y;
			
			this.addChild(container);
		}
		
		private function gui():void
		{
			var container:Sprite = new Sprite();
			
			var x1:int = (_solution[0].width + 10) * _solutionLength;
			var y1:int = (_solution[0].height + 10) * _numGuesses;
			
			var grid:Sprite = new Sprite();
			grid.graphics.lineStyle(3, 0x000000);
			grid.graphics.moveTo(0, 0);
			grid.graphics.lineTo(x1, 0);
			grid.graphics.lineTo(x1, y1);
			grid.graphics.lineTo(0, y1);
			grid.graphics.lineTo(0, 0);
			
			for ( var i:int = 1; i < _numGuesses; i++ )
			{
				grid.graphics.moveTo(0, (_solution[0].height + 10) * i);
				grid.graphics.lineTo(x1, (_solution[0].height + 10) * i);
			}
			
			container.addChild(grid);
			
			var clueGrid:Sprite = new Sprite();
			clueGrid.graphics.lineStyle(3, 0x800000);
			clueGrid.graphics.moveTo(0, 0);
			clueGrid.graphics.lineTo(x1, 0);
			clueGrid.graphics.lineTo(x1, y1);
			clueGrid.graphics.lineTo(0, y1);
			clueGrid.graphics.lineTo(0, 0);
			
			for ( var j:int = 1; j < _numGuesses; j++ )
			{
				clueGrid.graphics.moveTo(0, (_solution[0].height + 10) * j);
				clueGrid.graphics.lineTo(x1, (_solution[0].height + 10) * j);
			}
			
			clueGrid.x = grid.width + 30;
			container.addChild(clueGrid);
			
			container.x = 10;
			container.y = 10;
			this.addChild(container);
			
			var guessGrid:Sprite = new Sprite();
			guessGrid.graphics.lineStyle(3, 0x000000);
			guessGrid.graphics.moveTo(0, 0);
			guessGrid.graphics.lineTo(x1, 0);
			guessGrid.graphics.lineTo(x1, (_solution[0].height + 10));
			guessGrid.graphics.lineTo(0, (_solution[0].height + 10));
			guessGrid.graphics.lineTo(0, 0);
			
			guessGrid.x = 380;
			guessGrid.y = 240;
			this.addChild(guessGrid);
			
			_guessButtonContainer = new Sprite();
			for ( var btnIndex:int = 0; btnIndex < _numColors; btnIndex++ )
			{
				var btn:Block = new Block(Block.COLORS[btnIndex]);
				btn.x = (btn.width + 5) * (btnIndex % 4);
				btn.y = (btn.height + 5) * int(btnIndex / 4);
				btn.addEventListener(MouseEvent.CLICK, onBlockClick);
				
				_guessButtonContainer.addChild(btn);
			}
			
			_guessButtonContainer.x = 395;
			_guessButtonContainer.y = 300;
			this.addChild(_guessButtonContainer);
		}
		
		private function onBlockClick(event:MouseEvent):void
		{
			var clicked:* = event.currentTarget;			
			var btnIndex:int = _guessButtonContainer.getChildIndex(clicked);
			if ( btnIndex != -1 && _currentGuess.length < _solutionLength )
			{
				var block:Block = new Block(Block.COLORS[btnIndex]);
				var guessIndex:uint = _currentGuess.push(block);
				
				block.x = 390 + (block.width + 5) * (guessIndex-1);
				block.y = 245;
				
				this.addChild(block);
				
				trace("added block " + btnIndex + " to current guess.");
				dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		public function disable():void
		{
			for ( var i:int = 0; i < _guessButtonContainer.numChildren; i++ )
			{
				_guessButtonContainer.getChildAt(i).removeEventListener(MouseEvent.CLICK, onBlockClick);
			}
		}
		
		public function get currentGuess():Array
		{
			return _currentGuess;
		}
		
		public function get solution():Array
		{
			return _solution;
		}
		
		public function get won():Boolean
		{
			return _won;
		}
	}

}