package app.signals
{
    import org.osflash.signals.Signal;
    import net.findzen.mvcs.service.Config;

    public class ViewConfigLoaded extends Signal
    {
        public function ViewConfigLoaded()
        {
            super(Config);
        }
    }
}
