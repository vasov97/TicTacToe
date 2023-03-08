import 'package:socket_io_client/socket_io_client.dart';

class SocketClient{

  Socket? socket;
  static SocketClient? _instance;

  SocketClient._internal(){
    socket=io('http://192.168.1.45:3000',<String,dynamic>{
      'transports':['websocket'],
      'autoConnect':false,
    });
    socket!.connect();
  }


  static SocketClient get instance{
    _instance??=SocketClient._internal();
    return _instance!;
  }

}