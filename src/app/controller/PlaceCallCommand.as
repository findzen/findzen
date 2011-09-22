package app.controller
{
    import app.signals.PlaceCall;

    import net.findzen.mvcs.controller.Operator;
    import net.findzen.utils.Log;

    import org.osflash.signals.ISignal;
    import org.robotlegs.mvcs.SignalCommand;

    public class PlaceCallCommand extends SignalCommand
    {
        [Inject]
        public var signal:PlaceCall;

        [Inject]
        public var operator:Operator;

        override public function execute():void
        {
            Log.status(this, 'execute: Connecting to Operator');

            //operator.connect(signal.target as ISignal);
        }
    }
}
