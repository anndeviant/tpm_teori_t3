import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tpm_teori_t3/auth/auth_wrapper.dart';
import 'package:tpm_teori_t3/firebase_options.dart';

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
            borderSide: BorderSide(color: Color(0xff6A1B9A), width: 1)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xff6A1B9A), width: 2)),
        labelStyle: TextStyle(color: Colors.grey),
        prefixIconColor: Colors.grey,
        suffixIconColor: Colors.grey,
        //iconColor: Colors.grey, // ubah jika butuh
      )),
      home: const AuthWrapper(),
    );
  }
}
