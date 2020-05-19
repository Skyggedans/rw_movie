import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rw_movie/rw_movie.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('RealWear HMT1(Z1) movie plugin example app'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                child: Text('Play File'),
                onPressed: () async {
                  final fileName = await copyFiles();
                  RwMovie.playFile(fileName);
                },
              ),
              RaisedButton(
                child: Text('Play URL'),
                onPressed: () async {
                  RwMovie.playUrl(
                      'https://github.com/realwear/Developer-Examples/raw/integration/hmt1developerexamples/src/main/assets/kick%20ass.mp4');
                },
              ),
              RaisedButton(
                child: Text('Play Youtube'),
                onPressed: () async {
                  final files =
                      await RwMovie.playYoutube('https://youtu.be/ukARfq1sK6s');
                  print(files);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> copyFiles() async {
    Directory directory = await getExternalStorageDirectory();
    final filePath = join(directory.path, 'kick_ass.mp4');

    if (FileSystemEntity.typeSync(filePath) == FileSystemEntityType.notFound) {
      ByteData data = await rootBundle.load("assets/kick_ass.mp4");

      File(filePath).writeAsBytesSync(
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
    }

    return filePath;
  }
}
