import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'add_product_page.dart';
import 'view_product_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    if (_tabController.index == 2 && _tabController.indexIsChanging) {
      // If EXIT tab is selected, show confirmation dialog
      _showExitDialog();
      // Return to previous tab
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_tabController.previousIndex < 2) {
          _tabController.animateTo(_tabController.previousIndex);
        } else {
          _tabController.animateTo(0);
        }
      });
    }
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Exit Application'),
          content: const Text('Are you sure you want to exit the application?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                SystemNavigator.pop(); // Exit app
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Exit'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.add), text: 'ADD'),
            Tab(icon: Icon(Icons.view_list), text: 'VIEW'),
            Tab(icon: Icon(Icons.exit_to_app), text: 'EXIT'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          AddProductPage(),
          ViewProductPage(),
          SizedBox.shrink(), // Empty widget for EXIT tab
        ],
      ),
    );
  }
}
