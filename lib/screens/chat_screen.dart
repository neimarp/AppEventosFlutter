import 'dart:async';
import 'dart:io';

import 'package:scoped_model/scoped_model.dart';
import 'package:loja/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

final googleSignIn = GoogleSignIn();
final auth = FirebaseAuth.instance;

Future<Null> _ensureLoggedIn() async {
  GoogleSignInAccount user = googleSignIn.currentUser;
  if(user == null)
    user = await googleSignIn.signInSilently();
  if(user == null)
    user = await googleSignIn.signIn();
  if(await auth.currentUser() == null){

    final GoogleSignInAccount googleUser = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    //GoogleSignInAuthentication credentials = await googleSignIn.currentUser.authentication;

    AuthCredential credentials = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await auth.signInWithCredential(credentials);

    // await auth.signInWithCredential(
    //     idToken: credentials.idToken,
    //     accessToken: credentials.accessToken
    // );
  }
}

_handleSubmitted(String text) async {
  //await _ensureLoggedIn();
  _sendMessage(text: text);
}

void _sendMessage({String text, String imgUrl}){
  Firestore.instance.collection("messages").add(
    {
      "text" : text,
      "imgUrl" : imgUrl,
      "senderName" : googleSignIn.currentUser.displayName,
      "senderPhotoUrl" : googleSignIn.currentUser.photoUrl
    }
  );
}


class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      top: false,
      child: Scaffold(
        body: Column(
          children: <Widget>[
            ScopedModelDescendant<UserModel>(
              builder: (context, snapshot,model) {
                return Expanded(
                  child: StreamBuilder(
                      stream: Firestore.instance.collection("messages").snapshots(),
                      builder: (context, snapshot) {
                        switch(snapshot.connectionState){
                          case ConnectionState.none:
                          case ConnectionState.waiting:
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          default:
                            return ListView.builder(
                                reverse: true,
                                itemCount: snapshot.data.documents.length,
                                itemBuilder: (context, index) {
                                  //print(snapshot.data.documents.toList()[0].data); 
                                  List r = snapshot.data.documents.reversed.toList();
                                  print(r[index].data);
                                  //r.length >= 1 ? ChatMessage(r[index].data) : Center();
                                  //return Center();
                                  return ChatMessage(r[index].data);
                                }
                            );
                        }
                      }
                  ),
                );
              }
            ),
            Divider(
              height: 1.0,
            ),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
              ),
              child: TextComposer(),
            )
          ],
        ),
      ),
    );
  }
}

class TextComposer extends StatefulWidget {
  @override
  _TextComposerState createState() => _TextComposerState();
}

class _TextComposerState extends State<TextComposer> {
  final _textController = TextEditingController();
  bool _isComposing = false;

  void _reset(){
    _textController.clear();
    setState(() {
      _isComposing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: Theme.of(context).platform == TargetPlatform.iOS
            ? BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey[200])))
            : null,
        child: ScopedModelDescendant<UserModel>(
          builder: (context, snapshot,model) {
            return Row(
              children: <Widget>[
                Container(
                  child:
                    IconButton(icon: Icon(Icons.photo_camera),
                      onPressed: () async {
                        //await _ensureLoggedIn();
                        File imgFile = await ImagePicker.pickImage(source: ImageSource.camera);
                        if(imgFile == null) return;
                        StorageUploadTask task = FirebaseStorage.instance.ref().
                          child(model.userData["name"] +
                            DateTime.now().millisecondsSinceEpoch.toString()).putFile(imgFile);
                            Firestore.instance.collection("messages").add(
                              {
                                "text" : "",
                                "imgUrl" : await (await task.onComplete).ref.getDownloadURL(),
                                "senderName" : model.userData["name"],
                                "senderPhotoUrl" : model.userData["imagem"]
                              }
                            );
                            
                        //_sendMessage(imgUrl: await (await task.onComplete).ref.getDownloadURL());
                      }
                    ),
                  ),
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration:
                        InputDecoration.collapsed(hintText: "Enviar uma Mensagem"),
                    onChanged: (text) {
                      setState(() {
                        _isComposing = text.length > 0;
                      });
                    },
                    onSubmitted: (text){
                      //_handleSubmitted(text);
                        Firestore.instance.collection("messages").add(
                          {
                            "text" : text,
                            "imgUrl" : "",
                            "senderName" : model.userData["name"],
                            "senderPhotoUrl" : model.userData["imagem"]
                          }
                        );
                      _reset();
                    },
                  ),
                ),
                Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Theme.of(context).platform == TargetPlatform.iOS
                        ? CupertinoButton(
                            child: Text("Enviar"),
                            onPressed: _isComposing ? () {
                              //_handleSubmitted(_textController.text);
                              Firestore.instance.collection("messages").add(
                                {
                                  "text" : _textController.text,
                                  "imgUrl" : "",
                                  "senderName" : model.userData["name"],
                                  "senderPhotoUrl" : model.userData["imagem"]
                                }
                              );
                              _reset();
                            } : null,
                          )
                        : IconButton(
                            icon: Icon(Icons.send),
                            onPressed: _isComposing ? () {
                              Firestore.instance.collection("messages").add(
                                {
                                  "text" : _textController.text,
                                  "imgUrl" : "",
                                  "senderName" : model.userData["name"],
                                  "senderPhotoUrl" : model.userData["imagem"]
                                }
                              );
                              //_handleSubmitted(_textController.text);
                              _reset();
                            } : null,
                          ))
              ],
            );
          }
        ),
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {

  final Map<String, dynamic> data;

  ChatMessage(this.data);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage(data["senderPhotoUrl"]),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  data["senderName"],
                  style: Theme.of(context).textTheme.subhead,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: data["imgUrl"] != null ?
                    Image.network(data["imgUrl"], width: 250.0,) :
                      Text(data["text"])
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}