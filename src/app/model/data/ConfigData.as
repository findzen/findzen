package app.model.data
{
    import net.findzen.mvcs.view.ImageAsset;
    import net.findzen.mvcs.view.SWFAsset;
    import net.findzen.mvcs.view.VideoAsset;

    public class ConfigData
    {
        /////////////////////////////////////////////////////////////////////////////
        //// RUN-TIME VALUES
        ///////////////////////////////////////////////////////////////////////////

        // class references for run-time instantiation
        private static const __RUN_TIME_CLASSES:Array = [ ImageAsset, SWFAsset, VideoAsset ];

        // asset library
        public static const LIB_SWF_PATH:String = 'lib.swf';

        // intro swf
        public static const INTRO_SWF_PATH:String = 'intro.swf';

        // view config
        public static const CONFIG_PARAM:String = 'config';
        public static const CONFIG_XML_PATH:String = 'config.xml';

        // content xml
        public static const CONTENT_PARAM:String = 'content';
        public static const CONTENT_XML_PATH:String = 'content.xml';

        // country IDs
        public static const COUNTRIES:Array = [
            'australia',
            'austria',
            'belgium',
            'brazil',
            'canada',
            'china',
            'denmark',
            'france',
            'germany',
            'india',
            'italy',
            'japan',
            'mexico',
            'netherlands',
            'norway',
            'poland',
            'portugal',
            'russia',
            'skorea',
            'spain',
            'sweden',
            'uk',
            'usa'
            ];

        /////////////////////////////////////////////////////////////////////////////
        //// COMPILE-TIME VALUES
        ///////////////////////////////////////////////////////////////////////////

        // config map
        [Embed(source = '/app/config.map.xml', mimeType = 'application/octet-stream')]
        public static const MAP_XML:Class;
    }
}
