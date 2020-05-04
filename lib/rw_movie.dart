import 'package:flutter/services.dart';

class RwMovie {
  static const MethodChannel _channel =
      const MethodChannel('com.rockwellits.rw_plugins/rw_movie');

  /// Plays video from file.
  ///
  /// Plays video using built-in movie applet using its [fileName].
  static void playFile(String fileName) {
    _channel.invokeMethod('playFile', {'fileName': fileName});
  }

  /// Plays video from URL.
  ///
  /// Plays file using built-in movie applet using its [url].
  static void playUrl(String url) {
    _channel.invokeMethod('playUrl', {'url': url});
  }
}
