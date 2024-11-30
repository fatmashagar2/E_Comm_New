import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled15/layout/layout_screen.dart';
import '../on_boarding/on_boarding_screens.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateBasedOnState();
  }

  Future<void> _navigateBasedOnState() async {
    await Future.delayed(Duration(seconds: 3));  // الانتظار 3 ثواني

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool onboardingCompleted = prefs.getBool('onboarding_completed') ?? false;

    if (!onboardingCompleted) {
      // إذا لم تكتمل عملية Onboarding
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OnboardingScreen()),
      );
    } else {
      // الانتقال إلى الصفحة الرئيسية بعد إتمام Onboarding
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LayoutScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.gif', // استبدل مع المسار الفعلي للصورة
              height: 250,
              width: 250,
            ),
          ],
        ),
      ),
    );
  }
}
