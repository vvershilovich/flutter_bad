import 'dart:async';
import 'dart:isolate';

import 'package:flutter/material.dart';

import 'dart:io';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  late String counter = "0";
  Isolate? newIsolate;

  MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (counter == null) {
      counter = "0";
    }
    if (newIsolate == null) {
      callerCreateIsolate(createElement());
    }
    var has = _fileBear('file.txt');
    print(has);

    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: Text("Title"),
            ),
            body: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                  new Text(
                    '$counter' + 'ms',
                  )
                ]))));
  }

  Future<bool> _fileBear(String path) {
    var completer = Completer<bool>();
    File(path).readAsString().then((contents) {
      completer.complete(contents.contains('bear'));
    });
    return completer.future;
  }

  // update elapsed time (milliseconds)
  void callerCreateIsolate(Element widget) async {
    newIsolate = await Isolate.spawn((String s) {
      int i = 0;
      while (true) {
        sleep(const Duration(milliseconds: 1));
        counter = i.toString();
        widget.markNeedsBuild();
        i++;
      }
    }, '');
  }
}
