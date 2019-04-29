import 'package:flutter/material.dart';

class IconTile extends StatelessWidget {
  final IconData icon;
  final String text;

  const IconTile({this.icon,this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.width * 0.09,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.01),
            child: Container(
              height: MediaQuery.of(context).size.width * 0.0423,
              child: Center(
                child: Icon(icon,
                    color: Colors.black, size: 16.0),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.01),
            child: Container(
                height: MediaQuery.of(context).size.width * 0.0423,
                child:
                    Center(child: Text(text, style: TextStyle(fontSize: 10)))),
          )
        ],
      ),
    );
  }
}
