import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _NewMessageState();
  }
}

class _NewMessageState extends State<NewMessage> {
  final _messageController = TextEditingController();
  final _textFocus = FocusNode();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _submit() async {
    final message = _messageController.text.trim();

    _messageController.clear();

    if (message.isEmpty) {
      return;
    }

    final user = FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    FirebaseFirestore.instance.collection('chat').add({
      'text': message,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'username': userData['username'],
      'userImage': userData['imageUrl'],
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 1, bottom: 14),
      child: Row(
        children: [
          Expanded(
            child: RawKeyboardListener(
              focusNode: _textFocus,
              onKey: (event) {
                if (event.isKeyPressed(LogicalKeyboardKey.enter)) {
                  _submit();
                }
              },
              child: TextField(
                textCapitalization: TextCapitalization.sentences,
                controller: _messageController,
                enableSuggestions: true,
                autocorrect: true,
                decoration: const InputDecoration(labelText: 'Send a message'),
              ),
            ),
          ),
          IconButton(
            onPressed: _submit,
            icon: const Icon(Icons.send),
            color: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }
}
