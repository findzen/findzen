package net.findzen.mvcs.controller.operator
{
    import org.osflash.signals.ISignal;

    public class Relay
    {
        protected var _signal:ISignal;
        protected var _command:Class;
        protected var _data:Object;

        public function Relay($signal:ISignal, $command:Class, $data:Object = null)
        {
            _signal = $signal;
            _command = $command;
            _data = $data;
        }

        public function get signal():ISignal
        {
            return _signal;
        }

        public function get command():Class
        {
            return _command;
        }

        public function get data():Object
        {
            return _data;
        }

        public function addData($id:String, $data:Array):void
        {
            _data[$id] = $data;
        }

        public function hasData($id:String):Boolean
        {
            return _data.hasOwnProperty($id);
        }

        public function getData($id:String):Array
        {
            return _data.hasOwnProperty($id) ? _data[$id] : null;
        }
    }
}
