// ignore_for_file: file_names, must_call_super

import 'package:CameraDirect/domain/cubit/camera_send_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
                  context
                      .read<CameraSendCubit>()
                      .share(state.props[0] as List<String>);
                  Future.delayed(const Duration(seconds: 2), () {
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
                    return SizedBox(
                      height: 200,
                      width: 200,
                      child: Lottie.asset("assets/loading.json"),
                    );
                  case CameraSendError:
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "No fue posible acceder a la camara, por favor revise los permisos o intente mas tarde",
                          style: TextStyle(fontSize: 16, color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                        TextButton(
                            onPressed: () {
                              context
                                  .read<CameraSendCubit>()
                                  .captureVideoAndPhoto();
                            },
                            child: const Text(
                              "Reintentar",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.black),
                            )),
                        GestureDetector(
                            child: SizedBox(
                          height: 200,
                          width: 200,
                          child: Lottie.asset("assets/error.json"),
                        ))
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
}
