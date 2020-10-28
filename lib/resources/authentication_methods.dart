import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:chatapp/constants/strings.dart';
import 'package:chatapp/enum/user_state.dart';
import 'package:chatapp/models/users.dart';
import 'package:chatapp/utils/utilities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthenticationMethods {
  static final FirebaseFirestore _firebaseFirestore =
      FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  final CollectionReference _collectionReference =
      _firebaseFirestore.collection(USERS_COLLECTION);

  // Get Current User
  Future<User> getCurrentUser() async {
    User currentUser;
    currentUser = _auth.currentUser;
    return currentUser;
  }

  // Get All User Details
  Future<Users> getUserDetails() async {
    User currentUser = await getCurrentUser();

    DocumentSnapshot documentSnapshot =
        await _collectionReference.doc(currentUser.uid).get();

    return Users.fromMap(documentSnapshot.data());
  }

  // Get User Details by ID
  Future<Users> getUserDetailsById(id) async {
    try {
      DocumentSnapshot documentSnapshot =
          await _collectionReference.doc(id).get();
      return Users.fromMap(documentSnapshot.data());
    } catch (e) {
      print(e);
      return null;
    }
  }

  // Sign In with Google
  Future<User> signInWithGoogle() async {
    await Firebase.initializeApp();

    final GoogleSignInAccount googleSignInAccount =
        await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential authCredential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential userCredential =
        await _auth.signInWithCredential(authCredential);

    final User user = userCredential.user;
    return user;
  }

  // Authenticate User
  // ignore: missing_return
  Future<bool> authenticateUser(User user) async {
    Stream<QuerySnapshot> result = _firebaseFirestore
        .collection(USERS_COLLECTION)
        .where(EMAIL_FIELD, isEqualTo: user.email)
        .snapshots();

    // final List<DocumentSnapshot> docs = result.docs;
    await for (var data in result) {
      //if user is registered then length of list > 0 or else less than 0
      return data.docs.length == 0 ? true : false;
    }
  }

  // Add Users to Database
  Future<void> addDataToDb(User currentUser, String token) async {
    String username = Utils.getUsername(currentUser.email);

    Users user = Users(
      uid: currentUser.uid,
      email: currentUser.email,
      name: currentUser.displayName,
      profilePhoto: currentUser.photoURL,
      firebaseToken: token,
      username: username,
    );

    _firebaseFirestore
        .collection(USERS_COLLECTION)
        .doc(currentUser.uid)
        .set(user.toMap(user));
  }

  // Fetch All Users
  Future<List<Users>> fetchAllUsers(User currentUser) async {
    List<Users> userList = List<Users>();

    QuerySnapshot querySnapshot =
        await _firebaseFirestore.collection(USERS_COLLECTION).get();
    for (var i = 0; i < querySnapshot.docs.length; i++) {
      if (querySnapshot.docs[i].id != currentUser.uid) {
        userList.add(Users.fromMap(querySnapshot.docs[i].data()));
      }
    }
    return userList;
  }

  Future<bool> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  void setUserState({@required String userId, @required UserState userState}) {
    int stateNum = Utils.stateToNum(userState);

    _collectionReference.doc(userId).update({
      "state": stateNum,
    });
  }

  Stream<DocumentSnapshot> getUserStream({@required String uid}) =>
      _collectionReference.doc(uid).snapshots();
}
