package net.findzen.display.base
{
    import com.greensock.*;
    import com.greensock.events.LoaderEvent;
    import com.greensock.loading.LoaderStatus;
    import com.greensock.loading.core.LoaderCore;
    import com.greensock.loading.display.ContentDisplay;

    import flash.display.*;

    import net.findzen.display.Component;
    import net.findzen.utils.Log;

    public class AssetBase extends Component
    {
        protected var _loader:LoaderCore;
        protected var _url:String;

        public var autoLoad:Boolean;

        public function AssetBase()
        {
        }

        public function set url($url:String):void
        {
            _url = $url;

            if(_loader && autoLoad)
                load();
        }

        public function load($flushContent:Boolean = false):void
        {
            if(!_loader)
            {
                Log.error(this, 'Loader is null');
                return;
            }

            Log.status(this, 'Load', _url);

            _loader.autoDispose = true;
            _loader.addEventListener(LoaderEvent.OPEN, _onOpen, false, 0, true);
            _loader.load($flushContent);
        }

        public function get loader():LoaderCore
        {
            return _loader;
        }

        protected function _onOpen($e:LoaderEvent):void
        {
            Log.status(this, 'loader open:', this.name);

            $e.target.removeEventListener(LoaderEvent.OPEN, _onOpen);

            // remove everything but the ContentDisplay object (preloader animations, etc)
            while(this.numChildren > 1)
                this.removeChildAt(0);
        }

        override public function destroy():void
        {
            if(_loader)
            {
                if(_loader.hasEventListener(LoaderEvent.OPEN))
                    _loader.removeEventListener(LoaderEvent.OPEN, _onOpen);

                _loader.dispose(true);
                _loader = null;
            }

            _url = null;

            super.destroy();
        }
    }
}
