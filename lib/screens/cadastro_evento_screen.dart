import 'package:flutter/material.dart';
import 'package:loja/blocs/cadastro_evento_bloc.dart';

class CadastroEventoScreen extends StatefulWidget {
  CadastroEventoScreen({Key key}) : super(key: key);

  _CadastroEventoScreenState createState() => _CadastroEventoScreenState();
}

class _CadastroEventoScreenState extends State<CadastroEventoScreen> {

  final bloc = Bloc();

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: Text("Cadastro Eventos"),
        centerTitle: true,
        actions: <Widget>[
          new IconButton(icon: const Icon(Icons.save), onPressed: () {})
        ],
      ),

      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(MediaQuery.of(context).size.height*0.01),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              
              StreamBuilder<String>(
                stream: bloc.nomeEvento,
                builder: (context, snapshot) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 10.0) ,
                    child: TextField(
                      onChanged: (s) => bloc.nomeEventoChanged.add(s),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Digite o Nome do Evento",
                        labelText: "Nome do Evento",
                        errorText: snapshot.error
                      ),
                    ),
                  );
                }
              ),

              //SizedBox(height: 20.0),

              StreamBuilder<String>(
                stream: bloc.password,
                builder: (context, snapshot) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 20.0, top: 10.0),
                    child: TextField(
                      onChanged: (s) => bloc.passwordChanged.add(s),
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Digite a Senha",
                        labelText: "Senha",
                        errorText: snapshot.error
                      ),
                    ),
                  );
                }
              ),

              //SizedBox(height: 20.0),

              StreamBuilder<bool>(
                stream: bloc.submitCheck,
                builder: (context, snapshot) {
                  return RaisedButton(
                    color: Colors.teal,
                    onPressed: snapshot.hasData ? () async {
                      String result = await bloc.submit();
                      if (result == "ok") {
                        print("Loguei");
                        //Navigator.of(context).push(MaterialPageRoute(builder: (context)=> PageTwo()));
                      }
                    } : null,
                    textColor: Colors.white,
                    child: Text("Entrar"),
                  );
                }
              ),

            ],
          ),
        ),
      )
    );
  }
}