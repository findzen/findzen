package app.signals
{
    import app.model.data.AddressState;

    import org.osflash.signals.Signal;

    public class AddressChange extends Signal
    {
        public function AddressChange()
        {
            super(AddressState);
        }
    }
}
