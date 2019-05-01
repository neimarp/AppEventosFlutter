import 'package:flutter/material.dart';
import 'package:loja/models/user_model.dart';
import 'package:loja/screens/cadastro_evento_screen.dart';
import 'package:loja/tabs/home_tab.dart';
import 'package:scoped_model/scoped_model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(
      model: UserModel(),
      child: MaterialApp(
        title: 'App Eventos Esportivos',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: Colors.green
        ),
        debugShowCheckedModeBanner: false,
        home: CadastroEventoScreen(),
      )
    );
  }
}

