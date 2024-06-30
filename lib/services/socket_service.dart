import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

enum ServerStatus { online, offline, connecting }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.connecting;
  late io.Socket _socket;

  ServerStatus get serverStatus => _serverStatus;

  io.Socket get socket => _socket;

  SocketService() {
    _initConfig();
  }

  void _initConfig() {
    // Dart client

    // url local --> http://192.168.0.100:3000/
    // url nube  --> https://luisnu-socket-server-bands.herokuapp.com/

    _socket = io.io('http://192.168.0.100:3000/', {
      'transports': ['websocket'],
      'autoConnect': true,
    });

    _socket.on('connect', (_) {
      _serverStatus = ServerStatus.online;
      notifyListeners();
    });

    _socket.on('disconnect', (data) {
      _serverStatus = ServerStatus.offline;
      notifyListeners();
    });
    // _socket.on('nuevo-mensaje', (payload) {
    //   print('nuevo-mensaje:');
    //   print('nombre: ' + payload['nombre']);
    //   print('mensaje: ' + payload['mensaje']);
    //   print(payload.containsKey('mensaje2')
    //       ? 'mensaje2: ' + payload['mensaje2']
    //       : "No hay mensaje2");
    // });
  }
}
