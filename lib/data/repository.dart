import 'package:CameraDirect/data/abstract_contract.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Repository implements AbstractContract {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  @override
  Future<String?> getPhoneNumber() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> resp =
          await _firestore.collection('Tel').doc('Phone').get();
      return resp['Phone'];
    } on FirebaseException catch (e) {
     throw Exception(e);
    }
  }
}
