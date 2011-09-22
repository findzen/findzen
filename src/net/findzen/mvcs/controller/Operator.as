package net.findzen.mvcs.controller
{
    import app.AppContext;
    //import app.controller.PlaceCallCommand;
    import app.signals.PlaceCall;

    import flash.display.DisplayObjectContainer;
    import flash.display.MovieClip;
    import flash.events.*;
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;
    import flash.utils.getQualifiedClassName;

    import net.findzen.mvcs.controller.operator.Relay;
    import net.findzen.mvcs.controller.operator.Route;
    import net.findzen.utils.Lib;
    import net.findzen.utils.Log;

    import org.osflash.signals.ISignal;
    import org.osflash.signals.Signal;
    import org.robotlegs.mvcs.Actor;

    public class Operator extends Actor
    {
        [Inject]
        public var context:AppContext;

        private var _switch:Object;
        private var _callers:Object;

        public function Operator()
        {
            _switch = {};
            _callers = {};
        }

        public function registerCaller($signal:ISignal, $route:String):void
        {
            Log.status(this, 'Registering caller', $signal, 'to route', $route);

            if(!_callers.hasOwnProperty($signal))
                _callers[$signal] = [];

            _callers[$signal].push($route);

            var placeCall:PlaceCall = new PlaceCall();
            placeCall.add(this.connect);

            // there has to be a better way...
            var callback:Function = function(... args):void {
                placeCall.dispatch($signal);
            }

            $signal.add(callback);

        /*$signal.add(placeCall.dispatch);
        context.signalCommandMap.mapSignal(placeCall, PlaceCallCommand);*/
        }

        public function route($route:String, $commandClass:Class, $signalClass:Class, $data:Array = null, $oneShot:Boolean = false):void
        {

            trace(''); ///////////////////////////////////////////////////////////////////////////////////////////////
            Log.info(this, '================================= ROUTE REQUEST ====================================');
            Log.info(this, 'route:        ', $route);
            Log.info(this, 'commandClass: ', $commandClass);
            Log.info(this, 'signalClass:  ', $signalClass);
            Log.info(this, 'data:         ', $data);
            Log.info(this, '====================================================================================\n');
            ///////////////////////////////////////////////////////////////////////////////////////////////

            var route:Route = _parseRoute($route);
            var exchange:Object;
            var relay:Relay;

            if(!route)
            {
                Log.error(this, 'Invalid route', $route);
                return;
            }

            Log.info(this, 'exchange:', route.exchange, 'relay:', route.relay, 'data:', route.data);

            // create new exchange if it doesn't already exist
            if(!_switch.hasOwnProperty(route.exchange))
                _switch[route.exchange] = {};

            exchange = _switch[route.exchange];

            // create new relay if it doesn't already exist
            if(!exchange.hasOwnProperty(route.relay))
                exchange[route.relay] = new Relay(new $signalClass(), $commandClass, $data);

            relay = exchange[route.relay];
            relay.addData(route.data, $data);

            context.signalCommandMap.mapSignal(relay.signal, relay.command, $oneShot);

            Log.status(this, 'route added successfully');
        }

        private function _parseRoute($route:String):Route
        {
            var a:Array = $route.split('::');
            var id:String;

            id = a.length > 1 ? a.pop() : null;

            if(!id)
                return null;

            a = a.pop().split('.');
            a.push(id);

            return a.length == 3 ? new Route(a[0], a[1], a[2]) : null;
        }

        //_switch[$exchangeID][$relayID].getData($dataID);
        private function _getRelay($exchangeID:String, $relayID:String):Relay
        {
            var exchange:Object;

            exchange = _switch.hasOwnProperty($exchangeID) ? _switch[$exchangeID] : null;

            if(!exchange)
                return null;

            return exchange.hasOwnProperty($relayID) ? exchange[$relayID] : null;
        }

        public function connect($signal:ISignal):void
        {
            Log.status(this, 'Connect');

            if(!_callers.hasOwnProperty($signal))
            {
                Log.error(this, $signal, 'is not a registered caller');
                return;
            }

            var routes:Array = _callers[$signal];
            var i:int;
            var route:Route;
            var relay:Relay;
            var data:Array;

            for(i = 0; i < routes.length; i++)
            {
                route = _parseRoute(routes[i]);
                relay = _getRelay(route.exchange, route.relay);

                if(!relay)
                {
                    Log.error(this, 'Relay not found on route', routes[i]);
                    continue;
                }

                data = relay.getData(route.data);

                if(!data)
                {
                    Log.error(this, 'Data not found on relay', routes[i]);
                    continue;
                }

                trace(''); ///////////////////////////////////////////////////////////////////////////////////////////////
                Log.info(this, '============================== CONNECTING =================================');
                Log.info(this, 'route:   ', routes[i]);
                Log.info(this, 'command: ', relay.command);
                Log.info(this, 'signal:  ', relay.signal);
                Log.info(this, 'data:    ', data);
                Log.info(this, '===========================================================================\n');
                ///////////////////////////////////////////////////////////////////////////////////////////////

                Signal(relay.signal).dispatch.apply({}, data);
            }
        }
    }
}
