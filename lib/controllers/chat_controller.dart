import 'package:get/get.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:uuid/uuid.dart';

class ChatController extends GetxController {
  final uuid = const Uuid();
  // Make messages observable using RxList
  final messages = <types.Message>[].obs;
  final user = const types.User(id: '1', firstName: 'Ahmed');

  @override
  void onInit() {
    super.onInit();
    // Initialize with messages using update method
    addInitialMessages();
  }

  void addInitialMessages() {
    final initialMessages = [
      createMessage('Welcome to Fat2Fit! How can I help you today?', true),
      createMessage('Here to help you achieve your fitness goals!', true),
    ];
    messages.assignAll(initialMessages.reversed);
  }

  types.TextMessage createMessage(String text, bool isReceived) {
    return types.TextMessage(
      author:
          isReceived ? const types.User(id: '2', firstName: 'Assistant') : user,
      id: uuid.v4(),
      text: text,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );
  }

  void addMessage(String text, bool isReceived) {
    final message = createMessage(text, isReceived);
    messages.insert(0, message);
  }

  void handleSendPressed(types.PartialText message) {
    addMessage(message.text, false);
    // Simulate bot response after 1 second
    Future.delayed(const Duration(seconds: 1), () {
      addMessage('Thank you for your message! I\'ll help you with that.', true);
    });
  }
}
