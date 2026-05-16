import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final goal = TextEditingController();
  final level = TextEditingController();

  Future<void> save() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'goal': goal.text.trim(),
      'level': level.text.trim(),
      'subscription_status': 'free',
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saved')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Text(user?.email ?? 'Anonymous user', style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 18),
            TextField(controller: goal, decoration: const InputDecoration(labelText: 'Your main goal')),
            TextField(controller: level, decoration: const InputDecoration(labelText: 'Your level')),
            const SizedBox(height: 18),
            FilledButton(onPressed: save, child: const Text('Save Profile')),
          ],
        ),
      ),
    );
  }
}
