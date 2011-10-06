package net.findzen.display
{
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.utils.*;

    import net.findzen.display.core.IComponent;
    import net.findzen.display.core.IView;
    import net.findzen.utils.HashTable;
    import net.findzen.utils.Inspector;
    import net.findzen.utils.Log;
    import net.findzen.utils.VarsBase;
    import net.findzen.utils.Lib;

    import org.osflash.signals.ISignal;
    import org.osflash.signals.Signal;
    import org.osflash.signals.natives.NativeMappedSignal;

    public class Component extends Sprite implements IComponent
    {
        protected var _skin:MovieClip;
        protected var _includeIn:Array;

        // signals
        protected var _clicked:ISignal;
        protected var _clickedRoute:String;
        protected var _mouseOver:ISignal;
        protected var _mouseOut:ISignal;

        public function Component()
        {
            this.addEventListener(Event.ADDED_TO_STAGE, _onAddedToStage, false, 0, true);
        }

        /////////////////////////////////////////////////////////////////////////////
        //// API
        ///////////////////////////////////////////////////////////////////////////

        public function set skinClass($skinClass:String):void
        {
            try
            {
                this.skin = Lib.createAsset($skinClass, this) as MovieClip;
            }
            catch(e:Error)
            {
                Log.error(this, 'Failed to create skin', e.message);
            }
        }

        public function set skin($skin:MovieClip):void
        {
            Log.status(this, 'Setting skin', $skin);
            _skin = $skin;
            this.addChild(_skin);
        }

        public function get skin():MovieClip
        {
            return _skin;
        }

        public function show($forceAnim:Boolean = false):IComponent
        {
            //Log.status(this, this.name, 'show');

            this.visible = true;
            return this;
        }

        public function hide($forceAnim:Boolean = false):IComponent
        {
            //Log.status(this, this.name, 'hide');

            this.visible = false;
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

        public function destroy():void
        {
            _includeIn = null;
            _clicked = null;
            _clickedRoute = null;
        }

        public function get click():ISignal
        {
            return _clicked ||= new NativeMappedSignal(this, MouseEvent.CLICK, MouseEvent);;
        }

        public function get mouseOver():ISignal
        {
            return _mouseOver ||= new NativeMappedSignal(this, MouseEvent.MOUSE_OVER, MouseEvent);;
        }

        public function get mouseOut():ISignal
        {
            return _mouseOut ||= new NativeMappedSignal(this, MouseEvent.MOUSE_OUT, MouseEvent);
        }

        public function get clickRoute():String
        {
            return _clickedRoute;
        }

        public function set clickRoute($route:String):void
        {
            _clickedRoute = $route;
        }

        /////////////////////////////////////////////////////////////////////////////
        //// Protected
        ///////////////////////////////////////////////////////////////////////////

        protected function _createChildren():void
        {
            // override me
            Log.status(this, 'Create children');
        }

        /////////////////////////////////////////////////////////////////////////////
        //// Private
        ///////////////////////////////////////////////////////////////////////////

        private function _onAddedToStage($e:Event):void
        {
            this.removeEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
            _createChildren();
        }
    }
}
