import 'package:flutter/material.dart';

class DrawerTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final PageController controller;
  final int page;

  DrawerTile(this.icon,this.text, this.controller, this.page);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: (){
          Navigator.of(context).pop();
          controller.jumpToPage(page);
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: controller.page.round() == page ? [Colors.green, Colors.green[300]] : [Colors.transparent,Colors.transparent],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight
            )
          ),
          padding: EdgeInsets.only(left: 16.0),
          height: 60.0,
          child: Row(
            children: <Widget>[
              Icon(
                icon,
                size: 32.0,
                color: Colors.white,
              ),
              SizedBox(width: 32.0),
              Text(
                text,
                style:TextStyle(
                  fontSize: 16.0, 
                  color: Colors.white
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}