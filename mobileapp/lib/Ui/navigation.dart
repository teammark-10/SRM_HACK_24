import 'package:flutter/material.dart';
import 'package:molten_navigationbar_flutter/molten_navigationbar_flutter.dart';
import 'package:studiesy/Ui/HomeScreen.dart';
import 'package:studiesy/Ui/profile.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});
  static const route = '/dashboard';
  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    List pages = [const HomeScreen(), const ProfileScreen()];
    return Scaffold(
      bottomNavigationBar: MoltenBottomNavigationBar(
        domeCircleColor: const Color(0xFF8070eb),
        selectedIndex: _selectedIndex,
        onTabChange: (clickedIndex) {
          setState(() {
            _selectedIndex = clickedIndex;
          });
        },
        tabs: [
          MoltenTab(
            icon: const Icon(Icons.home),
          ),
          MoltenTab(
            icon: const Icon(Icons.person),
          ),
        ],
      ),
      body: pages[_selectedIndex],
    );
  }
}
