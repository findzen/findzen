package app.controller
{
    import app.signals.BuildViewComplete;

    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.InteractiveObject;
    import flash.display.MovieClip;
    import flash.text.Font;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.utils.getQualifiedClassName;

    import net.findzen.display.Button;
    import net.findzen.display.DisplayFactory;
    import net.findzen.display.View;
    import net.findzen.display.core.IComponent;
    import net.findzen.display.core.IFactory;
    import net.findzen.display.core.IView;
    import net.findzen.utils.Config;
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

            var view:IView = _create(config.xml.child('AnimatedView')[0], config.lib) as IView;

            this.contextView.addChild(view as DisplayObject);
            view.show();

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
            trace($node);

            var classRef:Class = config.nodeMap.getClass($node.name());

            if(!classRef)
            {
                Log.error(this, 'Missing class reference in node map for node', $node.name());
                return null;
            }

            var instance:Object = _getInstance($node, classRef, $container);

            if(!instance)
                return null;

            var container:DisplayObjectContainer = instance is DisplayObjectContainer ? instance as DisplayObjectContainer : $container;

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

        protected function _findChild($name:String, $container:DisplayObjectContainer):DisplayObject
        {
            if($container.getChildByName($name))
                return $container[$name]; // well that was easy... nothing more to do here

            // must not be a direct descendent.. keep searching
            var instance:DisplayObject;
            var child:DisplayObject;

            for(var i:uint = 0; i < $container.numChildren; i++)
            {
                child = $container.getChildAt(i);

                if(child is DisplayObjectContainer)
                    instance = _findChild($name, child as DisplayObjectContainer);

                if(instance)
                    return instance;
            }

            // didn't find anything.
            return null;
        }

        protected function _getInstance($xml:XML, $class:Class, $container:DisplayObjectContainer = null):Object
        {
            Log.info(this, 'Get instance', $class, $container);

            var instance:Object;
            var instanceName:String = _getXMLMatch($xml, 'instance');
            var linkage:String = _getXMLMatch($xml, 'linkage');

            Log.info(this, 'name:', instanceName, 'linkage:', linkage);

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
                if($container)
                {
                    instance = _findChild(instanceName, $container);

                    if(!instance)
                        Log.error(this, 'instance name', instanceName, 'not found in container', $container);

                    return instance;
                }
                else
                {
                    return null;
                }
            }

            instance = new $class();

            if(!instance)
            {
                Log.error(this, 'Failed to create instance of', $class);
                return null;
            }

            Log.info(this, 'Created instance', instance);

            if($container && instance is DisplayObject)
                $container.addChild(instance as DisplayObject);

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
            var container:DisplayObjectContainer = $instance is DisplayObjectContainer ? $instance as DisplayObjectContainer : $container;
            var propName:String;
            var xmlMatch:XML;
            var val:*;

            /*if($instance is IComponent && $xml.@skinClass.length())
                Lib.*/

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

                break;

                case MovieClip:
                    trace('MC');
                    trace($xml.children()[0].toXMLString());
                    return $xml.children().length() ? _create($xml.children()[0], $container) : null;
                    break;*/

                default:
                    trace('\n======\n DEFAULT \n======\n');

                    if(!$xml.children().length())
                        return null;

                    var instance:Object = _create($xml.children()[0], $container);

                    if(!instance)
                        return null;

                    var container:DisplayObjectContainer = instance is DisplayObjectContainer ? instance as DisplayObjectContainer : $container;

                    _setProperties($xml, instance, _getProperties($propType), container);

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
