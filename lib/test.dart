import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('나의 첫 플러터 앱'),
        ),
        body: const Center(
          child: Text('안녕, 플러터!'),
        ),
      ),
    );
  }
}
