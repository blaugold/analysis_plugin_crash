import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import 'package:web_socket_channel/io.dart';

class ProxyPlugin {
  late final SendPort _serverSendPort;
  late final ReceivePort _pluginReceivePort;
  late final IOWebSocketChannel _remotePluginChannel;

  Future<void> start(SendPort serverSendPort) async {
    _serverSendPort = serverSendPort;
    _pluginReceivePort = ReceivePort();

    _serverSendPort.send(_pluginReceivePort.sendPort);

    _remotePluginChannel = IOWebSocketChannel.connect('ws://localhost:9999');

    _pluginReceivePort.listen((message) {
      _remotePluginChannel.sink.add(json.encode(message));
    });

    _remotePluginChannel.stream.listen((message) {
      _serverSendPort.send(json.decode(message as String));
    });
  }
}
