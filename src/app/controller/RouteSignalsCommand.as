package app.controller
{
    import app.controller.*;
    import app.signals.*;
    import app.model.data.*;

    import org.robotlegs.mvcs.Command;

    import net.findzen.mvcs.controller.Operator;
    import net.findzen.utils.Log;

    public class RouteSignalsCommand extends Command
    {
        [Inject]
        public var operator:Operator;

        override public function execute():void
        {
            Log.status(this, 'execute');
            //operator.route('social.global::Twitter', GlobalTwitterShareCommand, ChangeAddressState, [ new AddressState([ 'data', 'usa' ], null, 'USA')]);

        /*operator.route('navigation.section::usa', ChangeAddressStateCommand, ChangeAddressState, [ new AddressState([ 'data', 'usa' ], null, 'USA')]);

        operator.route('navigation.section::data', ChangeAddressStateCommand, ChangeAddressState, [ new AddressState([ 'data' ], null, 'Map')]);*/
        }
    }
}
