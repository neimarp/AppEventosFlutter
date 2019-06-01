import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loja/models/user_model.dart';
import 'package:loja/screens/informacoes_evento_screen.dart';
import 'package:loja/tiles/icon_tiles.dart';
import 'package:scoped_model/scoped_model.dart';

class AgendaScreen extends StatefulWidget {
  final String userId;

  const AgendaScreen({@required this.userId});

  @override
  _AgendaScreenState createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {

  Firestore _firestore = Firestore.instance;
  //List<DocumentSnapshot> _eventos = [];
  List<DocumentSnapshot> _informacaoEventos = [];
  bool _loadingEventos = true;
  
  _getEventos() async {

    Query q = _firestore.collection('eventosConfirmados')
                          .where('idUsuario', isEqualTo: widget.userId);  

    setState(() {
      _loadingEventos = true;
    });
    
    QuerySnapshot querySnapshot = await q.getDocuments();
    
    for (var item in querySnapshot.documents) {
      _informacaoEventos.add(await _firestore.collection('eventos')
                        .document(item.data['idEvento']).get());
    }

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

    return Container(
      child: ScopedModelDescendant<UserModel>(
        builder: (context, snapshot,model) {
          return _loadingEventos == true
              ? Center(child: CircularProgressIndicator())
              : Container(
                  child: _informacaoEventos.length == 0
                      // Se não tiver eventos, aparece somente um texto no centro
                      ? Center(child: Text("Sem eventos no momento!"))

                      // Se tiver eventos, aparece a listagem "ListView"
                      : ListView.builder(
                          //controller: _scrollController,
                          itemCount: _informacaoEventos.length,
                          itemBuilder: (BuildContext context, int index) {
                            // Padding para dar espaçamentos nas bordas
                            return InkWell(
                              onTap: (){
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => InformacoesEventoScreen(
                                      idUsuario: model.userData["id"],
                                      id: _informacaoEventos[index].documentID,
                                      data: _informacaoEventos[index].data["data"],
                                      descricao: _informacaoEventos[index].data["descricao"],
                                      esporte: _informacaoEventos[index].data["esporte"],
                                      estacionamento: _informacaoEventos[index].data["estacionamento"],
                                      hora: _informacaoEventos[index].data["hora"],
                                      imagem: _informacaoEventos[index].data["imagem"],
                                      maxparticipantes: _informacaoEventos[index].data["maxparticipantes"],
                                      minparticipantes: _informacaoEventos[index].data["minparticipantes"],
                                      nome: _informacaoEventos[index].data["nome"],
                                      pago: _informacaoEventos[index].data["pago"],
                                      sexo: _informacaoEventos[index].data["sexo"],
                                    )
                                  )
                                );
                              },
                              child: Padding(
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
                                            child: _informacaoEventos[index].data["imagem"] != null
                                                ? Image.network(
                                                    _informacaoEventos[index].data["imagem"],
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
                                                  _informacaoEventos[index].data["nome"],
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
                                                  _informacaoEventos[index].data["descricao"],
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

                                                      // ícone de data de evento
                                                      _informacaoEventos[index].data["data"] == ""
                                                          ? Container()
                                                          : IconTile(
                                                              icon: Icons.date_range,
                                                              text: _informacaoEventos[index].data["data"],
                                                            ),

                                                      // ícone de horario de evento
                                                      _informacaoEventos[index].data["hora"] == ""
                                                          ? Container()
                                                          : IconTile(
                                                              icon: Icons.watch_later,
                                                              text: _informacaoEventos[index].data["hora"],
                                                            ),

                                                      // ícone de sexo do evento
                                                      _informacaoEventos[index].data["sexo"] == ""
                                                          ? Container()
                                                          : _informacaoEventos[index].data["sexo"] == "M"
                                                              ? IconTile(
                                                                  icon: FontAwesomeIcons.female,
                                                                  text: _informacaoEventos[index].data["sexo"]
                                                                )
                                                              : _informacaoEventos[index].data["sexo"] == "H"
                                                                  ? IconTile(
                                                                      icon: FontAwesomeIcons.male,
                                                                      text: _informacaoEventos[index].data["sexo"])
                                                                  : Container(),

                                                      // ícone de evento pago
                                                      _informacaoEventos[index].data["pago"] == ""
                                                          ? Container()
                                                          : _informacaoEventos[index].data["pago"] == "s"
                                                              ? IconTile(
                                                                  icon: Icons.monetization_on,
                                                                  text: "Pago",
                                                                )
                                                              : _informacaoEventos[index].data["pago"] == "n"
                                                                  ? IconTile(
                                                                      icon: Icons.money_off,
                                                                      text:"Free",
                                                                    )
                                                                  : Container(),

                                                      // ícone de estacionamento
                                                      _informacaoEventos[index].data["estacionamento"] == ""
                                                          ? Container()
                                                          : _informacaoEventos[index].data["estacionamento"] == "s"
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
                              ),
                            );
                          },
                        ),
                );
        }
      ),
    );
    
  }
}