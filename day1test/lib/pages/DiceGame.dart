import 'dart:math';
import 'package:flutter/material.dart';

class DiceGame extends StatefulWidget {
  const DiceGame({super.key});

  @override
  State<StatefulWidget> createState() => _DiceGameState();
}

class _DiceGameState extends State<DiceGame> {
  int left = 1;
  int middle = 2;
  int right = 3;

  void change() {
    setState(() {
      left = Random().nextInt(6) + 1;
      middle = Random().nextInt(6) + 1;
      right = Random().nextInt(6) + 1;
      if (left == right && left == middle) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Congratulations!"),
              content: const Text("Win win...!"),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Close"),
                ),
              ],
            );
          },
        );
      }
    });
  }

  Widget animatedDice(int value) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
      child: Image.asset(
        'images/d$value.png',
        key: ValueKey<int>(value),
        width: 100,
        height: 100,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Dice Game'),
        backgroundColor: Colors.purple,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: change,
                  child: animatedDice(left),
                ),
                const SizedBox(width: 20),
                InkWell(
                  onTap: change,
                  child: animatedDice(middle),
                ),
                const SizedBox(width: 20),
                InkWell(
                  onTap: change,
                  child: animatedDice(right),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: change, child: const Text('Roll Dice')),
          ],
        ),
      ),
    );
  }
}