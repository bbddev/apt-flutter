import 'package:flutter/material.dart';
import 'package:demoprovider/providers/product_provider.dart';
import 'package:demoprovider/providers/tabindex_provider.dart';
import 'package:demoprovider/widgets/form_product.dart';
import 'package:demoprovider/widgets/list_product.dart';
import 'package:demoprovider/widgets/test.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
      //1 provider
      // ChangeNotifierProvider(
      //   create: (context) => TabIndexProvider(),
      //   child: MyApp(),
      // )
      //2. multiprovider
      MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => TabIndexProvider()),
    ChangeNotifierProvider(create: (context) => ProductProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const BottomNavigationBarExample());
  }
}

class BottomNavigationBarExample extends StatefulWidget {
  const BottomNavigationBarExample({super.key});

  @override
  State<BottomNavigationBarExample> createState() =>
      _BottomNavigationBarExampleState();
}

class _BottomNavigationBarExampleState
    extends State<BottomNavigationBarExample> {
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    ProductList(),
    FormProduct(),
    TestProduct()
  ];

  @override
  Widget build(BuildContext context) {
    final tabIndexProvider = Provider.of<TabIndexProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('BottomNavigationBar Sample'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(tabIndexProvider.selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Business',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'School',
          ),
        ],
        currentIndex: tabIndexProvider.selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: (index) => tabIndexProvider.setIndex(index),
      ),
    );
  }
}
