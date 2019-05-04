import 'package:eventesports/screens/cadastro_eventos.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Eventos Esportivos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.green
      ),
      debugShowCheckedModeBanner: false,
      home: CadastroEventos(),
    );
  }
}

