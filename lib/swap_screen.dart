import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:tpm_teori_t3/about.dart';
import 'package:tpm_teori_t3/convert.dart';
import 'package:tpm_teori_t3/profiles.dart';

class SwapScreen extends StatefulWidget {
  const SwapScreen({super.key});

  @override
  State<SwapScreen> createState() => _SwapScreenState();
}

final screen = [
  Convert(),
  AboutPage(),
  Profiles(),
];

class _SwapScreenState extends State<SwapScreen> {
  //this
  int index = 0;
  final items = <Widget>[
    Icon(Icons.home, size: 30),
    Icon(Icons.book, size: 30),
    Icon(Icons.person, size: 30),
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body: screen[index],
        //this
        bottomNavigationBar: Theme(
          data: Theme.of(context)
              .copyWith(iconTheme: IconThemeData(color: Colors.white)),
          child: CurvedNavigationBar(
              color: Colors.deepPurpleAccent,
              buttonBackgroundColor: Colors.deepPurple,
              height: 60,
              index: index,
              onTap: (index) => setState(() {
                    this.index = index;
                  }),
              backgroundColor: Colors.transparent,
              items: items),
        ),
      ),
    );
  }
}
