import 'package:flutter/services.dart';

class YtFile {
  final String url;
  final String ext;
  final int height;

  YtFile(this.url, this.ext, this.height);

  factory YtFile.fromMap(Map<String, dynamic> map) {
    return YtFile(map['url'], map['ext'], map['height']);
  }
}

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

  /// Plays video from Youtube.
  ///
  /// Plays file using built-in movie applet using its Youtube [url].
  static Future<List<YtFile>> playYoutube(String url) async {
    _channel.invokeMethod('playYoutube', {'url': url});
  }

  /// Retrieves available stream URLs for Youtube URL.
  ///
  /// Retrieves available stream URLs for Youtube [url].
  static Future<List<YtFile>> getYoutubeStreams(String url) async {
    return _channel.invokeMethod('getYoutubeStreams', {'url': url}).then(
        (value) => Future.value(List<YtFile>.from(value
            .map((map) => YtFile.fromMap(Map<String, dynamic>.from(map))))));
  }
}
