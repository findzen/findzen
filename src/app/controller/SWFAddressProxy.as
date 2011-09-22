package app.controller
{
    import app.model.data.AddressState;
    import app.signals.*;

    import com.asual.swfaddress.SWFAddress;
    import com.asual.swfaddress.SWFAddressEvent;

    import net.findzen.utils.Log;

    import org.robotlegs.mvcs.Actor;

    public class SWFAddressProxy extends Actor
    {
        [Inject]
        public var addressChange:AddressChange;

        protected var _tracker:Object;

        public function SWFAddressProxy()
        {
            super();
        }

        public function init():void
        {
            SWFAddress.onInit = onInit;
        }

        public function onInit():void
        {
            Log.status(this, 'INIT', SWFAddress.getValue());

            SWFAddress.addEventListener(SWFAddressEvent.CHANGE, onChange, false, 0, true);

            if(SWFAddress.getValue() == '/')
                this.state = new AddressState([ 'intro' ]);
        }

        public function set tracker($tracker:Object):void
        {
            _tracker = $tracker;
        }

        private function onChange($e:SWFAddressEvent):void
        {
            trace('\n');
            Log.info(this, '------------------------------------------------------------------------------------------------------------');
            Log.info(this, 'Change:', $e.value);
            Log.info(this, '------------------------------------------------------------------------------------------------------------\n');

            addressChange.dispatch(this.state);

            if(!_tracker)
                return;

            _tracker.track({
                               type: 'page view',
                               page: SWFAddress.getValue(),
                               contentType: 'page',
                               contentTitle: SWFAddress.getTitle()
                           });
        }

        public function set state($state:AddressState):void
        {
            var path:String = '';
            var params:String = '';
            var s:String;

            // paths array to string
            if($state.paths)
            {
                for each(s in $state.paths)
                    path += '/' + s;
            }

            // title
            if($state.title)
                SWFAddress.setTitle($state.title);

            // params object to string
            if($state.params)
            {
                for(s in $state.params)
                {
                    params += params.length ? '&' : '?';
                    params += s + '=' + $state.params[s];
                }
            }

            Log.status(this, 'setting state:', path, params, $state.title);

            SWFAddress.setValue(path + params);
        }

        public function get state():AddressState
        {
            // get parameter names object
            var params:Object = {};
            var paramNames:Array = SWFAddress.getParameterNames();
            var val:String;

            for each(val in paramNames)
                params[val] = SWFAddress.getParameter(val);

            return new AddressState(SWFAddress.getPathNames(), params, SWFAddress.getTitle());
        }

        public function getURL($url:String, $target:String = '_self'):void
        {
            SWFAddress.href($url, $target);

            if(!_tracker)
                return;

            var socialNetwork:String;

            if($url.indexOf('facebook') != -1)
                socialNetwork = 'facebook';
            else if($url.indexOf('twitter') != -1)
                socialNetwork = 'twitter';

            _tracker.track({
                               type: 'social media share',
                               page: SWFAddress.getValue(),
                               contentType: 'site',
                               contentTitle: SWFAddress.getTitle(),
                               socialNetwork: socialNetwork
                           });
        }

        public function get value():String
        {
            return SWFAddress.getValue();
        }
    }
}
