import 'package:chat_app/widgets/message_blubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MessagesList extends StatelessWidget {
  const MessagesList({super.key});

  @override
  Widget build(BuildContext context) {
    final authenticatedUserId = FirebaseAuth.instance.currentUser!.uid;

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (ctx, chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (!chatSnapshot.hasData || chatSnapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('No message found'),
          );
        }

        if (chatSnapshot.hasError) {
          return const Center(
            child: Text('Something went wrong...'),
          );
        }

        return ListView.builder(
          reverse: true,
          itemCount: chatSnapshot.data!.docs.length,
          itemBuilder: (ctx, index) {
            final currentMessage = chatSnapshot.data!.docs[index].data();
            final nextMessage = index + 1 < chatSnapshot.data!.docs.length
                ? chatSnapshot.data!.docs[index + 1]
                : null;

            final isSameUser =
                currentMessage['userId'] == nextMessage?['userId'];

            if (isSameUser) {
              return MessageBubble.next(
                message: currentMessage['text'],
                isMe: authenticatedUserId == currentMessage['userId'],
              );
            } else {
              return MessageBubble.first(
                userImage: currentMessage['userImage'],
                username: currentMessage['username'],
                message: currentMessage['text'],
                isMe: authenticatedUserId == currentMessage['userId'],
              );
            }
          },
        );
      },
    );
  }
}
