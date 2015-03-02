package  
{
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Joe
	 */
	public class RedX extends Sprite
	{
		public function RedX() 
		{
			this.graphics.lineStyle(4, 0x100000);
			this.graphics.moveTo(0, 0);
			this.graphics.lineTo(Block.BLOCKSIZE, Block.BLOCKSIZE);
			this.graphics.moveTo(Block.BLOCKSIZE, 0);
			this.graphics.lineTo(0, Block.BLOCKSIZE);
		}
		
	}

}