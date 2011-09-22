package net.findzen.mvcs.view.core
{

    public interface IComponentFactory extends IFactory
    {
        function get product():Class;
    }
}
