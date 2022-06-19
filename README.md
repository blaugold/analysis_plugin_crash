This repo contains a minimal setup to replicate
https://github.com/dart-lang/sdk/issues/49281.

# Reproduce analysis server crash

1. run `pub get` in packages:
   ```
   dart pub get -C example
   dart pub get -C tools/analyzer_plugin
   ```
1. Ensure the current version of the analyzer plugin is used by deleting the
   plugin cache:
   ```
   rm -rf $HOME/.dartServer/.plugin_manager
   ```
1. Start the plugin in separate process and wait until it is ready:
   ```shell
   dart tools/analyzer_plugin/bin/debug_plugin.dart
   ```
1. Enable the plugin in `example/analysis_options.yaml`.

When using VS Code, log files will be created in the repository root:

- `analyzer.log`: Analyzer logs recorded by the VS Code extension. This is where
  the backtrace for the crash is logged.
- `instrumentation.log`: Instrumentation logs from the analysis server

# Workaround

`tools/analyzer_plugin/bin/plugin.dart` contains a commented import
(`package:analyzer_plugin/plugin/plugin.dart`). When this import is uncommented,
the crash goes away.

1. Disable the plugin in `example/analysis_options.yaml`.
1. Uncomment the import in `tools/analyzer_plugin/bin/plugin.dart`.
1. Ensure the current version of the analyzer plugin is used by deleting the
   plugin cache:
   ```
   rm -rf $HOME/.dartServer/.plugin_manager
   ```
1. Start the plugin in separate process and wait until it is ready:
   ```shell
   dart tools/analyzer_plugin/bin/debug_plugin.dart
   ```
1. Enable the plugin in `example/analysis_options.yaml`.
