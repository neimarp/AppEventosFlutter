import 'dart:async';
import 'package:eventesports/validadores.dart';
import 'package:rxdart/rxdart.dart';

class Bloc extends Object with Validators implements BaseBloc{

  final _emailController = BehaviorSubject<String>();
  final _nomeEventoController = BehaviorSubject<String>();
  final _descricaoEventoController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  StreamSink<String> get emailChanged => _emailController.sink;
  StreamSink<String> get nomeEventoChanged => _nomeEventoController.sink;
  StreamSink<String> get descricaoEventoChanged => _descricaoEventoController.sink;
  StreamSink<String> get passwordChanged => _passwordController.sink;
  
  Stream<String> get email => _emailController.stream.transform(emailValidator);
  Stream<String> get nomeEvento => _nomeEventoController.stream.transform(nomeEventoValidator);
  Stream<String> get descricaoEvento => _descricaoEventoController.stream.transform(descricaoEventoValidator);
  Stream<String> get password => _passwordController.stream.transform(passwordValidator);

  Stream<bool> get submitCheck => Observable.combineLatest2(email, password, (e,p)=>true);

  submit() async {
    print("asdfas");
    return "ok";
  }

  @override
  void dispose() {
    _emailController?.close();
    _passwordController?.close();
    _nomeEventoController?.close();
    _descricaoEventoController?.close();
  }

}


abstract class BaseBloc{

  void dispose();

}