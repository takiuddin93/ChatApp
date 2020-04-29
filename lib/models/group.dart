import 'package:cloud_firestore/cloud_firestore.dart';

class Group {
  String uid;
  Timestamp createdOn;

  Group({
    this.uid,
    this.createdOn,
  });

  Map toMap(Group contact) {
    var data = Map<String, dynamic>();
    data['contact_id'] = contact.uid;
    data['created_on'] = contact.createdOn;
    return data;
  }

  Group.fromMap(Map<String, dynamic> mapData) {
    this.uid = mapData['contact_id'];
    this.createdOn = mapData["created_on"];
  }
}
