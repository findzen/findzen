package net.findzen.utils
{
    import flash.display.Stage;
    import flash.events.EventDispatcher;
    import flash.utils.getQualifiedClassName;
    import flash.utils.getTimer;

    import net.findzen.utils.log.adapters.ILogAdapter;

    public class Log extends EventDispatcher
    {
        public static const DEBUG:int = 2;
        public static const ERROR:int = 4;
        public static const FATAL:int = 5;
        public static const INFO:int = 0;
        public static const STATUS:int = 1;
        public static const TIMER:int = 6;
        public static const WARNING:int = 3;

        private static var __debuggers:Array = [];
        private static var __levels:Array = [];
        private static var __silenced:Object = {};
        private static var __time:int;

        /**
         * Sends a clear message to any registered debuggers.  Doesn't do anything within the IDE.
         */
        public static function clear():void
        {
            if(__debuggers.length)
                for each(var i:ILogAdapter in __debuggers)
                    i.clear();
        }

        /**
         * Disable all debugging levels
         */
        public static function disableAllLevels():void
        {
            disableLevel(INFO);
            disableLevel(STATUS);
            disableLevel(DEBUG);
            disableLevel(WARNING);
            disableLevel(ERROR);
            disableLevel(FATAL);
            disableLevel(TIMER);
        }

        /**
         * Disable a specific debugging level
         * @param $level The level to disable
         */
        public static function disableLevel($level:int):void
        {
            __levels[$level] = null;
        }

        /**
         * Enable all debugging levels
         */
        public static function enableAllLevels():void
        {
            enableLevel(INFO);
            enableLevel(STATUS);
            enableLevel(DEBUG);
            enableLevel(WARNING);
            enableLevel(ERROR);
            enableLevel(FATAL);
            enableLevel(TIMER);
        }

        /**
         * Enable a specific debugging level
         * @param $level The level to enable
         */
        public static function enableLevel($level:int):void
        {
            __levels[$level] = __output;
        }

        /**
         * Check to see if an object is currently being silenced
         * @param $o The object being checked
         * @return A boolean indicating it's silenced state
         * @see silence
         * @see unsilence
         */
        public static function isSilenced($o:*):Boolean
        {
            var s:String = __getClassName($o);

            return __silenced[s];
        }

        public static function registerDebugger($debugger:ILogAdapter):void
        {
            __debuggers[__debuggers.length] = $debugger;
        }

        /**
         * Silence a specific object from making debug calls.
         * @param $o
         * @see unsilence
         */
        public static function silence($o:*):void
        {
            var s:String = __getClassName($o);

            __silenced[s] = true;
        }

        /**
         * Enable an object to start making debug calls again after it has been silenced using <code>silence</code>.
         * @param $o
         * @see silence
         */
        public static function unsilence($o:*):void
        {
            var s:String = __getClassName($o);

            __silenced[s] = false;
        }

        /////////////////////////////////////////////////////////////////////////////
        //// LEVELS
        ///////////////////////////////////////////////////////////////////////////

        public static function startTimer($origin:*, ... $args):int
        {
            __time = getTimer();

            if(!isSilenced($origin) && __levels.hasOwnProperty(TIMER) && __levels[TIMER] != null)
                __levels[TIMER].apply(null, [ 'TIMER', $origin ].concat($args, ':: START TIME: ' + __time + 'ms'));

            return __time;
        }

        public static function stopTimer($origin:*, ... $args):int
        {
            if(!isSilenced($origin) && __levels.hasOwnProperty(TIMER) && __levels[TIMER] != null)
                __levels[TIMER].apply(null, [ 'TIMER', $origin ].concat($args, ':: END TIME: ' + getTimer() + 'ms ELAPSED: ' + (getTimer() - __time) + 'ms'));

            return getTimer() - __time;
        }

        public static function debug($origin:*, ... $args):void
        {
            if(isSilenced($origin))
                return;

            if(__levels.hasOwnProperty(DEBUG) && __levels[DEBUG] != null)
                __levels[DEBUG].apply(null, [ "DEBUG", $origin ].concat($args));
        }

        public static function error($origin:*, ... $args):void
        {
            if(isSilenced($origin))
                return;

            if(__levels.hasOwnProperty(ERROR) && __levels[ERROR] != null)
                __levels[ERROR].apply(null, [ "ERROR", $origin ].concat($args));
        }

        public static function fatal($origin:*, $str:String, ... $args):void
        {
            if(isSilenced($origin))
                return;

            if(__levels.hasOwnProperty(FATAL) && __levels[FATAL] != null)
                __levels[FATAL].apply(null, [ "FATAL", $origin ].concat($args));
        }

        public static function info($origin:*, ... $args):void
        {
            if(isSilenced($origin))
                return;

            if(__levels.hasOwnProperty(INFO) && __levels[INFO] != null)
                __levels[INFO].apply(null, [ "INFO", $origin ].concat($args));
        }

        public static function warning($origin:*, ... $args):void
        {
            if(isSilenced($origin))
                return;

            if(__levels.hasOwnProperty(WARNING) && __levels[WARNING] != null)
                __levels[WARNING].apply(null, [ "WARNING", $origin ].concat($args));
        }

        public static function status($origin:*, ... $args):void
        {
            if(isSilenced($origin))
                return;

            if(__levels.hasOwnProperty(STATUS) && __levels[STATUS] != null)
                __levels[STATUS].apply(null, [ "STATUS", $origin ].concat($args));
        }

        public static function deepTrace($origin:*, ... $args):void
        {
            if(isSilenced($origin))
                return;

            info($origin, 'DEEP TRACE:\n', __deepTrace($args));
        }

        /////////////////////////////////////////////////////////////////////////////
        //// PRIVATE
        ///////////////////////////////////////////////////////////////////////////

        private static function __deepTrace(obj:*, level:int = 0):String
        {
            var output:String = '';
            var tabs:String = '';
            var i:int;
            var prop:String;

            // indent tabs
            for(i = 0; i < level; i++, tabs += '\t')
            {
            }

            for(prop in obj)
                output += tabs + '[' + prop + '] -> ' + obj[prop] + __deepTrace(obj[prop], level + 1);

            return output;
        }

        private static function __getClassName($o:*):String
        {
            var c:String = flash.utils.getQualifiedClassName($o);
            var s:String = (c == "String" ? $o : c.split("::")[1] || c);

            return s;
        }

        private static function __output($level:String, $origin:*, ... $objects):void
        {
            var l:String = $level;
            var s:String = $origin ? __getClassName($origin) : '';

            while(l.length < 8)
                l += " ";

            var prefix:String = l + ':::	' + s + '	-> ';
            var output:String = prefix;

            for(var k:String in $objects)
            {
                output += ' ' + ($objects[k] ? $objects[k].toString() : null);
            }

            // if additional adapters are enabled
            if(__debuggers.length)
            {
                for each(var j:ILogAdapter in __debuggers)
                    j.output.apply(null, [ prefix, $level ].concat($objects));
            }

            trace(output);
        }

    }
}
