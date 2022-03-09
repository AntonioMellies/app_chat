import 'package:chat/core/models/auth.user.dart';
import 'package:chat/core/models/chat.message.dart';
import 'package:chat/core/services/chat/chat.service.firebase.dart';

abstract class ChatService {
  Stream<List<ChatMessage>> messagesStream();
  Future<ChatMessage> save(String text, AuthUser user);

  factory ChatService() {
    return ChatServiceFirebase();
  }
}
