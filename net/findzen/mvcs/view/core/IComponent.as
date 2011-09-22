package net.findzen.mvcs.view.core
{
    import flash.display.MovieClip;

    import org.osflash.signals.ISignal;
    import org.osflash.signals.natives.NativeSignal;

    public interface IComponent
    {
        function get container():MovieClip;
        //function set container($container:MovieClip):void;

        function get parent():IView;
        function set parent($c:IView):void;

        function get name():String;
        function set name($val:String):void;

        function show($force:Boolean = false):IComponent;
        function hide($force:Boolean = false):IComponent;

        function get type():Class;

        function get includeIn():Array;
        function set includeIn($val:Array):void;

        function destroy():void;

        // signals
        function get clicked():ISignal;
        function get clickedRoute():String;
        function set clickedRoute($route:String):void;

        function get mouseOver():ISignal;
        function get mouseOut():ISignal;

    /*
    to do:
    function get mouseDown():NativeSignal;
    function get mouseMove():NativeSignal;
    function get mouseOver():NativeSignal;
    function get mouseUp():NativeSignal;
    function get mouseOut():NativeSignal;
    function get doubleClick():NativeSignal;
    */
    }
}
