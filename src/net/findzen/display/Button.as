package net.findzen.display
{
    import com.bigspaceship.display.StandardButton;

    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.MovieClip;
    import flash.events.MouseEvent;

    public class Button extends Component
    {
        protected var _btn:StandardButton;

        public function Button($container:MovieClip)
        {
            super($container);

            _btn = new StandardButton($container);

            this.container.buttonMode = true;
            this.container.mouseChildren = false;
        }
    }
}
