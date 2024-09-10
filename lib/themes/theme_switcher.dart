import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart'; // Import the ThemeProvider

class ThemeSwitcher extends StatelessWidget {
  const ThemeSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        GestureDetector(
          onTap: () => themeProvider.setThemeMode(ThemeMode.light),
          child: Icon(
            Icons.light_mode,
            color: themeProvider.themeMode == ThemeMode.light
                ? Colors.orange.shade300
                : Colors.grey.shade400,
          ),
        ),
        const SizedBox(
          width: 10.0,
        ),
        GestureDetector(
          onTap: () => themeProvider.setThemeMode(ThemeMode.system),
          child: Icon(
            Icons.brightness_auto_rounded,
            color: themeProvider.themeMode == ThemeMode.system
                ? Colors.blue
                : Colors.grey.shade400,
          ),
        ),
        const SizedBox(
          width: 10.0,
        ),
        GestureDetector(
          onTap: () => themeProvider.setThemeMode(ThemeMode.dark),
          child: Icon(
            Icons.dark_mode,
            color: themeProvider.themeMode == ThemeMode.dark
                ? Colors.white
                : Colors.grey.shade400,
          ),
        ),
      ],
    );
  }
}
