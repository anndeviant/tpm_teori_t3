import 'package:flutter/material.dart';
import 'package:tpm_teori_t3/convert.dart';
import 'package:tpm_teori_t3/num_type.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  int index = 0;

  final screen = [
    Convert(),
    NumType(),
  ];

  final items = ["Konverter Tahun", "Check Jenis Bilangan"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(
          items[index],
          style: TextStyle(color: Colors.white),
        ),
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
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Logged out successfully')),
                        );
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.deepPurple),
              child: Text("Drawer Header",
                  style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: Icon(Icons.calendar_today_rounded),
              selected: index == 0,
              title: Text("Convert Tahun"),
              onTap: () => {
                setState(() {
                  index = 0;
                }),
                Navigator.pop(context)
              },
            ),
            ListTile(
              leading: Icon(Icons.numbers),
              selected: index == 1,
              title: Text("Cek Number"),
              onTap: () => {
                setState(() {
                  index = 1;
                }),
                Navigator.pop(context)
              },
            ),
          ],
        ),
      ),
      body: screen[index],
    );
  }
}
