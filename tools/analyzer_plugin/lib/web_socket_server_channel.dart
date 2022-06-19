// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:analyzer_plugin/channel/channel.dart';
import 'package:analyzer_plugin/protocol/protocol.dart';

class WebSocketPluginServer implements PluginCommunicationChannel {
  WebSocketPluginServer({Object? address, this.port = 9999})
      : address = address ?? InternetAddress.loopbackIPv4 {
    _init();
  }

  final Object address;
  final int port;

  late HttpServer _server;
  WebSocket? _currentClient;

  final StreamController<WebSocket?> _clientStream =
      StreamController.broadcast();

  Future<void> _init() async {
    _server = await HttpServer.bind(address, port);
    print('listening on $address at port $port');
    _server.transform(WebSocketTransformer()).listen(_handleClientAdded);
  }

  void _handleClientAdded(WebSocket client) {
    if (_currentClient != null) {
      print(
        'ignoring connection attempt because an active client already '
        'exists',
      );
      client.close();
    } else {
      print('client connected');
      _currentClient = client;
      _clientStream.add(_currentClient);
      _currentClient!.done.then((_) {
        print('client disconnected');
        _currentClient = null;
        _clientStream.add(null);
      });
    }
  }

  @override
  void close() {
    _server.close(force: true);
  }

  @override
  void listen(
    void Function(Request request) onRequest, {
    Function? onError,
    void Function()? onDone,
  }) {
    final clientStream = _clientStream.stream;

    // Wait until we're connected.
    clientStream.firstWhere((client) => client != null).then((_) {
      _currentClient!.listen((data) {
        print('I: $data');
        final request = Request.fromJson(
          json.decode(data as String) as Map<String, dynamic>,
        );
        onRequest(request);
      });
    });

    clientStream
        .firstWhere((client) => client == null)
        .then((_) => onDone?.call());
  }

  @override
  void sendNotification(Notification notification) {
    print('N: ${notification.toJson()}');
    _currentClient!.add(json.encode(notification.toJson()));
  }

  @override
  void sendResponse(Response response) {
    print('O: ${response.toJson()}');
    _currentClient!.add(json.encode(response.toJson()));
  }
}
