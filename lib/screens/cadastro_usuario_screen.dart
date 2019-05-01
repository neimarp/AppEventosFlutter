import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CadastroUsuarioScreen extends StatefulWidget {
  CadastroUsuarioScreen({Key key}) : super(key: key);

  _CadastroUsuarioScreenState createState() => _CadastroUsuarioScreenState();
}

class _CadastroUsuarioScreenState extends State<CadastroUsuarioScreen> {
  
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final db = Firestore.instance;
  final storage = FirebaseStorage.instance;

  List<String> _sexo = ['Masculino', 'Feminino'];

  var _cpfController = new MaskedTextController(text: '',mask: '000.000.000-00');
  var _dataController = new MaskedTextController(text: '',mask: '00/00/0000');
  var _celularController = new MaskedTextController(text: '',mask: '(00) 00000-0000');

  bool _isLoading = false;
  double _progress;

  String _idSave;

  File _imagem;
  String _nome;
  String _email;
  String _cpf;
  String _celular;
  String _dataNascimento;
  String _sexoSelecionado;
  
  void createData() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      _isLoading = true;
      DocumentReference ref = await db.collection('usuarios')
                              .add({'imagem': await _pickSaveImage(),'nome': '$_nome',
                                    'celular': '$_celular','email': '$_email',
                                    'cpf': '$_cpf','sexo': _sexoSelecionado == "Masculino" ? 'H' : 'M', 
                                    'dtNascimento':'$_dataNascimento'})
                              .then(
                                (_) { 
                                  _idSave = _.documentID;
                                  print(_.documentID);
                                  setState(() { _isLoading = false;}); 
                                })
                              .catchError((e){
                                _scaffoldKey.currentState.showSnackBar(
                                  SnackBar(content: Text("Falha ao criar usuário!"),
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
        title: Text("Cadastro Usuário"),
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
                      content: Text("Imagem do Usuário não foi selecionada!"),
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
                    hintText: "Digite seu Nome",
                    labelText: "Nome",
                    contentPadding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width * 0.035,horizontal: MediaQuery.of(context).size.width * 0.02),
                  ),
                  validator: (value) {
                    if (value.length > 50) {
                      return 'Digite no máximo 50 caracteres!';
                    }else if(value.isEmpty){
                      return 'Digite seu Nome!';
                    }
                  },
                  onSaved: (value) => _nome = value,
                ),
              ),

              Container(
                padding: EdgeInsets.fromLTRB(
                    MediaQuery.of(context).size.width * 0.01,
                    MediaQuery.of(context).size.width * 0.03,
                    MediaQuery.of(context).size.width * 0.01,
                    MediaQuery.of(context).size.width * 0.02),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Digite seu Email",
                    labelText: "Email",
                    contentPadding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width * 0.035,horizontal: MediaQuery.of(context).size.width * 0.02),
                  ),
                  validator: (value) {
                    if (!value.contains("@")) {
                      return 'Email inválido';
                    }else if(value.isEmpty){
                      return 'Digite um Email!';
                    }
                  },
                  onSaved: (value) => _email = value,
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
                      controller: _cpfController,
                      maxLength: 14,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        counterText: "",
                        counterStyle: TextStyle(fontSize: 0),
                        border: OutlineInputBorder(),
                        labelText: "Cpf",
                        hintText: "CPF",
                        contentPadding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width * 0.035,horizontal: MediaQuery.of(context).size.width * 0.02),
                      ),
                      validator: (value) {
                        if (value.length < 14) {
                          return 'CPF inválido';
                        }else if(value.isEmpty){
                          return 'Digite um CPF!';
                        }
                      },
                      onSaved: (value) => _cpf = value,
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
                      controller: _celularController,
                      maxLength: 15,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        counterText: "",
                        counterStyle: TextStyle(fontSize: 0),
                        border: OutlineInputBorder(),
                        labelText: "Celular",
                        hintText: "Celular",
                        contentPadding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width * 0.035,horizontal: MediaQuery.of(context).size.width * 0.02),
                      ),
                      validator: (value) {
                        if (value.length < 14) {
                          return 'Celular inválido';
                        }else if(value.isEmpty){
                          return 'Digite um Celular!';
                        }
                      },
                      onSaved: (value) => _celular = value,
                    ),
                  ),

                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
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
                        if (value != "Masculino" && value != "Feminino") {
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
                      controller: _dataController,
                      maxLength: 10,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        counterText: "",
                        counterStyle: TextStyle(fontSize: 0),
                        border: OutlineInputBorder(),
                        labelText: "Data Nascimento",
                        hintText: "Data de Nascimento",
                        contentPadding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width * 0.035,horizontal: MediaQuery.of(context).size.width * 0.02),
                      ),
                      validator: (value) {
                        if (value.length < 10) {
                          return 'Data de Nascimento inválida';
                        }else if(value.isEmpty){
                          return 'Digite sua Data de Nascimento!';
                        }
                      },
                      onSaved: (value) => _dataNascimento = value,
                    ),
                  ),
                  
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
