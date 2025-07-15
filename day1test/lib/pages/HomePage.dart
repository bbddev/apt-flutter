import 'package:day1test/pages/DiceGame.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Ink.image(
          image: AssetImage('images/male.png'),
          width: 50,
          height: 50,
        ),
        title: Text('Home Page'),
        backgroundColor: Colors.purple,
      ),
      body: GridView.count(
        crossAxisCount: 3,
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DiceGame()),
              );
            },
            child: Ink.image(
              image: AssetImage('images/d3.png'),
              width: 100,
              height: 100,
            ),
          ),
          Image.asset("images/spaceship.jpg"),
          Image.asset("images/spaceship.jpg"),
          Image.asset("images/spaceship.jpg"),
          // Add more cards as needed
        ],
      ),
    );
  }
}
