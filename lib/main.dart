import 'package:flutter/material.dart';
import 'package:ppe_detection/screens/add_worker.dart';
import 'package:ppe_detection/screens/notification_screen.dart';
import 'package:ppe_detection/screens/profile.dart';
import 'auth/login.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/detection_screen.dart';
import 'package:firebase_core/firebase_core.dart';

// void main() {
//   runApp(const PPEDetectionApp());
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // bắt buộc nếu gọi async trong main
  await Firebase.initializeApp();  // Khởi tạo Firebase
  runApp(const PPEDetectionApp());
}

class PPEDetectionApp extends StatelessWidget {
  const PPEDetectionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PPE Detection',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: const Color(0xFF1e40af), // blue-800
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1e40af),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
      routes: {
        '/home': (context) => const HomeScreen(),
        '/detection': (context) => const DetectionScreen(),
        '/login': (context) => LoginPage(),
        '/add_worker': (context) => SignUpPage(),
        '/profile': (context) => ProfileScreen(),
        '/notifications': (context) => NotificationScreen(),
      },
    );
  }
}