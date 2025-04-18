import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:tpm_teori_t3/about.dart';
import 'package:tpm_teori_t3/drawer.dart';
import 'package:tpm_teori_t3/profiles.dart';

class SwapScreen extends StatefulWidget {
  const SwapScreen({super.key});

  @override
  State<SwapScreen> createState() => _SwapScreenState();
}

class _SwapScreenState extends State<SwapScreen> {
  final screen = <Widget>[
    MyDrawer(),
    AboutPage(),
    Profiles(),
  ];

  //this
  int index = 0;
  final items = <Widget>[
    Icon(Icons.home, size: 25),
    Icon(Icons.book, size: 25),
    Icon(Icons.person, size: 25),
  ];

  final PageController _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        extendBody: true,
        body: PageView(
            controller: _pageController,
            onPageChanged: (index) => setState(() {
                  this.index = index;
                }),
            children: screen),
        //this
        bottomNavigationBar: Theme(
          data: Theme.of(context)
              .copyWith(iconTheme: IconThemeData(color: Colors.white)),
          child: CurvedNavigationBar(
              color: Colors.deepPurpleAccent,
              buttonBackgroundColor: Colors.deepPurple,
              height: 50,
              index: index,
              onTap: (index) => setState(() {
                    this.index = index;
                    _pageController.animateToPage(
                      index,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }),
              backgroundColor: Colors.transparent,
              items: items),
        ),
      ),
    );
  }
}
