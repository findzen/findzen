package net.findzen.mvcs.view.core
{
    import flash.display.DisplayObjectContainer;

    public interface IFactory
    {
        //function create($o:Object, $container:DisplayObjectContainer):Object;
        function create($node:XML, $container:DisplayObjectContainer = null):Object
    }
}
