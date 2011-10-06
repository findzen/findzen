package app
{
    import app.controller.*;
    import app.model.*;
    import app.signals.*;

    import com.asual.swfaddress.SWFAddress;
    import com.asual.swfaddress.SWFAddressEvent;

    import flash.display.*;
    import flash.events.*;
    import flash.net.*;

    import net.findzen.mvcs.controller.Operator;
    import net.findzen.utils.Config;
    import net.findzen.mvcs.view.*;
    import net.findzen.display.core.*;
    import net.findzen.utils.Log;

    import org.osflash.signals.ISignal;
    import org.robotlegs.base.ContextEvent;
    import org.robotlegs.core.ICommandMap;
    import org.robotlegs.core.ISignalContext;
    import org.robotlegs.mvcs.SignalContext;

    public class AppContext extends SignalContext
    {
        public function AppContext(contextView:DisplayObjectContainer, autoStartup:Boolean = true)
        {
            super(contextView, autoStartup);
        }

        override public function startup():void
        {
            Log.enableAllLevels();
            Log.status(this, 'startup');

            injector.mapValue(AppContext, this);

            // model
            injector.mapSingleton(AppModel);

            // controller
            signalCommandMap.mapSignalClass(OperatorConfigLoaded, RouteSignalsCommand, true);
            signalCommandMap.mapSignalClass(ViewConfigLoaded, BuildViewCommand, true);
            signalCommandMap.mapSignalClass(BuildViewComplete, InitSWFAddressCommand, true);

            injector.mapSingleton(ViewStateChange);
            signalCommandMap.mapSignalClass(AddressChange, HandleAddressChangeCommand);
            signalCommandMap.mapSignalClass(ChangeAddressState, ChangeAddressStateCommand);

            injector.mapSingleton(Operator);
            injector.mapSingleton(SWFAddressProxy);
            injector.instantiate(SWFAddressProxy);

            commandMap.mapEvent(ContextEvent.STARTUP_COMPLETE, LoadConfigCommand, ContextEvent, true);

            super.startup();
        }

    }
}
