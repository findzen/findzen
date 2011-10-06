package app.controller
{
    import app.model.AppModel;
    import app.model.data.ConfigData;
    import app.signals.OperatorConfigLoaded;
    import app.signals.ViewConfigLoaded;

    import com.asual.swfaddress.SWFAddress;
    import com.greensock.TweenLite;
    import com.greensock.events.LoaderEvent;
    import com.greensock.layout.AlignMode;
    import com.greensock.layout.LiquidArea;
    import com.greensock.layout.LiquidStage;
    import com.greensock.layout.ScaleMode;
    import com.greensock.loading.LoaderMax;
    import com.greensock.loading.SWFLoader;
    import com.greensock.loading.XMLLoader;
    import com.greensock.loading.display.ContentDisplay;

    import flash.display.DisplayObject;
    import flash.display.MovieClip;
    import flash.events.*;
    import flash.net.*;

    import net.findzen.display.core.IProgressDisplay;
    import net.findzen.utils.Config;
    import net.findzen.utils.FlashVars;
    import net.findzen.utils.Log;
    import net.findzen.utils.XMLUtility;
    import net.findzen.utils.deepTrace;

    import org.robotlegs.mvcs.SignalCommand;

    public class LoadConfigCommand extends SignalCommand
    {
        /*[Inject]
        public var preloader:IProgressDisplay;*/

        [Inject]
        public var model:AppModel;

        [Inject]
        public var operatorConfigLoaded:OperatorConfigLoaded;

        [Inject]
        public var viewConfigLoaded:ViewConfigLoaded;

        [Inject]
        public var proxy:SWFAddressProxy;

        protected var _loader:LoaderMax;
        protected var _config:Config;
        protected var _configPath:String;
        protected var _contentPath:String;

        override public function execute():void
        {
            Log.status(this, 'execute');

            /*_preloader = new Preloader();
            _preloader.x = 500 - _preloader.width / 2;
            _preloader.y = 350 - _preloader.height / 2;
            this.contextView.addChild(_preloader);*/

            _config = new Config();
            _config.map = XML(new ConfigData.MAP_XML());

            _getFlashVars();

            _loader = new LoaderMax({ onProgress: _onLoaderProgress, onComplete: _onLoadComplete, onError: _onLoadError });
            _loader.append(new SWFLoader(ConfigData.LIB_SWF_PATH, { onComplete: _onLibLoaded }));
            _loader.append(new XMLLoader(ConfigData.STRUCTURE_XML_PATH, { onComplete: _onContentLoaded }));
            _loader.append(new XMLLoader(ConfigData.COPY_XML_PATH, { onComplete: _onConfigLoaded }));

            _loader.load();
        /*

        // build this out...
        operatorConfigLoaded.dispatch();

        // get flashvars
        _configPath = this.contextView.stage.loaderInfo.parameters.hasOwnProperty(ConfigData.CONFIG_PARAM) ? this.contextView.stage.loaderInfo.parameters[ConfigData.CONFIG_PARAM] : ConfigData.CONFIG_XML_PATH;
        _contentPath = this.contextView.stage.loaderInfo.parameters.hasOwnProperty(ConfigData.CONTENT_PARAM) ? this.contextView.stage.loaderInfo.parameters[ConfigData.CONTENT_PARAM] : ConfigData.CONTENT_XML_PATH;

        Log.info(this, 'config path:', _configPath);
        Log.info(this, 'content path:', _contentPath);

        */

            // tracking
        /*var params:Object = this.contextView.stage.loaderInfo.parameters;
        var t:FoxTracker = new FoxTracker(params['wpr'], params['property'], params['territory']);

        trace('Tracker values :: wpr:', params['wpr'], 'property:', params['property'], 'territory:', params['territory']);

        if(params.hasOwnProperty('wpr') && params.hasOwnProperty('property') && params.hasOwnProperty('territory'))
            proxy.tracker = new FoxTracker(params['wpr'], params['property'], params['territory']);
        else
            Log.error(this, 'Missing tracker value(s)');*/
        }

        protected function _getFlashVars():void
        {
            // todo
            ConfigData.assetsURL = FlashVars.getValue(ConfigData.ASSET_URL_FLASH_VAR, this.contextView.stage);

        }

        protected function _onLoaderProgress($e:LoaderEvent):void
        {
            var progress:int = Math.ceil(Number($e.target.progress) * 100);
            // _preloader.gotoAndStop(progress);
        }

        protected function _onConfigLoaded($e:LoaderEvent):void
        {
            Log.status(this, 'Config XML loaded', $e.target);

            _config.xml = LoaderMax.getContent(ConfigData.STRUCTURE_XML_PATH);
            _checkComplete();
        }

        protected function _onContentLoaded($e:LoaderEvent):void
        {
            Log.status(this, 'Content XML loaded', $e.target);

            var xml:XML = LoaderMax.getContent(ConfigData.COPY_XML_PATH);
            //model.data = xml..child('data')[0];
        }

        protected function _onLibLoaded($e:LoaderEvent):void
        {
            Log.status(this, 'Lib loaded', $e.target.content);
            _config.lib = ContentDisplay(LoaderMax.getContent(ConfigData.LIB_SWF_PATH)).rawContent;
            _checkComplete();
        }

        protected function _checkComplete():void
        {
            if(_config.lib && _config.xml)
            {
                Log.status(this, 'load complete');
                viewConfigLoaded.dispatch(_config);
            }
        }

        protected function _onLoadComplete($e:LoaderEvent):void
        {
            Log.status(this, 'cleaning');
            _clean();
        }

        protected function _onLoadError($e:LoaderEvent):void
        {
            Log.error(this, 'error occured with', $e.target, $e.text);
        }

        protected function _clean():void
        {
            /* this.contextView.removeChild(_preloader);
             _preloader = null;*/
            _loader.dispose();
            _loader = null;
        }
    }
}
