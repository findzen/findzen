package app.controller
{
    import app.model.AppModel;
    import app.model.data.AddressState;

    import net.findzen.utils.Log;

    import org.robotlegs.mvcs.Command;

    public class HandleAddressChangeCommand extends Command
    {
        [Inject]
        public var model:AppModel;

        [Inject]
        public var state:AddressState;

        override public function execute():void
        {
            Log.status(this, 'execute', state.paths, state.params, state.title);

            model.state = state;
        }
    }
}
