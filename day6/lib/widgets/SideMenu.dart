import 'package:flutter/material.dart';

class SideMenu extends StatelessWidget {
  final Function(int)? onItemSelected;

  const SideMenu({super.key, this.onItemSelected});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            child: const Text(
              'Menu',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            onTap: () {
              if (onItemSelected != null) {
                onItemSelected!(0);
              }
              Navigator.pop(context); // Close drawer
            },
          ),
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text('List'),
            onTap: () {
              if (onItemSelected != null) {
                onItemSelected!(2);
              }
              Navigator.pop(context); // Close drawer
            },
          ),
          ListTile(
            leading: const Icon(Icons.color_lens),
            title: const Text('Themes'),
            onTap: () {
              if (onItemSelected != null) {
                onItemSelected!(1);
              }
              Navigator.pop(context); // Close drawer
            },
          ),
        ],
      ),
    );
  }
}
