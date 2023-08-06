import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:final_year_project/screens/bottom_nav_screen/main_settings.dart';
import 'package:final_year_project/screens/bottom_nav_screen/home_screen/home_screen.dart';
import 'package:final_year_project/screens/drawer_side.dart';
import 'package:flutter/material.dart';
import '../../config_color/constants_color.dart';
import '../My_profile/profile.dart';

class BottomNavigation extends StatefulWidget {
  static String routeName = 'BottomNavigation';

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}


bool _iconBool = false;
IconData iconLight = Icons.sunny;
IconData iconDark = Icons.nights_stay;

ThemeData _lightTheme =
    ThemeData(primarySwatch: Colors.amber, brightness: Brightness.dark);

ThemeData _darkTheme =
    ThemeData(primarySwatch: Colors.red, brightness: Brightness.light);

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    HomeScreen(),
    Setting(),
    MyProfile()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _iconBool ? _darkTheme : _lightTheme,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        drawer: DrawerScreen(),
        appBar: AppBar(
            actions: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      _iconBool = !_iconBool;
                    });
                  },
                  icon: Icon(_iconBool ? iconDark : iconLight))
            ],
            backgroundColor: primaryColor,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 Text(
                  'Sahar Public School Rawalpindi',
                  style: kInputTextStyle,
                ),
              ],
            )),
        body: SafeArea(
          child: AnimatedSwitcher(
            duration: Duration(milliseconds: 500),
            child: _pages[_selectedIndex],
          ),
        ),
        bottomNavigationBar: Theme(
          data: Theme.of(context)
              .copyWith(iconTheme: const IconThemeData(color: Colors.white)),
          child: CurvedNavigationBar(
            index: 0,
            height: 65,
            color: primaryColor,
            backgroundColor: Colors.transparent,
            buttonBackgroundColor: primaryColor,
            items: <Widget>[
              _buildNavItem(Icons.home, 'Home'),
              _buildNavItem(Icons.settings, 'Settings'),
              _buildNavItem(Icons.person, 'Profile'),
            ],
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }
  Widget _buildNavItem(IconData iconData, String name) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(iconData, size: 30),
        SizedBox(height: 1),
        Text(name, style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold,color: Colors.white)),
      ],
    );
  }
}

