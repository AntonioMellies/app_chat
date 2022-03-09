import 'dart:async';
import 'dart:math';
import 'package:chat/core/models/auth.user.dart';
import 'package:chat/core/models/chat.message.dart';
import 'package:chat/core/services/chat/chat.service.dart';

class ChatServiceMock implements ChatService {
  static final List<ChatMessage> _msgs = [
    // ChatMessage(id: "1", text: "Oi", createdAt: DateTime.now(), userId: "1", userName: "Neto", userImageUrl: "assets/images/avatar.png"),
    // ChatMessage(id: "2", text: "Oi, tudo bem ?", createdAt: DateTime.now(), userId: "456", userName: "Antonio", userImageUrl: "assets/images/avatar.png"),
    // ChatMessage(id: "3", text: "Tudo Certo e com vc ?", createdAt: DateTime.now(), userId: "1", userName: "Neto", userImageUrl: "assets/images/avatar.png"),
  ];
  static MultiStreamController<List<ChatMessage>>? _controller;
  static final _msgsStream = Stream<List<ChatMessage>>.multi((controller) {
    _controller = controller;
    controller.add(_msgs);
  });

  @override
  Stream<List<ChatMessage>> messagesStream() {
    return _msgsStream;
  }

  @override
  Future<ChatMessage> save(String text, AuthUser user) async {
    final newMessage = ChatMessage(
      id: Random().nextDouble().toString(),
      text: text,
      createdAt: DateTime.now(),
      userId: user.id,
      userName: user.name,
      userImageUrl: user.imageURL,
    );
    _msgs.add(newMessage);
    _controller?.add(_msgs.reversed.toList());
    return newMessage;
  }
}
