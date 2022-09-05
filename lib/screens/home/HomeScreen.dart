// ignore_for_file: file_names, must_call_super

import 'package:CameraDirect/domain/cubit/camera_send_cubit.dart';
import 'package:CameraDirect/screens/home/InputPhoneScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:twilio_flutter/twilio_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TwilioFlutter twilioFlutter;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: BlocConsumer<CameraSendCubit, CameraSendState>(
              listener: (context, state) {
                if (state.runtimeType == CameraSendLoaded) {
                  sendSms(state.props[0] as List<String>,
                      state.props[1] as String, state.props[2] as String);
                  Future.delayed(const Duration(seconds: 4), () {
                    context.read<CameraSendCubit>().initialState();
                  });
                }
              },
              builder: (context, state) {
                switch (state.runtimeType) {
                  case CameraSendInitial:
                    return GestureDetector(
                        onTap: () => context
                            .read<CameraSendCubit>()
                            .captureVideoAndPhoto(),
                        child: SizedBox(
                          height: 200,
                          width: 200,
                          child:
                              Lottie.asset("assets/action.json", repeat: false),
                        ));
                  case CameraSendLoading:
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 200,
                          width: 200,
                          child: Image.asset('assets/art.png'),
                        ),
                        Text(
                          "${state.props[0]}",
                          style: TextStyle(fontSize: 16, color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 200,
                          width: 200,
                          child: Lottie.asset("assets/loading.json"),
                        ),
                      ],
                    );
                  case CameraSendError:
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${state.props[0]}",
                          style: TextStyle(fontSize: 16, color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) =>
                                          InputPhoneScreen())),
                                  (route) => false);
                            },
                            child: const Text(
                              "Reintentar",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.black),
                            )),
                        SizedBox(
                          height: 200,
                          width: 200,
                          child: Lottie.asset("assets/error.json"),
                        )
                      ],
                    );
                  default:
                    return SizedBox(
                      height: 200,
                      width: 200,
                      child: Lottie.asset("assets/loading.json"),
                    );
                }
              },
            )),
      ),
    );
  }

  sendSms(List<String> archives, String phone, String token) async {
    late final resultcode;
    twilioFlutter = TwilioFlutter(
        accountSid: 'ACaba5945bd02ab0dd681f40724a69702d',
        authToken: token,
        twilioNumber: '+15595943720');
    switch (archives.length) {
      case 1:
        resultcode = twilioFlutter.sendSMS(
            toNumber: '+$phone',
            messageBody: 'Archivos cargados\n Image \n${archives[0]}\n');
        break;
      case 2:
        resultcode = twilioFlutter.sendSMS(
            toNumber: '+$phone',
            messageBody:
                'Archivos cargados\n Primero \n${archives[0]}\n Segundo \n${archives[1]}');
        break;
      case 4:
        resultcode = twilioFlutter.sendSMS(
            toNumber: '+$phone',
            messageBody:
                'Archivos cargados\n Primero \n${archives[0]}\n Segundo \n${archives[1]}\n Tercero \n${archives[2]}\n Cuarto \n${archives[3]}');
        break;
      default:
        twilioFlutter.sendSMS(
            toNumber: '+$phone', messageBody: 'Error de Camaras');
    }
    return resultcode;
  }
}
