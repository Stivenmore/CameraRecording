import 'package:CameraDirect/domain/cubit/camera_send_cubit.dart';
import 'package:CameraDirect/screens/home/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InputPhoneScreen extends StatefulWidget {
  InputPhoneScreen({Key? key}) : super(key: key);

  @override
  State<InputPhoneScreen> createState() => _InputPhoneScreenState();
}

class _InputPhoneScreenState extends State<InputPhoneScreen> {
  TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Numero de celular con codigo de pais:',
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              height: 60,
              width: 200,
              child: Form(
                key: _formKey,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  controller: _controller,
                  decoration: InputDecoration(
                      labelText: 'Escriba aqui...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                  validator: (v) =>
                      v != null && v.isEmpty ? "Campo invalido" : null,
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () {
                validateAndSave();
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(16)),
                height: 35,
                width: 100,
                child: Center(
                    child: Text(
                  'Aceptar',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                )),
              ),
            )
          ],
        ),
      ),
    );
  }

  void validateAndSave() {
    if (_controller.text[0] == '5') {
      if (_formKey.currentState!.validate()) {
        context.read<CameraSendCubit>().getNumberPhone(_controller.text);
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => HomeScreen()));
      }
    }
  }
}
