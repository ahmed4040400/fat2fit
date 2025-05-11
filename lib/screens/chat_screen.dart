import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:get/get.dart';
import '../controllers/chat_controller.dart';

class ChatScreen extends GetView<ChatController> {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Ensure controller is initialized
    Get.put(ChatController());

    return Scaffold(
      appBar: _buildAppBar(context),
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
  
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade800, Colors.green.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
      ),
      title: Row(
        children: [
          // Chat icon in circle
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.chat_rounded,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Chat Support',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              Text(
                'Ask our AI assistant',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        // Reset button
        IconButton(
          icon: const Icon(Icons.refresh, color: Colors.white),
          tooltip: 'Reset Conversation',
          onPressed: () {
            _showResetConfirmation(context);
          },
        ),
        IconButton(
          icon: const Icon(Icons.info_outline, color: Colors.white),
          onPressed: () {
            _showResetInfo(context);
          },
        ),
      ],
    );
  }
  
  void _showResetConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Reset Conversation'),
          content: Text('Are you sure you want to reset the conversation?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: Text('Reset'),
              onPressed: () {
                Navigator.of(context).pop();
                // Show loading indicator
                controller.addMessage('...', true);
                
                // Call the fitness advice API with reset command
                controller.getFitnessAdvice('reset').then((response) {
                  // Remove typing indicator
                  controller.messages.removeWhere((msg) => 
                    msg.author.id == '2' && (msg as types.TextMessage).text == '...');
                  
                  // Show response before resetting
                  controller.addMessage(response, true);
                  
                  // Reset chat after showing the response
                  Future.delayed(Duration(milliseconds: 500), () {
                    controller.resetChatHistory();
                  });
                });
              },
            ),
          ],
        );
      },
    );
  }
  
  void _showResetInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Chat Commands'),
          content: Text('Type "reset" to clear the conversation history and start fresh.'),
          actions: [
            TextButton(
              child: Text('Got it'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
