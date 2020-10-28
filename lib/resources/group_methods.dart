import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chatapp/constants/strings.dart';
import 'package:chatapp/models/group.dart';
import 'package:chatapp/models/users.dart';

class GroupMethods {
  static final FirebaseFirestore _firebaseFirestore =
      FirebaseFirestore.instance;

  final CollectionReference _messageCollection =
      _firebaseFirestore.collection(MESSAGES_COLLECTION);

  final CollectionReference _userCollection =
      _firebaseFirestore.collection(USERS_COLLECTION);
  final CollectionReference _groupCollection =
      _firebaseFirestore.collection(GROUPS_COLLECTION);

  Future<void> addGroupToDb(Users sender, Users receiver) async {
    addToGroups(senderId: sender.uid, receiverId: receiver.uid);
  }

  DocumentReference getGroupsDocument({String of, String forContact}) =>
      _userCollection
          .doc(of)
          .collection(GROUPS_COLLECTION)
          .doc("group_" + Random().nextInt(1000).toString());

  addToGroups({String senderId, String receiverId}) async {
    Timestamp currentTime = Timestamp.now();

    await addToSenderGroups(senderId, receiverId, currentTime);
    await addToReceiverGroups(senderId, receiverId, currentTime);
  }

  Future<void> addToSenderGroups(
      String senderId, String receiverId, currentTime) async {
    DocumentSnapshot senderSnapshot =
        await getGroupsDocument(of: senderId, forContact: receiverId).get();

    if (!senderSnapshot.exists) {
      //does not exists
      Group receiverGroup = Group(
        uid: receiverId,
        createdOn: currentTime,
      );

      var receiverMap = receiverGroup.toMap(receiverGroup);

      await getGroupsDocument(of: senderId, forContact: receiverId)
          .set(receiverMap);
    }
  }

  Future<void> addToReceiverGroups(
    String senderId,
    String receiverId,
    currentTime,
  ) async {
    DocumentSnapshot receiverSnapshot =
        await getGroupsDocument(of: receiverId, forContact: senderId).get();

    if (!receiverSnapshot.exists) {
      //does not exists
      Group senderGroup = Group(
        uid: senderId,
        createdOn: currentTime,
      );

      var senderMap = senderGroup.toMap(senderGroup);

      await getGroupsDocument(of: receiverId, forContact: senderId)
          .set(senderMap);
    }
  }

  Stream<QuerySnapshot> fetchGroups({String userId}) =>
      _userCollection.doc(userId).collection(GROUPS_COLLECTION).snapshots();

  Stream<QuerySnapshot> fetchLastMessageBetween({
    @required String senderId,
    @required String receiverId,
  }) =>
      _messageCollection
          .doc(senderId)
          .collection(receiverId)
          .orderBy("timestamp")
          .snapshots();
}
