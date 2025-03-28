import 'package:flutter/material.dart';
import 'package:tpm_teori_t3/about.dart';
// import 'package:tpm_teori_t3/login_page.dart';
import 'package:tpm_teori_t3/num_type.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: AboutPage(),
    );
  }
}
