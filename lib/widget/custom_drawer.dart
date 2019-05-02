import 'package:flutter/material.dart';
import 'package:loja/models/user_model.dart';
import 'package:loja/screens/login_screen.dart';
import 'package:loja/tiles/drawer_tiles.dart';
import 'package:scoped_model/scoped_model.dart';

class CustomDrawer extends StatelessWidget {
  final PageController pageController;
  CustomDrawer(this.pageController);

  @override
  Widget build(BuildContext context) {
    //Drawer Degrade
    Widget _buildDrawerBack() => Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.green, Colors.green[200]],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter)),
        );

    return Drawer(
      child: Stack(
        children: <Widget>[
          _buildDrawerBack(),
          ListView(
            padding: EdgeInsets.only(top: 16.0),
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 8.0, left: 16.0),
                padding: EdgeInsets.fromLTRB(0.0, 16.0, 16.0, 8.0),
                height: MediaQuery.of(context).size.width * 0.6,
                child: Column(

                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: <Widget>[

                    Container(
                      margin: EdgeInsets.only(top: 5),
                      child: Text("EventEsport",
                          style: TextStyle(
                              fontSize: 34.0, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                    
                    Container(
                      child: ScopedModelDescendant<UserModel>(
                        builder: (context, child, model) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[

                              CircleAvatar(
                                radius: 50.0,
                                backgroundColor: const Color(0xFF778899),
                                backgroundImage: NetworkImage(model.userData["imagem"]), // for Network image

                              ),

                              // model.userData["imagem"] != "" 
                              // ? Container(
                              //   width: MediaQuery.of(context).size.width * 0.2,
                              //   height: MediaQuery.of(context).size.width * 0.2,

                              //   decoration: BoxDecoration(
                              //     border: Border.all(
                              //       color: Colors.green,
                              //       width: 2.0,
                              //       style: BorderStyle.solid
                              //     ),
                              //     borderRadius: BorderRadius.all(Radius.circular(8))
                              //   ),
                                
                              //   child: ClipRRect(
                              //     borderRadius: BorderRadius.all(Radius.circular(6)),
                              //     child: Image.network(model.userData["imagem"]),
                              //   )
                                
                              // ): Container(),

                              Text(
                                "Olá, ${ !model.isLoggedIn() ? "" : model.userData["name"] }",
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              GestureDetector(
                                child: Text( 
                                  "Sair",
                                  style: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                onTap: () {
                                  if (model.isLoggedIn()) {
                                    model.signOut();
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              LoginScreen()));
                                  }else{
                                    model.signOut();
                                  }
                                  
                                },
                              )
                            ],
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
              Divider(color: Colors.white70),
              DrawerTile(Icons.home, "Eventos", pageController, 0),
              DrawerTile(Icons.event, "Cadastro Evento", pageController, 1),

            ],
          )
        ],
      ),
    );
  }
}
