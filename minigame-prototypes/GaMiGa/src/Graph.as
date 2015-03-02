package  
{
	/**
	 * ...
	 * @author Joe
	 */
	public class Graph
	{
		private var _adjList:Array;
		private var _edges:Array;
		
		public function Graph():void
		{
			_adjList = [];
			_edges = [];
		}
		
		public function addVertex():int
		{
			return _adjList.push([]) - 1;
		}
		
		/**
		 * 
		 * @param	u
		 * @param	v
		 * @return -1 if invalid vertices
		 */
		public function addEdge(u:int, v:int):int
		{
			if ( u == v )
				return -1;
			if ( u >= _adjList.length || v >= _adjList.length || u < 0 || v < 0 )
				return -1;
				
			var ulist:Array = _adjList[u];
			var vlist:Array = _adjList[v];
			
			//if this edge does not exist
			if ( ulist.indexOf(v) == -1 && vlist.indexOf(u) == -1 )
			{
				//add the edge
				ulist.push(v);
				vlist.push(u);
				
				return _edges.push( { u:u, v:v } ) - 1;
			}
			
			return -1;
		}
		
		public function containsEdge(u:int, v:int):Boolean
		{
			if ( u >= _adjList.length || v >= _adjList.length || u < 0 || v < 0 )
				return false;
				
			var ulist:Array = _adjList[u];
			var vlist:Array = _adjList[v];
			
			//if this edge does exist
			return !( ulist.indexOf(v) == -1 && vlist.indexOf(u) == -1 );
		}
		
		public function getNeighborCount(vertex:int):int
		{
			if ( vertex >= _adjList.length || vertex < 0 )
				return -1;
				
			return (_adjList[vertex] as Array).length;
		}
		
		public function getNeighbors(vertex:int):Array
		{
			if ( vertex >= _adjList.length || vertex < 0 )
				return null;
				
			return (_adjList[vertex] as Array);
		}
		
		public function getOpposite(vertex:int):int
		{
			for ( var i:int = 0; i < _edges.length; i++ )
			{
				if ( _edges[i].u == vertex )
					return _edges[i].v;
				else if ( _edges[i].v == vertex )
					return _edges[i].u;
			}
			
			return -1;
		}
		
		public function getEdgeID(u:int, v:int):int
		{
			for ( var i:int = 0; i < _edges.length; i++ )
			{
				if( (_edges[i].u == u && _edges[i].v == v) ||
					(_edges[i].u == v && _edges[i].v == u) )
					return i;
			}
			
			return -1;
		}
		
		public function getEdge(u:int, v:int):Object
		{
			for ( var i:int = 0; i < _edges.length; i++ )
			{
				if( (_edges[i].u == u && _edges[i].v == v) ||
					(_edges[i].u == v && _edges[i].v == u) )
					return _edges[i];
			}
			
			return null;
		}
		
		public function get edges():Array
		{
			return _edges;
		}
		
		public function get numVertices():int
		{
			return _adjList.length;
		}
		
		public function get numEdges():int
		{
			return _edges.length;
		}
		
		public function clone():Graph
		{
			var g:Graph = new Graph();
			g._adjList = this._adjList.concat();
			g._edges = this._edges.concat();
			
			return g;
		}
		
		/**** VERTEX COVER *****/

		public function approxCover():int
		{
			var approxCover:Array = [];
			
			var edges:Array = _edges.concat();
			
			while ( edges.length > 0 )
			{
				var randomEdge:int = int(Math.random() * edges.length);
				var edge:Object = edges[randomEdge];
				trace("numEdges: " + edges.length + ", random: " + randomEdge);
				
				var u:int = edge.u;
				var v:int = edge.v;
					
				approxCover.push(u);
				approxCover.push(v);
				var coverEdge:Object = this.getEdge(u, v);
				var coverEdgeIndex:int = edges.indexOf(coverEdge);
				if ( coverEdgeIndex != -1 )
				{
					trace("removing edge:", coverEdge.u, coverEdge.v);
					edges.splice(coverEdgeIndex, 1);
				}
				
					
				var uNeighbors:Array = this.getNeighbors(u);
				var vNeighbors:Array = this.getNeighbors(v);
					
				trace(u + " uNeighbors: " + uNeighbors);
				trace(v + " vNeighbors: " + vNeighbors);
					
				for ( var ui:int = 0; ui < uNeighbors.length; ui++ )
				{
					var uNeighbor:int = uNeighbors[ui];
					if ( uNeighbor == v )
						continue;
							
					var uEdge:Object = this.getEdge(u, uNeighbor);
					var uEdgeIndex:int = edges.indexOf(uEdge);
					if ( uEdgeIndex != -1 )
					{
						trace("removing edge:", uEdge.u, uEdge.v);
						edges.splice(uEdgeIndex, 1);
					}
					else
						trace("edge is already removed", edge);
				}
					
				for ( var vi:int = 0; vi < vNeighbors.length; vi++ )
				{
					var vNeighbor:int = vNeighbors[vi];
					if ( vNeighbor == u )
						continue;
							
					var vEdge:Object = this.getEdge(v, vNeighbor);
					var vEdgeIndex:int = edges.indexOf(vEdge);
					if ( vEdgeIndex != -1 )
					{
						trace("removing edge:", vEdge.u, vEdge.v);
						edges.splice(vEdgeIndex, 1);
					}
					else
						trace("edge is already removed", edge);
				}
			}
			
			trace("cover:", approxCover);
			return approxCover.length;
		}
		
		/** 
		 * http://www.dharwadker.org/vertex_cover/
		 */
		public function minVertexCover():Array
		{
			var minCover:Array = minCoverOfVertex(0);
			
			for ( var v:int = 1; v < _adjList.length; v++ )
			{
				var vMinCover:Array = minCoverOfVertex(v);
				if ( vMinCover.length < minCover.length )
					minCover = vMinCover;
			}
			
			return minCover;
		}
		
		private function minCoverOfVertex(vertex:int):Array
		{
			trace("Finding min cover with vertex", vertex);
			//initialize Cv = V - {v}
			var cover:Set = new Set();
			for ( var i:int = 0; i < _adjList.length; i++ )
			{
				if ( vertex == i )
					continue;
				cover.add(i);
			}
			
			return reduceCover(cover).array;
		}
		
		private function reduceCover(cover:Set):Set
		{
			var removableVerts:Array = getRemovables(cover).array;
			
			trace(removableVerts + " can be removed from " + cover);
			if ( removableVerts.length == 0 )
				return cover;
			
			var maxRemovableVert:int = -1;
			var maxRemovableSize:int = -1;
			
			for ( var j:int = 0; j < removableVerts.length; j++ )
			{
				var testCoverMinusV:Set = cover.clone();
				testCoverMinusV.remove(removableVerts[j]);
				
				var testSize:int = getRemovables(testCoverMinusV).size;
				if ( testSize > maxRemovableSize )
				{
					maxRemovableSize = testSize;
					maxRemovableVert = removableVerts[j];
				}
			}
			
			trace("removing " + maxRemovableVert + " from " + cover + ", removes: "+maxRemovableSize);
			cover.remove(maxRemovableVert);
				
			return reduceCover(cover);
		}
		
		private function getRemovables(cover:Set):Set
		{
			var removableVerts:Set = new Set();
			var candidateVerts:Array = cover.array;
			for ( var j:int = 0; j < candidateVerts.length; j++ )
			{
				if ( isRemovable(cover, candidateVerts[j]) )
					removableVerts.add(candidateVerts[j]);
			}
			
			return removableVerts;
		}
		
		private function isRemovable(cover:Set, vertex:int):Boolean
		{
			var testCover:Set = cover.clone();
			testCover.remove(vertex);
			
			return this.isVertexCover(testCover);
		}
		
		public function isVertexCover(coverSet:Set):Boolean
		{
			var edgesInCover:Set = new Set();
			
			var cover:Array = coverSet.array;			
			for ( var i:int = 0; i < cover.length; i++ )
			{
				var neigh:Array = this.getNeighbors(cover[i]);
				for ( var n:int = 0; n < neigh.length; n++ )
				{
					edgesInCover.add(this.getEdgeID(cover[i], neigh[n]));
				}
			}
			
			return edgesInCover.size == _edges.length;
		}
		
	}

}