import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loja/tiles/icon_tiles.dart';

class HomeTab extends StatefulWidget {
  HomeTab();
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  Firestore _firestore = Firestore.instance;
  List<DocumentSnapshot> _eventos = [];
  bool _loadingEventos = true;
  int _itensPorPagina = 20;
  DocumentSnapshot _lastDocument;
  ScrollController _scrollController = ScrollController();
  bool _gettingMaisEventos = false;
  bool _maisEventosExistentes = true;

  _getEventos() async {
    Query q =
        _firestore.collection("eventos").orderBy("nome").limit(_itensPorPagina);

    setState(() {
      _loadingEventos = true;
    });

    QuerySnapshot querySnapshot = await q.getDocuments();
    _eventos = querySnapshot.documents;
    _lastDocument = querySnapshot.documents[querySnapshot.documents.length - 1];

    setState(() {
      _loadingEventos = false;
    });
  }

  _getMaisEventos() async {
    print("Mais eventos foram procurados!");

    if (_maisEventosExistentes == false) {
      //dizer para o usuário q não há mais eventos disponíveis
      print("Não há mais eventos");
      return;
    }
    if (_gettingMaisEventos == true) {
      return;
    }
    _gettingMaisEventos = true;

    Query q = _firestore
        .collection("eventos")
        .orderBy("nome")
        .startAfter([_lastDocument.data]).limit(_itensPorPagina);

    QuerySnapshot querySnapshot = await q.getDocuments();

    if (querySnapshot.documents.length < _itensPorPagina) {
      _maisEventosExistentes = false;
    }

    if (querySnapshot.documents.length > 0) {
      _lastDocument =
          querySnapshot.documents[querySnapshot.documents.length - 1];
    }
    _eventos.addAll(querySnapshot.documents);

    setState(() {});

    _gettingMaisEventos = false;
  }

  @override
  void initState() {
    super.initState();
    _getEventos();

    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.25;

      if (maxScroll - currentScroll <= delta) {
        _getMaisEventos();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Eventos"),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: Container(),
      ),
      body: _loadingEventos == true
          ? Center(child: CircularProgressIndicator())
          : Container(
              child: _eventos.length == 0
                  // Se não tiver eventos, aparece somente um texto no centro
                  ? Center(child: Text("Sem eventos no momento!"))

                  // Se tiver eventos, aparece a listagem "ListView"
                  : ListView.builder(
                      controller: _scrollController,
                      itemCount: _eventos.length,
                      itemBuilder: (BuildContext context, int index) {

                        // Padding para dar espaçamentos nas bordas
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.010,
                              vertical:
                                  MediaQuery.of(context).size.width * 0.010),
                          
                          // Container com as informações
                          child: Container(
                            child: Material(
                              color: Colors.white,
                              elevation: 7.0,
                              borderRadius: BorderRadius.circular(5.0),
                              
                              child: Row(
                                children: <Widget>[

                                  // Box com a imagem
                                  Container(
                                    height:
                                        MediaQuery.of(context).size.width * 0.28,
                                    width:
                                        MediaQuery.of(context).size.width * 0.38,
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

                                  // Box com as informações
                                  Container(
                                    height:
                                        MediaQuery.of(context).size.width * 0.28,
                                    width:
                                        MediaQuery.of(context).size.width * 0.59,
                                 
                                    padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.03),

                                    child: Column(
                                      children: <Widget>[

                                        // Título do Evento
                                        Container(
                                          alignment: Alignment.bottomLeft,
                                          height: MediaQuery.of(context).size.width * 0.075,                                          
                                          child: Text(_eventos[index].data["nome"],
                                            maxLines: 1, 
                                            overflow: TextOverflow.ellipsis,
                                            style:TextStyle(
                                                    color: Colors.green,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: MediaQuery.of(context).size.width * 0.06
                                                  )
                                          ),
                                        ),

                                        // Descrição
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          height: MediaQuery.of(context).size.width * 0.115,                                          
                                          child: Text(_eventos[index].data["descricao"],
                                            maxLines: 2, 
                                            overflow: TextOverflow.ellipsis,
                                            style:TextStyle(
                                                    color: Colors.green,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: MediaQuery.of(context).size.width * 0.032
                                                  )
                                          ),
                                        ),
                                        
                                        // Linha de Icones de observação
                                        Container(
                                          height: MediaQuery.of(context).size.width * 0.09,
                                          
                                          child: Row(
                                            children: <Widget>[

                                              // ícone de horario de evento
                                              _eventos[index].data["hora"] == "" 
                                                ? Container()
                                                : IconTile(
                                                    icon:Icons.watch_later,
                                                    text: _eventos[index].data["hora"],
                                                  )
                                              ,
                                              
                                              // ícone de sexo do evento
                                              _eventos[index].data["sexo"] == "" 
                                                ? Container()
                                                : _eventos[index].data["sexo"] == "M"
                                                  ? IconTile(
                                                      icon: FontAwesomeIcons.female,
                                                      text: _eventos[index].data["sexo"]
                                                    )
                                                  : _eventos[index].data["sexo"] == "H"
                                                    ? IconTile(
                                                        icon: FontAwesomeIcons.male,
                                                        text: _eventos[index].data["sexo"]
                                                      )
                                                    : Container()
                                              ,

                                              // ícone de evento pago
                                              _eventos[index].data["pago"] == "" 
                                                ? Container()
                                                : _eventos[index].data["pago"] == "s"
                                                  ? IconTile(
                                                     icon:Icons.monetization_on,
                                                     text: "Pago",
                                                  )
                                                  : _eventos[index].data["pago"] == "n"
                                                    ? IconTile(
                                                      icon:Icons.money_off,
                                                      text: "Free",
                                                    )
                                                    : Container()
                                              ,

                                              // ícone de estacionamento
                                              _eventos[index].data["estacionamento"] == "" 
                                                ? Container()
                                                : _eventos[index].data["estacionamento"] == "s" 
                                                  ? IconTile(
                                                      icon:Icons.local_parking,
                                                      text: "Est",
                                                    )
                                                  : Container()
                                              ,

                                              

                                            ],
                                          )                                          
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
    );
  }
}
