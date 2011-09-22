package app.signals
{
    import app.model.data.AddressState;

    import org.osflash.signals.Signal;

    public class ChangeAddressState extends Signal
    {
        public function ChangeAddressState()
        {
            super(AddressState);
        }
    }
}
