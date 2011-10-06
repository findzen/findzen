package app.signals
{
    import org.osflash.signals.Signal;
    import net.findzen.utils.Config;

    public class ViewConfigLoaded extends Signal
    {
        public function ViewConfigLoaded()
        {
            super(Config);
        }
    }
}
