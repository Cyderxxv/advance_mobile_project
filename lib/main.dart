import 'package:flutter/material.dart';
import 'package:flutter/services.dart';  
import 'screens/splash.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ByMax AI Chatbot',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF1A2B5D),
        scaffoldBackgroundColor: const Color(0xFF1A2B5D),
        fontFamily: 'Poppins',
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
          bodyLarge: TextStyle(
            color: Colors.black87,
            fontSize: 16,
          ),
          bodyMedium: TextStyle(
            color: Colors.black54,
            fontSize: 14,
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}