package app.controller
{
    import net.findzen.display.core.IView;
    import net.findzen.utils.Log;

    import org.robotlegs.mvcs.Command;

    public class HideContainerCommand extends Command
    {
        [Inject]
        public var container:IView;

        override public function execute():void
        {
            Log.status(this, 'execute');

            container.hide();
        }
    }
}
