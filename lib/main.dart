import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:minimal_weather_app/pages/loading_page.dart';

Future<void> main() async {
  await Hive.initFlutter();
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter bindings are initialized
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoadingScreen(
        initialization: _initializeApp,
      ), // Use the loading screen as the initial screen
    );
  }

  /// Perform app initialization tasks here
  Future<void> _initializeApp() async {
     // Initialize Hive database
    await Future.delayed(const Duration(seconds: 0)); // Simulate loading delay
  }
}
