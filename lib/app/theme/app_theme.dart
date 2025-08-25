import 'package:flutter/material.dart';

class AppGradients {
  static const List<Color> darkWarm = [
    Color(0xFF1B1B1B),
    Color(0xFF2C2B2F),
    Color(0xFF3E2F3A),
    Color(0xFF6E5A53),
  ];
}

class GradientScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  const GradientScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.floatingActionButton,
    this.bottomNavigationBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: appBar != null,
      appBar: appBar,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: AppGradients.darkWarm,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: body,
      ),
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      backgroundColor: Colors.transparent,
    );
  }
}

ThemeData appTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF8AB4F8),
      secondary: Color(0xFFF8B4D9),
      surface: Color(0xFF121212),
    ),
    useMaterial3: true,
  );
}
