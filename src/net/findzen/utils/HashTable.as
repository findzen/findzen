package net.findzen.utils {

	import flash.utils.Dictionary;


	public class HashTable {

		private var _indexes:Vector.<String>;
		private var _hashes:Dictionary;
		private var _keys:Dictionary;


		public function HashTable($weakKeys:Boolean = false) {
			_indexes = new Vector.<String>();
			_hashes = new Dictionary($weakKeys);
			_keys = new Dictionary(true);
		}

		public function addItem($key:String, $val:Object):void {
			_hashes[$key] = $val;
			_keys[$key] = _indexes.push($key);
		}

		public function getItem($key:String):Object {
			return _hashes[$key] || null;
		}

		public function getItemAt($i:uint):Object {
			return ($i < _indexes.length) ? getItem(_indexes[$i]) : null;
		}

		public function getKeyAt($i:uint):String {
			return ($i < _indexes.length) ? _indexes[$i] : null;
		}

		public function getIndex($key:String):uint {
			return _keys[$key] || null;
		}

		public function get length():uint {
			return _indexes.length;
		}

		public function get contents():Dictionary {
			return _hashes;
		}

		public function get keys():Dictionary {
			return _keys;
		}



	}
}