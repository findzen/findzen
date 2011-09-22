package net.findzen.utils
{

    public function deepTrace(obj:*, level:int = 0):void
    {
        var tabs:String = '';
        var i:int;
        var prop:String;

        for(i = 0; i < level; i++, tabs += '\t')
        {
        }

        for(prop in obj)
        {
            trace(tabs + '[' + prop + '] -> ' + obj[prop]);
            deepTrace(obj[prop], level + 1);
        }
    }
}
