import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:masked_text/masked_text.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CadastroUsuarioScreen extends StatefulWidget {
  CadastroUsuarioScreen({Key key}) : super(key: key);

  _CadastroUsuarioScreenState createState() => _CadastroUsuarioScreenState();
}

class _CadastroUsuarioScreenState extends State<CadastroUsuarioScreen> {
  
  final _formKey = GlobalKey<FormState>();
  final db = Firestore.instance;

  List<String> _sexo = ['Masculino', 'Feminino'];

  final _textCPFController = new TextEditingController();
  final _textCellController = new TextEditingController();
  final _textDataController = new TextEditingController();

  bool _validaCpf = false;
  bool _validaCell = false;
  bool _validaData = false;

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
      DocumentReference ref = await db.collection('usuarios').add({'nome': '$_nome','celular': '$_celular','email': '$_email','cpf': '$_cpf','sexo': _sexoSelecionado == "Masculino" ? 'H' : 'M', 'dtNascimento':'$_dataNascimento'});
      setState(() => _idSave = ref.documentID);
      print(ref.documentID);
    }
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

      appBar: AppBar(
        title: Text("Cadastro Usuário"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.save), 
            onPressed: (){
              print(_cpf.length);
              if (_cpf == null || _cpf.length != 14) {                
                setState(() {
                  _validaCpf = true ;
                });
              }else if(_celular == null || _celular.length != 15){
                setState(() {
                  _validaCell = true ;
                });
              }else if(_dataNascimento == null || _dataNascimento.length != 10){
                setState(() {
                  _validaData = true ;
                });
              }else if(_imagem == null){
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
                            createData();
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
        child: Form(
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
                    child: MaskedTextField(
                      maskedTextFieldController: _textCPFController,
                      escapeCharacter: '#',
                      mask: "###.###.###-##",
                      maxLength: 14,
                      keyboardType: TextInputType.number,
                      inputDecoration: InputDecoration(
                        errorText: _validaCpf ? 'CPF inválido' : null,
                        counterText: "",
                        counterStyle: TextStyle(fontSize: 0),
                        border: OutlineInputBorder(),
                        hintText: "Digite seu CPF", 
                        labelText: "CPF",
                        contentPadding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width * 0.035,horizontal: MediaQuery.of(context).size.width * 0.02),
                      ),
                      onChange: (value) {
                        setState(() {
                          _cpf = value;
                        });
                      },
                    ),
                  ),

                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    padding: EdgeInsets.fromLTRB(
                        MediaQuery.of(context).size.width * 0.01,
                        MediaQuery.of(context).size.width * 0.03,
                        MediaQuery.of(context).size.width * 0.01,
                        MediaQuery.of(context).size.width * 0.02),
                    child: MaskedTextField(
                      maskedTextFieldController: _textCellController,
                      escapeCharacter: '#',
                      mask: "(##) #####-####",
                      maxLength: 15,
                      keyboardType: TextInputType.number,
                      inputDecoration: InputDecoration(
                        errorText: _validaCell ? 'Celular inválido' : null,
                        counterText: "",
                        counterStyle: TextStyle(fontSize: 0),
                        border: OutlineInputBorder(),
                        hintText: "Digite seu Celular", 
                        labelText: "Celular",
                        contentPadding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width * 0.035,horizontal: MediaQuery.of(context).size.width * 0.02),
                      ),
                      onChange: (value) {
                        setState(() {
                          _celular = value;
                        });
                      },
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
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Sexo",
                        hintText: "Selecione o Sexo",
                        contentPadding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width * 0.035,horizontal: MediaQuery.of(context).size.width * 0.02),
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
                    child: MaskedTextField(
                      maskedTextFieldController: _textDataController,
                      escapeCharacter: 'x',
                      mask: "xx/xx/xxxx",
                      maxLength: 10,
                      keyboardType: TextInputType.number,
                      inputDecoration: InputDecoration(
                        errorText: _validaData ? 'Data de Nascimento inválida' : null,
                        counterText: "",
                        counterStyle: TextStyle(fontSize: 0),
                        border: OutlineInputBorder(),
                        hintText: "Digite sua Data de Nascimento", 
                        labelText: "Data de Nascimento",
                        contentPadding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width * 0.035,horizontal: MediaQuery.of(context).size.width * 0.02),
                      ),
                      onChange: (value) {
                        setState(() {
                          _dataNascimento = value;
                        });
                      },
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
