// ignore: file_names
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medical/Screens/Login-Signup/Profile_screen.dart';
// import 'package:medical/Screens/Login-Signup/shedule_screen.dart';
import 'package:medical/Screens/Views/Dashboard_screen.dart';
import 'package:medical/Screens/Views/find_ai.dart';
import 'package:medical/Screens/Widgets/TabbarPages/message_tab_all.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<IconData> icons = [
    FontAwesomeIcons.house,
    FontAwesomeIcons.blog,
    FontAwesomeIcons.searchengin,
    FontAwesomeIcons.user,
  ];

  int page = 0;

  List<Widget> pages = [
    const Dashboard(),
    const MessageTabAll(),
    const find_ai(),
    const ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        if (page == 0) {
          return true;
        } else {
          setState(() {
            page = 0;
          });
          return false;
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: pages[page], // Display the selected page
        bottomNavigationBar: AnimatedBottomNavigationBar(
          icons: icons,
          iconSize: 20,
          activeIndex: page,
          height: 80,
          splashSpeedInMilliseconds: 300,
          gapLocation: GapLocation.none,
          activeColor: const Color.fromARGB(202, 168, 0, 0),
          inactiveColor: const Color.fromARGB(255, 223, 219, 219),
          onTap: (int tappedIndex) {
            setState(() {
              page = tappedIndex; // Update the selected page
            });
          },
        ),
      ),
    );
  }
}
