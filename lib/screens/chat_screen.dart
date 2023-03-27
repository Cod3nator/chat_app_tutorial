
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:chat_x/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;
class ChatScreen extends StatefulWidget {
  static const String id='chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}
class _ChatScreenState extends State<ChatScreen> {
  final messageTextController=TextEditingController();
  final _auth = FirebaseAuth.instance;

  String? messageText;
  String emailUsed = '';

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        emailUsed = user.email ?? '';
      }
    } catch (e) {
      print(e);
    }
  }
  void messageStream()async{
    await for(var snapshot in _firestore.collection('messages').snapshots()){
      for(var message in snapshot.docs){
        print(message.data);
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              _auth.signOut();
              messageStream();
              //Navigator.pop(context);
            },
          ),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: MessageBuilder(),
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                      maxLength: 500, // set maximum message length
                      maxLines: null, // allow any number of lines
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      messageTextController.clear();
                      if (messageText != null && messageText!.isNotEmpty) {
                        _firestore.collection('messages').add({
                          'text': messageText!,
                          'sender': emailUsed,
                        });
                      }
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageBuilder extends StatelessWidget {
  const MessageBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final messages = snapshot.data?.docs;
          List<MessageBubble> messageWidgets = [];
          for (var message in messages ?? []) {
            final messageText = message.data()['text'] as String?;
            final messageSender = message.data()['sender'] as String?;

            if (messageText != null && messageSender != null) {
              final messageBubble =
              MessageBubble(text: messageText, sender: messageSender);
              messageWidgets.add(messageBubble);
            }
          }
          return ListView(
            children: messageWidgets,
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}


class MessageBubble extends StatelessWidget {
  MessageBubble({required this.text,required this.sender});
  final String text;
  final String sender;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Text(sender,
          style: TextStyle(
            fontSize: 12.0,
            color: Colors.black54,
          ),),
          Material(
            color: Colors.lightBlueAccent,
            elevation: 5.0,
            borderRadius:BorderRadius.circular(30.0),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical:10.0,horizontal:20.0),
              child: Text(text,
                style: TextStyle(
                    color:Colors.white ,
                    fontSize:15.0
                ),),
            ),
          ),
        ],
      ),
    );
  }
}