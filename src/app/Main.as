package app
{
    import flash.display.*;
    import flash.events.*;
    import flash.system.Security;

    import net.findzen.utils.DebugPanel;
    import net.findzen.utils.Log;
    import net.findzen.utils.log.adapters.DebugPanelAdapter;
    import net.findzen.utils.log.adapters.ILogAdapter;
    import net.hires.debug.Stats;

    import org.robotlegs.mvcs.Context;

    [SWF(width = "1000", height = "700", frameRate = "24", backgroundColor = "#ffffff")]
    public class Main extends MovieClip
    {
        public var context:AppContext;

        public function Main()
        {
            context = new AppContext(this);

            Security.allowDomain('*');

            this.stage ? _init() : this.addEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
        }

        private function _onAddedToStage($e:Event):void
        {
            trace(this, 'added to stage');
            $e.target.removeEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
            _init();
        }

        private function _init():void
        {
            // Debug mode activated when debug param is present or file is run locally
            if(this.stage.loaderInfo.parameters.hasOwnProperty('debug') || this.loaderInfo.url.indexOf('file:') != -1)
            {
                trace(this, '.. DEBUG MODE ..');

                // setup debug panel and register with Out
                DebugPanel.stage = this.stage;
                var adapter:ILogAdapter = new DebugPanelAdapter();

                Log.registerDebugger(adapter);
                Log.enableAllLevels();

                this.addChild(new Stats());
            }

            Log.status(this, 'INIT');
        }

    }

}
