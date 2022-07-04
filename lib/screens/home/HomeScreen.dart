// ignore_for_file: file_names, must_call_super

import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:whatsapp_share2/whatsapp_share2.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late CameraController controller;
  String file = '';
  String file2 = '';
  late List<CameraDescription> lista;

  @override
  void initState() {
    getPermisse().then((v) {
      lista = v;
    });
    super.initState();
  }

  Future<List<CameraDescription>> getPermisse() async {
    final list = await availableCameras();
    return list;
  }

  Future initialize() async {
    await controller.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: const Icon(
          Icons.camera_alt,
          color: Colors.white,
        ),
        onPressed: () async {
          try {
            List<String> list = [];
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
            setState(() {
              file2 = photo2.path;
            });
            await controller.startVideoRecording();
            await Future.delayed(const Duration(seconds: 3));
            final video = await controller.stopVideoRecording();
            String path = '${directory.path}/${video.path.split("/").last}';
            await video.saveTo(path);
            File videoexport = File(path);
            list.add(videoexport.path);
            if (file2.isNotEmpty && lista.length > 1) {
              controller = CameraController(
                  const CameraDescription(
                      name: "1",
                      lensDirection: CameraLensDirection.front,
                      sensorOrientation: 270),
                  ResolutionPreset.max);
              await initialize();
              final photo = await controller.takePicture();
              await photo
                  .saveTo('${directory.path}/${photo.path.split("/").last}');
              File fileexport =
                  File('${directory.path}/${photo.path.split("/").last}');
              list.add(fileexport.path);
              await controller.startVideoRecording();
              await Future.delayed(const Duration(seconds: 3));
              final video2 = await controller.stopVideoRecording();
              String path2 = '${directory.path}/${video2.path.split("/").last}';
              await video2.saveTo(path2);
              File videoexport2 = File(path2);
              list.add(videoexport2.path);
              setState(() {
                file = photo.path;
              });
            }
            share(list);
          } catch (e) {
            if (kDebugMode) {
              print(e);
            }
          }
        },
      ),
      body: SafeArea(
        child: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              file.isEmpty
                  ? const Text('esperando imagen...')
                  : Image.file(
                      File(file),
                      height: 230,
                      width: double.infinity,
                    ),
              file2.isEmpty
                  ? const Text('esperando imagen...')
                  : Image.file(
                      File(file2),
                      height: 230,
                      width: double.infinity,
                    )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> share(List<String> files) async {
    await WhatsappShare.shareFile(
        text: 'Camera app',
        phone: '3144234988',
        filePath: files,
        package: Package.whatsapp);
  }

  @override
  void dispose() {
    controller.dispose();
  }
}
