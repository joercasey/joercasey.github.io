package  
{
	/**
	 * ...
	 * @author Joe
	 */
	public class KnuthAlgX
	{
		
		public function KnuthAlgX() 
		{
			
		}
		
		public static function run(matrix:Array):Boolean
		{
			if ( matrix.length == 0 )
				return true;
				
			var sparsestCol:int = findSparsestCol(matrix);
			
			var solution:Array = branch([], matrix, sparsestCol);
			
			trace("sparsest col", sparsestCol);
			return false;
		}
		
		private static function branch(partialSolution:Array, matrix:Array, sparseCol:int):Boolean
		{
			var rowsWithCol:Array = findRowsWithCol(matrix, sparseCol);
			
			//var traceline:String = "Rows with sparsest col: ";
			for ( var i:int = 0; i < rowsWithCol.length; i++ )
			{
				//traceline += rowsWithCol[i] + " ";
				
			}
			//trace(traceline);
			
			
		}
		
		private static function findRowsWithCol(matrix:Array, sparseCol:int):Array
		{
			var rows:Array = [];
			for ( var row:int = 0; row < matrix.length; row++ )
			{
				if ( matrix[row][sparseCol] == 1 )
					rows.push(row);
			}
			
			return rows;
		}
		
		private static function findSparsestCol(matrix:Array):int
		{
			var colCounts:Array = []
			for ( var j:int = 0; j < matrix[0].length; j++ )
				colCounts.push(0);
			
			for ( var row:int = 0; row < matrix.length; row++ )
			{
				for ( var col:int = 0; col < matrix[row].length; col++ )
				{
					colCounts[col] += matrix[row][col];
				}
			}
			
			var sparsestCol:int = 0;
			var minCount:int = 0xFFFFFF;
			trace(minCount);
			for ( var i:int = 0; i < colCounts.length; i++ )
			{
				//trace("count: col " + i + " = " + colCounts[i]);
				if ( colCounts[i] < minCount )
				{
					sparsestCol = i;
					minCount = colCounts[i];
				}
			}
			
			return sparsestCol;
		}
		
	}

}