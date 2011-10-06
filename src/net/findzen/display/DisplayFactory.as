package net.findzen.display
{
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.MovieClip;
    import flash.text.TextField;

    import net.findzen.utils.NodeMap;
    import net.findzen.display.core.IFactory;
    import net.findzen.utils.Inspector;
    import net.findzen.utils.Lib;
    import net.findzen.utils.Log;
    import net.findzen.utils.StringUtil;

    public class DisplayFactory implements IFactory
    {
        protected var _nodeMap:NodeMap;
        protected var _properties:Object;

        public function DisplayFactory($nodeMap:NodeMap)
        {
            _properties = {};
            _nodeMap = $nodeMap;
        }

        public function create($node:XML, $container:DisplayObjectContainer = null):Object
        {
            Log.info(this, 'Create');

            var classRef:Class;

            classRef = _nodeMap.getClass($node.name());
            //trace('node.name()', $node.name(), 'classRef', classRef);

            if(!classRef)
            {
                Log.error(this, 'Missing class reference in node map for node', $node.name());
                return null;
            }

            var instance:Object = _getInstance($node, classRef, $container);

            if(!instance)
                return null;

            _setProperties($node, instance, _getProperties(classRef), $container);
            //trace(instance);

            return instance;
        }

        public function destroy():void
        {
            _properties = null;
            _nodeMap = null;
        }

        protected function _getInstance($xml:XML, $class:Class, $container:DisplayObjectContainer = null):Object
        {
            Log.info(this, 'Get instance', $class, $container);

            var instance:Object;
            var name:String = _getXMLMatch($xml, 'name');
            var linkage:String = _getXMLMatch($xml, 'linkage');

            Log.info(this, 'name:', name, 'linkage:', linkage);

            if(linkage && linkage.length)
            {
                try
                {
                    instance = Lib.createClassObject(linkage, $container);
                }
                catch(e:Error)
                {
                    Log.error(this, 'Definition', linkage, 'not found in scope', $container, $container.name);
                    return null;
                }
                Log.info(this, 'Found linkage', linkage);
            }
            else if(name && $container.getChildByName(name) is $class)
            {
                // get instance from container
                instance = $container[name];
                delete $xml.@name;
                Log.info(this, 'Found instance', instance);
            }

            if(!instance)
            {
                // create new instance of class
                try
                {
                    instance = new $class();
                }
                catch(e:Error)
                {
                    Log.error(this, 'Failed to create instance of', $class, e.message);
                    return null;
                }
                Log.info(this, 'Created instance', instance);

                if($container && instance is DisplayObject)
                    $container.addChild(instance as DisplayObject);
            }

            return instance;
        }

        protected function _getXMLMatch($xml:XML, $property:String):XML
        {
            // returns attribute, first node match, or null
            return $xml.attribute($property).length() ? $xml.attribute($property)[0] :
                $xml.child($property).length() ? $xml.child($property)[0] : null;
        }

        protected function _getProperties($class:Class):Object
        {
            return _properties[$class] ||= Inspector.getProperties($class);
        }

        protected function _setProperties($xml:XML, $instance:Object, $properties:Object, $container:DisplayObjectContainer = null):void
        {
            //trace('\n\n\nsetting properties', $xml);
            var container:DisplayObjectContainer = $instance is DisplayObjectContainer ? $instance as DisplayObjectContainer : $container;
            var propName:String;
            var propType:Class;
            var xmlMatch:XML;

            for(propName in $properties)
            {
                propType = $properties[propName];
                //trace(propName, propType);

                xmlMatch = _getXMLMatch($xml, propName);
                //trace('xmlMatch', xmlMatch);

                if(!xmlMatch || !xmlMatch.length())
                    continue;

                switch(propType)
                {
                    case Array:
                        $instance[propName] = _createChildren(xmlMatch.children(), container);
                        break;

                    case Boolean:
                        $instance[propName] = StringUtil.toBoolean(xmlMatch.toString());
                        break;

                    case Object:
                        if(xmlMatch.children().length())
                            $instance[propName] = _createChildren(xmlMatch.children(), container) as Object;
                        else
                            $instance[propName] = xmlMatch.toString();
                        break;

                    case String:
                        if(xmlMatch.toString().length)
                            $instance[propName] = xmlMatch.toString();
                        break;

                    case int:
                    case Number:
                    case uint:
                        if(xmlMatch.toString().length)
                            $instance[propName] = propType(xmlMatch.toString());
                        break;

                    /*case Vector:

                    break;

                    case XML:

                    break;

                    case XMLList:

                    break;*/

                    default:
                        var children:XMLList = xmlMatch.children();

                        if(!children)
                            return;

                        $instance[propName] = this.create(children[0], container);
                }

            }
        }

        protected function _createChildren($children:XMLList, $container:DisplayObjectContainer = null):Array
        {
            var child:XML;
            var a:Array = [];

            for each(child in $children)
                a.push(this.create(child, $container));

            return a;
        }

    }
}
