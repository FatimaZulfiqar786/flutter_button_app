import 'package:flutter/material.dart';

class ListViewScreen extends StatelessWidget {
  const ListViewScreen({super.key});

  final List<String> entries = const <String>['A', 'B', 'C'];
  final List<int> colorCodes = const <int>[600, 500, 100];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ListView Example"),
        backgroundColor: Colors.amber[700],
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(8),
        itemCount: entries.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            height: 50,
            color: Colors.amber[colorCodes[index]],
            child: Center(
              child: Text(
                'Entry ${entries[index]}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(
            height: 1.0,
            width: double.infinity,
            child: ColoredBox(color: Color(0xFF000000)),
          );
        },
      ),
    );
  }
}
