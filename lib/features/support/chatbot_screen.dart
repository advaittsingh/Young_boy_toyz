import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _addBotMessage('Hello! How can I help you today?');
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _addBotMessage(String message) {
    setState(() {
      _messages.add(ChatMessage(
        message: message,
        isUser: false,
      ));
    });
  }

  void _handleSubmitted(String text) {
    if (text.trim().isEmpty) return;

    _messageController.clear();
    setState(() {
      _messages.add(ChatMessage(
        message: text,
        isUser: true,
      ));
      _isTyping = true;
    });

    // Simulate bot response
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() {
        _isTyping = false;
      });
      _processUserMessage(text);
    });
  }

  void _processUserMessage(String message) {
    String response = _getBotResponse(message.toLowerCase());
    _addBotMessage(response);
  }

  String _getBotResponse(String message) {
    if (message.contains('hello') || message.contains('hi')) {
      return 'Hello! How can I assist you today?';
    } else if (message.contains('price') || message.contains('cost')) {
      return 'Our prices vary depending on the vehicle and event. You can check the specific prices in the Browse section.';
    } else if (message.contains('event') || message.contains('show')) {
      return 'We host various car and bike events throughout the year. Check our Events section for upcoming shows!';
    } else if (message.contains('contact') || message.contains('support')) {
      return 'You can reach our support team at Nidhisingh@youngboyztoyz.com or call us at 9619007705.';
    } else if (message.contains('thank')) {
      return 'You\'re welcome! Is there anything else I can help you with?';
    } else {
      return 'I\'m not sure I understand. Could you please rephrase your question or contact our support team for more specific assistance.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Support'),
      ),
      backgroundColor: AppTheme.primaryBlack,
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length) {
                  return const _TypingIndicator();
                }
                return _messages[index];
              },
            ),
          ),
          const Divider(height: 1),
          Container(
            decoration: BoxDecoration(
              color: AppTheme.secondaryBlack,
            ),
            child: _buildMessageComposer(),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageComposer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      height: 70,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              style: const TextStyle(color: AppTheme.textWhite),
              decoration: const InputDecoration(
                hintText: 'Type a message...',
                hintStyle: TextStyle(color: AppTheme.textGrey),
                border: InputBorder.none,
              ),
              onSubmitted: _handleSubmitted,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: AppTheme.accentRed),
            onPressed: () => _handleSubmitted(_messageController.text),
          ),
        ],
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String message;
  final bool isUser;

  const ChatMessage({
    super.key,
    required this.message,
    required this.isUser,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser) _buildAvatar(),
          const SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isUser ? AppTheme.accentRed : AppTheme.secondaryBlack,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                message,
                style: const TextStyle(color: AppTheme.textWhite),
              ),
            ),
          ),
          const SizedBox(width: 8),
          if (isUser) _buildAvatar(),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return CircleAvatar(
      backgroundColor: isUser ? AppTheme.accentRed : AppTheme.secondaryBlack,
      child: Icon(
        isUser ? Icons.person : Icons.support_agent,
        color: AppTheme.textWhite,
      ),
    );
  }
}

class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppTheme.secondaryBlack,
            child: const Icon(
              Icons.support_agent,
              color: AppTheme.textWhite,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.secondaryBlack,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                _buildDot(0),
                _buildDot(1),
                _buildDot(2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: SizedBox(
        width: 8,
        height: 8,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            AppTheme.accentRed.withOpacity(0.5 + (index * 0.2)),
          ),
        ),
      ),
    );
  }
} 