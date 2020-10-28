import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chatapp/constants/strings.dart';
import 'package:chatapp/models/call.dart';

class CallMethods {
  final CollectionReference callCollection = FirebaseFirestore.instance.collection(CALL_COLLECTION);

  Stream<DocumentSnapshot> callStream({String uid}) =>
      callCollection.doc(uid).snapshots();

  Future<bool> makeVideoCall({Call call}) async {
    try {
      call.hasDialled = true;
      call.isCall = "video";
      Map<String, dynamic> hasDialledMap = call.toMap(call);

      call.hasDialled = false;
      call.isCall = "video";
      Map<String, dynamic> hasNotDialledMap = call.toMap(call);

      await callCollection.doc(call.callerId).set(hasDialledMap);
      await callCollection.doc(call.receiverId).set(hasNotDialledMap);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> makeVoiceCall({Call call}) async {
    try {
      call.hasDialled = true;
      call.isCall = "audio";
      Map<String, dynamic> hasDialledMap = call.toMap(call);

      call.hasDialled = false;
      call.isCall = "audio";
      Map<String, dynamic> hasNotDialledMap = call.toMap(call);

      await callCollection.doc(call.callerId).set(hasDialledMap);
      await callCollection.doc(call.receiverId).set(hasNotDialledMap);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> endCall({Call call}) async {
    try {
      await callCollection.doc(call.callerId).delete();
      await callCollection.doc(call.receiverId).delete();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
