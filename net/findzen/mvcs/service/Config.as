package net.findzen.mvcs.service
{
    import flash.display.MovieClip;
    import flash.utils.getDefinitionByName;

    import net.findzen.utils.Log;

    public class Config
    {
        public static const MAP:String = 'map';
        public static const NODE:String = 'node';
        public static const CLASS:String = 'class';

        protected var _nodeMap:NodeMap;
        protected var _xml:XML;
        protected var _lib:MovieClip;

        public function Config($xml:XML = null, $map:XML = null, $lib:MovieClip = null)
        {
            _lib = $lib;
            _xml = $xml;

            if($map)
                this.map = $map;
        }

        public function get xml():XML
        {
            return _xml;
        }

        public function set xml(value:XML):void
        {
            _xml = value;
        }

        public function get lib():MovieClip
        {
            return _lib;
        }

        public function set lib(value:MovieClip):void
        {
            _lib = value;
        }

        public function get nodeMap():NodeMap
        {
            return _nodeMap;
        }

        public function set map($xml:XML):void
        {
            if(_nodeMap)
                _nodeMap.destroy();

            _nodeMap = new NodeMap();

            var mapNodes:XMLList = $xml.child(MAP);
            var node:XML;
            var nodeName:String;
            var className:String;
            var classRef:Class;

            for each(node in mapNodes)
            {
                nodeName = node.attribute(NODE);

                if(!nodeName)
                {
                    Log.error(this, 'Node name not found\n', node.toXMLString());
                    continue;
                }

                className = node.attribute(CLASS);

                if(!className)
                {
                    Log.error(this, 'Class name not found\n', node.toXMLString());
                    continue;
                }

                try
                {
                    classRef = getDefinitionByName(className) as Class;
                }
                catch(e:Error)
                {
                    Log.error(this, 'Class reference', className, 'not found');
                    continue;
                }

                if(!classRef)
                {
                    Log.error(this, 'Class', className, 'not found');
                    continue;
                }

                _nodeMap.mapClass(classRef, nodeName);
            }
        }

        public function destroy():void
        {
            _nodeMap.destroy();
            _nodeMap = null;
            _xml = null;
        }
    }
}
