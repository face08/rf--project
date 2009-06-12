package com.youbt.rpc.remoting {

  import flash.utils.Proxy;
  import flash.utils.flash_proxy;

  public dynamic class RemotingService extends Proxy {

    private var _serviceName:String;
    private var _connection:RemotingConnection;

    public function RemotingService(gatewayUrl:String, serviceName:String, conn:RemotingConnection=null) {
      if (conn != null) {
        _connection = conn;
      } else {
        _connection = new RemotingConnection(gatewayUrl);
      }
      _serviceName = serviceName;
    }

    public function get connection():RemotingConnection {
      return _connection;
    }
    flash_proxy override function callProperty(methodName:*, ... args):* {
      return new PendingCall(_connection, _serviceName, methodName, args);
    }

  }
}
