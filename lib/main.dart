import 'package:flutter/material.dart';
import 'package:tpm_teori_t3/auth/login_screen.dart';
// import 'package:tpm_teori_t3/swap_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tpm_teori_t3/firebase_options.dart';
import 'package:tpm_teori_t3/swap_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.light,
      theme: ThemeData.light().copyWith(
          inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 1)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 2)),
              labelStyle: TextStyle(color: Colors.black))),
      home: const LoginScreen(),
    );
  }
}
