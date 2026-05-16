import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String text;
  final bool isUser;

  const MessageBubble({super.key, required this.text, required this.isUser});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 7),
        padding: const EdgeInsets.all(14),
        constraints: const BoxConstraints(maxWidth: 310),
        decoration: BoxDecoration(
          gradient: isUser
              ? const LinearGradient(colors: [Color(0xFF6C5CE7), Color(0xFF5A4BDA)])
              : const LinearGradient(colors: [Color(0xFF1C1C24), Color(0xFF111118)]),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(text, style: const TextStyle(height: 1.35)),
      ),
    );
  }
}
