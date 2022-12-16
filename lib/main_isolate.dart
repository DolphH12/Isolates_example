import 'dart:async';
import 'dart:isolate';

import 'package:flutter/material.dart';

// Generar un isolate que renderize el ejemplo de fibonacci

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const IsolatePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class IsolatePage extends StatefulWidget {
  const IsolatePage({super.key, required this.title});
  final String title;

  @override
  State<IsolatePage> createState() => _IsolatePageState();
}

class _IsolatePageState extends State<IsolatePage> {
  int numero = 5;
  Isolate? _isolate;
  final ReceivePort _receivePort = ReceivePort();
  late StreamSubscription _streamSubscription;

  int fibonacci(int n) {
    if (n < 2) {
      return n;
    }
    return fibonacci(n - 2) + fibonacci(n - 1);
  }

  static void entryPoint(SendPort sendPort) {
    Timer.periodic(
      const Duration(seconds: 2),
      (_) {
        sendPort.send(DateTime.now().toString());
      },
    );
  }

  void onPress() async {
    _isolate = await Isolate.spawn<SendPort>(entryPoint, _receivePort.sendPort);
    setState(() {});
  }

  @override
  void dispose() {
    _isolate?.kill();
    _streamSubscription.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _streamSubscription = _receivePort.listen((message) {
      print('message $message');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '$numero',
              ),
              const CircularProgressIndicator(),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: onPress,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ));
  }
}
