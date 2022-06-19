import 'package:analyzer/src/dart/analysis/driver.dart';
import 'package:analyzer_plugin/plugin/plugin.dart';
import 'package:analyzer_plugin/protocol/protocol_generated.dart';

class FooPlugin extends ServerPlugin {
  FooPlugin([super.provider]);

  @override
  String get name => 'foo';

  @override
  String get version => '1.0.0-alpha.0';

  @override
  List<String> get fileGlobsToAnalyze => ['*.dart'];

  @override
  AnalysisDriverGeneric createAnalysisDriver(ContextRoot contextRoot) {
    throw UnimplementedError();
  }
}
