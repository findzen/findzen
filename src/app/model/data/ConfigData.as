package app.model.data
{
    import net.findzen.display.AnimatedView;
    import net.findzen.display.View;
    import net.findzen.display.ImageAsset;
    import net.findzen.display.SWFAsset;
    import net.findzen.display.VideoAsset;

    public class ConfigData
    {

        /////////////////////////////////////////////////////////////////////////////
        //// RUN-TIME VALUES
        ///////////////////////////////////////////////////////////////////////////

        // class references for run-time instantiation
        private static const __RUN_TIME_CLASSES:Array = [ AnimatedView, View, ImageAsset, SWFAsset, VideoAsset ];

        // asset swf
        public static const LIB_SWF_PATH:String = 'lib.swf';

        // xml config
        public static const ASSET_XML_PATH:String = 'assets.xml';
        public static const COPY_XML_PATH:String = 'copy.xml';
        public static const STRUCTURE_XML_PATH:String = 'structure.xml';

        // css
        public static const CSS_PATH:String = 'styles.css';

        // flashVars
        public static const LOCALE_VAR:String = '{locale}';
        public static const LOCALE_FLASH_VAR:String = 'locale';
        public static const ASSET_URL_VAR:String = '{assetURL}';
        public static const ASSET_URL_FLASH_VAR:String = 'assetURL';

        // replace with flashVars
        public static var locale:String = '';
        public static var assetsURL:String = '';

        /////////////////////////////////////////////////////////////////////////////
        //// COMPILE-TIME VALUES
        ///////////////////////////////////////////////////////////////////////////

        // config map
        [Embed(source = '/app/config.map.xml', mimeType = 'application/octet-stream')]
        public static const MAP_XML:Class;
    }
}
