// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:http/http.dart';
// import 'package:we_chat/Models/chat%20User.dart';
// import 'package:we_chat/Models/messgae.dart';

// class APIs {
//   //for authentication

//   static FirebaseAuth auth = FirebaseAuth.instance;
//   //for accessing cloude firestore database
//   static FirebaseFirestore firestore = FirebaseFirestore.instance;

//   //for accessing cloude firesbase storage
//   static FirebaseStorage storage = FirebaseStorage.instance;

//   // For storing self information
//   static late ChatUser me;
//   // For return current user
//   static User get user => auth.currentUser!;
//   // for accessing firebase messaging (Push Notification)
//   static FirebaseMessaging fMessaging = FirebaseMessaging.instance;

//   // for getting firebase messaging token
//   static Future<void> getFirebaseMessagingToken() async {
//     await fMessaging.requestPermission();

//     await fMessaging.getToken().then((t) {
//       if (t != null) {
//         me.pushToken = t;
//       }
//     });
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       print('Got a message whilst in foreground');
//       print('Message data: ${message.data}');
//       if (message.notification != null) {
//         print('Message also contained a notification: ${message.notification}');
//       }
//     });
//   }

//   // for sending push notification
//   static Future<void> sendPushNotification(
//       ChatUser chatUser, String msg) async {
//     try {
//       final body = {
//         "to": chatUser.pushToken,
//         "notification": {
//           "title": me.name, //our name should be send
//           "body": msg,
//           "android_channel_id": "chats"
//         },
//         "data": {
//           "some_data": "User ID: ${me.id}",
//         },
//       };

//       var res = await post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
//           headers: {
//             HttpHeaders.contentTypeHeader: 'application/json',
//             HttpHeaders.authorizationHeader:
//                 'key=AAAAPqg4iwk:APA91bH9-tOeZc5uLMAfxKUE3dHKOWUh9EhepmwtvoCVo-GFX2rwux9FnMFZyxRaT1wJ9J_4DBH6shGfqVy0t7gUYeZO-Ti_1mgo0cphLcb6LUQRcdUCdrQJZAT07bLBHTk1M9UcDYY-'
//           },
//           body: jsonEncode(body));
//       print('Response status: ${res.statusCode}');
//       print('Response body: ${res.body}');
//     } catch (e) {
//       print('\nsendPushNotificationE: $e');
//     }
//   }

//   //for checking if user is exist or not
//   static Future<bool> userExists() async {
//     return (await firestore.collection('users').doc(user.uid).get()).exists;
//   }

//   //for get current user info
//   static Future<void> getSelfInfo() async {
//     await firestore.collection('users').doc(user.uid).get().then((user) async {
//       if (user.exists) {
//         me = ChatUser.fromJson(user.data()!);
//         await getFirebaseMessagingToken();

//         APIs.updateActiveStatus(true);
//         print('My Data: ${user.data()}');
//       } else {
//         await createUser().then((value) => getSelfInfo());
//       }
//     });
//   }

//   //for creating new User
//   static Future<void> createUser() async {
//     final time = DateTime.now().millisecondsSinceEpoch.toString();
//     final chatUser = ChatUser(
//         id: user.uid,
//         name: user.displayName.toString(),
//         email: user.email.toString(),
//         about: "Hey, I'm using it",
//         image: user.photoURL.toString(),
//         createdAt: time,
//         isOnline: false,
//         lastActive: time,
//         pushToken: '');

//     return await firestore
//         .collection('users')
//         .doc(user.uid)
//         .set(chatUser.toJson());
//   }

//   //for getting all users
//   static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
//     return firestore
//         .collection('users')
//         .where('id', isNotEqualTo: user.uid)
//         .snapshots();
//   }

//   //for updateing  user information
//   static Future<void> updateUserInfo() async {
//     await firestore
//         .collection('users')
//         .doc(user.uid)
//         .update({'name': me.name, 'about': me.about});
//   }

//   // update profile picture of user
//   static Future<void> updateProfilePicture(File file) async {
//     //getting image file extension
//     final ext = file.path.split('.').last;
//     print('Extension: $ext');

//     //storage file ref with path
//     final ref = storage.ref().child('profile_pictures/${user.uid}.$ext');

//     //uploading image
//     await ref
//         .putFile(file, SettableMetadata(contentType: 'image/$ext'))
//         .then((p0) {
//       print('Data Transferred: ${p0.bytesTransferred / 1000} kb');
//     });

//     //updating image in firestore database
//     me.image = await ref.getDownloadURL();
//     await firestore
//         .collection('users')
//         .doc(user.uid)
//         .update({'image': me.image});
//   }

//   // for getting specific user info
//   static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(
//       ChatUser chatUser) {
//     return firestore
//         .collection('users')
//         .where('id', isEqualTo: chatUser.id)
//         .snapshots();
//   }

//   // update online or last active status of user
//   static Future<void> updateActiveStatus(bool isOnline) async {
//     firestore.collection('users').doc(user.uid).update({
//       'is_online': isOnline,
//       'last_active': DateTime.now().millisecondsSinceEpoch.toString(),
//       'push_token': me.pushToken,
//     });
//   }

//   ///************** Chat Screen Related APIs **************

//   // chats (collection) --> conversation_id (doc) --> messages (collection) --> message (doc)

//   // useful for getting conversation id
//   static String getConversationID(String id) => user.uid.hashCode <= id.hashCode
//       ? '${user.uid}_$id'
//       : '${id}_${user.uid}';

//   // for getting all messages of a specific conversation from firestore database
//   static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
//       ChatUser user) {
//     return firestore
//         .collection('chats/${getConversationID(user.id)}/messages/')
//         .orderBy('sent', descending: true)
//         .snapshots();
//   }

//   // for sending message
//   static Future<void> sendMessage(
//       ChatUser chatUser, String msg, Type type) async {
//     //message sending time (also used as id)
//     final time = DateTime.now().millisecondsSinceEpoch.toString();

//     //message to send
//     final Message message = Message(
//         toId: chatUser.id,
//         msg: msg,
//         read: '',
//         type: type,
//         fromId: user.uid,
//         sent: time);

//     final ref = firestore
//         .collection('chats/${getConversationID(chatUser.id)}/messages/');
//     await ref.doc(time).set(message.toJson()).then((value) =>
//         sendPushNotification(chatUser, type == Type.text ? msg : 'image'));
//   }

//   //update read status of message
//   static Future<void> updateMessageReadStatus(Message message) async {
//     firestore
//         .collection('chats/${getConversationID(message.fromId)}/messages/')
//         .doc(message.sent)
//         .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
//   }

//   //get last message of user to show under username
//   static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
//       ChatUser user) {
//     return firestore
//         .collection('chats/${getConversationID(user.id)}/messages')
//         .orderBy('sent', descending: true)
//         .limit(1)
//         .snapshots();
//   }

//   //send chat image
//   static Future<void> sendChatImage(ChatUser chatUser, File file) async {
//     //getting image file extension
//     final ext = file.path.split('.').last;

//     //storage file ref with path
//     final ref = storage.ref().child(
//         'images/${getConversationID(chatUser.id)}/${DateTime.now().millisecondsSinceEpoch}.$ext');

//     //uploading image
//     await ref
//         .putFile(file, SettableMetadata(contentType: 'image/$ext'))
//         .then((p0) {
//       print('Data Transferred: ${p0.bytesTransferred / 1000} kb');
//     });

//     //updating image in firestore database
//     final imageUrl = await ref.getDownloadURL();
//     await sendMessage(chatUser, imageUrl, Type.image);
//   }

//   //delete message
//   static Future<void> deleteMessage(Message message) async {
//     await firestore
//         .collection('chats/${getConversationID(message.toId)}/messages/')
//         .doc(message.sent)
//         .delete();

//     if (message.type == Type.image) {
//       await storage.refFromURL(message.msg).delete();
//     }
//   }

//   //update message
//   static Future<void> updateMessage(Message message, String updatedMsg) async {
//     await firestore
//         .collection('chats/${getConversationID(message.toId)}/messages/')
//         .doc(message.sent)
//         .update({'msg': updatedMsg});
//   }
// }

import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart';
import 'package:we_chat/Models/chat%20User.dart';
import 'package:we_chat/Models/messgae.dart';

class APIs {
  // for authentication
  static FirebaseAuth auth = FirebaseAuth.instance;

  // for accessing cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  // for accessing firebase storage
  static FirebaseStorage storage = FirebaseStorage.instance;

  // for storing self information
  static ChatUser me = ChatUser(
      id: user.uid,
      name: user.displayName.toString(),
      email: user.email.toString(),
      about: "Hey, I'm using We Chat!",
      image: user.photoURL.toString(),
      createdAt: '',
      isOnline: false,
      lastActive: '',
      pushToken: '');

  // to return current user
  static User get user => auth.currentUser!;

  // for accessing firebase messaging (Push Notification)
  static FirebaseMessaging fMessaging = FirebaseMessaging.instance;

  // for getting firebase messaging token
  static Future<void> getFirebaseMessagingToken() async {
    await fMessaging.requestPermission();

    await fMessaging.getToken().then((t) {
      if (t != null) {
        me.pushToken = t;
        print('Push Token: $t');
      }
    });

    // for handling foreground messages
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   print('Got a message whilst in the foreground!');
    //   print('Message data: ${message.data}');

    //   if (message.notification != null) {
    //     print('Message also contained a notification: ${message.notification}');
    //   }
    // });
  }

  // for sending push notification
  static Future<void> sendPushNotification(
      ChatUser chatUser, String msg) async {
    try {
      final body = {
        "to": chatUser.pushToken,
        "notification": {
          "title": me.name, //our name should be send
          "body": msg,
          "android_channel_id": "chats"
        },
        // "data": {
        //   "some_data": "User ID: ${me.id}",
        // },
      };

      var res = await post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader:
                'key=AAAAPqg4iwk:APA91bH9-tOeZc5uLMAfxKUE3dHKOWUh9EhepmwtvoCVo-GFX2rwux9FnMFZyxRaT1wJ9J_4DBH6shGfqVy0t7gUYeZO-Ti_1mgo0cphLcb6LUQRcdUCdrQJZAT07bLBHTk1M9UcDYY-'
          },
          body: jsonEncode(body));
      print('Response status: ${res.statusCode}');
      print('Response body: ${res.body}');
    } catch (e) {
      print('\nsendPushNotificationE: $e');
    }
  }

  // for checking if user exists or not?
  static Future<bool> userExists() async {
    return (await firestore.collection('users').doc(user.uid).get()).exists;
  }

  // for adding an chat user for our conversation
  static Future<bool> addChatUser(String email) async {
    final data = await firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    print('data: ${data.docs}');

    if (data.docs.isNotEmpty && data.docs.first.id != user.uid) {
      //user exists

      print('user exists: ${data.docs.first.data()}');

      firestore
          .collection('users')
          .doc(user.uid)
          .collection('my_users')
          .doc(data.docs.first.id)
          .set({});

      return true;
    } else {
      //user doesn't exists

      return false;
    }
  }

  // for getting current user info
  static Future<void> getSelfInfo() async {
    await firestore.collection('users').doc(user.uid).get().then((user) async {
      if (user.exists) {
        me = ChatUser.fromJson(user.data()!);
        await getFirebaseMessagingToken();

        //for setting user status to active
        APIs.updateActiveStatus(true);
        print('My Data: ${user.data()}');
      } else {
        await createUser().then((value) => getSelfInfo());
      }
    });
  }

  // for creating a new user
  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final chatUser = ChatUser(
        id: user.uid,
        name: user.displayName.toString(),
        email: user.email.toString(),
        about: "Hey, I'm using We Chat!",
        image: user.photoURL.toString(),
        createdAt: time,
        isOnline: false,
        lastActive: time,
        pushToken: '');

    return await firestore
        .collection('users')
        .doc(user.uid)
        .set(chatUser.toJson());
  }

  // for getting id's of known users from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getMyUsersId() {
    return firestore
        .collection('users')
        .doc(user.uid)
        .collection('my_users')
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return firestore
        .collection('users')
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }
  // for getting all users from firestore database
  // static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers(
  //     List<String> userIds) {
  //   print('\nUserIds: $userIds');

  //   return firestore
  //       .collection('users')
  //       // .where('id',
  //       //     whereIn: userIds.isEmpty
  //       //         ? ['']
  //       //         : userIds) //because empty list throws an error
  //      .where('id', isNotEqualTo: user.uid)
  //       .snapshots();
  // }

  // for adding an user to my user when first message is send
  static Future<void> sendFirstMessage(
      ChatUser chatUser, String msg, Type type) async {
    await firestore
        .collection('users')
        .doc(chatUser.id)
        .collection('my_users')
        .doc(user.uid)
        .set({}).then((value) => sendMessage(chatUser, msg, type));
  }

  // for updating user information
  static Future<void> updateUserInfo() async {
    await firestore.collection('users').doc(user.uid).update({
      'name': me.name,
      'about': me.about,
    });
  }

  // update profile picture of user
  static Future<void> updateProfilePicture(File file) async {
    //getting image file extension
    final ext = file.path.split('.').last;
    print('Extension: $ext');

    //storage file ref with path
    final Reference = storage.ref().child('profile_pictures/${user.uid}.$ext');

    //uploading image
    await Reference.putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      print('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });

    //updating image in firestore database
    me.image = await Reference.getDownloadURL();
    await firestore
        .collection('users')
        .doc(user.uid)
        .update({'image': me.image});
  }

  // for getting specific user info
  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(
      ChatUser chatUser) {
    return firestore
        .collection('users')
        .where('id', isEqualTo: chatUser.id)
        .snapshots();
  }

  // update online or last active status of user
  static Future<void> updateActiveStatus(bool isOnline) async {
    firestore.collection('users').doc(user.uid).update({
      'is_online': isOnline,
      'last_active': DateTime.now().millisecondsSinceEpoch.toString(),
      'push_token': me.pushToken,
    });
  }

  ///************** Chat Screen Related APIs **************

  // chats (collection) --> conversation_id (doc) --> messages (collection) --> message (doc)

  // useful for getting conversation id
  static String getConversationID(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';

  // for getting all messages of a specific conversation from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      ChatUser user) {
    return firestore
        .collection('chats/${getConversationID(user.id)}/messages/')
        .orderBy('sent', descending: true)
        .snapshots();
  }

  // for sending message
  static Future<void> sendMessage(
      ChatUser chatUser, String msg, Type type) async {
    //message sending time (also used as id)
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    //message to send
    final Message message = Message(
        toId: chatUser.id,
        msg: msg,
        read: '',
        type: type,
        fromId: user.uid,
        sent: time);

    final ref = firestore
        .collection('chats/${getConversationID(chatUser.id)}/messages/');
    await ref.doc(time).set(message.toJson()).then((value) =>
        sendPushNotification(chatUser, type == Type.text ? msg : 'image'));
  }

  //update read status of message
  static Future<void> updateMessageReadStatus(Message message) async {
    firestore
        .collection('chats/${getConversationID(message.fromId)}/messages/')
        .doc(message.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  //get only last message of a specific chat
  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      ChatUser user) {
    return firestore
        .collection('chats/${getConversationID(user.id)}/messages/')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }

  //send chat image
  static Future<void> sendChatImage(ChatUser chatUser, File file) async {
    //getting image file extension
    final ext = file.path.split('.').last;

    //storage file ref with path
    final Reference = storage.ref().child(
        'images/${getConversationID(chatUser.id)}/${DateTime.now().millisecondsSinceEpoch}.$ext');

    //uploading image
    await Reference.putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      print('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });

    //updating image in firestore database
    final imageUrl = await Reference.getDownloadURL();
    await sendMessage(chatUser, imageUrl, Type.image);
  }

  //delete message
  static Future<void> deleteMessage(Message message) async {
    await firestore
        .collection('chats/${getConversationID(message.toId)}/messages/')
        .doc(message.sent)
        .delete();

    if (message.type == Type.image) {
      await storage.refFromURL(message.msg).delete();
    }
  }

  //update message
  static Future<void> updateMessage(Message message, String updatedMsg) async {
    await firestore
        .collection('chats/${getConversationID(message.toId)}/messages/')
        .doc(message.sent)
        .update({'msg': updatedMsg});
  }
}















// class APIs {
//   // for authentication
//   static FirebaseAuth auth = FirebaseAuth.instance;

//   // for accessing cloud firestore database
//   static FirebaseFirestore firestore = FirebaseFirestore.instance;

//   // for accessing firebase storage
//   static FirebaseStorage storage = FirebaseStorage.instance;

//   // for storing self information
//   static ChatUser me = ChatUser(
//       id: user.uid,
//       name: user.displayName.toString(),
//       email: user.email.toString(),
//       about: "Hey, I'm using We Chat!",
//       image: user.photoURL.toString(),
//       createdAt: '',
//       isOnline: false,
//       lastActive: '',
//       pushToken: '');

//   // to return current user
//   static User get user => auth.currentUser!;

//   // for accessing firebase messaging (Push Notification)
//   static FirebaseMessaging fMessaging = FirebaseMessaging.instance;

//   // for getting firebase messaging token
//   static Future<void> getFirebaseMessagingToken() async {
//     await fMessaging.requestPermission();

//     await fMessaging.getToken().then((t) {
//       if (t != null) {
//         me.pushToken = t;
//         print('Push Token: $t');
//       }
//     });

//     // for handling foreground messages
//     // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//     //   print('Got a message whilst in the foreground!');
//     //   print('Message data: ${message.data}');

//     //   if (message.notification != null) {
//     //     print('Message also contained a notification: ${message.notification}');
//     //   }
//     // });
//   }

//   // for sending push notification
//   static Future<void> sendPushNotification(
//       ChatUser chatUser, String msg) async {
//     try {
//       final body = {
//         "to": chatUser.pushToken,
//         "notification": {
//           "title": me.name, //our name should be send
//           "body": msg,
//           "android_channel_id": "chats"
//         },
//         // "data": {
//         //   "some_data": "User ID: ${me.id}",
//         // },
//       };

//       var res = await post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
//           headers: {
//             HttpHeaders.contentTypeHeader: 'application/json',
//             HttpHeaders.authorizationHeader:
//                 'key=AAAAQ0Bf7ZA:APA91bGd5IN5v43yedFDo86WiSuyTERjmlr4tyekbw_YW6JrdLFblZcbHdgjDmogWLJ7VD65KGgVbETS0Px7LnKk8NdAz4Z-AsHRp9WoVfArA5cNpfMKcjh_MQI-z96XQk5oIDUwx8D1'
//           },
//           body: jsonEncode(body));
//       print('Response status: ${res.statusCode}');
//       print('Response body: ${res.body}');
//     } catch (e) {
//       print('\nsendPushNotificationE: $e');
//     }
//   }

//   // for checking if user exists or not?
//   static Future<bool> userExists() async {
//     return (await firestore.collection('users').doc(user.uid).get()).exists;
//   }

//   // for adding an chat user for our conversation
//   static Future<bool> addChatUser(String email) async {
//     final data = await firestore
//         .collection('users')
//         .where('email', isEqualTo: email)
//         .get();

//     print('data: ${data.docs}');

//     if (data.docs.isNotEmpty && data.docs.first.id != user.uid) {
//       //user exists

//       print('user exists: ${data.docs.first.data()}');

//       firestore
//           .collection('users')
//           .doc(user.uid)
//           .collection('my_users')
//           .doc(data.docs.first.id)
//           .set({});

//       return true;
//     } else {
//       //user doesn't exists

//       return false;
//     }
//   }

//   // for getting current user info
//   static Future<void> getSelfInfo() async {
//     await firestore.collection('users').doc(user.uid).get().then((user) async {
//       if (user.exists) {
//         me = ChatUser.fromJson(user.data()!);
//         await getFirebaseMessagingToken();

//         //for setting user status to active
//         APIs.updateActiveStatus(true);
//         print('My Data: ${user.data()}');
//       } else {
//         await createUser().then((value) => getSelfInfo());
//       }
//     });
//   }

//   // for creating a new user
//   static Future<void> createUser() async {
//     final time = DateTime.now().millisecondsSinceEpoch.toString();

//     final chatUser = ChatUser(
//         id: user.uid,
//         name: user.displayName.toString(),
//         email: user.email.toString(),
//         about: "Hey, I'm using We Chat!",
//         image: user.photoURL.toString(),
//         createdAt: time,
//         isOnline: false,
//         lastActive: time,
//         pushToken: '');

//     return await firestore
//         .collection('users')
//         .doc(user.uid)
//         .set(chatUser.toJson());
//   }

//   // for getting id's of known users from firestore database
//   static Stream<QuerySnapshot<Map<String, dynamic>>> getMyUsersId() {
//     return firestore
//         .collection('users')
//         .doc(user.uid)
//         .collection('my_users')
//         .snapshots();
//   }

//   // for getting all users from firestore database
//   static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers(
//       List<String> userIds) {
//     print('\nUserIds: $userIds');

//     return firestore
//         .collection('users')
//         .where('id',
//             whereIn: userIds.isEmpty
//                 ? ['']
//                 : userIds) //because empty list throws an error
//         // .where('id', isNotEqualTo: user.uid)
//         .snapshots();
//   }

//   // for adding an user to my user when first message is send
//   static Future<void> sendFirstMessage(
//       ChatUser chatUser, String msg, Type type) async {
//     await firestore
//         .collection('users')
//         .doc(chatUser.id)
//         .collection('my_users')
//         .doc(user.uid)
//         .set({}).then((value) => sendMessage(chatUser, msg, type));
//   }

//   // for updating user information
//   static Future<void> updateUserInfo() async {
//     await firestore.collection('users').doc(user.uid).update({
//       'name': me.name,
//       'about': me.about,
//     });
//   }

//   // update profile picture of user
//   static Future<void> updateProfilePicture(File file) async {
//     //getting image file extension
//     final ext = file.path.split('.').last;
//     print('Extension: $ext');

//     //storage file ref with path
//     final ref = storage.ref().child('profile_pictures/${user.uid}.$ext');

//     //uploading image
//     await ref
//         .putFile(file, SettableMetadata(contentType: 'image/$ext'))
//         .then((p0) {
//       print('Data Transferred: ${p0.bytesTransferred / 1000} kb');
//     });

//     //updating image in firestore database
//     me.image = await ref.getDownloadURL();
//     await firestore
//         .collection('users')
//         .doc(user.uid)
//         .update({'image': me.image});
//   }

//   // for getting specific user info
//   static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(
//       ChatUser chatUser) {
//     return firestore
//         .collection('users')
//         .where('id', isEqualTo: chatUser.id)
//         .snapshots();
//   }

//   // update online or last active status of user
//   static Future<void> updateActiveStatus(bool isOnline) async {
//     firestore.collection('users').doc(user.uid).update({
//       'is_online': isOnline,
//       'last_active': DateTime.now().millisecondsSinceEpoch.toString(),
//       'push_token': me.pushToken,
//     });
//   }

//   ///************** Chat Screen Related APIs **************

//   // chats (collection) --> conversation_id (doc) --> messages (collection) --> message (doc)

//   // useful for getting conversation id
//   static String getConversationID(String id) => user.uid.hashCode <= id.hashCode
//       ? '${user.uid}_$id'
//       : '${id}_${user.uid}';

//   // for getting all messages of a specific conversation from firestore database
//   static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
//       ChatUser user) {
//     return firestore
//         .collection('chats/${getConversationID(user.id)}/messages/')
//         .orderBy('sent', descending: true)
//         .snapshots();
//   }

//   // for sending message
//   static Future<void> sendMessage(
//       ChatUser chatUser, String msg, Type type) async {
//     //message sending time (also used as id)
//     final time = DateTime.now().millisecondsSinceEpoch.toString();

//     //message to send
//     final Message message = Message(
//         toId: chatUser.id,
//         msg: msg,
//         read: '',
//         type: type,
//         fromId: user.uid,
//         sent: time);

//     final ref = firestore
//         .collection('chats/${getConversationID(chatUser.id)}/messages/');
//     await ref.doc(time).set(message.toJson()).then((value) =>
//         sendPushNotification(chatUser, type == Type.text ? msg : 'image'));
//   }

//   //update read status of message
//   static Future<void> updateMessageReadStatus(Message message) async {
//     firestore
//         .collection('chats/${getConversationID(message.fromId)}/messages/')
//         .doc(message.sent)
//         .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
//   }

//   //get only last message of a specific chat
//   static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
//       ChatUser user) {
//     return firestore
//         .collection('chats/${getConversationID(user.id)}/messages/')
//         .orderBy('sent', descending: true)
//         .limit(1)
//         .snapshots();
//   }

//   //send chat image
//   static Future<void> sendChatImage(ChatUser chatUser, File file) async {
//     //getting image file extension
//     final ext = file.path.split('.').last;

//     //storage file ref with path
//     final ref = storage.ref().child(
//         'images/${getConversationID(chatUser.id)}/${DateTime.now().millisecondsSinceEpoch}.$ext');

//     //uploading image
//     await ref
//         .putFile(file, SettableMetadata(contentType: 'image/$ext'))
//         .then((p0) {
//       print('Data Transferred: ${p0.bytesTransferred / 1000} kb');
//     });

//     //updating image in firestore database
//     final imageUrl = await ref.getDownloadURL();
//     await sendMessage(chatUser, imageUrl, Type.image);
//   }

//   //delete message
//   static Future<void> deleteMessage(Message message) async {
//     await firestore
//         .collection('chats/${getConversationID(message.toId)}/messages/')
//         .doc(message.sent)
//         .delete();

//     if (message.type == Type.image) {
//       await storage.refFromURL(message.msg).delete();
//     }
//   }

//   //update message
//   static Future<void> updateMessage(Message message, String updatedMsg) async {
//     await firestore
//         .collection('chats/${getConversationID(message.toId)}/messages/')
//         .doc(message.sent)
//         .update({'msg': updatedMsg});
//   }
// }
