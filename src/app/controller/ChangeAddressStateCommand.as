package app.controller
{
    import app.model.data.AddressState;

    import net.findzen.utils.Log;

    import org.robotlegs.mvcs.Command;

    public class ChangeAddressStateCommand extends Command
    {
        [Inject]
        public var proxy:SWFAddressProxy;

        [Inject]
        public var state:AddressState;

        override public function execute():void
        {
            Log.status(this, 'execute, state:', state.paths, state.params, state.title);

            //proxy.setValue(state.paths, state.params, state.title);
            proxy.state = state;
        }
    }
}
