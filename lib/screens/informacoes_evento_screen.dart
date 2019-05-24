import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:loja/models/user_model.dart';

class InformacoesEventoScreen extends StatefulWidget {

  final String id;
  final String idUsuario;
  final String nome;
  final String descricao;
  final String data;
  final String hora;
  final String sexo;
  final String esporte;
  final String estacionamento;
  final String imagem;
  final String maxparticipantes;
  final String minparticipantes;
  final String pago;
  
  const InformacoesEventoScreen({@required this.id, @required this.idUsuario, @required this.nome, @required this.descricao, 
                           @required this.data, @required this.hora, @required this.sexo,
                           @required this.esporte, @required this.estacionamento,
                           @required this.imagem, @required this.maxparticipantes,
                           @required this.minparticipantes, @required this.pago
                          });

  _InformacoesEventoScreenState createState() => _InformacoesEventoScreenState();
}

class _InformacoesEventoScreenState extends State<InformacoesEventoScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _isLoading = false;
  bool _isLoadingInscrito = false;
  bool _inscrito = false;
  final db = Firestore.instance;
  var eventoConfirmado;

  @override
  void initState() {
    super.initState();
    _getInscrito();
  }

  void _getInscrito() async {

    setState(() {
      _isLoadingInscrito = true;
    });

    QuerySnapshot query2 = await db.collection('eventosConfirmados')
                          .where('idUsuario', isEqualTo: widget.idUsuario)
                          .where('idEvento', isEqualTo: widget.id)
                          .getDocuments();
    
    eventoConfirmado = query2.documents[0].documentID;

    setState(() {
      _isLoadingInscrito = false;
    });

    if (query2.documents.length > 0) {
      _inscrito = true;
    }
  }

  void _createData(idUsuario) async {

      setState(() { _isLoading = true;});

      DocumentReference ref = await db.collection('eventosConfirmados')
                              .add({'idEvento': widget.id,'idUsuario': idUsuario,
                                    'dataCadastro': FieldValue.serverTimestamp()
                             }).then(
                                (_) { 
                                  setState(() { _isLoading = false;}); 
                                  _getInscrito();                        
                                  
                              }).catchError((e){
                                _scaffoldKey.currentState.showSnackBar(
                                  SnackBar(content: Text("Falha ao Inscrever no Evento!"),
                                    backgroundColor: Colors.red,
                                    duration: Duration(seconds: 3)
                                  )
                                );
                                
                                _isLoading = false;
                              });
    
  }

  void _deleteData(idUsuario) async {

      //setState(() { _isLoading = true;});
      print(eventoConfirmado);
      //DocumentReference ref = await db.collection('eventosConfirmados').document();




                            //   .add({'idEvento': widget.id,'idUsuario': idUsuario,
                            //         'dataCadastro': FieldValue.serverTimestamp()
                            //  }).then(
                            //     (_) { 
                            //       setState(() { _isLoading = false;}); 
                            //       _getInscrito();                        
                                  
                            //   }).catchError((e){
                            //     _scaffoldKey.currentState.showSnackBar(
                            //       SnackBar(content: Text("Falha ao Inscrever no Evento!"),
                            //         backgroundColor: Colors.red,
                            //         duration: Duration(seconds: 3)
                            //       )
                            //     );
                                
                            //     _isLoading = false;
                            //   });
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      key: _scaffoldKey,

      appBar: AppBar(
        title: Text(widget.nome != null ? widget.nome : '',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: _isLoading == true 
      
      ? Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      )      
      
      : SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width, 
          child: Column(
            children: <Widget>[

              Container(

                margin: EdgeInsets.only(top: MediaQuery.of(context).size.width * 0.03),

                height:MediaQuery.of(context).size.width * 0.58,
                width: MediaQuery.of(context).size.width * 0.58,      

                child: ClipRRect(
                  borderRadius: BorderRadius.horizontal(left: Radius.circular(5.0)),
                  child: widget.imagem != null
                      ? Image.network(
                          widget.imagem,
                          fit: BoxFit.cover,
                          alignment: Alignment.topLeft,
                        )
                      : Container(),
                ),
              ),             

              Container(
                alignment: Alignment.centerLeft,
                width: MediaQuery.of(context).size.width* 0.95,
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.width * 0.02),
                child: Text("Esporte",style: TextStyle(fontWeight: FontWeight.bold),)
              ),

              Container(

                width: MediaQuery.of(context).size.width* 0.95,
                margin: EdgeInsets.only(top: 6),

                padding: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width * 0.01,
                  MediaQuery.of(context).size.width * 0.03,
                  MediaQuery.of(context).size.width * 0.01,
                  MediaQuery.of(context).size.width * 0.02
                ),
                  
                decoration: BoxDecoration(
                  border: Border.all(width: 1.2,color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                ),

                child: Text(
                  widget.esporte != null ? widget.esporte : ''
                ),
              ),

              Container(
                alignment: Alignment.centerLeft,
                width: MediaQuery.of(context).size.width* 0.95,
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.width * 0.02),
                child: Text("Descrição",style: TextStyle(fontWeight: FontWeight.bold),)
              ),

              Container(

                width: MediaQuery.of(context).size.width* 0.95,
                margin: EdgeInsets.only(top: 6),

                padding: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width * 0.01,
                  MediaQuery.of(context).size.width * 0.03,
                  MediaQuery.of(context).size.width * 0.01,
                  MediaQuery.of(context).size.width * 0.02
                ),
                  
                decoration: BoxDecoration(
                  border: Border.all(width: 1.2,color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                ),

                child: Text(
                  widget.descricao != null ? widget.descricao : ''
                ),
              ),

              Container(
                width: MediaQuery.of(context).size.width* 0.95,
                child: Row(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                          width: MediaQuery.of(context).size.width* 0.45,
                          margin: EdgeInsets.only(top: MediaQuery.of(context).size.width * 0.02),
                          child: Text("Data",style: TextStyle(fontWeight: FontWeight.bold),)
                        ),

                        Container(

                          width: MediaQuery.of(context).size.width* 0.45,
                          margin: EdgeInsets.only(top: 6),

                          padding: EdgeInsets.fromLTRB(
                            MediaQuery.of(context).size.width * 0.01,
                            MediaQuery.of(context).size.width * 0.03,
                            MediaQuery.of(context).size.width * 0.01,
                            MediaQuery.of(context).size.width * 0.02
                          ),
                            
                          decoration: BoxDecoration(
                            border: Border.all(width: 1.2,color: Colors.grey),
                            borderRadius: BorderRadius.circular(5),
                          ),

                          child: Text(
                            widget.data != null ? widget.data : '12/12/1212'
                          ),
                        ),
                      ],
                    ),

                    SizedBox(width: MediaQuery.of(context).size.width* 0.05),

                    Column(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                          width: MediaQuery.of(context).size.width* 0.45,
                          margin: EdgeInsets.only(top: MediaQuery.of(context).size.width * 0.02),
                          child: Text("Hora",style: TextStyle(fontWeight: FontWeight.bold),)
                        ),

                        Container(

                          width: MediaQuery.of(context).size.width* 0.45,
                          margin: EdgeInsets.only(top: 6),

                          padding: EdgeInsets.fromLTRB(
                            MediaQuery.of(context).size.width * 0.01,
                            MediaQuery.of(context).size.width * 0.03,
                            MediaQuery.of(context).size.width * 0.01,
                            MediaQuery.of(context).size.width * 0.02
                          ),
                            
                          decoration: BoxDecoration(
                            border: Border.all(width: 1.2,color: Colors.grey),
                            borderRadius: BorderRadius.circular(5),
                          ),

                          child: Text(
                            widget.hora != null ? widget.hora : '00:00'
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Container(
                width: MediaQuery.of(context).size.width* 0.95,
                child: Row(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                          width: MediaQuery.of(context).size.width* 0.45,
                          margin: EdgeInsets.only(top: MediaQuery.of(context).size.width * 0.02),
                          child: Text("Mínimo Participantes",style: TextStyle(fontWeight: FontWeight.bold),)
                        ),

                        Container(

                          width: MediaQuery.of(context).size.width* 0.45,
                          margin: EdgeInsets.only(top: 6),

                          padding: EdgeInsets.fromLTRB(
                            MediaQuery.of(context).size.width * 0.01,
                            MediaQuery.of(context).size.width * 0.03,
                            MediaQuery.of(context).size.width * 0.01,
                            MediaQuery.of(context).size.width * 0.02
                          ),
                            
                          decoration: BoxDecoration(
                            border: Border.all(width: 1.2,color: Colors.grey),
                            borderRadius: BorderRadius.circular(5),
                          ),

                          child: Text(
                            widget.minparticipantes != null ? widget.minparticipantes : '0'
                          ),
                        ),
                      ],
                    ),

                    SizedBox(width: MediaQuery.of(context).size.width* 0.05),

                    Column(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                          width: MediaQuery.of(context).size.width* 0.45,
                          margin: EdgeInsets.only(top: MediaQuery.of(context).size.width * 0.02),
                          child: Text("Máximo Participantes",style: TextStyle(fontWeight: FontWeight.bold),)
                        ),

                        Container(

                          width: MediaQuery.of(context).size.width* 0.45,
                          margin: EdgeInsets.only(top: 6),

                          padding: EdgeInsets.fromLTRB(
                            MediaQuery.of(context).size.width * 0.01,
                            MediaQuery.of(context).size.width * 0.03,
                            MediaQuery.of(context).size.width * 0.01,
                            MediaQuery.of(context).size.width * 0.02
                          ),
                            
                          decoration: BoxDecoration(
                            border: Border.all(width: 1.2,color: Colors.grey),
                            borderRadius: BorderRadius.circular(5),
                          ),

                          child: Text(
                            widget.maxparticipantes != null ? widget.maxparticipantes : 'Ilimitado'
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),


              Container(
                width: MediaQuery.of(context).size.width* 0.95,
                child: Row(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                          width: MediaQuery.of(context).size.width* 0.25,
                          margin: EdgeInsets.only(top: MediaQuery.of(context).size.width * 0.02),
                          child: Text("Pago",style: TextStyle(fontWeight: FontWeight.bold),)
                        ),

                        Container(

                          width: MediaQuery.of(context).size.width* 0.25,
                          margin: EdgeInsets.only(top: 6),

                          padding: EdgeInsets.fromLTRB(
                            MediaQuery.of(context).size.width * 0.01,
                            MediaQuery.of(context).size.width * 0.03,
                            MediaQuery.of(context).size.width * 0.01,
                            MediaQuery.of(context).size.width * 0.02
                          ),
                            
                          decoration: BoxDecoration(
                            border: Border.all(width: 1.2,color: Colors.grey),
                            borderRadius: BorderRadius.circular(5),
                          ),

                          child: Text(
                            widget.pago == null ? '0' : widget.pago == 'n' ? "Não" : "Sim"
                          ),
                        ),
                      ],
                    ),

                    SizedBox(width: MediaQuery.of(context).size.width* 0.05),

                    Column(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                          width: MediaQuery.of(context).size.width* 0.25,
                          margin: EdgeInsets.only(top: MediaQuery.of(context).size.width * 0.02),
                          child: Text("Sexo",style: TextStyle(fontWeight: FontWeight.bold),)
                        ),

                        Container(

                          width: MediaQuery.of(context).size.width* 0.25,
                          margin: EdgeInsets.only(top: 6),

                          padding: EdgeInsets.fromLTRB(
                            MediaQuery.of(context).size.width * 0.01,
                            MediaQuery.of(context).size.width * 0.03,
                            MediaQuery.of(context).size.width * 0.01,
                            MediaQuery.of(context).size.width * 0.02
                          ),
                            
                          decoration: BoxDecoration(
                            border: Border.all(width: 1.2,color: Colors.grey),
                            borderRadius: BorderRadius.circular(5),
                          ),

                          child: Text(
                            widget.sexo == null ? '' : widget.sexo == 'H' ? "Homem" : widget.sexo == 'M' ? "Mulher" : "Unissex"
                          ),
                        ),
                      ],
                    ),

                    SizedBox(width: MediaQuery.of(context).size.width* 0.05),

                    Column(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                          width: MediaQuery.of(context).size.width* 0.35,
                          margin: EdgeInsets.only(top: MediaQuery.of(context).size.width * 0.02),
                          child: Text("Estacionamento",style: TextStyle(fontWeight: FontWeight.bold),)
                        ),

                        Container(

                          width: MediaQuery.of(context).size.width* 0.35,
                          margin: EdgeInsets.only(top: 6),

                          padding: EdgeInsets.fromLTRB(
                            MediaQuery.of(context).size.width * 0.01,
                            MediaQuery.of(context).size.width * 0.03,
                            MediaQuery.of(context).size.width * 0.01,
                            MediaQuery.of(context).size.width * 0.02
                          ),
                            
                          decoration: BoxDecoration(
                            border: Border.all(width: 1.2,color: Colors.grey),
                            borderRadius: BorderRadius.circular(5),
                          ),

                          child: Text(
                            widget.estacionamento == null ? '0' : widget.estacionamento == 'n' ? "Não" : "Sim"
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              _isLoadingInscrito == true 
                ? Container(
                  width: MediaQuery.of(context).size.width* 0.95,
                  margin: EdgeInsets.only(top: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 1.2,color: Colors.green),
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.green,
                    ),
                    height: 40,
                    width: MediaQuery.of(context).size.width,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                )

              : _inscrito == true               
                 ? 

                ScopedModelDescendant<UserModel>(
                  builder: (context, snapshot,model) {
                  return Container(
                    width: MediaQuery.of(context).size.width* 0.95,
                    margin: EdgeInsets.only(top: 10),
                    child: InkWell(
                      onTap: (){                        
                        _deleteData(model.userData["id"]);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(width: 1.2,color: Colors.green),
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.green,
                        ),
                        height: 40,
                        width: MediaQuery.of(context).size.width,
                        child: Center(child: Text("Inscrito!",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),)),
                      )
                    ),
                  );
                })

              : ScopedModelDescendant<UserModel>(
                builder: (context, snapshot,model) {
                  return Container(
                    width: MediaQuery.of(context).size.width* 0.95,
                    margin: EdgeInsets.only(top: 10),
                    child: InkWell(
                      onTap: (){
                        _createData(model.userData["id"]);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(width: 1.2,color: Colors.green),
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.green,
                        ),
                        height: 40,
                        width: MediaQuery.of(context).size.width,
                        child: Center(child: Text("Participar!",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),)),
                      )
                    ),
                  );
                }
              ),
             

            ],
          ),
        ),
      ),
    );
  }
}