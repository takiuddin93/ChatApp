import 'package:cloud_firestore/cloud_firestore.dart';

class Group {
  String uid;
  Timestamp addedOn;

  Group({
    this.uid,
    this.addedOn,
  });

  Map toMap(Group contact) {
    var data = Map<String, dynamic>();
    data['contact_id'] = contact.uid;
    data['added_on'] = contact.addedOn;
    return data;
  }

  Group.fromMap(Map<String, dynamic> mapData) {
    this.uid = mapData['contact_id'];
    this.addedOn = mapData["added_on"];
  }
}
