import 'package:chat/core/services/notification/chat.notification.service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notificationService = Provider.of<ChatNotificationService>(context);
    final items = notificationService.items;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Minhas notificações"),
      ),
      body: ListView.builder(
        itemCount: notificationService.itemsCount,
        itemBuilder: (context, index) => ListTile(
          title: Text(items[index].title),
          subtitle: Text(items[index].body),
          onTap: () => notificationService.remove(index),
        ),
      ),
    );
  }
}
