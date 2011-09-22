package net.findzen.mvcs.view
{
    import flash.display.DisplayObjectContainer;
    import flash.text.Font;
    import flash.text.TextFormat;

    import net.findzen.utils.Lib;
    import net.findzen.utils.Log;
    import net.findzen.utils.FontManager;
    import net.findzen.mvcs.view.core.IFactory;

    public class FontFactory implements IFactory
    {
        public function get product():Class
        {
            return Font;
        }

        public function create($node:XML, $container:DisplayObjectContainer = null):Object
        {
            return null;
        /*var font:Font = Lib.createClassObject($o.linkage, $scope);

        if(!font)
            return null;

        Font.registerFont(Lib.getClassDefinition($o.linkage, $scope));

        return font;*/
        }
    }
}
