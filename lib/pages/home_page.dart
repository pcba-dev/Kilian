import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _KilianAppState();
}

class _KilianAppState extends State<HomePage> {
  int counter = 0;

  @override
  void initState() {
    super.initState();
    counter = 0;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
          child: new Text(
        counter.toString(),
        style: const TextStyle(fontSize: 48),
      )),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          setState(() => ++counter);
        },
        backgroundColor: Colors.amber,
        child: const Icon(Icons.add),
      ),
    );
  }
}
