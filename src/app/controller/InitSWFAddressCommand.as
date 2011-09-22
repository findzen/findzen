package app.controller
{
    import org.robotlegs.mvcs.SignalCommand;
    import net.findzen.utils.Log;

    public class InitSWFAddressCommand extends SignalCommand
    {

        [Inject]
        public var proxy:SWFAddressProxy;

        override public function execute():void
        {
            Log.status(this, 'execute');
            proxy.init();
        }
    }
}
