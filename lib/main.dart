import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const LitariApp());
}

class LitariApp extends StatelessWidget {
  const LitariApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LITARI',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              backgroundColor: Color(0xFF1A1F2E),
              body: Center(
                child: CircularProgressIndicator(
                  color: Color(0xFFE07B3A),
                ),
              ),
            );
          }
          if (snapshot.hasData) {
            return const HomeScreen();
          }
          return const SplashScreen();
        },
      ),
    );
  }
}