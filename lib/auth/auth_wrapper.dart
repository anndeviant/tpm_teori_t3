import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lottie/lottie.dart';
import 'package:tpm_teori_t3/auth/auth_service.dart';
import 'package:tpm_teori_t3/auth/landing_screen.dart';
import 'package:tpm_teori_t3/swap_screen.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool hasConnection = false;
  bool checkedConnection = false;
  bool showError = false;

  @override
  void initState() {
    super.initState();
    _checkInternetWithTimeout(); // ngeceknya di initstate biar di proses paling awal
  }

  Future<void> _checkInternetWithTimeout() async {
    // cek selama 10 detik untuk koneksi, lyan suka lupa fungsi method
    for (int i = 0; i < 10; i++) {
      bool result = await InternetConnectionChecker().hasConnection;
      if (result) {
        setState(() {
          hasConnection = true;
          checkedConnection = true;
        });
        return;
      }
      await Future.delayed(const Duration(seconds: 1));
    }

    // Setelah 10 detik masih tidak ada koneksi
    setState(() {
      hasConnection = false;
      checkedConnection = true;
      showError = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!checkedConnection) {
      // Loading sementara selama cek koneksi atau 10 detik
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Lottie.asset(
            'assets/animations/Main Scene.json',
            width: 250,
            height: 250,
          ),
        ),
      );
    }

    if (showError && !hasConnection) {
      // Tidak ada koneksi
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'No Internet Connection',
                style: TextStyle(fontSize: 18, color: Colors.red),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    checkedConnection = false;
                    showError = false;
                  });
                  _checkInternetWithTimeout();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    // Jika koneksi ada, langsung cek auth state yang annas buat tadi
    return StreamBuilder<User?>(
      stream: AuthService().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              //tetep loading lagi nunggu firebasenya
              child: Lottie.asset(
                'assets/animations/Main Scene.json',
                width: 250,
                height: 250,
              ),
            ),
          );
        }

        if (snapshot.hasData) {
          return const SwapScreen();
        } else {
          return const LandingScreen();
        }
      },
    );
  }
}
