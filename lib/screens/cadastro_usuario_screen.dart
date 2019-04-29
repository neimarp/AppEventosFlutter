import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:masked_text/masked_text.dart';

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

  bool _validaCpf = false;
  bool _validaCell = false;

  String _idSave;

  String _nome;
  String _email;
  String _cpf;
  String _celular;
  String _sexoSelecionado;
  
  void createData() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      DocumentReference ref = await db.collection('usuarios').add({'nome': '$_nome','celular': '$_celular','email': '$_email','cpf': '$_cpf','sexo': _sexoSelecionado == "Masculino" ? 'H' : 'M'});
      setState(() => _idSave = ref.documentID);
      print(ref.documentID);
    }
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
              if (_cpf.length != 14) {
                setState(() {
                  _validaCpf = true ;
                });
              }else if(_celular.length != 15){
                setState(() {
                  _validaCell = true ;
                });
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
