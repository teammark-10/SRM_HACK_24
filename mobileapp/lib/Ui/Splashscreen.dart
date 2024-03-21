import 'package:flutter/material.dart';
import 'package:studiesy/Ui/HomeScreen.dart';
import 'package:studiesy/Ui/navigation.dart';
import 'package:studiesy/Ui/try.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required this.loggedInSplash});
  // ignore: prefer_typing_uninitialized_variables
  final loggedInSplash;
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    navigateToHome();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF8070eb),
              Color(0xFF8070eb),
            ],
          ),
        ),
        child: Center(
          child: Image.asset(
            'assets/icon.png',
            width: 300,
          ),
        ),
      ),
    );
  }

  Future navigateToHome() async {
    await Future.delayed(const Duration(seconds: 2), () {
      if (widget.loggedInSplash == 0) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const First(),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const NavigationPage(),
          ),
        );
      }
    });
  }
}
