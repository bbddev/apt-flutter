import 'package:flutter/material.dart';
import 'package:demoprovider/providers/tabindex_provider.dart';
import 'package:provider/provider.dart';

class TestProduct extends StatelessWidget {
  const TestProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: ElevatedButton(
        onPressed: () {
          //cach 1
          //context.read<TabIndexProvider>().setIndex(0);
          //cach 2
          Provider.of<TabIndexProvider>(context, listen: false).setIndex(0);
        },
        child: const Text('Go to Home'),
      ),
    );
  }
}
