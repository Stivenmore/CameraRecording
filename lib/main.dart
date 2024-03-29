import 'package:CameraDirect/data/DataSource/repository.dart';
import 'package:CameraDirect/domain/cubit/camera_send_cubit.dart';
import 'package:CameraDirect/env/prefs.dart';
import 'package:CameraDirect/screens/home/LogoScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserPreferences().initPrefs();
  await Firebase.initializeApp();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CameraSendCubit(Repository()),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'CameraDirect',
          home: Scaffold(
            body: LogoScreen(),
          )),
    );
  }
}
