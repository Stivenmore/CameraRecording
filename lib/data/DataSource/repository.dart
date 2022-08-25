
import 'dart:io';


import 'package:CameraDirect/data/abstract_contract.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Repository implements AbstractContract {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;


  Future sendImageWhatsapp(
      {required String url,
      required String id,
      required String nameFile}) async {
    try {
      await _firestore
          .collection("Files")
          .doc(id)
          .set({"Id": id, nameFile: url}, SetOptions(merge: true));
          
    } catch (e) {
      print(e.toString());
    }
  }

  Future setFileFirebase({required File file, required String phone}) async {
    try {
      final postimageRef = _storage.ref(phone);
      final UploadTask uploadTask =
          postimageRef.child(file.path.split("/").last).putFile(file);
      var urlImage = await (await uploadTask).ref.getDownloadURL();
      return urlImage;
    } catch (e) {
      print(e.toString());
    }
  }
  
  @override
  Future<String?> getTokenTwilio() async{
    try {
      DocumentSnapshot<Map<String, dynamic>> resp =
          await _firestore.collection('Auth').doc('Token').get();
      return resp['Token'];
    } on FirebaseException catch (e) {
      throw Exception(e);
    }
  }
}
