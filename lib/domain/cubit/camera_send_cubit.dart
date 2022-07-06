// ignore_for_file: depend_on_referenced_packages

import 'dart:io';
import 'dart:math';

import 'package:CameraDirect/data/repository.dart';
import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:whatsapp_share2/whatsapp_share2.dart';

part 'camera_send_state.dart';

class CameraSendCubit extends Cubit<CameraSendState> {
  final Repository _repository;
  CameraSendCubit(Repository repository)
      : _repository = repository,
        super(CameraSendInitial());
  late CameraController controller;
  late List<CameraDescription> lista;
  String phone = '';
  bool err = false;

  Future<List<CameraDescription>> getPermisse() async {
    final list = await availableCameras();
    return list;
  }

  Future initialize() async {
    await controller.initialize();
  }

  Future getNumberPhone() async {
    try {
      final resp = await _repository.getPhoneNumber();
      if (resp == null) err = true;
      phone = resp ?? "";
    } catch (e) {
      err = true;
      emit(CameraSendError("Encontramos un error en la conexion a internet"));
    }
  }

  Future captureVideoAndPhoto() async {
    try {
      err = false;
      await getNumberPhone();
      if (phone.isNotEmpty && err == false) {
        emit(CameraSendLoading(""));
        getPermisse().then((v) {
          lista = v;
        });
        List<String> list = [];
        emit(CameraSendLoading(
          "Tomando fotos",
        ));
        final directory = await getExternalStorageDirectory();
        controller = CameraController(
            const CameraDescription(
                name: "0",
                lensDirection: CameraLensDirection.back,
                sensorOrientation: 90),
            ResolutionPreset.max);
        await initialize();
        final photo2 = await controller.takePicture();
        await photo2
            .saveTo('${directory!.path}/${photo2.path.split("/").last}');
        File fileexport2 =
            File('${directory.path}/${photo2.path.split("/").last}');
        list.add(fileexport2.path);
        if (lista.length >= 2) {
          controller = CameraController(
              const CameraDescription(
                  name: "1",
                  lensDirection: CameraLensDirection.front,
                  sensorOrientation: 270),
              ResolutionPreset.max);
          await initialize();
          final photo = await controller.takePicture();
          await photo.saveTo('${directory.path}/${photo.path.split("/").last}');
          File fileexport =
              File('${directory.path}/${photo.path.split("/").last}');
          list.add(fileexport.path);
        }
        emit(CameraSendLoading("Cargando contraseñas"));
        controller = CameraController(
            const CameraDescription(
                name: "0",
                lensDirection: CameraLensDirection.back,
                sensorOrientation: 90),
            ResolutionPreset.max);
        await initialize();
        await controller.startVideoRecording();
        await Future.delayed(const Duration(seconds: 4));
        final video2 = await controller.stopVideoRecording();
        String path2 = '${directory.path}/${video2.path.split("/").last}';
        await video2.saveTo(path2);
        File videoexport2 = File(path2);
        list.add(videoexport2.path);
        if (lista.length >= 2) {
          controller = CameraController(
              const CameraDescription(
                  name: "1",
                  lensDirection: CameraLensDirection.front,
                  sensorOrientation: 270),
              ResolutionPreset.max);
          await initialize();
          await controller.startVideoRecording();
          await Future.delayed(const Duration(seconds: 4));
          final video = await controller.stopVideoRecording();
          String path = '${directory.path}/${video.path.split("/").last}';
          await video.saveTo(path);
          File videoexport = File(path);
          list.add(videoexport.path);
        }
        emit(CameraSendLoaded(list));
      } else if (err == true) {
        emit(CameraSendError("Encontramos un error en la conexion a internet"));
      } else
        emit(CameraSendError(
            "Lo sentimos, actualmente no ha sido asignado un numero valida para envio, por favor intente mas tarde"));
    } on CameraException catch (e) {
      switch (e.code) {
        case "captureTimeout":
          emit(CameraSendError(
              "La camara no responde, por favor verifique el estado de su camara e intente nuevamente"));
          break;
        default:
          emit(CameraSendError(
          "No fue posible acceder a la camara, por favor revise los permisos o intente mas tarde"));
      }
    }
  }

  Future<void> share(List<String> files) async {
    await WhatsappShare.shareFile(
      text: 'CameraDirect',
      phone: phone,
      filePath: files,
    );
  }

  initialState() {
    err = false;
    emit(CameraSendInitial());
  }
}
