package  
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author Joe
	 */
	public class QuadGraph extends Sprite
	{
		private var _graph:Graph;
		private var _currentCover:Set;
		
		private var _vertexSprites:Array;
		private var _edgeSprites:Array;
		
		public function QuadGraph(numVerts:int, numEdges:int) 
		{
			trace("Making new graph with " + numVerts + " vertices, " + numEdges + " edges");
			_graph = new Graph();
			randomizeGraph(numVerts, numEdges);
			_currentCover = new Set();
			
			_vertexSprites = [];
			_edgeSprites = [];
			draw();
		}
		
		private function randomizeGraph(numVerts:int, numEdges:int):void
		{
			for ( var i:int = 0; i < numVerts; i++ )
			{
				_graph.addVertex();
			}
			
			for ( var j:int = 0; j < numEdges; )
			{
				var u:int = int(Math.random() * numVerts);
				var v:int = int(Math.random() * numVerts);
				
				if( !_graph.containsEdge(u, v) &&
					_graph.getNeighborCount(u) <= 4 &&
					_graph.getNeighborCount(v) <= 4 )
				{
					trace("edge", u, v);
					_graph.addEdge(u, v);
					j++;
				}
			}
		}
		
		private function draw():void
		{
			for ( var i:int = 0; i < _graph.numVertices; i++ )
			{
				var v:Sprite = vertexSprite(i);
				//v.x = 100 + 100 * (i % 4);
				//v.y = 200 + 100 * int(i / 4);
				v.x = 400 + 200 * Math.sin(i * (Math.PI / 6));
				v.y = 300 + 200* Math.cos(i * (Math.PI / 6));
				this.addChild(v);
				
				_vertexSprites.push( { id:i, sprite:v, edges:[], selected:false } );
				v.addEventListener(MouseEvent.CLICK, onVertexClick);
			}
			
			var edges:Array = _graph.edges;
			for ( var j:int = 0; j < edges.length; j++ )
			{
				var uSprite:Sprite = _vertexSprites[edges[j].u].sprite;
				var vSprite:Sprite = _vertexSprites[edges[j].v].sprite;
				var e:Sprite = edgeSprite(uSprite, vSprite);
				
				_vertexSprites[edges[j].u].edges.push(e);
				_vertexSprites[edges[j].v].edges.push(e);
				
				this.addChild(e);
			}
		}
		
		private function vertexSprite(vertexNum:int):Sprite
		{
			var v:Sprite = new Sprite();
			v.graphics.beginFill(0x0033FF);
			v.graphics.drawRect( -25, -25, 50, 50);
			
			var text:TextField = new TextField();
			text.defaultTextFormat = vertexTextFormat;
			text.text = String(vertexNum);
			text.selectable = false;
			text.mouseEnabled = false;
			text.x = 25;
			text.y = 25;
			//v.addChild(text);
			
			return v;
		}
		
		private function edgeSprite(u:Sprite, v:Sprite):Sprite
		{
			//check if diagonal line
			//if ( u.x != v.x && u.y != v.y )
				
			var e:Sprite = new Sprite();
			e.graphics.lineStyle(3, 0x00FF80);
			e.graphics.moveTo(u.x, u.y);
			e.graphics.lineTo(v.x, v.y);
			
			return e;
		}
		
		private function onVertexClick(event:MouseEvent):void
		{
			var t:Object = event.target;
			var v:Object = null;
			for ( var i:int = 0; i < _vertexSprites.length; i++ )
			{
				if ( t === _vertexSprites[i].sprite )
				{
					//trace("found!");
					v = _vertexSprites[i];
					break;
				}
			}
			
			if ( v == null )
			{
				trace("shouldn't be here");
				return;
			}
			
			var sprite:Sprite = v.sprite;
			var edges:Array = v.edges;
			if ( v.selected )
			{
				//trace("unselected");
				v.selected = false;
				_currentCover.remove(v.id);
				
				sprite.transform.colorTransform = normalColor;
				
				for ( var k:int = 0; k < edges.length; k++ )
				{
					(edges[k] as Sprite).transform.colorTransform = normLineColor;
				}
				
				for ( var n:int = 0; n < _vertexSprites.length; n++ )
				{
					if ( _vertexSprites[n].selected )
					{
						for ( var m:int = 0; m < _vertexSprites[n].edges.length; m++ )
						{
							(_vertexSprites[n].edges[m] as Sprite).transform.colorTransform = selLineColor;
						}
					}
				}
				dispatchEvent(new Event(Event.CANCEL));
			}
			else
			{
				//trace("changing color");
				sprite.transform.colorTransform = selectedColor;
				
				for ( var j:int = 0; j < edges.length; j++ )
				{
					(edges[j] as Sprite).transform.colorTransform = selLineColor;
				}
				
				v.selected = true;
				_currentCover.add(v.id);
				
				
				dispatchEvent(new Event(Event.SELECT));
			}
			
			if ( _graph.isVertexCover(_currentCover) )
			{
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		public function clearCover():void
		{
			_currentCover = new Set();
			
			for ( var n:int = 0; n < _vertexSprites.length; n++ )
			{
				_vertexSprites[n].selected = false;
				(_vertexSprites[n].sprite as Sprite).transform.colorTransform = normalColor;
				
				for ( var m:int = 0; m < _vertexSprites[n].edges.length; m++ )
				{
					(_vertexSprites[n].edges[m] as Sprite).transform.colorTransform = normLineColor;
				}
			}
		}
		
		public function get graph():Graph
		{
			return _graph;
		}
		
		public function get currentCover():Set
		{
			return _currentCover;
		}
		
		private static var selectedColor:ColorTransform;
		private static var normalColor:ColorTransform;
		{
			selectedColor = new ColorTransform(1, 1, 1, 1, 200, 128, -255);
			normalColor = new ColorTransform(0, 0, 1, 1, 0, 0, 255);
		}
		
		private static var selLineColor:ColorTransform;
		private static var normLineColor:ColorTransform; //0x00FF80
		{
			selLineColor = new ColorTransform(1, 1, 1, 1, 255, -255, -255);
			normLineColor = new ColorTransform(0, 1, 1, 1, 0, 255, 0);
		}
		
		private static var vertexTextFormat:TextFormat;
		{
			vertexTextFormat = new TextFormat();
			vertexTextFormat.color = 0x000000;
			vertexTextFormat.bold = true;
			vertexTextFormat.font = "Arial";
			vertexTextFormat.size = 14;
		}
	}

}