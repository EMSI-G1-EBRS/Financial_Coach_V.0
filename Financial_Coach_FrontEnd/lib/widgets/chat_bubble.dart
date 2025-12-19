import 'package:flutter/material.dart';

import '../models/chat_message.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;
  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    final bg = isUser ? Colors.white : const Color(0xFF5E85B0);
    final fg = isUser ? Colors.black87 : Colors.white;
    final align = isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final radius = BorderRadius.only(
      topLeft: const Radius.circular(16),
      topRight: const Radius.circular(16),
      bottomLeft: Radius.circular(isUser ? 16 : 4),
      bottomRight: Radius.circular(isUser ? 4 : 16),
    );

    return Column(
      crossAxisAlignment: align,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: radius,
            boxShadow: [
              BoxShadow(
                color: const Color.fromRGBO(0, 0, 0, 0.6),
                blurRadius: 6,
                offset: const Offset(0, 2),
              )
            ],
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.8,
            ),
            child: Text(
              message.text,
              style: TextStyle(color: fg, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }
}
