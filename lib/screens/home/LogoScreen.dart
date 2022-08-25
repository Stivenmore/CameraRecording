import 'package:CameraDirect/screens/home/InputPhoneScreen.dart';
import 'package:flutter/material.dart';

class LogoScreen extends StatefulWidget {
  LogoScreen({Key? key}) : super(key: key);

  @override
  State<LogoScreen> createState() => _LogoScreenState();
}

class _LogoScreenState extends State<LogoScreen> {
  
  @override
  void initState() {
   Future.delayed(Duration(seconds: 3), (){
     Navigator.of(context).push(MaterialPageRoute(builder: (_) => InputPhoneScreen()));
   });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Center(
        child: Image.asset("assets/art.png",
        height: double.infinity*0.5,
        width: 200,),
      ),
    );
  }
}
