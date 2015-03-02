package
{
	import fl.controls.Button;
	import fl.controls.CheckBox;
	import fl.motion.AdjustColor;
	import fl.transitions.Tween;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.ColorTransform;
	import fl.transitions.TweenEvent;
	/**
	 * ...
	 * @author Joe
	 */
	public class Game extends Sprite
	{
		private var _strips:Array;
		private var _checkBoxes:Array;
		
		private var _hasColors:Array;
		private var _needRemake:Boolean = true;
		
		//private var _numStrips:int = 11;
		private var _minStripSize:int = 2;
		private var _maxStripSize:int = 4;
		
		private var _numColors:int = 15;// Block.COLORS.length;
		private var _subsetSize:int = 3;
		private var _numStrips:int = _numColors / _subsetSize;
		private var _stripSize = 6;
		
		private var _slideRightBtns:Array = [];
		private var _slideLeftBtns:Array = [];
		
		private var _displayStripX:int = 200;
		private var _displayStripY:int = 100;
		private var _displayBlockMargin:int = 5;
		
		public function Game(numColors:int, subsetSize:int, stripSize:int) 
		{
			_numColors = numColors;
			_subsetSize = subsetSize;
			_stripSize = stripSize;
			_numStrips = _numColors / _subsetSize;
			
			//while ( _needRemake || !hasExactCover() )
			//	makeGame();
			do {
				_strips = [];
				_slideRightBtns = [];
				_slideLeftBtns = [];
				var solution:Array = makeCover();
				fillOutSolution(solution.concat());
			} while (isExactCover()); //make sure the puzzle created isn't already solved...
			
			
			createSlideButtons();
			
			drawSetOutline(_displayStripX - _displayBlockMargin / 2, 
							_displayStripY - _displayBlockMargin / 2 );
			drawRowLines();
			drawStatus();
			updateStatus();
		}
		
		private function makeCover():Array
		{
			var ordering:Set = new Set();
			var solution:Array = [];
			
			//fill up the ordering set with random indices
			while ( ordering.size < _numColors )
			{
				ordering.add( int(Math.random() * _numColors) );
			}
			
			var orderingArray:Array = ordering.array;
			trace(orderingArray);
			for ( var stripIndex:int = 0; stripIndex < _numStrips; stripIndex++ )
			{
				var colors:Set = new Set();
				
				for ( var blockIndex:int = 0; blockIndex < _subsetSize; blockIndex++)
				{
					colors.add(Block.COLORS[orderingArray[stripIndex*_subsetSize + blockIndex]]);
				}
				
				solution.push(colors);
			}
			
			return solution;
		}
		
		private function fillOutSolution(solution:Array):void
		{
			for ( var solIndex:int = 0; solIndex < solution.length; solIndex++ )
			{
				//fill in random colors
				var colors:Set = solution[solIndex];
				var preColors:Set = new Set();
				var postColors:Set = new Set();
				while ( colors.size + preColors.size + postColors.size < _stripSize )
				{
					var randColor:int = Block.COLORS[int(Math.random() * _numColors)];
					if ( colors.contains(randColor) )
						continue;
					
					var flip:int = Math.round(Math.random());
					if ( flip == 0 )
					{
						if ( postColors.contains(randColor) )
							continue;
						preColors.add( randColor );
					}
					else
					{
						if ( preColors.contains(randColor) )
							continue;
						postColors.add( randColor );
					}
				}
					
				var rawStrip:Set = new Set();
				rawStrip.union(preColors);
				rawStrip.union(colors);
				rawStrip.union(postColors);
				
				var strip:Strip = new Strip(rawStrip);
				strip.x = _displayStripX;
				strip.y = _displayStripY + (strip.height + _displayBlockMargin) * solIndex;
				//strip.addEventListener(MouseEvent.MOUSE_UP, onStripMouseUp);
				//strip.addEventListener(MouseEvent.MOUSE_DOWN, onStripMouseDown);
				//strip.addEventListener(MouseEvent.MOUSE_MOVE, onStripMouseMove);
				this.addChild(strip);
				_strips.push(strip);
			}
		}
		
		private function createSlideButtons():void
		{
			for ( var i:int = 0; i < _strips.length; i++ )
			{
				var rBtn:Button = new Button();
				rBtn.label = ">";
				rBtn.width = 25;
				rBtn.x = 465;
				rBtn.y = _displayStripY + (Block.BLOCKSIZE + _displayBlockMargin) * i;
				rBtn.addEventListener(MouseEvent.CLICK, onRBtnClick);
				_slideRightBtns.push(rBtn);
				this.addChild(rBtn);
				
				var lBtn:Button = new Button();
				lBtn.label = "<";
				lBtn.width = 25;
				lBtn.x = 10;
				lBtn.y = _displayStripY + (Block.BLOCKSIZE + _displayBlockMargin) * i;
				lBtn.addEventListener(MouseEvent.CLICK, onLBtnClick);
				_slideLeftBtns.push(lBtn);
				this.addChild(lBtn);
			}
		}
		
		private function onRBtnClick(event:MouseEvent):void
		{
			var btn:Object = event.currentTarget;
			var index:int = 0;
			for ( var i:int = 0; i < _slideRightBtns.length; i++ )
			{
				if ( _slideRightBtns[i] === btn )
				{
					index = i;
					break;
				}
			}
			
			var oldIndex:int = _strips[index].currentBlockIndex;
			_strips[index].shiftRight();
			var shiftDelta:int =  _strips[index].currentBlockIndex - oldIndex;
			
			_strips[index].x -= shiftDelta * (Block.BLOCKSIZE + _displayBlockMargin);
			
			if ( isExactCover() )
			{
				dispatchEvent(new Event(Event.COMPLETE));
			}
			
			updateStatus();
		}
		
		private function onLBtnClick(event:MouseEvent):void
		{
			var btn:Object = event.currentTarget;
			var index:int = 0;
			for ( var i:int = 0; i < _slideLeftBtns.length; i++ )
			{
				if ( _slideLeftBtns[i] === btn )
				{
					index = i;
					break;
				}
			}
			
			var oldIndex:int = _strips[index].currentBlockIndex;
			_strips[index].shiftLeft();
						
			if ( _strips[index].currentBlockIndex + _subsetSize > _stripSize )
			{
				//we've gone too far!
				_strips[index].shiftRight();
				return;
			}
			
			var shiftDelta:int = oldIndex - _strips[index].currentBlockIndex;
			
			_strips[index].x += shiftDelta * (Block.BLOCKSIZE + _displayBlockMargin);
			
			if ( isExactCover() )
			{
				dispatchEvent(new Event(Event.COMPLETE));
			}
			
			updateStatus();
		}
		
		private function isExactCover():Boolean
		{
			var checkSet:Set = new Set();
			for ( var stripIndex:int = 0; stripIndex < _strips.length; stripIndex++ )
			{
				for ( var blockIndex:int = 0; blockIndex < _subsetSize; blockIndex++ )
				{
					var absoluteBlockIndex:int = _strips[stripIndex].currentBlockIndex + blockIndex;
					var blockNum:int = _strips[stripIndex].blocks[absoluteBlockIndex].number;
					
					//if adding this element does not modify the set, i.e. there is a duplicate
					if ( !checkSet.add( blockNum ) )
						return false;
				}
			}
			
			
			/*var checkSet:Set = new Set();
			for ( var stripIndex:int = 0; stripIndex < _strips.length; stripIndex++ )
			{
				for ( var blockIndex:int = _strips[stripIndex].currentBlockIndex; blockIndex < _subsetSize; blockIndex++ )
				{
					//if adding this element does not modify the set, i.e. there is a duplicate
					if ( !checkSet.add( _strips[stripIndex].blocks[blockIndex].number ) )
						return false;
				}
			}*/
			trace("exact cover!", checkSet.toString());
			return true;
		}
		
		/*private var mouseDown:Boolean = false;
		private var draggingStrip:Strip = null;
		private var dragStartX:int = 0;
		private var dragStartY:int = 0;
		public function onStripMouseMove():void
		{
			if ( draggingStrip != null )
			{
				//delta is > 0 if mouse move right
				var mouseDelta:int = dragStartX - this.mouseX;
				var scrollAmount:int = mouseDelta / Block.BLOCKSIZE;
				
				trace("mouse delta = " + mouseDelta + "; scroll = " + scrollAmount);
				
				draggingStrip.currentBlockIndex += scrollAmount;
				var oldX:int = draggingStrip.x;
				
				//check bounds
				if ( draggingStrip.currentBlockIndex > _stripSize - _subsetSize )
					draggingStrip.currentBlockIndex = _stripSize - _subsetSize;
				else if ( draggingStrip.currentBlockIndex < 0 )
					draggingStrip.currentBlockIndex = 0;
					
				draggingStrip.x = _displayStripX + draggingStrip.currentBlockIndex * -Block.BLOCKSIZE;
			}
		}
		
		public function onStripMouseUp():void
		{
			mouseDown = false;
			draggingStrip = null;
		}
		
		public function onStripMouseDown(strip:Strip):void
		{
			mouseDown = true;
			draggingStrip = strip;
			dragStartX = this.mouseX;
			dragStartY = this.mouseY;
			trace(draggingStrip);
		}*/
		
		private function updateStatus():void
		{
			//mark all as unselected
			for ( var i:int = 0; i < _statusBoxes.length; i++ )
			{
				//_statusBoxes[i].transform.colorTransform = UNSELECTED_STATUS;
				_statusBoxes[i].filters = [GREYSCALE_FILTER];
				//if( _statusBoxes[i].numChildren > 1 )
				//	_statusBoxes[i].removeChildAt(1);
			}
			
			var checkSet:Set = new Set();
			for ( var stripIndex:int = 0; stripIndex < _strips.length; stripIndex++ )
			{
				var traceline:String = "strip " + stripIndex + ",";
				for ( var blockIndex:int = 0; blockIndex < _subsetSize; blockIndex++ )
				{
					//if adding this element modifies the set, then this is this first copy
					var absoluteBlockIndex:int = _strips[stripIndex].currentBlockIndex + blockIndex;
					var blockNum:int = _strips[stripIndex].blocks[absoluteBlockIndex].number;
					
					traceline += " " + blockNum;
					
					if ( checkSet.add( blockNum ) )
					{
						//_statusBoxes[blockNum].transform.colorTransform = SELECTED_STATUS;
						_statusBoxes[blockNum].filters = [NORMAL_FILTER];
						//_statusBoxes[blockNum].addChildAt(new CheckMark(), 1);
						//trace("check ", blockNum);
					}
					else //there is a duplicate
					{
						_statusBoxes[blockNum].filters = [DUPLICATE_FILTER];
						//if( _statusBoxes[blockNum].numChildren > 0 )
						//	_statusBoxes[blockNum].removeChildAt(1);
						//_statusBoxes[blockNum].addChildAt(new RedX(), 1);
					}
				}
				//trace(traceline);
			}
			//trace("------");
		}
		
		private static var GREYSCALE_FILTER:ColorMatrixFilter;
		private static var NORMAL_FILTER:ColorMatrixFilter;
		private static var DUPLICATE_FILTER:ColorMatrixFilter;
		{
			static var greymat:Array = 
			[ .3,.3,.3,0,150,
			  .3,.3,.3,0,150,
			  .3,.3,.3,0,150,
			  0,0,0,1,0 ];
			GREYSCALE_FILTER = new ColorMatrixFilter(greymat);
			
			static var normal:Array = 
			[ 1,0,0,0,0,
			  0,1,0,0,0,
			  0,0,1,0,0,
			  0,0,0,1,0 ];
			NORMAL_FILTER = new ColorMatrixFilter(normal);
			
			static var dup:Array = 
			[ .3,.3,.3,0,100,
			  .3,.3,.3,0,100,
			  .3,.3,.3,0,100,
			  0,0,0,1,0 ];
			DUPLICATE_FILTER = new ColorMatrixFilter(dup);
		}
		
		private var _statusBoxes:Array;
		private function drawStatus():void
		{
			_statusBoxes = [];
			for ( var colorIndex:int = 0; colorIndex < _numColors; colorIndex++ )
			{
				var block:Block = new Block(Block.COLORS[colorIndex]);
				
				var row:int = colorIndex / 8;
				block.x = 25 + (block.width + _displayBlockMargin) * (colorIndex % 8);
				block.y = 320 + (block.height + _displayBlockMargin) * row;
				
				this.addChild(block);
				_statusBoxes.push(block);
			}
		}
		
		private function drawSetOutline(boxX:int, boxY:int):void
		{
			var outline:Sprite = new Sprite();
			outline.graphics.lineStyle(3, 0x000000);
			outline.graphics.moveTo(boxX, boxY);
			outline.graphics.lineTo(boxX + (Block.BLOCKSIZE + _displayBlockMargin)*_subsetSize, boxY);
			outline.graphics.lineTo(boxX + (Block.BLOCKSIZE + _displayBlockMargin) * _subsetSize,
									boxY + (Block.BLOCKSIZE + _displayBlockMargin) * _numStrips);
			outline.graphics.lineTo(boxX, boxY + (Block.BLOCKSIZE + _displayBlockMargin) * _numStrips);
			outline.graphics.lineTo(boxX, boxY);
			this.addChildAt(outline, 0);
			/*this.graphics.beginFill(0x000000);
			this.graphics.drawRect(boxX, boxY, 
				(Block.BLOCKSIZE + 5) * _subsetSize, 
				(Block.BLOCKSIZE + 5) * _numStrips);*/
		}
		
		private function drawRowLines():void
		{
			for ( var i:int = 0; i < _strips.length; i++ )
			{
				if ( i % 2 == 1 )
					continue;
				
				var bg:Sprite = new Sprite();
				bg.graphics.beginFill(0xF6F6F6);
				bg.graphics.drawRect(0, _displayStripY + (Block.BLOCKSIZE + _displayBlockMargin) * i-3, 500, Block.BLOCKSIZE+6);
				this.addChildAt(bg,0);
			}
		}
		
		public function disable():void
		{
			for ( var i:int = 0; i < _slideRightBtns.length; i++ )
			{
				_slideRightBtns[i].enabled = false;
				_slideLeftBtns[i].enabled = false;
			}
		}
	}

}