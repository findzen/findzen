package net.findzen.display
{
    import flash.display.FrameLabel;
    import flash.display.MovieClip;
    import flash.text.TextField;

    import net.findzen.display.core.IComponent;
    import net.findzen.display.data.AnimationState;
    import net.findzen.utils.Log;

    import org.osflash.signals.ISignal;
    import org.osflash.signals.Signal;

    public class AnimatedView extends View
    {
        private var _animationState:String;

        // signals
        private var _animateInit:ISignal;
        private var _animateInStart:ISignal;
        private var _animateIn:ISignal;
        private var _animateOutStart:ISignal;
        private var _animateOut:ISignal;
        private var _animateIdle:ISignal;

        public var testText:TextField;

        public function AnimatedView()
        {
            super();
        }

        /////////////////////////////////////////////////////////////////////////////
        //// API
        ///////////////////////////////////////////////////////////////////////////

        override public function set skin($skin:MovieClip):void
        {
            super.skin = $skin;

            var labels:Array = this.skin.currentLabels;
            var label:FrameLabel;

            for each(label in labels)
            {
                switch(label.name)
                {
                    case AnimationState.INIT:
                        this.skin.addFrameScript(label.frame, _onAnimateInit);
                        break;

                    case AnimationState.IN_START:
                        this.skin.addFrameScript(label.frame, _onAnimateInStart);
                        break;

                    case AnimationState.IN:
                        this.skin.addFrameScript(label.frame, _onAnimateIn);
                        break;

                    case AnimationState.OUT_START:
                        this.skin.addFrameScript(label.frame, _onAnimateOutStart);
                        break;

                    case AnimationState.OUT:
                        this.skin.addFrameScript(label.frame, _onAnimateOut);
                        break;
                }
            }
        }

        override public function show($forceAnim:Boolean = false):IComponent
        {
            _skin.gotoAndPlay(AnimationState.IN_START);
            return super.show($forceAnim);
        }

        override public function hide($forceAnim:Boolean = false):IComponent
        {
            // if skin has not been set or the animationState is already OUT oand $forceAnim is false...
            if(!_skin || (this.animationState == AnimationState.OUT && !$forceAnim))
                return this;

            // otherwise...
            _skin.gotoAndPlay(AnimationState.OUT_START);
            return super.hide($forceAnim);
        }

        public function get animationState():String
        {
            return _animationState;
        }

        /////////////////////////////////////////////////////////////////////////////
        //// Signals
        ///////////////////////////////////////////////////////////////////////////

        public function get animateInStart():ISignal
        {
            return _animateInStart ||= new Signal();
        }

        public function get animateIn():ISignal
        {
            return _animateIn ||= new Signal();
        }

        public function get animateOutStart():ISignal
        {
            return _animateOutStart ||= new Signal();
        }

        public function get animateOut():ISignal
        {
            return _animateOut ||= new Signal();
        }

        /////////////////////////////////////////////////////////////////////////////
        //// Protected
        ///////////////////////////////////////////////////////////////////////////

        /////////////////////////////////////////////////////////////////////////////
        //// Animation handlers (attached to skin frames at runtime)
        ///////////////////////////////////////////////////////////////////////////

        protected function _onAnimateInit():void
        {
            trace('_onAnimateInStart');
            _skin.stop();
            _animationState = AnimationState.INIT;
        }

        protected function _onAnimateInStart():void
        {
            trace('_onAnimateInStart');
            Signal(this.animateInStart).dispatch();
            _animationState = AnimationState.IN_START;
        }

        protected function _onAnimateIn():void
        {
            trace('_onAnimateIn');
            trace(this.testText);
            _skin.stop();
            Signal(this.animateIn).dispatch();
            _animationState = AnimationState.IN;
        }

        protected function _onAnimateOutStart():void
        {
            trace('_onAnimateOutStart');
            Signal(this.animateOutStart).dispatch();
            _animationState = AnimationState.OUT_START;
        }

        protected function _onAnimateOut():void
        {
            trace('_onAnimateOut');
            _skin.stop();
            Signal(this.animateOut).dispatch();
            _animationState = AnimationState.OUT;
        }

    }
}
