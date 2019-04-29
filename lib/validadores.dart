import 'dart:async';

mixin Validators {
  
  var emailValidator = StreamTransformer<String,String>.fromHandlers(
    handleData: (email,sink){
      if(email.contains("@"))
        sink.add(email);
      else{
        sink.addError("Email Inválido!");
      }
    }
  );

  var nomeEventoValidator = StreamTransformer<String,String>.fromHandlers(
    handleData: (nomeEvento,sink){
      if(nomeEvento.length > 30)
        sink.addError("O nome não pode ter mais de 30 caracteres!");
      else{
        sink.add(nomeEvento);        
      }
    }
  );

  var descricaoEventoValidator = StreamTransformer<String,String>.fromHandlers(
    handleData: (descricaoEvento,sink){
      if(descricaoEvento.length > 200)
        sink.addError("O nome não pode ter mais de 200 caracteres!");
      else{
        sink.add(descricaoEvento);        
      }
    }
  );

  var passwordValidator = StreamTransformer<String,String>.fromHandlers(
    handleData: (password,sink){
      if(password.length > 4)
        sink.add(password);
      else{
        sink.addError("Senha deve ter no mínimo 4 caracteres!");
      }
    }
  );

}