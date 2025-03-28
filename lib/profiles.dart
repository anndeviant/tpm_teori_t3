import 'package:flutter/material.dart';

class Profiles extends StatelessWidget {
  const Profiles({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Data Kelompok, NakaTachi!\nTPM IF - D',
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
    ));
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
