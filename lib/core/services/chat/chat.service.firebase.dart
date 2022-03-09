import 'dart:async';
import 'package:chat/core/models/auth.user.dart';
import 'package:chat/core/models/chat.message.dart';
import 'package:chat/core/services/chat/chat.service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatServiceFirebase implements ChatService {
  @override
  Stream<List<ChatMessage>> messagesStream() {
    final store = FirebaseFirestore.instance;
    final snapshots = store
        .collection("chat")
        .withConverter(
          fromFirestore: _fromFirestore,
          toFirestore: _toFirestore,
        )
        .orderBy("createdAt", descending: true)
        .snapshots();

    return snapshots.map((snapshot) {
      return snapshot.docs.map((doc) {
        return doc.data();
      }).toList();
    });
  }

  @override
  Future<ChatMessage> save(String text, AuthUser user) async {
    final store = FirebaseFirestore.instance;
    ChatMessage msg = ChatMessage.fromSave(text, user);
    final docRef = await store.collection("chat").withConverter(fromFirestore: _fromFirestore, toFirestore: _toFirestore).add(msg);
    final docSnapshot = await docRef.get();
    return docSnapshot.data()!;
  }

  ChatMessage _fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc, SnapshotOptions? options) {
    return ChatMessage(
      id: doc.id,
      text: doc['text'],
      createdAt: DateTime.parse(doc['createdAt']),
      userId: doc['userId'],
      userName: doc['userName'],
      userImageUrl: doc['userImageUrl'],
    );
  }

  Map<String, dynamic> _toFirestore(ChatMessage msg, SetOptions? options) {
    return {
      "text": msg.text,
      "createdAt": msg.createdAt.toIso8601String(),
      "userId": msg.userId,
      "userName": msg.userName,
      "userImageUrl": msg.userImageUrl,
    };
  }
}
