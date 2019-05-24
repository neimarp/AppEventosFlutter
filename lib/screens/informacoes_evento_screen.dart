import 'package:flutter/material.dart';

class InformacoesEventoScreen extends StatefulWidget {
  InformacoesEventoScreen({Key key, String id}) : super(key: key);

  _InformacoesEventoScreenState createState() => _InformacoesEventoScreenState();
}

class _InformacoesEventoScreenState extends State<InformacoesEventoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Informações do Evento"),
        centerTitle: true,
      ),
      body: Container(
        child: Center(
          child: Text("Em construção"),
        ),
      ),
    );
  }
}