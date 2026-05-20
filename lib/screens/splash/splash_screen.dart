
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zindaonlineschool/screens/auth/login_screen.dart';
import 'package:zindaonlineschool/screens/dashboard/dashborad_screen.dart';
import 'package:zindaonlineschool/screens/home/home_screen/home_screen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() =>
      _SplashScreenState();
}

class _SplashScreenState
    extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  Future<void> checkLogin() async {

    await Future.delayed(
      const Duration(seconds: 2),
    );

    final prefs =
        await SharedPreferences.getInstance();

    final token =
        prefs.getString("token");

    if (!mounted) return;

 if (token != null) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (_) => DashboardScreen(token: token),
    ),
  );
} else {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (_) => const LoginScreen(),
    ),
  );
}
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Container(

        width: double.infinity,

        decoration: const BoxDecoration(

          gradient: LinearGradient(
             colors: [Color.fromARGB(255, 4, 0, 22), Color.fromARGB(255, 14, 4, 55)],
        

             begin: Alignment.topCenter,
             end: Alignment.bottomCenter,
          ),
        ),

        child: Center(

          child: Image.asset(
            "assets/images/Online school logo.png",
            height: 140,
          ),
        ),
      ),
    );
  }
}