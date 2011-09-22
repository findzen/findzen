package net.findzen.mvcs.controller.operator
{

    public class Route
    {
        public var exchange:String;
        public var relay:String;
        public var data:String;

        public function Route($exchange:String, $relay:String, $data:String)
        {
            exchange = $exchange;
            relay = $relay;
            data = $data;
        }
    }
}
