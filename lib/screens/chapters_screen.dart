import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChaptersScreen extends StatelessWidget {
  const ChaptersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final ref = FirebaseFirestore.instance.collection('users').doc(uid).collection('chapters');

    return Scaffold(
      appBar: AppBar(title: const Text('Daily Chapters')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await ref.add({
            'title': 'Today’s Chapter',
            'text': 'Today, your story moves forward. Choose one small action and complete it before sleeping.',
            'createdAt': FieldValue.serverTimestamp(),
          });
        },
        icon: const Icon(Icons.add),
        label: const Text('Generate demo'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: ref.orderBy('createdAt', descending: true).snapshots(),
        builder: (_, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final docs = snapshot.data!.docs;
          if (docs.isEmpty) return const Center(child: Text('No chapters yet.'));
          return ListView(
            padding: const EdgeInsets.all(16),
            children: docs.map((d) {
              final data = d.data();
              return Card(
                color: const Color(0xFF1C1C24),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(data['text'] ?? ''),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
