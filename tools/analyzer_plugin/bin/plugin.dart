// ignore_for_file: unused_import

import 'dart:isolate';

import 'package:foo_plugin/proxy_plugin.dart';

// With this import uncommented the crash goes away.
// import 'package:analyzer_plugin/plugin/plugin.dart';

void main(List<String> args, SendPort sendPort) async {
  ProxyPlugin().start(sendPort);
}
