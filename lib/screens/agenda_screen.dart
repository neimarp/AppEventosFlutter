import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AgendaScreen extends StatefulWidget {
  final String userId;

  const AgendaScreen({@required this.userId});

  @override
  _AgendaScreenState createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {

  Firestore _firestore = Firestore.instance;
  List<DocumentSnapshot> _eventos = [];
  bool _loadingEventos = true;
  DocumentSnapshot _lastDocument;

  _getEventos() async {

    Query q = _firestore.collection('eventosConfirmados')
                          .where('idUsuario', isEqualTo: widget.userId);  

    setState(() {
      _loadingEventos = true;
    });

    QuerySnapshot querySnapshot = await q.getDocuments();

    _eventos = querySnapshot.documents;

    setState(() {
      _loadingEventos = false;
    });

  }

  @override
  void initState() {
    super.initState();
    _getEventos();
  }

  @override
  Widget build(BuildContext context) {

    var assetsImage = new AssetImage('lib/images/jogos2.png');
    var image = new Image(image: assetsImage);

    return Scaffold(
      body: ListView.builder(
        itemCount: _eventos.length,
        itemBuilder: (BuildContext context, int index) {
          print(_eventos[index].data);
          return Padding(
            padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width*0.01,horizontal: MediaQuery.of(context).size.width*0.01),
            child: Container(
              height: MediaQuery.of(context).size.width*0.5,
              child: Card(
                elevation: 5,
                child: Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: MediaQuery.of(context).size.width * 0.03),

                      width: MediaQuery.of(context).size.width * 0.35,      

                      child: ClipRRect(
                        borderRadius: BorderRadius.horizontal(left: Radius.circular(5.0)),
                        child: _eventos[index].data["imagem"] != null
                            ? Image.network(
                                _eventos[index].data["imagem"],
                                fit: BoxFit.cover,
                                alignment: Alignment.topLeft,
                              )
                            : Container(),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.width*0.4,
                      width: 1.0,
                      color: Colors.green,
                      margin: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.04),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width*0.55,
                      child: Center(
                        child: ListTile(
                          title: Container(
                            margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.width*0.025),
                            child: Text(_eventos[index].data["nome"],style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)
                          ),
                          subtitle: Text(_eventos[index].data["descricao"],maxLines: 4,),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );        
        }        
      ),
    );
  }
}