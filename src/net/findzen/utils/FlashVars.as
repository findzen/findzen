package net.findzen.utils
{
    import flash.display.Stage;

    public class FlashVars
    {
        public static var locale:String;
        public static var assetsURL:String;

        public static function getValue($key:String, $stage:Stage, $defaultValue:String = ''):String
        {
            return !$stage.loaderInfo.parameters[$key] ? $defaultValue : $stage.loaderInfo.parameters[$key];
        }

        public static function hasKey($key:String, $stage:Stage):Boolean
        {
            return getValue($key, $stage) ? true : false;
        }
    }
}
