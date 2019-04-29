import 'package:flutter/material.dart';
import 'package:masked_text/masked_text.dart';

class CadastroUsuarioScreen extends StatefulWidget {
  CadastroUsuarioScreen({Key key}) : super(key: key);

  _CadastroUsuarioScreenState createState() => _CadastroUsuarioScreenState();
}

class _CadastroUsuarioScreenState extends State<CadastroUsuarioScreen> {
  List<String> _sexo = ['Masculino', 'Feminino'];
  String _sexoSelecionado;
  final _textCPFController = new TextEditingController();
  final _textCellController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text("Cadastro Usuário"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(icon: const Icon(Icons.save), onPressed: () {})
        ],
      ),
      
      body: SingleChildScrollView(
        child: Form(
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
                    }
                  },
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
                        counterText: "",
                        counterStyle: TextStyle(fontSize: 0),
                        border: OutlineInputBorder(),
                        hintText: "Digite seu CPF", 
                        labelText: "CPF",
                        contentPadding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width * 0.035,horizontal: MediaQuery.of(context).size.width * 0.02),
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
                    child: MaskedTextField(
                      maskedTextFieldController: _textCellController,
                      escapeCharacter: '#',
                      mask: "(##) #####-####",
                      maxLength: 15,
                      keyboardType: TextInputType.number,
                      inputDecoration: InputDecoration(
                        counterText: "",
                        counterStyle: TextStyle(fontSize: 0),
                        border: OutlineInputBorder(),
                        hintText: "Digite seu Celular", 
                        labelText: "Celular",
                        contentPadding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width * 0.035,horizontal: MediaQuery.of(context).size.width * 0.02),
                      ),
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
