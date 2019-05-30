import 'package:flutter/material.dart';

class DrawerScreen extends StatefulWidget {
  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  @override
  Widget build(BuildContext context) {

    _decora(cor){
      return BoxDecoration( 
        color: Colors.transparent, 
        border: Border.all(color: Color(cor),width: 0),              
      );
    }

    var dercoracao = BoxDecoration( color: Colors.transparent, border: Border.all(color: Colors.blue,width: 0));

    return Scaffold(
      appBar: AppBar(
        title: Text("Drawer Teste"),
      ),
      drawer: SafeArea(
        child: Drawer(
          child: Column(
            children: <Widget>[
              Container(
                decoration: _decora(0xFF074717),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.28,
                  child: Center(child: Text('Drawer Header')),
                  decoration: BoxDecoration(
                    color: Color(0xFF074717),
                  ),
                ),
              ),
              
              Container(
                decoration: _decora(0xFF074717),
                child: Container(
                  color: Color(0xFF074717),
                  child: ClipPath(
                    clipper: ClipDrawer(),
                    child: Container(
                      color: Color(0xFF06681F),
                      child: Container(
                        margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.15),
                        height: MediaQuery.of(context).size.height * 0.07,
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                  right: MediaQuery.of(context).size.width * 0.08),
                              child: Icon(Icons.ac_unit),
                            ),
                            Text(
                              'Item 1',
                              style: TextStyle(fontSize: 13),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              
              Container(
                decoration: _decora(0xFF06681F),
                child: Container(
                  color: Color(0xFF06681F),
                  child: ClipPath(
                    clipper: ClipDrawer(),
                    child: Container(
                      color: Color(0xFF074717),
                      child: Container(
                        margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.15),
                        height: MediaQuery.of(context).size.height * 0.07,
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                  right: MediaQuery.of(context).size.width * 0.08),
                              child: Icon(Icons.ac_unit),
                            ),
                            Text(
                              'Item 2',
                              style: TextStyle(fontSize: 13),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              Container(
                decoration: _decora(0xFF074717),
                child: Container(
                  color: Color(0xFF074717),
                  child: ClipPath(
                    clipper: ClipDrawer(),
                    child: Container(
                      color: Color(0xFF0D5325),
                      child: Container(
                        margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.15),
                        height: MediaQuery.of(context).size.height * 0.07,
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                  right: MediaQuery.of(context).size.width * 0.08),
                              child: Icon(Icons.ac_unit),
                            ),
                            Text(
                              'Item 3',
                              style: TextStyle(fontSize: 13),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              Container(
                decoration: _decora(0xFF0D5325),
                child: Container(
                  color: Color(0xFF0D5325),
                  child: ClipPath(
                    clipper: ClipDrawer(),
                    child: Container(
                      color: Color(0xFF06681F),
                      child: Container(
                        margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.15),
                        height: MediaQuery.of(context).size.height * 0.07,
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                  right: MediaQuery.of(context).size.width * 0.08),
                              child: Icon(Icons.ac_unit),
                            ),
                            Text(
                              'Item 4',
                              style: TextStyle(fontSize: 13),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              Container(
                decoration: _decora(0xFF06681F),
                child: Container(
                  color: Color(0xFF06681F),
                  child: ClipPath(
                    clipper: ClipDrawer(),
                    child: Container(
                      color: Color(0xFF247B26),
                      child: Container(
                        margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.15),
                        height: MediaQuery.of(context).size.height * 0.07,
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                  right: MediaQuery.of(context).size.width * 0.08),
                              child: Icon(Icons.ac_unit),
                            ),
                            Text(
                              'Item 5',
                              style: TextStyle(fontSize: 13),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              Container(
                decoration: _decora(0xFF247B26),
                child: Container(
                  color: Color(0xFF247B26),
                  child: ClipPath(
                    clipper: ClipDrawer(),
                    child: Container(
                      color: Color(0xFF3B892B),
                      child: Container(
                        margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.15),
                        height: MediaQuery.of(context).size.height * 0.07,
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                  right: MediaQuery.of(context).size.width * 0.08),
                              child: Icon(Icons.ac_unit),
                            ),
                            Text(
                              'Item 6',
                              style: TextStyle(fontSize: 13),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              Container(
                decoration: _decora(0xFF3B892B),
                child: Container(
                  color: Color(0xFF3B892B),
                  child: ClipPath(
                    clipper: ClipDrawer(),
                    child: Container(
                      color: Color(0xFF519730),
                      child: Container(
                        margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.15),
                        height: MediaQuery.of(context).size.height * 0.07,
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                  right: MediaQuery.of(context).size.width * 0.08),
                              child: Icon(Icons.ac_unit),
                            ),
                            Text(
                              'Item 7',
                              style: TextStyle(fontSize: 13),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              Container(
                decoration: _decora(0xFF519730),
                child: Container(
                  color: Color(0xFF519730),
                  child: ClipPath(
                    clipper: ClipDrawer(),
                    child: Container(
                      color: Color(0xFF67A535),
                      child: Container(
                        margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.15),
                        height: MediaQuery.of(context).size.height * 0.07,
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                  right: MediaQuery.of(context).size.width * 0.08),
                              child: Icon(Icons.ac_unit),
                            ),
                            Text(
                              'Item 8',
                              style: TextStyle(fontSize: 13),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              Container(
                decoration: _decora(0xFF67A535),
                child: Container(
                  color: Color(0xFF67A535),
                  child: ClipPath(
                    clipper: ClipDrawer(),
                    child: Container(
                      color: Color(0xFF89BA3D),
                      child: Container(
                        margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.15),
                        height: MediaQuery.of(context).size.height * 0.07,
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                  right: MediaQuery.of(context).size.width * 0.08),
                              child: Icon(Icons.ac_unit),
                            ),
                            Text(
                              'Item 9',
                              style: TextStyle(fontSize: 13),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              
              Expanded(
                child: Container(
                color: Color(0xFF89BA3D)
              ),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        child: ClipPath(
          clipper: ClipBody(),
          child: Container(
            color: Colors.blue,
          ),
        ),
      ),
    );
  }
}

class ClipBody extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    path.lineTo(0.0, size.height - 80);

    var firstControlPoint = new Offset(size.width / 4, size.height);
    var firstEndPoint = new Offset(size.width / 2.25, size.height * 0.89);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondControlPoint =
        Offset(size.width - (size.width / 3.25), size.height * 0.75);
    var secondEndPoint = Offset(size.width, size.height * 0.89);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    //path.lineTo(size.width, size.height - 120);
    path.lineTo(size.width, 0.0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return oldClipper != this;
  }
}

class ClipDrawer extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    path.lineTo(0.0, size.height * 0.5);

    // var firstControlPoint = new Offset(size.width / 4, size.height);
    // var firstEndPoint = new Offset(size.width / 2.25, size.height *0.89);
    // path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
    //   firstEndPoint.dx, firstEndPoint.dy);

    // var secondControlPoint =Offset(size.width - (size.width / 3.25), size.height *0.75);
    // var secondEndPoint = Offset(size.width, size.height *0.89);
    // path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
    //   secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width * 0.15, 0);
    path.lineTo(size.width, 0.0);
    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return oldClipper != this;
  }
}
