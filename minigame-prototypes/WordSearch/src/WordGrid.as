package  
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Joe
	 */
	public class WordGrid extends Sprite
	{
		public static const DIR_N:int = 0;
		public static const DIR_NE:int = 1;
		public static const DIR_E:int = 2;
		public static const DIR_SE:int = 3; 
		public static const DIR_S:int = 4;
		public static const DIR_SW:int = 5;
		public static const DIR_W:int = 6;
		public static const DIR_NW:int = 7;
		
		var _numColors:int = 0;
		var _gridHeight:int = 0;
		var _gridWidth:int = 0;
		
		private var _grid:Array;
		
		private var _currentWord:Array;
		private var _wordSprite:Sprite;
		
		public function WordGrid(numColors:int, gridHeight:int, gridWidth:int) 
		{
			_numColors = numColors;
			_gridHeight = gridHeight;
			_gridWidth = gridWidth;
			
			generateGrid();
		}
		
		private function generateGrid():void
		{
			_grid = [];
			for ( var r:int = 0; r < _gridWidth; r++ )
			{
				_grid.push([]);
				for ( var c:int = 0; c < _gridHeight; c++ )
				{
					var color:int = Block.COLORS[int(Math.random() * _numColors)];
					var block:Block = new Block(color);
					_grid[r][c] = block;
					
					block.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
					block.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
					block.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
					
					block.x = r * (Block.BLOCKSIZE+4);
					block.y = c * (Block.BLOCKSIZE+4);
					this.addChild(block);
				}
			}
		}
		
		private var _selectedStartIndex:int;
		private var _selected:Array;
		var selectedGlow:GlowFilter = new GlowFilter(0x0, 1, 12, 12, 6);
		private function onMouseDown(event:MouseEvent):void
		{
			_selected = [event.currentTarget as Block];
			_selected[0].filters = [selectedGlow];
			_selectedStartIndex = getTileIndex(_selected[0]);
		}
		
		private function onMouseUp(event:MouseEvent):void
		{
			checkSelection();
		}
		
		private function getTileIndex(block:Block):int
		{
			for ( var r:int = 0; r < _gridWidth; r++ )
				for ( var c:int = 0; c < _gridHeight; c++ )
					if ( _grid[r][c] === block )
						return r + c*_gridHeight;
			
			return -1;
		}
		
		private function onMouseMove(event:MouseEvent):void
		{
			if ( _selected )
			{
				for ( var i:int = 0; i < _selected.length; i++ )
					_selected[i].filters = [];
				_selected = [_selected[0]];
				
				var ltog:Point = localToGlobal(
					new Point(_selected[0].x+Block.BLOCKSIZE/2, _selected[0].y+Block.BLOCKSIZE/2));
				var dragDirection:Point = new Point(
						event.stageX - ltog.x, 
						event.stageY - ltog.y);
				
				//trace("mouse: " + event.stageX + "," + event.stageY + " | block: " + ltog.x + ","+ltog.y);
				var dir:int = -1;
				//figure out new direction
				var angle:Number = Math.atan2(dragDirection.y, dragDirection.x);
				if ( angle >= (Math.PI * 0.125) && angle < (Math.PI * 0.375) )
					dir = DIR_SE;
				else if ( angle >= (Math.PI * 0.375) && angle < (Math.PI * 0.625) )
					dir = DIR_S
				else if ( angle >= (Math.PI * 0.625) && angle < (Math.PI * 0.875) )
					dir = DIR_SW;
				else if ( angle >= (Math.PI * 0.875) || angle < (Math.PI * -0.875) )
					dir = DIR_W;
				else if ( angle >= (Math.PI * -0.875) && angle < (Math.PI * -0.625) )
					dir = DIR_NW;
				else if ( angle >= (Math.PI * -0.625) && angle < (Math.PI * -0.375) )
					dir = DIR_N;
				else if ( angle >= (Math.PI * -0.375) && angle < (Math.PI * -0.125) )
					dir = DIR_NE;
				else
					dir = DIR_E;
				
				var dragDist:Number = Math.sqrt(
					dragDirection.x * dragDirection.x + 
					dragDirection.y * dragDirection.y);
				
				var ray:Array = tileRay(_selectedStartIndex, dir);
				
				var dx:Number = ray[1].x - ray[0].x;
				var dy:Number = ray[1].y - ray[0].y;
				var blockSpacing:Number = Math.sqrt(dx * dx + dy * dy);
				
				for ( var i:int = 1; i < ray.length; i++ )
				{	
					dragDist -= blockSpacing;
					if( dragDist >= 0 )
						_selected.push(ray[i]);
				}
				
				for ( var i:int = 0; i < _selected.length; i++ )
					_selected[i].filters = [selectedGlow];
				//event.currentTarget.filters = [selectedGlow];
			}
		}
		
		private function checkSelection():void
		{
			var isCorrect:Boolean = true;
			for ( var i:int = 0; i < _currentWord.length; i++ )  
			{
				if ( i >= _selected.length || _selected[i].number != _currentWord[i].number )
					isCorrect = false;
			}
			
			if ( isCorrect )
			{
				dispatchEvent(new Event(Event.COMPLETE));
				trace("FOUND!");
			}
			else
			{
				clearFilters();
				dispatchEvent(new Event(Event.CANCEL));
			}
			
			_selected = null;
		}
		
		private function clearFilters():void
		{
			for ( var r:int = 0; r < _gridWidth; r++ )
				for ( var c:int = 0; c < _gridHeight; c++ )
					_grid[r][c].filters = [];
		}
		
		public function get totalCells():int
		{
			var retval:int = -1;
			if ( _grid )
				retval = _gridHeight * _gridWidth;
			return retval;
		}
		
		public function search(startIndex, direction, size):Array
		{
			var ray:Array = tileRay(startIndex, direction);
			
			if ( size > ray.length )
				return null;
			
			var traceStr:String = "";
			var word:Array = [];
			for ( var i:int = 0; i < size; i++ )
			{
				word.push(ray[i]);
				traceStr += ray[i].number +",";
			}
			trace(traceStr);
			return word;
		}
		
		private function tileRay(startIndex:int, direction:int):Array
		{
			var r:int = startIndex % _gridWidth;
			var c:int = startIndex / _gridHeight;
			
			var word:Array = [_grid[r][c]];
			//trace("index:"+startIndex+", r:"+r+", c:"+ c+", block:"+_grid[r][c].number);
			
			switch( direction )
			{
				case DIR_N:
				while ( _grid[r][--c] )
					word.push(_grid[r][c]);
				break;
				
				case DIR_NE:
				while ( ++r < _gridWidth && --c >= 0 )
					word.push(_grid[r][c]);
				break;
				
				case DIR_E:
				while ( ++r < _gridWidth )
					word.push(_grid[r][c]);
				break;
				
				case DIR_SE:
				while ( ++r < _gridWidth && ++c < _gridHeight )
					word.push(_grid[r][c]);
				break;
				
				case DIR_S:
				while ( ++c < _gridHeight )
					word.push(_grid[r][c]);
				break;
				
				case DIR_SW:
				while ( --r >= 0 && ++c < _gridHeight )
					word.push(_grid[r][c]);
				break;
				
				case DIR_W:
				while ( --r >= 0 )
					word.push(_grid[r][c]);
				break;
				
				case DIR_NW:
				while ( --r >= 0 && --c >= 0 )
					word.push(_grid[r][c]);
				break;
			}
			
			return word;
		}
		
		public function findTargetWord(size:int = 5):void
		{
			if ( _currentWord )
			{
				_currentWord = null;
				clearFilters();
			}
			
			do {
				var startIndex:int = int(Math.random() * this.totalCells);
				var direction:int = int(Math.random() * 8);
				
				_currentWord = this.search(startIndex, direction, size);
			} while ( !_currentWord );
			
			if ( _wordSprite )
				this.removeChild(_wordSprite);
				
			_wordSprite = new Sprite();
			_wordSprite.x = -230;
			_wordSprite.y = 120;
			for ( var i:int = 0; i < _currentWord.length; i++ )
			{
				var block:Block = new Block(_currentWord[i].color);
				block.x = i * (Block.BLOCKSIZE + 4);
				_wordSprite.addChild(block);
			}
			this.addChild(_wordSprite);
		}
		
	}

}