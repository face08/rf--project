package com.youbt.error
{

    import com.youbt.utils.StringUtil;

    import flash.utils.Dictionary;

    public class RFMessage
    {



        private static var _instance:RFMessage;
        internal static function getInsatnce():RFMessage
        {
            if(!_instance){
                _instance = new RFMessage();
                _instance.locationStore = new Dictionary();
            }
            return _instance;
        }

        public static  function generateMessage(code:String,...args):String
        {
            getInsatnce();

            if(!_instance.currentLocationlize)
                return 'Unknow Locationlize Message Code:'+code;

            var location:Dictionary = _instance.locationStore[_instance.currentLocationlize];
            var loc:String;
            if(code in location)
            {
                var obj:Object=location[code]
                if(obj is RFMessageVO){
                    loc= (obj as RFMessageVO).data
                }else{
                    var tmp:XML=XML(obj);
                    loc =  tmp.child('locationlize').toString();
                }

            }else
            {
                loc = 'Unknow Message Code:'+code;
            }

            if(args.length!=0)
            {
                args.unshift(loc);
                loc =(StringUtil.substitute as Function).apply(null,args);
            }
            return loc;
        }

        public static function setLocationlizeXML2(xml:XML):void
        {
            getInsatnce();
            var _xml:XML = xml.copy();
            var language:String=_xml.descendants('locationlize').attribute('language').toString();

            if(!(language  in _instance.locationStore))
                _instance.locationStore[language] = new Dictionary();
            var	_location:Dictionary =  _instance.locationStore[language];
            var tmplist:XMLList = _xml.descendants('Message');
            for each(var txml:XML in tmplist)
            {
                var key:String=txml.child('code').toString()
                var vo:RFMessageVO=new RFMessageVO()
                vo.data=txml.child('data').toString()
                vo.lv=int(txml.child('lv'))
                _location[key]=vo
            }
            _instance.currentLocationlize = language;
        }

        /**
         * 设置本地化xml
         * @param xml
         *
         */
        public static function setLocationlizeXML_old(xml:XML):void
        {
            getInsatnce();
            var _xml:XML = xml.copy();

            var language:String=_xml.descendants('locationlize').attribute('language').toString();


            if(!(language  in _instance.locationStore))
                _instance.locationStore[language] = new Dictionary();

            var	_location:Dictionary =  _instance.locationStore[language];
            var tmplist:XMLList = _xml.descendants('Message');
            for each(var txml:XML in tmplist)
            {
                _location[txml.@code.toString()] = txml.copy();
            }

            _instance.currentLocationlize = language;

        }
        public function RFMessage()
        {
        }
        public var currentLocationlize:String;

        public var locationStore:Dictionary ;
        private var subscribers:Array ;

        /**
         * 返回当前设定的本地化语言信息，如zh-cn,zh-tw,之类
         * @return
         *
         */
        public function get Location():String
        {
            return currentLocationlize;
        }

        /**
         * 设置本地化语言，如果有错误信息有多个配置语言的情况下使用
         * 如zh-cn zh-tw, en，之类。
         * @param value
         *
         */
        public function set Location(value:String):void
        {
            if(value in locationStore)
                currentLocationlize = value;
        }


        /**
         *  返回可用的错误信息本地化版本
         * 如zh-cn,zh-tw
         * @return
         *
         */
        public function get LocationlizeList():Array
        {
            var tmp:Array = new Array();
            for (var item:String  in locationStore)
            {
                tmp.push(item)
            }
            return tmp;
        }

        /**
         * 返回当前设定的提示信息版本，可用信息列表
         * @return
         *
         */
        public function get LocationlizeMessageCodeList():Array
        {
            if(currentLocationlize in locationStore)
            {
                var location:Dictionary = locationStore[currentLocationlize];
                var tmp:Array = new Array();
                for(var item:String  in location)
                {
                    tmp.push(item);
                }
                return tmp;
            }
            return new Array();
        }
    }
}
class RFMessageVO{
    public function RFMessageVO(){

    }
    public var data:String;
    public var lv:int;
}


