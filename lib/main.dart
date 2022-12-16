import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

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
      debugShowCheckedModeBanner: false,
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

  static int fibonacci(int n) {
    if (n < 2) {
      return n;
    }
    return fibonacci(n - 2) + fibonacci(n - 1);
  }

  void onPress() async {
    final number = await compute<int, int>(fibonacci, 45);
    numero = number;
    setState(() {});
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
