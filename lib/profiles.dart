import 'package:flutter/material.dart';
import 'package:tpm_teori_t3/auth/auth_service.dart';
import 'package:tpm_teori_t3/auth/login_screen.dart';

class Profiles extends StatelessWidget {
  const Profiles({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Kelompok'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () async {
                        try {
                          await AuthService().signOut();
                          if (context.mounted) {
                            Navigator.pop(context);
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()),
                                (route) => false);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  backgroundColor: Colors.green,
                                  content: Text(
                                    'Logged out successfully',
                                    style: TextStyle(color: Colors.white),
                                  )),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                      Text('Logout failed: ${e.toString()}')),
                            );
                          }
                        }
                      },
                      child: const Text('Logout'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Data Kelompok, Murabito!\nTPM IF - D',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Divider(thickness: 2, color: Colors.black),
            const SizedBox(height: 8),
            Center(
              child: Image.asset(
                'assets/profiles/bareng1.jpg',
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8),
            const Divider(thickness: 2, color: Colors.black),
            const SizedBox(height: 8),
            ProfileCard(
              imagePath: 'assets/profiles/annas.jpg',
              name: 'Annas Sovianto',
              nim: '123220045',
              otherInfo: 'Other info 1',
            ),
            ProfileCard(
              imagePath: 'assets/profiles/galang.jpg',
              name: 'Galang Rakha Ahnanta',
              nim: '123220047',
              otherInfo: 'Other info 2',
            ),
            ProfileCard(
              imagePath: 'assets/profiles/ade.jpg',
              name: 'Arya Ade Wiguna',
              nim: '123220058',
              otherInfo: 'Other info 3',
            ),
            ProfileCard(
              imagePath: 'assets/profiles/lyan.jpg',
              name: 'Lyan Nandyan D S S',
              nim: '123220070',
              otherInfo: 'Other info 4',
            ),
          ],
        ),
      )),
    );
  }
}

class ProfileCard extends StatelessWidget {
  final String imagePath;
  final String name;
  final String nim;
  final String otherInfo;

  const ProfileCard({
    required this.imagePath,
    required this.name,
    required this.nim,
    required this.otherInfo,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(40.0),
              child: Image.asset(imagePath, width: 80, height: 80),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                Text(nim),
                Text(otherInfo),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
