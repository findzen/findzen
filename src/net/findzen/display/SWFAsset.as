package net.findzen.display
{
    import com.greensock.events.LoaderEvent;
    import com.greensock.loading.LoaderStatus;
    import com.greensock.loading.SWFLoader;
    import flash.display.MovieClip;
    import net.findzen.utils.Log;
    import net.findzen.display.base.AssetBase;

    public class SWFAsset extends AssetBase
    {
        public function SWFAsset()
        {

            _loader = new SWFLoader(this._url, { name: this.name, container: this });

            if(autoLoad)
                load();
        }
    }
}
