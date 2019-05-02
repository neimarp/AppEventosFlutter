import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserModel extends Model {
  
  FirebaseAuth _auth = FirebaseAuth.instance;
  
  FirebaseUser firebaseUser;
  
  Map<String, dynamic> userData = Map();

  bool isLoading = false;

  @override
  void addListener(VoidCallback listener){
    super.addListener(listener);
    _loadCurrentUser();
  } 

  void signUp({@required Map<String, dynamic> userData, @required String pass, @required VoidCallback onSuccess, @required VoidCallback onFail, @required File imagem}){
    isLoading = true;
    notifyListeners();
    _auth.createUserWithEmailAndPassword(

      email: userData["email"],
      password: pass

    ).then((user) async {
      
      firebaseUser = user;
      await _saveUserData(userData, imagem);

      onSuccess();
      isLoading = false;
      notifyListeners();

    }).catchError((e){

      onFail();
      isLoading = false;
      notifyListeners();

    });

  }

  void signIn({@required String email, @required String pass,@required VoidCallback onSuccess,@required VoidCallback onFail}) async{
    isLoading = true;
    notifyListeners();

    _auth.signInWithEmailAndPassword(email: email, password: pass).then(
      (user) async {
        firebaseUser = user;

        await _loadCurrentUser();

        onSuccess();
        isLoading = false;
        notifyListeners();
      }
    ).catchError((e){
      onFail();
      isLoading = false;
      notifyListeners();
    });

  }

  void signOut() async {
    await _auth.signOut();

    userData = Map();
    firebaseUser = null;

    notifyListeners();

  }

  void recoverPass(String email){
    _auth.sendPasswordResetEmail(email: email);
  }

  bool isLoggedIn(){
    return firebaseUser != null;
  }

  Future<String> _pickSaveImage({@required File imagem}) async {
    
    isLoading = true;
    notifyListeners();

    StorageReference ref = FirebaseStorage.instance.ref().child(DateTime.now().millisecondsSinceEpoch.toString());
    StorageUploadTask uploadTask = ref.putFile(imagem);
    uploadTask.events.listen((event) {

    }).onError((error) {
      isLoading = false;
      notifyListeners();      
    });

    return await (await uploadTask.onComplete).ref.getDownloadURL();
  }

  Future<Null> _saveUserData(Map<String, dynamic> userData, File imagem) async {
    String imageUrl = await _pickSaveImage(imagem : imagem);
    print(imageUrl);
    userData["imagem"] = imageUrl;
    this.userData = userData;
    await Firestore.instance.collection("users").document(firebaseUser.uid).setData(userData);
  }

  Future<Null> _loadCurrentUser() async {
    if (firebaseUser == null){
      firebaseUser = await _auth.currentUser();
    }
    if (firebaseUser != null) {
      if(userData["name"] == null){
        DocumentSnapshot docUser = await Firestore.instance.collection("users").document(firebaseUser.uid).get();
        userData = docUser.data;
      }
    }
    notifyListeners();
  }

}