import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

@RoutePage()
class ChatHistoryPage extends StatelessWidget {
  const ChatHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat History'),
        automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const CircleAvatar(child: Icon(Iconsax.user)),
            title: Text('Chat ${index + 1}'),
            subtitle: const Text('Last message...'),
            trailing: const Text('2h ago'),
            onTap: () {},
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
