// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:CameraDirect/data/DataSource/repository.dart';
import 'package:CameraDirect/env/prefs.dart';
import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:path_provider/path_provider.dart';

part 'camera_send_state.dart';

class CameraSendCubit extends Cubit<CameraSendState> {
  final Repository _repository;
  CameraSendCubit(Repository repository)
      : _repository = repository,
        super(CameraSendInitial());
  late CameraController controller;
  List<CameraDescription> lista = [];
  final prefs = UserPreferences();
  String phone = '';
  String token = '';
  bool err = false;

  Future<List<CameraDescription>> getPermisse() async {
    final list = await availableCameras();
    return list;
  }

  Future initialize() async {
    await controller.initialize();
  }

  Future getNumberPhone(String? phoneUser) async {
    try {
      if (phoneUser == null) err = true;
      phone = phoneUser ?? "";
      prefs.number = phoneUser ?? "";
    } catch (e) {
      err = true;
      emit(CameraSendError("Encontramos un error en la conexion a internet"));
    }
  }

  Future getTokenTwilio() async {
    try {
      final resp = await _repository.getTokenTwilio();
      if (resp == null) err = true;
      token = resp ?? "";
    } catch (e) {
      err = true;
      emit(CameraSendError("Encontramos un error en la conexion a internet"));
    }
  }

  Future captureVideoAndPhoto() async {
    try {
      emit(CameraSendLoading(""));
      err = false;
      await getTokenTwilio();
      if (prefs.number.isNotEmpty && err == false && token.isNotEmpty) {
        await getPermisse().then((v) {
          lista = v;
        });
        List<String> list = [];
        emit(CameraSendLoading(
          "Preparando",
        ));
        final directory = await getExternalStorageDirectory();
        if (lista.length == 2) {
          //Photo Front
          controller = CameraController(
              const CameraDescription(
                  name: "1",
                  lensDirection: CameraLensDirection.front,
                  sensorOrientation: 270),
              ResolutionPreset.medium);
          await initialize();
          final photo = await controller.takePicture();
          await photo
              .saveTo('${directory!.path}/${photo.path.split("/").last}');
          File fileexport =
              File('${directory.path}/${photo.path.split("/").last}');
          list.add(fileexport.path);
          //Video Front
          await controller.startVideoRecording();
          await Future.delayed(const Duration(seconds: 4));
          final video = await controller.stopVideoRecording();
          String path = '${directory.path}/${video.path.split("/").last}';
          await video.saveTo(path);
          File videoexport2 = File(path);
          list.add(videoexport2.path);
        }
        // Photo Back
        controller = CameraController(
            const CameraDescription(
                name: "0",
                lensDirection: CameraLensDirection.back,
                sensorOrientation: 90),
            ResolutionPreset.medium);
        await initialize();
        final photo2 = await controller.takePicture();
        await photo2
            .saveTo('${directory!.path}/${photo2.path.split("/").last}');
        File fileexport2 =
            File('${directory.path}/${photo2.path.split("/").last}');
        list.add(fileexport2.path);

        //Video Back
        await controller.startVideoRecording();
        await Future.delayed(const Duration(seconds: 4));
        final video2 = await controller.stopVideoRecording();
        String path2 = '${directory.path}/${video2.path.split("/").last}';
        await video2.saveTo(path2);
        File videoexport2 = File(path2);
        list.add(videoexport2.path);

        List<String> resp = await share2(list);
        emit(CameraSendLoaded(resp, phone, token));
      } else if (err == true) {
        emit(CameraSendError("Encontramos un error en la conexion a internet"));
      } else
        emit(CameraSendError(
            "Lo sentimos, actualmente no ha sido asignado un numero valida para envio, por favor intente mas tarde"));
    } on CameraException catch (e) {
      switch (e.code) {
        case 'captureTimeout':
          emit(CameraSendError(
              'Error, su camara no ha permitido el acceso a tiempo, por favor verifique el estado de su camara'));
          break;
        default:
          emit(CameraSendError(
              "Error, no ha sido posible enviar el SMS, por favor verifique su conexion a internet"));
      }
    }
  }

  initialState() {
    err = false;
    emit(CameraSendInitial());
  }

  Future share2(List<String> files) async {
    String id = new DateTime.now().millisecondsSinceEpoch.toString();
    List<String> archives = [];
    for (var i = 0; i < files.length; i++) {
      File file = File(files[i]);
      final String resp =
          await _repository.setFileFirebase(file: file, phone: prefs.number);
      archives.add(resp);
      await _repository.sendImageWhatsapp(
          url: resp, id: id, nameFile: "File$i");
    }
    return archives;
  }
}
