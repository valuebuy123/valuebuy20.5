import 'package:flutter/material.dart';

// Utility class for device metrics (assuming this exists or can be replaced)
class DeviceUtils {
  static double getAppBarHeight() {
    return kToolbarHeight; // Default AppBar height in Flutter
  }
}

class TAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TAppBar({
    super.key,
    required this.title,
    this.leadingIcon,
    this.leadingOnPressed,
    this.showBackArrow = true,
    this.actions,
  }
  );

  final Widget title;
  final bool showBackArrow;
  final IconData? leadingIcon;
  final VoidCallback? leadingOnPressed;
  final List<Widget>? actions;  

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0), // Replace with a valid value
      child: AppBar(
        automaticallyImplyLeading: false,
        leading: showBackArrow
            ? IconButton(
                onPressed: () => Navigator.of(context).pop(), // Using Navigator to go back
                icon: const Icon(Icons.arrow_back),
              )
            : leadingIcon != null
                ? IconButton(
                    onPressed: leadingOnPressed,
                    icon: Icon(leadingIcon),
                  )
                : null,
        title: title,
        actions: actions,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(DeviceUtils.getAppBarHeight());
}

// Sample screen to demonstrate usage
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(
        title: const Text(
          "Home Page",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        showBackArrow: true, // Show back arrow
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Favorite clicked!")),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Share clicked!")),
              );
            },
          ),
        ],
      ),
      body: const Center(
        child: Text(
          "Welcome to the Reusable AppBar Demo!",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

// Main app setup
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reusable AppBar Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}