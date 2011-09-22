package net.findzen.utils
{
    import flash.utils.describeType;
    import flash.utils.getDefinitionByName;

    public class Inspector
    {

        public static function getProperties($o:Object):Object
        {
            var props:Object = {};
            var desc:XML = describeType($o);
            var accessors:XMLList = desc..descendants('accessor').(@access == 'readwrite' || @access == 'writeonly');
            var variables:XMLList = desc..descendants('variable');

            __setValues(accessors, props);
            __setValues(variables, props);

            return props;
        }

        public static function getConstructorArgs($o:Object):Array
        {
            var args:Array = [];
            var desc:XML = describeType($o);
            var argList:XMLList = desc..constructor.descendants('parameter');
            var xml:XML;

            for each(xml in argList)
                args.push(getDefinitionByName(xml.@type));

            return args;
        }

        public static function validate($o:Object, $c:Class):Boolean
        {
            var props:Object = getProperties($c);
            var i:String;

            for(i in props)
            {
                if(!$o.hasOwnProperty(i))
                    return false;
            }

            return true;
        }

        private static function __setValues($list:XMLList, $props:Object):Object
        {
            var xml:XML;

            for each(xml in $list)
                $props[xml.@name] = getDefinitionByName(xml.@type);

            return $props;
        }
    }
}
