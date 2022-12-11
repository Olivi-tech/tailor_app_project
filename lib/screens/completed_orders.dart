import 'package:flutter/material.dart';

class CompletedOrders extends StatelessWidget {
  const CompletedOrders({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              tileColor: Colors.amber,
            ),
          )
        ],
      ),
    );
  }
}
