import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/ai_service.dart';
import '../widgets/message_bubble.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final input = TextEditingController();
  bool loading = false;

  String get uid => FirebaseAuth.instance.currentUser!.uid;
  CollectionReference<Map<String, dynamic>> get chatRef =>
      FirebaseFirestore.instance.collection('users').doc(uid).collection('chat');

  Future<void> send() async {
    final text = input.text.trim();
    if (text.isEmpty || loading) return;

    input.clear();
    setState(() => loading = true);

    await chatRef.add({
      'role': 'user',
      'text': text,
      'createdAt': FieldValue.serverTimestamp(),
    });

    final userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final memory = userDoc.data()?['memory_summary'] ?? '';

    final reply = await AIService.askLifeScript(userMessage: text, memory: memory);

    await chatRef.add({
      'role': 'ai',
      'text': reply,
      'createdAt': FieldValue.serverTimestamp(),
    });

    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'memory_summary': 'User recently asked: $text',
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Living Book'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: chatRef.orderBy('createdAt').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                final docs = snapshot.data!.docs;
                if (docs.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(22),
                      child: Text(
                        'Ask your AI book anything about your goals, future, discipline, money, or life decisions.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white60),
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: docs.length,
                  itemBuilder: (_, i) {
                    final data = docs[i].data();
                    return MessageBubble(
                      text: data['text'] ?? '',
                      isUser: data['role'] == 'user',
                    );
                  },
                );
              },
            ),
          ),
          if (loading) const Padding(
            padding: EdgeInsets.all(8),
            child: Text('AI is thinking...', style: TextStyle(color: Colors.white54)),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: input,
                      minLines: 1,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Ask your book...',
                        filled: true,
                        fillColor: const Color(0xFF1C1C24),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: send,
                    child: const Icon(Icons.send),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
