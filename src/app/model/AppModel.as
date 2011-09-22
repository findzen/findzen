package app.model
{
    import app.model.data.*;
    import app.signals.*;

    import net.findzen.utils.Log;
    import net.findzen.utils.StringUtil;

    import org.robotlegs.mvcs.Actor;

    public class AppModel extends Actor
    {

        [Inject]
        public var viewStateChange:ViewStateChange;

        public function AppModel()
        {
            super();
        }

        public function set data($xml:XML):void
        {
            Log.status(this, 'Parsing data');

        }

        public function set state($state:AddressState):void
        {
            trace('\n');
            Log.info(this, '------------------------------------------------------------------------------------------------------------');
            Log.info(this, 'State');
            Log.info(this, 'paths: ', $state.paths);
            Log.info(this, 'title: ', $state.title);
            Log.info(this, 'params:', $state.params);
            Log.info(this, 'topic: ', $state.params.topic);
            Log.info(this, 'age:   ', $state.params.age);
            Log.info(this, 'rank:  ', $state.params.rank);
            Log.info(this, 'sex:   ', $state.params.sex);
            Log.info(this, '------------------------------------------------------------------------------------------------------------\n');

            // first path is not data.. dispatch view state change
            viewStateChange.dispatch($state.paths);
        }

        /////////////////////////////////////////////////////////////////////////////
        //// PRIVATE
        ///////////////////////////////////////////////////////////////////////////

    }
}
