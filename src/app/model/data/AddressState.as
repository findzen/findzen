package app.model.data
{

    public class AddressState
    {
        public var paths:Array;
        public var params:Object;
        public var title:String;

        /*public var topic:String;
        public var age:uint;
        public var rank:uint;
        public var sex:uint;*/

        public function AddressState($paths:Array = null, $params:Object = null, $title:String = null)
        {
            paths = $paths;
            params = $params;
            title = $title;

        /*if(!$params)
            return;

        topic = $params.topic;
        age = $params.age;
        rank = $params.top;
        sex = $params.female;*/
        }

    /*  public function get params():Object
      {
          var o:Object = {};

          o.topic = topic;
          o.age = age;
          o.rank = rank;
          o.sex = sex;

          return o;
      }*/

    }
}
