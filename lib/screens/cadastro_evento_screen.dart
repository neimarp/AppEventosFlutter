import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CadastroEventoScreen extends StatefulWidget {
  CadastroEventoScreen({Key key}) : super(key: key);

  _CadastroEventoScreenState createState() => _CadastroEventoScreenState();
}

class _CadastroEventoScreenState extends State<CadastroEventoScreen> {
  
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final db = Firestore.instance;
  final storage = FirebaseStorage.instance;

  List<String> _sexo = ['Masculino', 'Feminino', 'Unissex'];
  List<String> _estacionamento = ['Sim', 'Não'];
  List<String> _pago = ['Sim', 'Não'];

  var _horaController = new MaskedTextController(text: 'HH:mm',mask: '00:00');
  var _dataController = new MaskedTextController(text: '',mask: '00/00/0000');

  bool _isLoading = false;
  double _progress;
  
  String _estacionamentoSelect = 'n';
  String _pagoSelect = 'n';

  String _idSave;

  File _imagem;
  String _nome;
  String _maxParticipantes;
  String _minParticipantes;
  String _descricao;
  String _hora;
  String _sexoSelecionado;
  String _esporte;
  String _pagoSelecionado;
  String _estacionamentoSelecionado;
  String _dataEvento;
  
  void createData() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      _isLoading = true;
      DocumentReference ref = await db.collection('eventos')
                              .add({'imagem': await _pickSaveImage(),'nome': '$_nome',
                                    'descricao': '$_descricao','hora': '$_hora',
                                    'sexo': _sexoSelecionado == "Masculino" ? 'H' : _sexoSelecionado == "Feminino" ? 'M' : 'U', 
                                    'pago':'$_pagoSelect', 'estacionamento':'$_estacionamentoSelect',
                                    'data':'$_dataEvento', 'minParticipantes':'$_minParticipantes',
                                    'maxParticipantes':'$_maxParticipantes', 'esporte':'$_esporte',
                             
                             }).then(
                                (_) { 
                                  _idSave = _.documentID;
                                  print(_.documentID);
                                  setState(() { _isLoading = false;}); 
                              
                              }).catchError((e){
                                _scaffoldKey.currentState.showSnackBar(
                                  SnackBar(content: Text("Falha ao criar evento!"),
                                    backgroundColor: Colors.red,
                                    duration: Duration(seconds: 3)
                                  )
                                );
                                _isLoading = false;
                              });

    }
  }

  Future<String> _pickSaveImage() async {
    StorageReference ref = storage.ref().child(DateTime.now().millisecondsSinceEpoch.toString());
    StorageUploadTask uploadTask = ref.putFile(_imagem);
    uploadTask.events.listen((event) {
          setState(() {
            _progress = event.snapshot.bytesTransferred.toDouble() / event.snapshot.totalByteCount.toDouble();
          });
        }).onError((error) {
          setState(() {
            _isLoading = false;
          });
          _scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text(error.toString()), backgroundColor: Colors.red, duration: Duration(seconds: 3),) );
        });

    return await (await uploadTask.onComplete).ref.getDownloadURL();
  }

  Future getImage() async {
    var imagem = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _imagem = imagem;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Cadastro Evento"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.save), 
            onPressed: (){
              if(_imagem == null){
                showDialog(
                  context: context, 
                  builder: (context){
                    return AlertDialog(
                      title: Text("Imagem"),
                      content: Text("Imagem do Evento não foi selecionada!"),
                      actions: <Widget>[
                        FlatButton(
                          child: Text("Ok"),
                          onPressed: (){
                            if (_formKey.currentState.validate() == false) {
                              Navigator.pop(context);
                            }else{
                              createData();
                            }
                          },
                        ),
                        FlatButton(
                          child: Text("Cancelar"),
                          onPressed: (){
                            Navigator.pop(context);
                          },
                        )
                      ],
                    );
                  }
                );
              }
              else{
                createData();
              }
            }
          )
        ],
      ),
      
      body: SingleChildScrollView(
        child: _isLoading 
        ? Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height*0.1),
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.25),
                child: Text("Carregando ...", style: TextStyle(fontSize: 30.0,fontWeight: FontWeight.bold)),
              ),
              Container(
                child: CircularProgressIndicator()
              ),
            ],
          )
        ) 
        : Form(
          key: _formKey,
          child: Column(
            children: <Widget>[

              Container(

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),

                width: MediaQuery.of(context).size.width * 0.58,
                height: MediaQuery.of(context).size.width * 0.48,
                margin: EdgeInsets.fromLTRB(
                    MediaQuery.of(context).size.width * 0.15,
                    MediaQuery.of(context).size.width * 0.05,
                    MediaQuery.of(context).size.width * 0.15,
                    MediaQuery.of(context).size.width * 0.05),
                    
                child: Container(

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8))
                  ),

                  child: _imagem == null 
                    ? IconButton(
                      icon: Icon(
                        Icons.insert_photo, 
                        color: Colors.green, 
                        size: MediaQuery.of(context).size.width * 0.48,
                      ),
                      onPressed: getImage
                    )
                    : InkWell(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.58,
                          height: MediaQuery.of(context).size.width * 0.48,

                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.green,
                              width: 2.0,
                              style: BorderStyle.solid
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(8))
                          ),
                          
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                            child: Image.file(_imagem, fit:BoxFit.cover),
                          )
                          
                          
                        ),
                        onTap: getImage,
                      )
                  ,
                ),
              ),

              Container(
                padding: EdgeInsets.fromLTRB(
                    MediaQuery.of(context).size.width * 0.01,
                    MediaQuery.of(context).size.width * 0.03,
                    MediaQuery.of(context).size.width * 0.01,
                    MediaQuery.of(context).size.width * 0.02),
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Digite o Nome do Evento",
                    labelText: "Nome Evento",
                    contentPadding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width * 0.035,horizontal: MediaQuery.of(context).size.width * 0.02),
                  ),
                  validator: (value) {
                    if (value.length >= 50) {
                      return 'Digite no máximo 50 caracteres!';
                    }else if(value.isEmpty){
                      return 'Digite o Nome do Evento!';
                    }
                  },
                  onSaved: (value) => _nome = value,
                ),
              ),

              Row(
                children: <Widget>[
                  
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    
                    padding: EdgeInsets.fromLTRB(
                        MediaQuery.of(context).size.width * 0.01,
                        MediaQuery.of(context).size.width * 0.03,
                        MediaQuery.of(context).size.width * 0.01,
                        MediaQuery.of(context).size.width * 0.02),
                    child: TextFormField(
                      controller: _horaController,
                      maxLength: 5,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        counterText: "",
                        counterStyle: TextStyle(fontSize: 0),
                        border: OutlineInputBorder(),
                        labelText: "Horário",
                        hintText: "HH:mm",
                        contentPadding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width * 0.035,horizontal: MediaQuery.of(context).size.width * 0.02),
                      ),
                      validator: (value) {
                        if (value.length != 5) {
                          return 'Horário inválido';
                        }else if(value.isEmpty){
                          return 'Digite um Horário!';
                        }
                      },
                      onSaved: (value) => _hora = value,
                    ),
                  ),

                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    
                    padding: EdgeInsets.fromLTRB(
                        MediaQuery.of(context).size.width * 0.01,
                        MediaQuery.of(context).size.width * 0.03,
                        MediaQuery.of(context).size.width * 0.01,
                        MediaQuery.of(context).size.width * 0.02),
                    child: TextFormField(
                      controller: _dataController,
                      maxLength: 10,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        counterText: "",
                        counterStyle: TextStyle(fontSize: 0),
                        border: OutlineInputBorder(),
                        labelText: "Data Evento",
                        hintText: "Data do Evento",
                        contentPadding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width * 0.035,horizontal: MediaQuery.of(context).size.width * 0.02),
                      ),
                      validator: (value) {
                        if (value.length < 10) {
                          return 'Data inválida';
                        }else if(value.isEmpty){
                          return 'Digite a Data do Evento!';
                        }
                      },
                      onSaved: (value) => _dataEvento = value,
                    ),
                  ),

                ],
              ),

              Row(
                children: <Widget>[
                
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,

                    padding: EdgeInsets.fromLTRB(
                        MediaQuery.of(context).size.width * 0.01,
                        MediaQuery.of(context).size.width * 0.03,
                        MediaQuery.of(context).size.width * 0.01,
                        MediaQuery.of(context).size.width * 0.02),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        counterText: "",
                        counterStyle: TextStyle(fontSize: 0),
                        border: OutlineInputBorder(),
                        hintText: "Nº Min Participantes",
                        labelText: "Nº Min Participantes",
                        contentPadding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width * 0.035,horizontal: MediaQuery.of(context).size.width * 0.02),
                      ),
                      validator: (value) {
                        if (value.length >= 50) {
                          return 'Digite no máximo 50 caracteres!';
                        }else if(value.isEmpty){
                          return 'Digite o Nome do Evento!';
                        }
                      },
                      onSaved: (value) => _minParticipantes = value,
                    ),
                  ),

                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,

                    padding: EdgeInsets.fromLTRB(
                        MediaQuery.of(context).size.width * 0.01,
                        MediaQuery.of(context).size.width * 0.03,
                        MediaQuery.of(context).size.width * 0.01,
                        MediaQuery.of(context).size.width * 0.02),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      maxLength: 8,
                      decoration: InputDecoration(
                        counterText: "",
                        counterStyle: TextStyle(fontSize: 0),
                        border: OutlineInputBorder(),
                        hintText: "Nº Max Participantes",
                        labelText: "Nº Max Participantes",
                        contentPadding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width * 0.035,horizontal: MediaQuery.of(context).size.width * 0.02),
                      ),
                      onSaved: (value) => _maxParticipantes = value,
                    ),
                  ),

                ],
              ),

              Row(
                children: <Widget>[

                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    padding: EdgeInsets.fromLTRB(
                        MediaQuery.of(context).size.width * 0.01,
                        MediaQuery.of(context).size.width * 0.03,
                        MediaQuery.of(context).size.width * 0.01,
                        MediaQuery.of(context).size.width * 0.02),
                    child: DropdownButtonFormField(
                      validator: (value){
                        if (value != "Masculino" && value != "Feminino" && value != "Unissex") {
                          return 'Selecione o Sexo';
                        }
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Sexo",
                        hintText: "Selecione o Sexo",
                        contentPadding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width * 0.03,horizontal: MediaQuery.of(context).size.width * 0.02),
                      ),                      
                      value: _sexoSelecionado,
                      onChanged: (newValue) {
                        setState(() {
                          _sexoSelecionado = newValue;
                        });
                      },
                      items: _sexo.map((sexo) {
                        return DropdownMenuItem(
                          child: Text(sexo),
                          value: sexo,
                        );
                      }).toList(),
                    ),
                  ),

                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,

                    padding: EdgeInsets.fromLTRB(
                        MediaQuery.of(context).size.width * 0.01,
                        MediaQuery.of(context).size.width * 0.03,
                        MediaQuery.of(context).size.width * 0.01,
                        MediaQuery.of(context).size.width * 0.02),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      //maxLength: 8,
                      decoration: InputDecoration(
                        counterText: "",
                        counterStyle: TextStyle(fontSize: 0),
                        border: OutlineInputBorder(),
                        hintText: "Esporte",
                        labelText: "Esporte",
                        contentPadding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width * 0.035,horizontal: MediaQuery.of(context).size.width * 0.02),
                      ),
                      validator: (value){
                        if (value.isEmpty) {
                          return 'Digite o Esporte!';
                        }
                      },
                      onSaved: (value) => _esporte = value,
                    ),
                  ),

                ],
              ),

              
              
              // Row(
              //   children: <Widget>[

              //     Container(
              //       width: MediaQuery.of(context).size.width * 0.5,
              //       padding: EdgeInsets.fromLTRB(
              //           MediaQuery.of(context).size.width * 0.01,
              //           MediaQuery.of(context).size.width * 0.03,
              //           MediaQuery.of(context).size.width * 0.01,
              //           MediaQuery.of(context).size.width * 0.02),
              //       child: DropdownButtonFormField(
              //         validator: (value){
              //           if (value != "Sim" && value != "Não") {
              //             return 'Estacionamento ?';
              //           }
              //         },
              //         decoration: InputDecoration(
              //           border: OutlineInputBorder(),
              //           labelText: "Estacionamento",
              //           hintText: "Estacionamento ?",
              //           contentPadding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width * 0.03,horizontal: MediaQuery.of(context).size.width * 0.02),
              //         ),                      
              //         value: _estacionamentoSelecionado,
              //         onChanged: (newValue) {
              //           setState(() {
              //             _estacionamentoSelecionado = newValue;
              //           });
              //         },
              //         items: _estacionamento.map((estacionamento) {
              //           return DropdownMenuItem(
              //             child: Text(estacionamento),
              //             value: estacionamento,
              //           );
              //         }).toList(),
              //       ),
              //     ),

              //     Container(
              //       width: MediaQuery.of(context).size.width * 0.5,
              //       padding: EdgeInsets.fromLTRB(
              //           MediaQuery.of(context).size.width * 0.01,
              //           MediaQuery.of(context).size.width * 0.03,
              //           MediaQuery.of(context).size.width * 0.01,
              //           MediaQuery.of(context).size.width * 0.02),
              //       child: DropdownButtonFormField(
              //         validator: (value){
              //           if (value != "Sim" && value != "Não") {
              //             return 'Evento pago ?';
              //           }
              //         },
              //         decoration: InputDecoration(
              //           border: OutlineInputBorder(),
              //           labelText: "Pago",
              //           hintText: "Evento Pago ?",
              //           contentPadding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width * 0.03,horizontal: MediaQuery.of(context).size.width * 0.02),
              //         ),                      
              //         value: _pagoSelecionado,
              //         onChanged: (newValue) {
              //           setState(() {
              //             _pagoSelecionado = newValue;
              //           });
              //         },
              //         items: _pago.map((pago) {
              //           return DropdownMenuItem(
              //             child: Text(pago),
              //             value: pago,
              //           );
              //         }).toList(),
              //       ),
              //     ),

              //   ],
              // ),

              Row(
                children: <Widget>[

                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    padding: EdgeInsets.fromLTRB(
                        MediaQuery.of(context).size.width * 0.01,
                        MediaQuery.of(context).size.width * 0.03,
                        MediaQuery.of(context).size.width * 0.01,
                        MediaQuery.of(context).size.width * 0.02),

                    child: Container(   
                      
                      padding: EdgeInsets.fromLTRB(
                        MediaQuery.of(context).size.width * 0.02,
                        MediaQuery.of(context).size.width * 0.025,
                        MediaQuery.of(context).size.width * 0.01,
                        0),

                      decoration: BoxDecoration(
                        border: Border.all(width: 1.2,color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Estacionamento ?',
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Radio(
                                activeColor: Colors.green,
                                value: 's',
                                groupValue: _estacionamentoSelect,
                                onChanged: (newValue) {
                                  setState(() {
                                    _estacionamentoSelect = newValue;
                                  });
                                },
                              ),
                              Text(
                                'Sim',
                                style: TextStyle(fontSize: 14.0),
                              ),
                              Radio(
                                activeColor: Colors.green,
                                value: 'n',
                                groupValue: _estacionamentoSelect,
                                onChanged: (newValue) {
                                  setState(() {
                                    _estacionamentoSelect = newValue;
                                  });
                                },
                              ), 
                              Text(
                                'Não',
                                style: TextStyle(fontSize: 14.0),
                              ),                       
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    padding: EdgeInsets.fromLTRB(
                        MediaQuery.of(context).size.width * 0.01,
                        MediaQuery.of(context).size.width * 0.03,
                        MediaQuery.of(context).size.width * 0.01,
                        MediaQuery.of(context).size.width * 0.02),

                    child: Container(

                      padding: EdgeInsets.fromLTRB(
                        MediaQuery.of(context).size.width * 0.02,
                        MediaQuery.of(context).size.width * 0.025,
                        MediaQuery.of(context).size.width * 0.01,
                        0),
                      
                      decoration: BoxDecoration(
                        border: Border.all(width: 1.2,color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Evento Pago ?',
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Radio(
                                activeColor: Colors.green,
                                value: 's',
                                groupValue: _pagoSelect,
                                onChanged: (newValue) {
                                  setState(() {
                                    _pagoSelect = newValue;
                                  });
                                },
                              ),
                              Text(
                                'Sim',
                                style: TextStyle(fontSize: 14.0),
                              ),
                              Radio(
                                activeColor: Colors.green,
                                value: 'n',
                                groupValue: _pagoSelect,
                                onChanged: (newValue) {
                                  setState(() {
                                    _pagoSelect = newValue;
                                  });
                                },
                              ), 
                              Text(
                                'Não',
                                style: TextStyle(fontSize: 14.0),
                              ),                       
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              Container(
                padding: EdgeInsets.fromLTRB(
                    MediaQuery.of(context).size.width * 0.01,
                    MediaQuery.of(context).size.width * 0.03,
                    MediaQuery.of(context).size.width * 0.01,
                    MediaQuery.of(context).size.width * 0.02),
                child: TextFormField(
                  maxLines: 4,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                    labelText: "Descrição",
                    hintText: "Digite uma Descrição para o Evento",
                  ),
                  validator: (value) {
                    if (value.length > 350) {
                      return 'Descrição inválido';
                    }else if(value.isEmpty){
                      return 'Digite uma Descrição!';
                    }
                  },
                  onSaved: (value) => _descricao = value,
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
