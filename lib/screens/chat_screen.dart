import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:get/get.dart';
import '../controllers/chat_controller.dart';

class ChatScreen extends GetView<ChatController> {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Ensure controller is initialized
    Get.put(ChatController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Support'),
        backgroundColor: Colors.green,
      ),
      body: Obx(
        () => Chat(
          messages: controller.messages.toList(),
          user: controller.user,
          onSendPressed: controller.handleSendPressed,
          theme: const DefaultChatTheme(
            primaryColor: Colors.green,
            backgroundColor: Color.fromRGBO(255, 255, 255, 1),
            inputBackgroundColor: Color(0xff90EE90),
            inputTextColor: Colors.black,

            sendButtonIcon: Icon(Icons.send, color: Colors.black),
          ),
        ),
      ),
    );
  }
}
