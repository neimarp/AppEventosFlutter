import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

    if (querySnapshot.documents.length < _itensPorPagina ) {
      _maisEventosExistentes = false;
    }

    if (querySnapshot.documents.length > 0 ) {
      _lastDocument = querySnapshot.documents[querySnapshot.documents.length - 1];
    }
    _eventos.addAll(querySnapshot.documents);

    setState(() {
    });

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
      drawer: Drawer(child: Container(),),
      body: _loadingEventos == true
          ? Center(child: CircularProgressIndicator())
          : Container(
              child: _eventos.length == 0
                  ? Center(child: Text("Sem eventos no momento!"))
                  : ListView.builder(
                      controller: _scrollController,
                      itemCount: _eventos.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          leading: CircleAvatar(
                            child: ClipOval(
                                child: _eventos[index].data["imagem"] != null 
                                ? Image.network(_eventos[index].data["imagem"])
                                : Container()
                                ),
                          ),
                          title: Text(_eventos[index].data["nome"]),
                        );
                      },
                    ),
            ),
    );
  }
}
