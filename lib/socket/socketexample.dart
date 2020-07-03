import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() => runApp(ServerSocket());

class ServerSocket extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final title = 'WebSocket';

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SocketExample(
        title: title,
        channel: IOWebSocketChannel.connect('ws://echo.websocket.org'),
      ),
    );
  }
}

class SocketExample extends StatefulWidget {
  final String title;
  final WebSocketChannel channel;

  SocketExample({Key key, @required this.title, @required this.channel})
      : super(key: key);

  @override
  _SocketExampleState createState() => _SocketExampleState();
}

class _SocketExampleState extends State<SocketExample> {
  TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(20.0),
              child: Form(
                child: TextFormField(
                  controller: _textEditingController,
                  decoration: InputDecoration(labelText: 'Send a message'),
                ),
              ),
            ),
            StreamBuilder(
              stream: widget.channel.stream,
              builder: (context, snapshot) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.0),
                  child: Text(
                    snapshot.hasData ? '${snapshot.data}' : '',
                    style: TextStyle(
                      fontSize: 80.0,
                      shadows: [
                        Shadow(
                          blurRadius:5,
                          color: Colors.blue,
                          offset: Offset(5.0, 5.0),
                        ),
//                        Shadow(
//                          blurRadius: 10,
//                          color: Colors.green,
//                          offset: Offset(-10.0, 5.0),
//                        ),

                      ],
                    ),
                  ),
                );
              },
            ),

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendMessage,
        tooltip: 'Send message',
        child: Icon(Icons.send),
      ),
    );
  }

  void _sendMessage() {
    if (_textEditingController.text.isNotEmpty) {
      widget.channel.sink.add(_textEditingController.text);
    }
  }

  @override
  void dispose() {
    widget.channel.sink.close();
    super.dispose();
  }
}
