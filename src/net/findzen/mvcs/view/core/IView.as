package net.findzen.mvcs.view.core
{
    import flash.display.DisplayObject;
    import flash.text.TextField;

    import net.findzen.mvcs.view.data.ViewState;

    public interface IView extends IComponent
    {
        function set components($components:Object):void;
        function addComponent($c:IComponent):IComponent;
        function getComponent($id:String, $type:Class = null):IComponent;

        function registerDisplayObject($o:DisplayObject):IView; // do we really need this?

        function set states($states:Object):void;
        function addState($state:ViewState):IView;
        function get defaultState():String;
        function set defaultState($id:String):void;
        function get state():Array;
        function set state($val:Array):void;

        function get loaded():Boolean;
    }
}
