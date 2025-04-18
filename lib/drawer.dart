import 'package:flutter/material.dart';
import 'package:tpm_teori_t3/auth/login_screen.dart';
import 'package:tpm_teori_t3/convert.dart';
import 'package:tpm_teori_t3/num_type.dart';
import 'package:tpm_teori_t3/stopwatch.dart';
import 'package:tpm_teori_t3/auth/auth_service.dart';
import 'package:tpm_teori_t3/website_menu.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  int index = 0;
  final AuthService _authService = AuthService();
  String fullName = "Loading...";
  String email = "";

  final screen = [
    Convert(),
    NumType(),
    StopwatchPage(),
    WebsiteRecommendationScreen()
  ];

  final items = [
    "Konverter Tahun",
    "Check Jenis Bilangan",
    "Stop Watch",
    "Saran Website"
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData(); // waktu loading ambil data user
  }

  // Load user data
  Future<void> _loadUserData() async {
    final user = _authService.currentUser;
    if (user != null) {
      final userData = await _authService.getCurrentUserData();
      if (userData != null) {
        setState(() {
          fullName = userData['fullName'] ?? "No Name";
          email = user.email ?? "No Email";
        });
      }
    }
  }

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
                      onPressed: () async {
                        try {
                          await _authService.signOut();
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            ClipPath(
              clipper: customClipPath(),
              child: DrawerHeader(
                decoration: BoxDecoration(color: Colors.deepPurple),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome,",
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    SizedBox(height: 2),
                    Text(
                      fullName,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      email,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
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
            ListTile(
              leading: Icon(Icons.timer_sharp),
              selected: index == 2,
              title: Text("Stop Wacth"),
              onTap: () => {
                setState(() {
                  index = 2;
                }),
                Navigator.pop(context)
              },
            ),
            ListTile(
              leading: Icon(Icons.web),
              selected: index == 3,
              title: Text("Saran Website"),
              onTap: () => {
                setState(() {
                  index = 3;
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

class customClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path_0 = Path();
    path_0.moveTo(0, 0);
    path_0.quadraticBezierTo(
        0, size.height * 0.6250000, 0, size.height * 0.8750000);
    path_0.cubicTo(
        size.width * 0.5660000,
        size.height * 1.0845000,
        size.width * 0.4660000,
        size.height * 0.6845000,
        size.width,
        size.height * 0.8500000);
    path_0.quadraticBezierTo(
        size.width, size.height * 0.6625000, size.width, 0);

    return path_0;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
