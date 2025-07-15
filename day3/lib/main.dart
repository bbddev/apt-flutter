import 'package:day3/pages/HomePage.dart';
// import 'package:day3/provider/subject_provider.dart';
import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

void main() {
  // runApp(
  //   ChangeNotifierProvider(
  //     create: (context) => SubjectProvider(),
  //     child: const MyApp(),
  //   ),
  // );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomePage());
  }
}
