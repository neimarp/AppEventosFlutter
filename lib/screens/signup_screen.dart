import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loja/models/user_model.dart';
import 'package:loja/widget/multi_select.dart';
import 'package:scoped_model/scoped_model.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _addressController = TextEditingController();
  final _preferenciasController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _validateEsporte;
  File _image;

  Firestore _firestore = Firestore.instance;

  List<dynamic> reportList = [];

  void _searchEsportes() async {
    var esportes = await _firestore.collection("esportes").orderBy("nome").getDocuments();
    reportList = esportes.documents.map((e){
      return e.data["nome"];
    }).toList();   
    //print(reportList); 
  }  

  List<dynamic> selectedReportList = List();

  _showReportDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text("Selecione os Esportes"),
            content: MultiSelect(
              reportList,
              onSelectionChanged: (selectedList) {
                setState(() {
                  selectedReportList = selectedList;
                  if(selectedReportList.length > 0){
                    _preferenciasController.text = selectedReportList.toString();
                  }else{
                    _preferenciasController.text = "";
                  }
                });
              }
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("confirmar"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
      }
    );
  }
  @override
  void initState() {
    super.initState();
    _searchEsportes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Cadastro"),
        centerTitle: true,
      ),
      body: ScopedModelDescendant<UserModel>(
        builder: (context, child, model){
          if(model.isLoading)
            return Center(child: CircularProgressIndicator());

          return Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.all(16.0),
              children: <Widget>[

                Container(

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),

                  width: MediaQuery.of(context).size.width * 0.58,
                  height: MediaQuery.of(context).size.width * 0.48,
                  margin: EdgeInsets.fromLTRB(
                      MediaQuery.of(context).size.width * 0.15,
                      MediaQuery.of(context).size.width * 0.1,
                      MediaQuery.of(context).size.width * 0.15,
                      MediaQuery.of(context).size.width * 0.1),
                      
                  child: Container(

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8))
                    ),

                    child: _image == null 
                      ? IconButton(
                        icon: Icon(
                          Icons.person, 
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
                              child: Image.file(_image, fit:BoxFit.cover),
                            )
                            
                          ),
                          onTap: getImage,
                        )
                    ,
                  ),
                ),

                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: "Nome Completo"
                  ),
                  validator:(text){
                    if ( text.isEmpty ){
                      return "Nome Inválido!";
                    }
                  }
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: "E-mail"
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator:(text){
                    if ( text.isEmpty || !text.contains("@")){
                      return "E-mail Inválido!";
                    }
                  }
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _passController,
                  decoration: InputDecoration(
                    hintText: "Senha"
                  ),
                  obscureText: true,     
                  validator:(text){
                    if ( text.isEmpty || text.length < 6){
                      return "Senha Inválida!";
                    }
                  }
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    hintText: "Endereço"
                  ),
                  validator:(text){
                    if ( text.isEmpty){
                      return "Endereço Inválida!";
                    }
                  }
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: _preferenciasController,
                  enableInteractiveSelection: false,
                  decoration: InputDecoration(
                    hintText: "Preferências Esportivas",
                    errorText: _validateEsporte == true ? 'Selecione um Esporte' : null,
                  ),
                  onTap: () { 
                    _showReportDialog();
                    FocusScope.of(context).requestFocus(new FocusNode()); 
                  },
                  
                ),
                SizedBox(height: MediaQuery.of(context).size.width * 0.12),
                RaisedButton(
                  padding: EdgeInsets.symmetric(vertical: 14.0),
                  child: Text(
                    "Criar Conta",
                    style: TextStyle(
                      fontSize: 18.0
                    ),
                  ),
                  textColor: Colors.white,
                  color: Theme.of(context).primaryColor,
                  onPressed: (){
                    print(_preferenciasController.text.isEmpty);
                    if (_preferenciasController.text.isEmpty){
                      setState(() {
                        _validateEsporte = true;
                      });
                    }else{
                      setState(() {
                        _validateEsporte = false;
                      });
                    }
                    if (_formKey.currentState.validate() && _image != null && _preferenciasController.text.isEmpty != true) {

                      Map<String, dynamic> userData ={
                        "name": _nameController.text,
                        "email": _emailController.text,
                        "address": _addressController.text,
                        "imagem":"",
                        "preferencias": _preferenciasController.text
                      };


                      model.signUp(
                        userData: userData,
                        imagem: _image,
                        pass: _passController.text,
                        onSuccess: _onSuccess,
                        onFail: _onFail
                      );
                    }else if (_image == null){
                      _scaffoldKey.currentState.showSnackBar(
                        SnackBar(content: Text("Selecione uma imagem de Perfil!"),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 3)
                        )
                      );
                    }
                  },
                )
              ],
            ),
          );
        },
      )
    );
  }

  Future getImage() async {
    var imagem = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = imagem;
    });
  }

  void _onSuccess(){
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text("Usuário criado com sucesso!"),
        backgroundColor: Theme.of(context).primaryColor,
        duration: Duration(seconds: 3)
      )
    );

    Future.delayed(Duration(seconds: 3)).then((_){
      Navigator.of(context).pop();
    });

  }

  void _onFail(){
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text("Falha ao criar usuário!"),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3)
      )
    );
  }


}




 
  