import 'package:flutter/material.dart';

class ThemeSelectionView extends StatelessWidget {
  final String currentThemeKey;
  final Function(String) onChangeTheme;

  const ThemeSelectionView({
    super.key,
    required this.currentThemeKey,
    required this.onChangeTheme,
  });

  @override
  Widget build(BuildContext context) {
    final themeKeys = ['blue', 'green', 'red', 'orange'];

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Theme Selection',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 24),
          Text('Selected Color', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          Wrap(
            spacing: 20,
            runSpacing: 16,
            children: themeKeys.map((key) {
              final isSelected = key == currentThemeKey;
              return ChoiceChip(
                label: Text(key[0].toUpperCase() + key.substring(1)),
                selected: isSelected,
                selectedColor: Colors.blue.shade300,
                onSelected: (selected) => onChangeTheme(key),
              );
            }).toList(),
          ),
          const SizedBox(height: 32),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Preview',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(
                        Icons.palette,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Current theme: ${currentThemeKey[0].toUpperCase() + currentThemeKey.substring(1)}',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
