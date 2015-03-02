package  
{
	/**
	 * ...
	 * @author Joe
	 */
	public class Set
	{
		private var _set:Array = null;
		
		public function Set() 
		{
			_set = [];
		}
		
		public function contains(element:*):Boolean
		{
			for ( var i:int = 0; i < _set.length; i++ )
			{
				if ( _set[i] === element )
					return true;
			}
			
			return false;
		}
		
		public function add(element:*):Boolean
		{
			if ( !this.contains(element) )
			{
				_set.push(element);
				return true;
			}
			return false;
		}
		
		public function remove(element:*):Boolean
		{
			for ( var i:int = 0; i < _set.length; i++ )
			{
				if ( _set[i] === element )
				{
					_set.splice(i, 1);
					return true;
				}
			}
			
			return false;
		}
		
		public function union(secondSet:Set):Boolean
		{
			var modified:Boolean = false;
			for ( var i:int = 0; i < secondSet.size; i++ )
			{
				var element:* = secondSet._set[i];
				if ( !this.contains(element) )
				{
					this._set.push(element);
					modified = true;
				}
			}
			
			return modified;
		}
		
		public function get size():int
		{
			return _set.length;
		}
		
		public function toString():String
		{
			var retval:String = "";
			for ( var i:int = 0; i < _set.length; i++ )
			{
				retval += _set[i] + " ";
			}
			
			return retval;
		}
		
		public function get array():Array
		{
			return _set.concat();
		}
		
		public function clone():Set
		{
			var newSet:Set = new Set();
			newSet._set = this._set.concat();
			return newSet;
		}
	}

}