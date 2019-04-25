import 'package:cloud_firestore/cloud_firestore.dart';

class EventosData{

  String id;
  String nome;
  String descricao;
  String imagem;

  EventosData.fromDocument(DocumentSnapshot snapshot){

    id = snapshot.documentID;
    nome = snapshot.data["nome"];
    descricao = snapshot.data["descricao"];
    imagem = snapshot.data["imagem"];

  }

}