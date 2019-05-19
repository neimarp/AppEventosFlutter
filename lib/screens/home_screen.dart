import 'package:flutter/material.dart';
import 'package:loja/screens/cadastro_evento_screen.dart';
import 'package:loja/screens/cadastro_usuario_screen.dart';
import 'package:loja/screens/chat_screen.dart';
import 'package:loja/tabs/home_tab.dart';
import 'package:loja/widget/custom_drawer.dart';

class HomeScreen extends StatelessWidget {

  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {

    return PageView(
      controller: _pageController,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        Scaffold(
          drawer: CustomDrawer(_pageController),
          appBar: AppBar(
            title: Text("Eventos"),
            centerTitle: true,
          ),
          body: HomeTab()
        ),
        Scaffold(
          drawer: CustomDrawer(_pageController),
          appBar: AppBar(
            title: Text("Cadastro Evento"),
            centerTitle: true,
          ),
          body: CadastroEventoScreen(),
        ),
        Scaffold(
          drawer: CustomDrawer(_pageController),
          appBar: AppBar(
            title: Text("Chat"),
            centerTitle: true,
          ),
          body: ChatScreen(),
        ),
      ],
    );

  }
}