package net.findzen.utils.log.adapters {

	public interface ILogAdapter {

		/**
		 * Called on "Log.clear()"  This should clear the screen of your debugger.
		 */
		function clear():void;
		/**
		 * Log will print trace data to this function
		 *
		 * @param $prefix A standard string that Out prefaces it's calls with. Looks something like "STATUS  :::	MyClass	::"
		 * @param $level Which debugging level this call is on.  See Log.as for a list of constants.
		 * @param $objects A list of all of the parameters passed into the Out call.
		 *
		 */
		function output($prefix:String, $level:String, ... $objects):void;
	}
}