package net.findzen.display.core
{
    import flash.display.MovieClip;

    import org.osflash.signals.ISignal;
    import org.osflash.signals.natives.NativeSignal;

    public interface IComponent
    {
        function show($force:Boolean = false):IComponent;
        function hide($force:Boolean = false):IComponent;

        function destroy():void;

        function get name():String;
        function set name($val:String):void;

        function set skinClass($skinClass:String):void;
        function set skin($skin:MovieClip):void;
        function get skin():MovieClip;

        function get includeIn():Array;
        function set includeIn($val:Array):void;

        // signals
        function get click():ISignal;
        function get clickRoute():String;
        function set clickRoute($route:String):void;
        function get mouseOver():ISignal;
        function get mouseOut():ISignal;
    }
}
