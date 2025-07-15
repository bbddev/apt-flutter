import 'package:flutter/material.dart';
import 'product_list_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quản lý sản phẩm',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const ProductListPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
