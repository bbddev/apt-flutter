import 'package:day6/pages/DashboardView.dart';
import 'package:day6/pages/ListItemsView.dart';
import 'package:day6/pages/ThemeSelectionView.dart';
import 'package:day6/widgets/Sidemenu.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final VoidCallback? onToggleDarkMode;
  final String currentThemeKey;
  final Function(String) onChangeTheme;
  const HomePage({
    super.key,
    required this.onToggleDarkMode,
    required this.currentThemeKey,
    required this.onChangeTheme,
  });

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  void _handleNavigation(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;

    // List of pages to display based on selectedIndex
    final List<Widget> pages = [
      const DashboardView(),
      ThemeSelectionView(
        currentThemeKey: widget.currentThemeKey,
        onChangeTheme: widget.onChangeTheme,
      ),
      const ListItemsView(),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('Home Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: widget.onToggleDarkMode,
          ),
        ],
      ),
      drawer: isMobile ? SideMenu(onItemSelected: _handleNavigation) : null,
      body: Row(
        children: [
          if (!isMobile) SideMenu(onItemSelected: _handleNavigation),
          Expanded(
            child: pages[selectedIndex < pages.length ? selectedIndex : 0],
          ),
        ],
      ),
      floatingActionButton: selectedIndex == 2
          ? FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Add new item'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
            )
          : null,
      bottomNavigationBar: isMobile
          ? BottomNavigationBar(
              currentIndex: selectedIndex,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.dashboard),
                  label: 'Dashboard',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.color_lens),
                  label: 'Themes',
                ),
                BottomNavigationBarItem(icon: Icon(Icons.list), label: 'List'),
              ],
              onTap: (index) {
                setState(() {
                  selectedIndex = index;
                });
              },
            )
          : null,
    );
  }
}
