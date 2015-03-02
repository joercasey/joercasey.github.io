package  
{
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Joe
	 */
	public class Strip extends Sprite
	{
		private var _activeIndex:int = 0;
		private var _blocks:Array;
		
		public function Strip(colors:Set) 
		{
			_blocks = [];
			var colorArray:Array = colors.array;
			for (var i:int = 0; i < colorArray.length; i++ )
			{	
				var block:Block = new Block(colorArray[i]);
				block.x = (block.width + 5) * i;
				this.addChild(block);
				_blocks.push( block );
			}
		}
		
		public function shiftLeft():void
		{
			if ( ++_activeIndex > _blocks.length - 1 )
				_activeIndex = _blocks.length -1;
		}
		
		public function shiftRight():void
		{
			if ( --_activeIndex < 0 )
				_activeIndex = 0;
		}
		
		public function get currentBlockIndex():int
		{
			return _activeIndex;
		}
		public function set currentBlockIndex(val:int):void
		{
			this._activeIndex = val;
		}
		
		public function get currentBlock():Block
		{
			return _blocks[_activeIndex];
		}
		
		public function get length():int
		{
			return this._blocks.length;
		}
		
		public function get blocks():Array
		{
			return this._blocks;
		}
	}

}