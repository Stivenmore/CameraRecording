import 'package:CameraDirect/env/prefs.dart';
import 'package:CameraDirect/screens/home/HomeScreen.dart';
import 'package:CameraDirect/screens/home/InputPhoneScreen.dart';
import 'package:flutter/material.dart';

class LogoScreen extends StatefulWidget {
  LogoScreen({Key? key}) : super(key: key);

  @override
  State<LogoScreen> createState() => _LogoScreenState();
}

class _LogoScreenState extends State<LogoScreen> {
  final prefs = UserPreferences();

  @override
  void initState() {
    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) {
        if (prefs.number.isEmpty) {
         return InputPhoneScreen();
        }
        else {
        return  HomeScreen();
        }
      }));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Center(
        child: Image.asset(
          "assets/art.png",
          height: double.infinity * 0.5,
          width: 200,
        ),
      ),
    );
  }
}
