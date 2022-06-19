import 'package:foo_plugin/plugin.dart';
import 'package:foo_plugin/web_socket_server_channel.dart';

void main() {
  FooPlugin().start(WebSocketPluginServer());
}
