package net.findzen.utils
{

    public class XMLUtility
    {
        /**
         *
         * @default
         */
        public static var _xmlObject:Object = {};

        /**
         *
         * @param xml
         * @param findString
         * @param replaceString
         */
        public static function replaceAllInstances(xml:XML, findString:String, replaceString:String):void
        {
            replaceAttributes(xml, findString, replaceString);
            replaceNodeNames(xml, findString, replaceString);
            replaceNodeText(xml, findString, replaceString);
        }

        /**
         *
         * @param xml
         * @param findString
         * @param replaceString
         */
        public static function replaceAttributes(xml:XML, findString:String, replaceString:String):void
        {
            var tempString:String;
            var attributes:XMLList = xml.@*;

            try
            {
                if(xml.nodeKind() == 'element')
                {
                    for(var i:int = 0; i < attributes.length(); i++)
                    {
                        tempString = attributes[i];
                        attributes[i] = tempString.replace(findString, replaceString);
                    }
                }

                for each(var child:XML in xml.children())
                {
                    XMLUtility.replaceAttributes(child, findString, replaceString);
                }
            }
            catch(error:Error)
            {
                // Logger.debug("XMLUtility.replaceAttributes(xml, findString, replaceString) [error] --> ", error);
            }
        }

        /**
         *
         * @param xml
         * @param findString
         * @param replaceString
         */
        public static function replaceNodeNames(xml:XML, findString:String, replaceString:String):void
        {
            var tempString:String;

            try
            {
                if(xml.nodeKind() == 'element')
                {
                    tempString = xml.localName();
                    xml.setLocalName(tempString.replace(findString, replaceString));
                }

                for each(var child:XML in xml.children())
                {
                    XMLUtility.replaceNodeNames(child, findString, replaceString);
                }
            }
            catch(error:Error)
            {
                //Logger.debug("XMLUtility.replaceNodeNames(xml, findString, replaceString) [error] --> ", error);
            }
        }

        /**
         *
         * @param xml
         * @param findString
         * @param replaceString
         */
        public static function replaceNodeText(xml:XML, findString:String, replaceString:String):void
        {
            var tempString:String;

            try
            {
                if(xml.nodeKind() == 'text')
                {
                    tempString = xml[0];
                    xml.parent().setChildren(tempString.replace(findString, replaceString));
                }

                for each(var child:XML in xml.children())
                {
                    XMLUtility.replaceNodeText(child, findString, replaceString);
                }
            }
            catch(error:Error)
            {
                // Logger.debug("XMLUtility.replaceNodeText(xml, findString, replaceString) [error] --> ", error);
            }
        }

        /**
         *
         * @param xml
         * @param nodeId
         * @param attributes
         * @param attributeValue
         */
        public static function addAttribute(xml:XML, nodeId:String, attributes:String, attributeValue:String = ''):void
        {
            // TODO - Check that this works
            xml.(@nodeId == nodeId).appendChild(<{nodeId} {attributes}={attributeValue}/>);
        }

        /**
         *
         * @param xml
         * @param nodeName
         */
        public static function addNode(xml:XML, nodeName:String):void
        {
            // TODO - Check that this works
            xml.appendChild(<{nodeName}></{nodeName}>);
        }
    }
}
