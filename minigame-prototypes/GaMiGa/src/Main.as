package 
{
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author Joe
	 */
	public class Main extends Sprite 
	{
		private var graph:QuadGraph;
		private var minCover:Array = null;
		private var numVertSelected:int = 0;
		
		private var timerText:TextField;
		private var vertexSelectedText:TextField;
		private var goalCoverText:TextField;
		private var minCoverText:TextField;
		private var statusText:TextField;
		
		private var clearBtn:TextField;
		private var newGraphBtn:TextField;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			timerText = new TextField();
			var timertf:TextFormat = new TextFormat();
			timertf.font = "Arial";
			timertf.size = "108";
			timertf.bold = true;
			timertf.color = 0xAAAAAA;
			timerText.defaultTextFormat = timertf;
			timerText.selectable = false;
			timerText.x = 330;
			timerText.y = 240;
			timerText.height = 200;
			timerText.width = 200;
			this.addChild(timerText);
			
			vertexSelectedText = new TextField();
			var tf:TextFormat = new TextFormat();
			tf.font = "Arial";
			tf.size = "36";
			tf.bold = true;
			vertexSelectedText.defaultTextFormat = tf;
			vertexSelectedText.selectable = false;
			vertexSelectedText.text = "" + numVertSelected;
			vertexSelectedText.x = 50;
			vertexSelectedText.y = 100;
			this.addChild(vertexSelectedText);
			
			var covertf:TextFormat = new TextFormat();
			covertf.font = "Arial";
			covertf.size = "24";
			covertf.color = 0xFF3A3A;
			covertf.bold = true;
			
			minCoverText = new TextField();
			minCoverText.defaultTextFormat = covertf;
			minCoverText.selectable = false;
			minCoverText.x = 10;
			minCoverText.y = 10;
			minCoverText.width = 300;
			this.addChild(minCoverText);
			
			goalCoverText = new TextField();
			goalCoverText.defaultTextFormat = covertf;
			goalCoverText.selectable = false;
			goalCoverText.x = 10;
			goalCoverText.y = 50;
			goalCoverText.width = 300;
			//this.addChild(goalCoverText);
			
			var statustf:TextFormat = new TextFormat();
			statustf.font = "Arial";
			statustf.size = "24";
			statustf.color = 0x000000;
			statustf.bold = true;
			
			statusText = new TextField();
			statusText.defaultTextFormat = statustf;
			statusText.text = "Click on the squares to find a vertex cover";
			statusText.width = 600;
			statusText.x = stage.stageWidth / 2 - statusText.width/2;
			statusText.y = stage.stageHeight - 50;
			this.addChild(statusText);
			
			var buttontf:TextFormat = new TextFormat();
			buttontf.font = "Arial";
			buttontf.size = "16";
			buttontf.color = 0x000000;
			buttontf.bold = true;
			
			clearBtn = new TextField();
			clearBtn.selectable = false;
			clearBtn.defaultTextFormat = buttontf;
			clearBtn.background = true;
			clearBtn.backgroundColor = 0xAAAAFF;
			clearBtn.text = "Clear Cover";
			clearBtn.width = 100;
			clearBtn.height = 30;
			clearBtn.x = 25;
			clearBtn.y = 300;
			clearBtn.addEventListener(MouseEvent.CLICK, onClearBtn);
			this.addChild(clearBtn);
			
			newGraphBtn = new TextField();
			newGraphBtn.selectable = false;
			newGraphBtn.defaultTextFormat = buttontf;
			newGraphBtn.background = true;
			newGraphBtn.backgroundColor = 0xAAAAFF;
			newGraphBtn.text = "New Graph";
			newGraphBtn.width = 100;
			newGraphBtn.height = 30;
			newGraphBtn.x = 25;
			newGraphBtn.y = 350;
			newGraphBtn.addEventListener(MouseEvent.CLICK, onNewGraphBtn);
			this.addChild(newGraphBtn);
			
			newGraph();
			findMinCover();
		}
		
		private function newGraph():void
		{
			var numVerts:int = 12;
			var numEdges:int = int(Math.ceil(Math.random() *6)+14); 
			graph = new QuadGraph(numVerts, numEdges);
			graph.addEventListener(Event.SELECT, onSelect);
			graph.addEventListener(Event.CANCEL, onUnselect);
			graph.addEventListener(Event.COMPLETE, onCoverFound);
			this.addChild(graph);
			
			timerCount = 15;
			timer = new Timer(1000, 15);
			timer.addEventListener(TimerEvent.TIMER, onTick)
			timer.start();
		}
		private var timer:Timer;
		
		private var timerCount:int = 0;
		private var foundCover:Boolean = false;
		private function onTick(event:TimerEvent):void
		{
			if ( !foundCover )
			{
				timerText.text = "" + --timerCount;
				if ( timerCount == 0 )
				{
					graph.mouseChildren = false;
					statusText.text = "Times Up!";
				}
			}
		}
		
		private function findMinCover():void
		{
			minCover = this.graph.graph.minVertexCover();
			trace("Min Cover: " + minCover);
			
			minCoverText.text = "Min Cover: " + minCover.length;
		}
		
		private function removeGraph():void
		{
			if ( this.contains(graph) )
			{
				foundCover = false;
				graph.removeEventListener(Event.SELECT, onSelect);
				graph.removeEventListener(Event.CANCEL, onUnselect);
				graph.removeEventListener(Event.COMPLETE, onCoverFound);
				this.removeChild(graph);
				timer.removeEventListener(TimerEvent.TIMER, onTick)
				timer.stop();
			}
		}
		
		private function onSelect(event:Event):void
		{
			vertexSelectedText.text = "" + ++numVertSelected;
			foundCover = false;
			timer.start();
		}
		
		private function onUnselect(event:Event):void
		{
			vertexSelectedText.text = "" + --numVertSelected;
			statusText.text = "";
			foundCover = false;
			timer.start();
		}
		
		private function onCoverFound(event:Event):void
		{
			if ( numVertSelected <= minCover.length )
			{
				statusText.text = "Minimum vertex cover found!";
				foundCover = true;
				timer.stop();
			}
			else
			{
				statusText.text = "Not a minimum vertex cover.";
			}
		}
		
		private function onClearBtn(event:MouseEvent):void
		{
			statusText.text = "Cleared.";
			vertexSelectedText.text = "" + 0;
			numVertSelected = 0;
			foundCover = false;
			timer.start();
			this.graph.clearCover();
		}
		
		private function onNewGraphBtn(event:MouseEvent):void
		{
			onClearBtn(event);
			statusText.text = "New Graph";
			this.removeGraph();
			newGraph();
			findMinCover();
		}
	}
	
}