import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chatapp/constants/strings.dart';
import 'package:chatapp/models/contact.dart';
import 'package:chatapp/models/user.dart';

class GroupMethods {
  static final Firestore _firestore = Firestore.instance;

  final CollectionReference _userCollection =
      _firestore.collection(USERS_COLLECTION);

  Future<void> addGroupToDb(User sender, User receiver) async {
    addToGroups(senderId: sender.uid, receiverId: receiver.uid);
  }

  DocumentReference getGroupsDocument({String of, String forContact}) =>
      _userCollection
          .document(of)
          .collection(GROUPS_COLLECTION)
          .document(forContact);

  addToGroups({String senderId, String receiverId}) async {
    Timestamp currentTime = Timestamp.now();

    await addToSenderGroups(senderId, receiverId, currentTime);
    await addToReceiverGroups(senderId, receiverId, currentTime);
  }

  Future<void> addToSenderGroups(
    String senderId,
    String receiverId,
    currentTime,
  ) async {
    DocumentSnapshot senderSnapshot =
        await getGroupsDocument(of: senderId, forContact: receiverId).get();

    if (!senderSnapshot.exists) {
      //does not exists
      Contact receiverContact = Contact(
        uid: receiverId,
        addedOn: currentTime,
      );

      var receiverMap = receiverContact.toMap(receiverContact);

      await getGroupsDocument(of: senderId, forContact: receiverId)
          .setData(receiverMap);
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
      Contact senderContact = Contact(
        uid: senderId,
        addedOn: currentTime,
      );

      var senderMap = senderContact.toMap(senderContact);

      await getGroupsDocument(of: receiverId, forContact: senderId)
          .setData(senderMap);
    }
  }

  Stream<QuerySnapshot> fetchGroups({String userId}) => _userCollection
      .document(userId)
      .collection(GROUPS_COLLECTION)
      .snapshots();
}
