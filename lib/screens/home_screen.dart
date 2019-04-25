import 'package:flutter/material.dart';
import 'package:loja/tabs/home_tab.dart';
import 'package:loja/widget/custom_drawer.dart';

class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return PageView(
      children: <Widget>[
        Scaffold(
          body: HomeTab(),
        ),
      ],
    );

  }
}