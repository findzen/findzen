package net.findzen.mvcs.view
{

    import net.findzen.utils.Log;
    import com.greensock.*;
    import com.greensock.events.LoaderEvent;
    import com.greensock.loading.LoaderMax;
    import com.greensock.loading.LoaderStatus;
    import com.greensock.loading.VideoLoader;
    import com.greensock.loading.core.LoaderCore;

    import flash.display.MovieClip;
    import net.findzen.mvcs.view.base.AssetBase;

    public class VideoAsset extends AssetBase
    {

        public function VideoAsset($container:MovieClip)
        {
            super($container);

            // may need to check for existence of props on $vars
        /*_loader = new VideoLoader(this.url, { name: this.id, container: this.mc, autoPlay: $vars.autoPlay, repeat: $vars.repeat, width: this.mc.width, height: this.mc.height });
        _loader.addEventListener(LoaderEvent.PROGRESS, _onProgress, false, 0, true);

        this.mc.mouseChildren = false;
        this.mc.mouseEnabled = false;*/
        }

        public function play():void
        {
            VideoLoader(this.loader).playVideo();
        }

        public function pause():void
        {
            VideoLoader(this.loader).pauseVideo();
        }

        override protected function _onOpen($e:LoaderEvent):void
        {
            Log.status(this, '_onOpen', this.name);
        }

        protected function _onProgress($e:LoaderEvent):void
        {
            if(_loader.status != LoaderStatus.LOADING)
            {
                Log.status(this, '_onProgress', this.loader.status);
                    //TweenLite.to(this.mc, 0.5, { colorTransform: { brightness: 0.5 }});
            }
        }

    }
}
