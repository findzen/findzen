package net.findzen.utils
{
    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.display.MovieClip;
    import flash.media.Sound;
    import flash.system.ApplicationDomain;
    import flash.utils.getDefinitionByName;

    import mx.core.MovieClipAsset;

    import net.findzen.utils.Log;

    public class Lib
    {

        /**
         * The <code>createAsset()</code> method creates a new Instance of a class.
         *
         * @param 	$appDomainOrMc	Object			ApplicationDomain or MovieClip (reference to swf) where the classDefinition can be found.
         * @param	$classname 		String			Name of the Class that you want to create
         * @return 					DisplayObject	Instance of the Class $classname, null if class definition couldn't be found.
         *
         */
        public static function createAsset($classname:String, $appDomainOrMc:Object):DisplayObject
        {
            var c:Class = getClassDefinition($classname, $appDomainOrMc);
            return new c();
        }

        public static function getClassDefinition($classname:String, $appDomainOrMc:Object):Class
        {
            var appDomain:ApplicationDomain;

            if($appDomainOrMc is ApplicationDomain)
                appDomain = ApplicationDomain($appDomainOrMc);
            else
                appDomain = $appDomainOrMc.loaderInfo.applicationDomain;

            var c:Class;

            if(appDomain.hasDefinition($classname))
                c = Class(appDomain.getDefinition($classname));
            else
                Log.error(Lib, $classname, 'is not defined in context', $appDomainOrMc);

            return c;
        }

    }
}
