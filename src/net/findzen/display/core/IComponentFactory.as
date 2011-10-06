package net.findzen.display.core
{

    public interface IComponentFactory extends IFactory
    {
        function get product():Class;
    }
}
