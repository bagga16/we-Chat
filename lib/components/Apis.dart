import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:we_chat/Models/chat%20User.dart';

class APIs {
  //for authentication

  static FirebaseAuth auth = FirebaseAuth.instance;
  //for accessing cloude firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  // For return current user
  static User get user => auth.currentUser!;
  //for checking if user is exist or not
  static Future<bool> userExists() async {
    return (await firestore.collection('users').doc(user.uid).get()).exists;
  }

  //for creating new User
  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final chatUser = ChatUser(
        id: user.uid,
        name: user.displayName.toString(),
        email: user.email.toString(),
        about: "Hey, I'm using it",
        image: user.photoURL.toString(),
        createdAt: time,
        isOmline: false,
        lastActive: time,
        pushToken: '');

    return await firestore
        .collection('users')
        .doc(user.uid)
        .set(chatUser.toJson());
  }
}
