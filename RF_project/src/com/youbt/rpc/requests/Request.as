package com.youbt.rpc.requests
{
    import com.youbt.rpc.RemoteToken;

    /**
     * Request 抽象
     * @author eas
     *
     */
    [Exclude]
    public class Request
    {
        public function Request()
        {
        }


        protected var _requestType:String = '';

        public function get requestType():String
        {
            return _requestType;
        }

        protected var _requestParameter:Array = [];

        public function get requestParameter():Array
        {
            return _requestParameter;
        }

        /* Abstract */	protected function initialize():void
        {

        }



        /**
         * 预置反应类
         * @return
         *
         */
        /* Abstract */public function get  preplaceResponserClass():Class
        {
            return _preplaceResponserClass;
        }
        protected var _preplaceResponserClass:Class = undefined

        /**
         * 呼叫一个远端方法
         * 以返回的remotetoken 来监视 处理结果
         * @return
         *
         */
        /* Abstract */public function invoke():RemoteToken
        {
            throw new Error('invoke() method need been overrride');
            return null;
        }

        /**
         * 呼叫一个远端的无返回的方法
         * 如socket 的操作
         */
        /* Abstract   */public function call():void
        {
            throw new Error('call() method need been overrride');
        }

    }
}

