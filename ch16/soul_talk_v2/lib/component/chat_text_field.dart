import 'package:flutter/material.dart';

class ChatTextField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final String? error;
  final bool loading;

  const ChatTextField({
    Key? key,
    required this.controller,
    required this.onSend,
    this.error,
    this.loading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      cursorColor: Colors.blueAccent,
      textAlignVertical: TextAlignVertical.center,
      minLines: 1,
      maxLines: 4,
      decoration: InputDecoration(
        hintText: '메시지를 입력해주세요.',
        errorText: error,

        suffixIcon: IconButton(
          onPressed: loading ? null : onSend,
          icon: Icon(
            Icons.send_outlined,
            color: loading ? Colors.grey : Colors.blueAccent,
          ),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32)),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: BorderSide(color: Colors.blueAccent, width: 2),
        ),
      ),
    );
  }
}
