package  
{
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Joe
	 */
	public class CheckMark extends Sprite
	{
		public function CheckMark() 
		{
			this.graphics.lineStyle(4, 0x00FF00);
			this.graphics.moveTo(0, Block.BLOCKSIZE / 2);
			this.graphics.lineTo(Block.BLOCKSIZE / 2, Block.BLOCKSIZE);
			this.graphics.lineTo(Block.BLOCKSIZE, 0);
		}
		
	}

}