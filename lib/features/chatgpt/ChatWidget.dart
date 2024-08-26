import 'package:flutter/material.dart';
import 'package:good_place/features/chatgpt/ChatGptService.dart';

// AI ile chat örnek kullanım widgetı denemesidir. İleride gerekli olmazsa silebiliriz.
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Chat Bot',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _messages = [];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _controller.text;
    _controller.clear();

    if (text.isNotEmpty) {
      setState(() {
        _messages.add('You: $text');
        _messages.add('Bot: ');
      });

      var response = '';
      ChatgptService().getChatResponse(text, "dddmdmf").listen((word) {
        setState(() {
          response += word;
          _messages[_messages.length - 1] = 'Bot: $response';
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chat with Bot',
        ),
      ),
      body: Column(
        children: [
          _buildMessages(),
          _buildUserInput(),
        ],
      ),
    );
  }

  Widget _buildMessages() {
    return Expanded(
      child: ListView.builder(
        itemCount: _messages.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(_messages[index]),
        ),
      ),
    );
  }

  Widget _buildUserInput() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Type your message here...',
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}
