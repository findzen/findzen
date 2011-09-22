package net.findzen.mvcs.view
{
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.utils.*;

    import net.findzen.mvcs.view.core.IComponent;
    import net.findzen.mvcs.view.core.IView;
    import net.findzen.utils.HashTable;
    import net.findzen.utils.Inspector;
    import net.findzen.utils.Log;
    import net.findzen.utils.VarsBase;

    import org.osflash.signals.ISignal;
    import org.osflash.signals.Signal;
    import org.osflash.signals.natives.NativeMappedSignal;

    public class Component implements IComponent
    {
        protected var _name:String;
        protected var _container:MovieClip;
        protected var _parent:IView;
        protected var _type:Class;
        protected var _includeIn:Array;

        // signals
        protected var _clicked:ISignal;
        protected var _clickedRoute:String;
        protected var _mouseOver:ISignal;
        protected var _mouseOut:ISignal;

        /*protected var _mouseDown:String;
        protected var _mouseMove:String;
        protected var _mouseOver:String;
        protected var _mouseUp:String;
        protected var _mouseOut:String;
        protected var _doubleClick:String;*/

        public function Component($container:MovieClip)
        {
            _container = $container;
            _type = getDefinitionByName(getQualifiedClassName(this)) as Class;
            _name = $container.name;
        }

        public function show($forceAnim:Boolean = false):IComponent
        {
            //Log.status(this, this.name, 'show');

            this.container.visible = true;

            return this;
        }

        public function hide($forceAnim:Boolean = false):IComponent
        {
            //Log.status(this, this.name, 'hide');

            this.container.visible = false;

            return this;
        }

        public function get includeIn():Array
        {
            return _includeIn;
        }

        public function set includeIn($val:Array):void
        {
            _includeIn = $val;
        }

        public function get container():MovieClip
        {
            return _container;
        }

        public function get name():String
        {
            return _name;
        }

        public function set name($val:String):void
        {
            _name = $val;
        }

        public function get type():Class
        {
            return _type;
        }

        public function get parent():IView
        {
            return _parent;
        }

        public function set parent($c:IView):void
        {
            _parent = $c;
        }

        public function destroy():void
        {
            _container = null;
            _name = null;
            _parent = null;
            _type = null;
            _includeIn = null;
            _clicked = null;
            _clickedRoute = null;
        }

        /////////////////////////////////////////////////////////////////////////////
        //// Signals
        ///////////////////////////////////////////////////////////////////////////

        public function get clicked():ISignal
        {
            if(!_clicked)
                _clicked = new NativeMappedSignal(this.container, MouseEvent.CLICK, MouseEvent);

            //this.container.addEventListener(MouseEvent.CLICK, _onMouseEvent, false, 0, true);

            return _clicked;
        }

        private function _onMouseEvent($e:MouseEvent):void
        {
            Log.status(this, 'Click', this.name, this.clickedRoute);

            if(!_clicked)
                return;

            // dispatch _clicked signal
            // why doesn't FB recognize ISignal's dispatch method? To do: try recompiling swc
            Signal(_clicked).dispatch();
        }

        public function get clickedRoute():String
        {
            return _clickedRoute;
        }

        public function set clickedRoute($route:String):void
        {
            _clickedRoute = $route;
        }

        public function get mouseOver():ISignal
        {
            if(!_mouseOver)
            {
                _mouseOver = new NativeMappedSignal(this.container, MouseEvent.MOUSE_OVER, MouseEvent);
                /*_mouseOver.add(function():void {

                });*/
            }

            return _mouseOver;
        }

        public function get mouseOut():ISignal
        {
            if(!_mouseOut)
                _mouseOut = new NativeMappedSignal(this.container, MouseEvent.MOUSE_OUT, MouseEvent);

            return _mouseOut;
        }

    /*public function get mouseDown():String
        {
            return _mouseDown;
        }

        public function get mouseMove():String
        {
            return _mouseMove;
        }



        public function get mouseUp():String
        {
            return _mouseUp;
        }



        public function get doubleClick():String
        {
            return _doubleClick;
        }*/

        /////////////////////////////////////////////////////////////////////////////
        //// Protected
        ///////////////////////////////////////////////////////////////////////////

    }
}
