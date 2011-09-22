package app.controller
{
    import app.signals.BuildViewComplete;
    import app.view.*;

    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.MovieClip;
    import flash.text.Font;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.utils.getQualifiedClassName;

    import net.findzen.mvcs.service.Config;
    import net.findzen.mvcs.view.Button;
    import net.findzen.mvcs.view.DisplayFactory;
    import net.findzen.mvcs.view.View;
    import net.findzen.mvcs.view.core.IComponent;
    import net.findzen.mvcs.view.core.IFactory;
    import net.findzen.mvcs.view.core.IView;
    import net.findzen.utils.FontManager;
    import net.findzen.utils.Inspector;
    import net.findzen.utils.Lib;
    import net.findzen.utils.Log;
    import net.findzen.utils.StringUtil;
    import net.findzen.utils.deepTrace;

    import org.robotlegs.core.IMediator;
    import org.robotlegs.mvcs.SignalCommand;

    public class BuildViewCommand extends SignalCommand
    {
        [Inject]
        public var config:Config;

        [Inject]
        public var buildViewComplete:BuildViewComplete;

        protected var _args:Object;
        protected var _properties:Object;

        override public function execute():void
        {
            Log.status(this, 'Setting up typography');

            FontManager.embedFonts = StringUtil.toBoolean(config.xml.typography[0].@embed);
            FontManager.deviceFont = config.xml.typography[0].@deviceFont;

            _args = {};
            _properties = {};

            // map view mediators
            /* mediatorMap.mapView(MainView, MainViewMediator);
             mediatorMap.mapView(ControlBar, ControlBarMediator, IView);
             mediatorMap.mapView(Map, MapMediator);
             mediatorMap.mapView(Country, CountryMediator);
             mediatorMap.mapView(CountryDetail, CountryDetailMediator);
             mediatorMap.mapView(Button, ComponentMediator, IComponent);
             mediatorMap.mapView(Quiz, QuizMediator);*/

            _buildView();
        }

        private function _buildView():void
        {
            Log.status(this, 'Setting up view');
            Log.startTimer(this);

            Log.stopTimer(this);

            _properties = null;
            _args = null;
            config.destroy();

            buildViewComplete.dispatch();
        }

        protected function _create($node:XML, $container:DisplayObjectContainer = null):Object
        {
            Log.info(this, 'Create', $container);

            var classRef:Class = config.nodeMap.getClass($node.name());

            if(!classRef)
            {
                Log.error(this, 'Missing class reference in node map for node', $node.name());
                return null;
            }

            var args:Array = _getArgs(classRef, $node, $container);
            var instance:Object = _getInstance($node, classRef, $container, args);

            if(!instance)
                return null;

            var container:DisplayObjectContainer = instance is DisplayObjectContainer ? instance as DisplayObjectContainer :
                instance is IComponent ? IComponent(instance).container : $container;

            _setProperties($node, instance, _getProperties(classRef), container);

            // if this is a DisplayObjectContainer and there are children nodes, parse children
            if(instance is DisplayObjectContainer && $node.children().length())
            {
                var node:XML;
                var child:Object;

                for each(node in $node.children())
                {
                    child = _create(node, instance as DisplayObjectContainer);

                    if(child is TextField && !FontManager.embedFonts)
                    {
                        TextField(child).defaultTextFormat = new TextFormat(FontManager.deviceFont);
                        TextField(child).embedFonts = FontManager.embedFonts;
                    }
                }
            }

            if(mediatorMap.hasMapping(instance))
                mediatorMap.createMediator(instance);

            return instance;
        }

        protected function _getInstance($xml:XML, $class:Class, $container:DisplayObjectContainer = null, $args:Array = null):Object
        {
            Log.info(this, 'Get instance', $class, $container);

            var instance:Object;
            var instanceName:String = _getXMLMatch($xml, 'instance');
            var linkage:String = _getXMLMatch($xml, 'linkage');

            Log.info(this, 'name:', instanceName, 'linkage:', linkage, 'args:', $args);

            if(linkage)
            {
                try
                {
                    $class = Lib.getClassDefinition(linkage, $container);
                }
                catch(e:Error)
                {
                    Log.error(this, 'Definition', linkage, 'not found in scope', $container, $container.name);
                    return null;
                }
                Log.info(this, 'Found linkage', linkage);
            }
            else if(instanceName)
            {
                if($container && $container.getChildByName(instanceName) is $class)
                {
                    // get instance from container
                    instance = $container[instanceName];

                    // remove attribute to prevent error thrown when attempting to set name of timeline-placed display objects
                    delete $xml.@name;

                    Log.info(this, 'Found instance', instance);

                    return instance;
                }
                else
                {
                    Log.error(this, 'instance name', instanceName, 'not found in container', $container);
                    return null;
                }
            }

            instance = _createInstance($class, $args);

            if(!instance)
                return null;

            Log.info(this, 'Created instance', instance);

            if($container && instance is DisplayObject)
                $container.addChild(instance as DisplayObject);

            return instance;
        }

        protected function _createInstance($class:Class, $args:Array = null):Object
        {
            var instance:Object;

            // create new instance of class
            try
            {
                if($args && $args.length)
                {
                    switch($args.length)
                    {
                        case 1:
                            instance = new $class($args[0]);
                            break;

                        case 2:
                            instance = new $class($args[0], $args[1], $args[3]);
                            break;

                        case 3:
                            instance = new $class($args[0], $args[1], $args[3], $args[4]);
                            break;

                        default:
                            Log.error(this, 'Constructor args length', $args.length, 'is unsupported');
                    }
                }
                else
                {
                    instance = new $class();
                }
            }
            catch(e:Error)
            {
                Log.error(this, 'Failed to create instance of', $class, e.message);
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

        protected function _getArgs($class:Class, $xml:XML, $container:DisplayObjectContainer = null):Array
        {
            var constructorList:XMLList = $xml.args;

            if(!constructorList || !constructorList.length())
                return null;

            var constructorXML:XML = constructorList[0];
            var argsList:Array = _args[$class] ||= Inspector.getConstructorArgs($class);
            var args:Array = [];
            var xmlMatch:XML;
            var fcqn:String;
            var i:int;

            for(i = 0; i < argsList.length; i++)
            {
                fcqn = getQualifiedClassName(argsList[i]);

                xmlMatch = _getXMLMatch(constructorXML, fcqn.split('::')[1]);

                if(!xmlMatch || !xmlMatch.length())
                {
                    Log.error(this, 'No xml match found!');
                    continue;
                }

                args.push(_getValue(xmlMatch, argsList[i], $container));
            }

            return args;
        }

        protected function _setProperties($xml:XML, $instance:Object, $properties:Object, $container:DisplayObjectContainer = null):void
        {
            var container:DisplayObjectContainer = $instance is DisplayObjectContainer ? $instance as DisplayObjectContainer : $container;
            var propName:String;
            var xmlMatch:XML;
            var val:*;

            for(propName in $properties)
            {
                xmlMatch = _getXMLMatch($xml, propName);

                if(!xmlMatch || !xmlMatch.length())
                    continue;

                val = _getValue(xmlMatch, $properties[propName], container);

                if(val)
                    $instance[propName] = val;
            }
        }

        protected function _getValue($xml:XML, $propType:Class, $container:DisplayObjectContainer = null):*
        {
            switch($propType)
            {
                case Array:
                    // if there are no children, assume this is a string (optionally comma-delimited)
                    if(!$xml.children().length())
                        return $xml.toString().split(',');

                    // else...
                    return _createChildren($xml.children(), $container);
                    break;

                case Boolean:
                    return StringUtil.toBoolean($xml.toString());
                    break;

                case Object:
                    return $xml.children().length() ? _createChildren($xml.children(), $container) as Object : $xml.toString();
                    break;

                case String:
                    return $xml.toString().length ? $xml.toString() : null;
                    break;

                case int:
                case Number:
                case uint:
                    return $xml.toString().length ? $propType($xml.toString()) : null;
                    break;

                /* todo:
                case Vector:

                break;

                case XML:

                break;

                case XMLList:

                break;*/

                default:
                    var instance:Object = _create($xml, $container);

                    if(!instance)
                        return null;

                    var container:DisplayObjectContainer = instance is DisplayObjectContainer ? instance as DisplayObjectContainer :
                        instance is IComponent ? IComponent(instance).container : $container;

                    _setProperties($xml, instance, _getProperties($propType), container);

                    // if this is a DisplayObjectContainer and there are children nodes, parse children
                    /*if(instance is DisplayObjectContainer && $xml.children().length())
                    {

                        var node:XML;
                        var child:Object;

                        for each(node in $xml.children())
                        {
                            trace(instance, node.toXMLString());
                            child = _create(node, instance as DisplayObjectContainer);

                            if(child is TextField && !FontManager.embedFonts)
                            {
                                TextField(child).defaultTextFormat = new TextFormat(FontManager.deviceFont);
                                TextField(child).embedFonts = FontManager.embedFonts;
                            }
                        }
                    }*/

                    return instance;
            }
        }

        protected function _createChildren($children:XMLList, $container:DisplayObjectContainer = null):Array
        {
            var child:XML;
            var instance:Object;
            var a:Array = [];

            for each(child in $children)
            {
                instance = _create(child, $container);

                if(instance)
                    a.push(instance);
            }

            return a;
        }

    }
}
