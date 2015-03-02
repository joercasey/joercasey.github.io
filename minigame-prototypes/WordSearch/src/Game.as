package  
{
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author Joe
	 */
	public class Game extends Sprite
	{		
		private var _grid:WordGrid;
		
		
		public function Game(numColors:int = 7, gridHeight:int = 10, gridWidth:int = 10) 
		{
			_grid = new WordGrid(numColors, gridHeight, gridWidth);
			_grid.x = 250;
			_grid.y = 50;
			this.addChild(_grid);
			
			_grid.addEventListener(Event.COMPLETE, onWordFound);
			_grid.addEventListener(Event.CANCEL, onSelectClear);
		}
		
		public function newWord(wordSize:int):void
		{
			_grid.findTargetWord(wordSize);
		}
		
		private function onWordFound(event:Event):void
		{
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function onSelectClear(event:Event):void
		{
			dispatchEvent(new Event(Event.CANCEL));
		}
		
	}

}