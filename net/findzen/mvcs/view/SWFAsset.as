package net.findzen.mvcs.view
{
    import com.greensock.events.LoaderEvent;
    import com.greensock.loading.LoaderStatus;
    import com.greensock.loading.SWFLoader;
    import flash.display.MovieClip;
    import net.findzen.utils.Log;
    import net.findzen.mvcs.view.base.AssetBase;

    public class SWFAsset extends AssetBase
    {
        public function SWFAsset($container:MovieClip)
        {
            super($container);

            _loader = new SWFLoader(this._url, { name: this.name, container: this.container });

            if(autoLoad)
                load();
        }
    }
}
