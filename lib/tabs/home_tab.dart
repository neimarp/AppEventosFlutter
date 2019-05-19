import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loja/tiles/icon_tiles.dart';
import 'package:rxdart/rxdart.dart';

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
  TextEditingController _pesquisaEventos = TextEditingController();

  var queryResultSet = [];
  var tempSearchStore = [];

  initiateSearch(val) {
    
    if (val.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });      
    }

    var valorCapturado = val.substring(0,1).toUpperCase() + val.substring(1);

    if (queryResultSet.length == 0 && val.length == 1) {
      _searchByName(val).then((QuerySnapshot docs){
        for(int i=0; i < docs.documents.length; i++){
          setState(() {
            queryResultSet.add(docs.documents[i].data);
          });
        }
      });
    }else{
      tempSearchStore = [];
      queryResultSet.forEach((elemento){
        if (elemento['nome'].startsWith(valorCapturado)){
          setState(() {
           tempSearchStore.add(elemento); 
          });
        }
      });
    }

  }

  _searchByName(String searchField){
    return _firestore.collection("esportes")
    .where('search', isEqualTo: searchField.substring(0,1).toUpperCase())
    .getDocuments();
  }

  _getEventos({String nomeEvento}) async {
    Query q;
    print(nomeEvento);
    if (nomeEvento != null) {
      q = _firestore
        .collection("eventos")
        .where('esporte', isEqualTo: nomeEvento);
    } else {
      q = _firestore
        .collection("eventos")
        .orderBy("dataCadastro")
        .limit(_itensPorPagina);
    }

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
        .orderBy("dataCadastro")
        .startAfter([_lastDocument.data["dataCadastro"]]).limit(
            _itensPorPagina);

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
    return Stack(
      children: <Widget>[        
        Container(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(
                    MediaQuery.of(context).size.width * 0.01,
                    MediaQuery.of(context).size.width * 0.01,
                    MediaQuery.of(context).size.width * 0.01,
                    0),
                margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.010),
                decoration: BoxDecoration(
                  border: Border.all(width: 1.2, color: Colors.green),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      TextField(
                        onChanged: (s) => initiateSearch(s),
                        onEditingComplete: (){
                          if (_pesquisaEventos.text.isEmpty == true ){
                            queryResultSet = [];
                            _getEventos();
                          }
                        },
                        controller: _pesquisaEventos,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: "Pesquisar Esporte",
                          hintStyle: TextStyle(color: Colors.green),
                          border: InputBorder.none,
                          icon: Icon(Icons.search, color: Colors.green),
                        ),
                      ),
                    ]
                ),
              ),
              Expanded(
                child: Container(
                child: _loadingEventos == true
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
                                      horizontal: MediaQuery.of(context).size.width * 0.010,
                                      vertical: MediaQuery.of(context).size.width * 0.010,
                                    ),

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
                                              height:MediaQuery.of(context).size.width * 0.38,
                                              width: MediaQuery.of(context).size.width * 0.38,
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
                                              height: MediaQuery.of(context).size.width * 0.38,
                                              width: MediaQuery.of(context).size.width * 0.59,
                                              padding: EdgeInsets.only(left: MediaQuery.of(context).size.width *0.03),
                                              child: Column(
                                                children: <Widget>[
                                                  // Título do Evento
                                                  Container(
                                                    alignment: Alignment.bottomLeft,
                                                    height: MediaQuery.of(context).size.width *0.09,
                                                    child: Text(
                                                      _eventos[index].data["nome"],
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color: Colors.green,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: MediaQuery.of(context).size.width * 0.065
                                                      )
                                                    ),
                                                  ),

                                                  // Descrição
                                                  Container(
                                                    alignment: Alignment.centerLeft,
                                                    height: MediaQuery.of(context).size.width * 0.155,
                                                    child: Text(
                                                      _eventos[index].data["descricao"],
                                                      maxLines: 3,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color: Colors.green,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: MediaQuery.of(context).size.width * 0.032
                                                      )
                                                    ),
                                                  ),

                                                  // Linha de Icones de observação
                                                  Container(
                                                      height: MediaQuery.of(context).size.width * 0.098,
                                                      margin: EdgeInsets.only(top: MediaQuery.of(context).size.width * 0.015),
                                                      child: Row(
                                                        children: <Widget>[
                                                          // ícone de horario de evento
                                                          _eventos[index].data["hora"] == ""
                                                              ? Container()
                                                              : IconTile(
                                                                  icon: Icons.watch_later,
                                                                  text: _eventos[index].data["hora"],
                                                                ),

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
                                                                          text: _eventos[index].data["sexo"])
                                                                      : Container(),

                                                          // ícone de evento pago
                                                          _eventos[index].data["pago"] == ""
                                                              ? Container()
                                                              : _eventos[index].data["pago"] == "s"
                                                                  ? IconTile(
                                                                      icon: Icons.monetization_on,
                                                                      text: "Pago",
                                                                    )
                                                                  : _eventos[index].data["pago"] == "n"
                                                                      ? IconTile(
                                                                          icon: Icons.money_off,
                                                                          text:"Free",
                                                                        )
                                                                      : Container(),

                                                          // ícone de estacionamento
                                                          _eventos[index].data["estacionamento"] == ""
                                                              ? Container()
                                                              : _eventos[index].data["estacionamento"] == "s"
                                                                  ? IconTile(
                                                                      icon: Icons.local_parking,
                                                                      text: "Est",
                                                                    )
                                                                  : Container(),
                                                        ],
                                                      )),
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
                )
              )
            ],
          ),
        ),
        queryResultSet.length > 0 
        ? Container(
          margin: EdgeInsets.only(top: MediaQuery.of(context).size.width * 0.15,left: MediaQuery.of(context).size.width * 0.010,right: MediaQuery.of(context).size.width * 0.010),
          color: Colors.green.withOpacity(0.5),
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            itemCount: queryResultSet.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: (){
                  setState(() {
                   _pesquisaEventos.text = queryResultSet[index]["nome"];
                   _pesquisaEventos.value;
                   queryResultSet = [];
                   _getEventos(nomeEvento: _pesquisaEventos.text);
                  });
                },
                child: Card(
                  elevation: 2.0,
                  child: Container(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width * 0.03,horizontal: MediaQuery.of(context).size.width * 0.025),
                    child: Text(queryResultSet[index]["nome"],style: TextStyle(fontSize: 22,color: Colors.green,fontWeight: FontWeight.bold),),
                  ),
                ),
              );
            }
          ),
        ) : Container(height: 0),
      ],
    );
  }
}
